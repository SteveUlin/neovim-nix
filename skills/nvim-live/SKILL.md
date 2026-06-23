---
name: nvim-live
description: Read and visually drive sulin's running Neovim over its RPC socket. Use when he refers to his screen — "this"/"here"/"this section"/"this error"/the current selection — so you read his live buffer/cursor/diagnostics instead of asking him to paste; and when explaining an idea you want to SHOW, to jump his editor to a file and highlight the useful lines with an inline note. Read + display only — never edits buffer content (edits stay in claudecode's reviewed diff flow).
---

# nvim-live

A live link to sulin's running Neovim via its RPC socket (`$XDG_RUNTIME_DIR/nvim.<pid>.0`). Helper: `~/.claude/skills/nvim-live/nvim-live.sh`. Every action is a READ or a DISPLAY action (jump / highlight) — none mutate buffer *content*, so none dirty a buffer or bypass claudecode's diff-review.

**Do not add content editing here.** Route edits through your normal `Edit` tool — claudecode surfaces those as a diff sulin approves. This skill is the *read + show* half; the *edit* half stays behind his review gate.

## When to use
- He references his screen — "this", "here", "this function", "this error", "the selection" — without pasting. Pull the context (`where` / `read` / `selection` / `diag`) instead of asking him to copy it.
- You're explaining something and a concrete location in his code would land it. Don't just cite `receiver.h:42` — `show` him: jump there and highlight the lines, with a "← why this matters" note.

## Commands
Invoke via Bash: `~/.claude/skills/nvim-live/nvim-live.sh <cmd>`

Reading (side-effect-free):
- `where` — focused file, cursor line/col, `<cword>`, filetype, modified flag.
- `read <start> <end>` — buffer lines start..end (1-indexed, numbered).
- `selection` — his last visual selection and its text.
- `diag` — structured LSP diagnostics (line:col, severity, message, source) — the resolved clangd payload, far richer than scraped compiler output.
- `buffers` — all loaded file buffers (his working set).

Display (changes his VIEW, not content):
- `jump <file> <line>` — move his cursor to file:line and center it.
- `show <file> <start> <end> [label]` — jump there AND highlight lines start..end, with an optional inline `← label`. The headline gesture: explain an idea, then show exactly where it lives.
- `hl <start> <end> [label]` — highlight a range in the current buffer.
- `clear` — remove all nvim-live highlights.

## Discipline
- **Labels are short tags** (a few words). They sit at end-of-line and long ones run off-screen — the badge is a *pointer*, not the explanation. Put the real reasoning in your chat reply (he keeps the editor and the Claude pane side by side).
- Reads use pure getters only — never `search()`, `normal!`, or `--remote-send` (they move his cursor or dirty state).
- `jump`/`show` move his cursor deliberately — right when he asked to be shown something; don't yank his cursor unannounced mid-task.
- Multi-instance: the helper targets the newest socket. If he has several nvims open and you hit the wrong one, set `NVIM_LIVE_SOCK=/run/user/<uid>/nvim.<pid>.0`.
- `clear` highlights once they've served their purpose, so they don't linger across topics.
