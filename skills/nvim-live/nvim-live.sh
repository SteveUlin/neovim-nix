#!/usr/bin/env bash
# nvim-live — give Claude live access to sulin's running Neovim over its RPC
# socket. READS are side-effect-free; DISPLAY actions (jump, highlight) change
# the *view*, never buffer content — so they never dirty a buffer or bypass the
# claudecode diff-gate. Content edits deliberately do NOT live here; those stay
# in claudecode's reviewed edit→diff flow.
#
# Usage:
#   nvim-live.sh where                      # focused file, cursor, word, ft
#   nvim-live.sh read <start> <end>         # lines start..end of current buffer
#   nvim-live.sh selection                  # last visual selection + its text
#   nvim-live.sh diag                       # structured LSP diagnostics
#   nvim-live.sh buffers                    # all loaded file buffers
#   nvim-live.sh jump <file> <line>         # move his view to file:line, center
#   nvim-live.sh show <file> <s> <e> [label]# jump + highlight lines s..e (+note)
#   nvim-live.sh hl <s> <e> [label]         # highlight s..e in current buffer
#   nvim-live.sh clear                      # clear all nvim-live highlights
#
# Override target instance with NVIM_LIVE_SOCK=/path/to/nvim.<pid>.0

sock() {
  if [ -n "${NVIM_LIVE_SOCK:-}" ]; then printf '%s' "$NVIM_LIVE_SOCK"; return; fi
  ls -t /run/user/"$(id -u)"/nvim.*.0 2>/dev/null | head -1
}

# Run a Lua chunk (on stdin) inside the live nvim; print whatever it `return`s.
# The chunk is written to a temp file and invoked via luaeval(loadfile(_A)) so
# no shell/vim/lua quoting ever has to be escaped by the caller.
nvlua() {
  local s; s=$(sock)
  if [ -z "$s" ]; then echo "nvim-live: no nvim socket under /run/user/$(id -u)/" >&2; return 1; fi
  local f; f=$(mktemp --suffix=.lua) || return 1
  cat >"$f"
  nvim --server "$s" --remote-expr "luaeval('(loadfile(_A))()', '$f')" 2>&1
  local rc=$?
  rm -f "$f"
  return $rc
}

is_int() { [[ "$1" =~ ^[0-9]+$ ]]; }

cmd_where() {
  nvlua <<'LUA'
local b = vim.api.nvim_get_current_buf()
local c = vim.api.nvim_win_get_cursor(0)
return string.format("%s\n  line %d col %d   word=<%s>   ft=%s   modified=%s",
  vim.api.nvim_buf_get_name(b), c[1], c[2] + 1,
  vim.fn.expand("<cword>"), vim.bo.filetype, tostring(vim.bo.modified))
LUA
}

cmd_read() {
  is_int "${1:-}" && is_int "${2:-}" || { echo "usage: read <start> <end>" >&2; return 2; }
  nvlua <<LUA
local lines = vim.api.nvim_buf_get_lines(0, $1 - 1, $2, false)
local out = {}
for i, l in ipairs(lines) do out[i] = string.format("%d  %s", $1 + i - 1, l) end
return table.concat(out, "\n")
LUA
}

cmd_selection() {
  nvlua <<'LUA'
local a, b = vim.fn.getpos("'<"), vim.fn.getpos("'>")
if a[2] == 0 then return "no visual selection recorded" end
local lines = vim.api.nvim_buf_get_lines(0, a[2] - 1, b[2], false)
return string.format("%s:%d-%d\n%s",
  vim.api.nvim_buf_get_name(0), a[2], b[2], table.concat(lines, "\n"))
LUA
}

cmd_diag() {
  nvlua <<'LUA'
local names = { "ERROR", "WARN", "INFO", "HINT" }
local out = {}
for _, d in ipairs(vim.diagnostic.get(0)) do
  out[#out + 1] = string.format("%d:%d [%s] %s (%s)",
    d.lnum + 1, d.col + 1, names[d.severity] or "?", d.message, d.source or "")
end
return #out > 0 and table.concat(out, "\n") or "no diagnostics in current buffer"
LUA
}

cmd_buffers() {
  nvlua <<'LUA'
local out = {}
for _, b in ipairs(vim.api.nvim_list_bufs()) do
  if vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buflisted then
    local n = vim.api.nvim_buf_get_name(b)
    if n ~= "" then out[#out + 1] = string.format("%d  %s%s", b, n, vim.bo[b].modified and "  [+]" or "") end
  end
end
return table.concat(out, "\n")
LUA
}

cmd_jump() {
  [ -n "${1:-}" ] && is_int "${2:-}" || { echo "usage: jump <file> <line>" >&2; return 2; }
  nvlua <<LUA
local target = vim.fn.fnamemodify([==[$1]==], ":p")
if target ~= vim.api.nvim_buf_get_name(0) then vim.cmd("edit " .. vim.fn.fnameescape(target)) end
vim.api.nvim_win_set_cursor(0, { $2, 0 })
vim.cmd("normal! zz")
return "jumped to " .. target .. ":$2"
LUA
}

# jump + highlight lines s..e in the target file, with an optional eol note.
cmd_show() {
  [ -n "${1:-}" ] && is_int "${2:-}" && is_int "${3:-}" || { echo "usage: show <file> <start> <end> [label]" >&2; return 2; }
  local label="${4:-}"
  nvlua <<LUA
local target = vim.fn.fnamemodify([==[$1]==], ":p")
if target ~= vim.api.nvim_buf_get_name(0) then vim.cmd("edit " .. vim.fn.fnameescape(target)) end
vim.api.nvim_win_set_cursor(0, { $2, 0 })
vim.cmd("normal! zz")
local ns = vim.api.nvim_create_namespace("claude_live")
vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
-- Background-only group applied as line_hl_group, so (1) treesitter/clangd
-- foreground colors show through, and (2) the band fills under inline inlay
-- hints (fn:/f:/t:) instead of leaving a gap in the highlight.
vim.api.nvim_set_hl(0, "ClaudeLiveHL", { link = "DiffDelete", default = true })
for _l = $2 - 1, $3 - 1 do
  vim.api.nvim_buf_set_extmark(0, ns, _l, 0, { line_hl_group = "ClaudeLiveHL" })
end
local label = [==[$label]==]
if #label > 0 then
  -- Short label: a distinct foreground accent (Special) + icon, NOT a bg pill,
  -- so it doesn't share the highlight's background. Override ClaudeLiveNote to taste.
  -- Keep labels short (a few words) — they sit at eol and long ones run offscreen;
  -- put the real explanation in the Claude pane.
  vim.api.nvim_set_hl(0, "ClaudeLiveNote", { link = "Special", default = true })
  vim.api.nvim_buf_set_extmark(0, ns, $2 - 1, 0,
    { virt_text = { { "  ← " .. label, "ClaudeLiveNote" } }, virt_text_pos = "eol" })
end
return "showing " .. target .. ":$2-$3" .. (#label > 0 and ("  (" .. label .. ")") or "")
LUA
}

cmd_hl() {
  is_int "${1:-}" && is_int "${2:-}" || { echo "usage: hl <start> <end> [label]" >&2; return 2; }
  local label="${3:-}"
  nvlua <<LUA
local ns = vim.api.nvim_create_namespace("claude_live")
vim.api.nvim_set_hl(0, "ClaudeLiveHL", { link = "DiffDelete", default = true })
for _l = $1 - 1, $2 - 1 do
  vim.api.nvim_buf_set_extmark(0, ns, _l, 0, { line_hl_group = "ClaudeLiveHL" })
end
local label = [==[$label]==]
if #label > 0 then
  vim.api.nvim_set_hl(0, "ClaudeLiveNote", { link = "Special", default = true })
  vim.api.nvim_buf_set_extmark(0, ns, $1 - 1, 0,
    { virt_text = { { "  ← " .. label, "ClaudeLiveNote" } }, virt_text_pos = "eol" })
end
return "highlighted $1-$2"
LUA
}

cmd_clear() {
  nvlua <<'LUA'
local ns = vim.api.nvim_create_namespace("claude_live")
for _, b in ipairs(vim.api.nvim_list_bufs()) do
  if vim.api.nvim_buf_is_loaded(b) then vim.api.nvim_buf_clear_namespace(b, ns, 0, -1) end
end
return "cleared nvim-live highlights"
LUA
}

case "${1:-}" in
  where)     cmd_where ;;
  read)      cmd_read "${2:-}" "${3:-}" ;;
  selection) cmd_selection ;;
  diag)      cmd_diag ;;
  buffers)   cmd_buffers ;;
  jump)      cmd_jump "${2:-}" "${3:-}" ;;
  show)      cmd_show "${2:-}" "${3:-}" "${4:-}" "${5:-}" ;;
  hl)        cmd_hl "${2:-}" "${3:-}" "${4:-}" ;;
  clear)     cmd_clear ;;
  *) echo "nvim-live: unknown command '${1:-}'. See header for usage." >&2; exit 2 ;;
esac
