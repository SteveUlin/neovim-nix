# Neovim Mastery Cheat Sheet

Press `q` to close this file.

## Symbol Legend

```
␣        Space (also the leader key)
⌃        Control
⇧        Shift
⏎        Enter / Return
⎋        Escape
⇥        Tab
⇧⇥       Shift+Tab
⌫        Backspace
★        Highlighted tip
→        Sequence / leads to
```

Emoji color-codes group actions by purpose:
- 🟢 navigation / jumps
- 🔧 actions (do something)
- 📖 information displays
- 🔘 toggles
- 📁 files & buffers
- 🪝 git / jujutsu
- 🤖 Claude Code
- 🪟 windows


## Essential Motions

### Word Movement
```
w         jump forward to start of next word
b         jump backward to start of previous word
e         jump forward to end of next word
ge        jump backward to end of previous word

2w        jump forward 2 words (use counts!)
3b        jump backward 3 words
```

### Line Navigation
```
0         jump to column 0 (start of line)
^         jump to first non-blank character    ★
$         jump to end of line

d^        delete to first non-blank
c$        change to end of line
```

### Paragraph & Block Navigation
```
{         jump to previous blank line (paragraph up)
}         jump to next blank line (paragraph down)

]f        jump to next function start
[f        jump to previous function start
]F        jump to next function end
[F        jump to previous function end
```

### Character Finding
```
fx        find next 'x' on current line
;         repeat last find forward
,         repeat last find backward
tx        until next 'x' (stops before it)

Fx        find previous 'x' on current line
Tx        until previous 'x' (stops after it)
```


## Text Objects — The Real Power

### The Concept
```
i         "inside" — excludes delimiters
a         "around" — includes delimiters

Example:
    "hello world"
         ↑ cursor here

    ci"   changes hello world (keeps quotes)
    ca"   changes everything including quotes
    da"   deletes everything including quotes
```

### Word Objects
```
iw        inside word (just the word)
aw        around word (includes surrounding space)
iW        inside WORD (includes punctuation)
aW        around WORD

ciw       change inside word
daw       delete around word (removes word + space)
```

### Quote & Bracket Objects
```
i"  a"    inside/around double quotes
i'  a'    inside/around single quotes
i`  a`    inside/around backticks

i(  a(    inside/around parentheses
i[  a[    inside/around square brackets
i{  a{    inside/around curly braces
i<  a<    inside/around angle brackets

Examples:
    ci"       change text inside quotes
    da{       delete entire block with braces
    di(       delete function arguments
```

### Tag Objects (HTML/JSX)
```
it        inside tag content
at        around tag (includes tag itself)

<div>content</div>
     ↑
cit       changes "content"
dat       deletes entire <div>...</div>
```

### Treesitter Objects (Your Config!)
```
af        around function (entire function)
if        inside function (function body)
ac        around class
ic        inside class body
ap        around parameter
ip        inside parameter

Examples:
    daf       delete entire function
    vif       select function body
    yac       yank entire class
    dap       delete a parameter
```


## Operators — Combine with Motions/Objects

### Core Operators
```
d         delete
c         change (delete + enter insert mode)
y         yank (copy)
v         visually select
>         indent right
<         indent left
=         auto-indent
```

### Powerful Combinations
```
Operation + Count + Motion/Object

dw        delete word
d3w       delete 3 words
d$        delete to end of line
d^        delete to first non-blank
d}        delete to next paragraph
dd        delete entire line

ciw       change inside word
ci"       change inside quotes
ca{       change around braces (includes braces)
cit       change inside tag

yiw       yank inside word
yap       yank around paragraph
yaf       yank entire function

vip       visually select paragraph
vif       visually select function body

>ip       indent paragraph right
=af       auto-indent function
```


## Your Custom Keybindings

### 📁 File Navigation
```
␣␣      🔭  smart find files (frecency)
␣/      🔍  live grep across project
␣,      🗂️  buffer picker
␣e      📁  file explorer
␣ff     📂  find file
␣fr     🕒  recent files
␣fb     🔎  grep open buffers
␣fs     💾  save file
␣q      ✖️  close window
```

### 🟢 Code Navigation (LSP)
```
␣cd     🎯  go to definition
␣cD     🪧  go to declaration
␣cR     🔁  go to references
␣cI     ⬇️  go to implementation
␣cy     🏷️  go to type definition
␣cs     📃  LSP symbols in current file       ★ great for C++
␣cS     🌐  workspace symbols (all files)

␣ca     🔧  code action (quick fixes, refactoring)
␣cf     🪶  format buffer (conform → clang-format / black / …)
␣ck     📖  LSP hover (documentation)
␣ce     ⚠️  show line diagnostics
␣ct     🔘  toggle inline diagnostic text
␣ch     🪪  toggle signature help popup

]]      🔁  next reference of word under cursor
[[      🔁  previous reference of word under cursor

gd      🎯  go to definition (built-in)
⌃o      ↩️  jump back to previous location
⌃i      ↪️  jump forward
```

### 🔍 Search & Grep
```
/pat    🔍  search forward
?pat    🔍  search backward
n       ⏭️  next match
N       ⏮️  previous match
*       🔍  search word under cursor forward
#       🔍  search word under cursor backward

␣sw     🔎  grep word under cursor             ★
␣sb     📃  search lines in current buffer
␣su     ↩️  undo history picker
␣;      🔁  resume last picker                 ★ huge time saver
␣:      📜  command history
␣sn     🔔  notification history

:noh    🧹  clear search highlight
```

### 🪝 Git / Jujutsu
```
]h      ⏭️  next hunk
[h      ⏮️  previous hunk

␣go     👁️  toggle inline diff overlay         ★ selective undo
            (use gH inside overlay to undo a hunk)
␣gu     ↩️  undo hunk under cursor

␣gs     📊  jujutsu status picker
```

### 👁️ Inline Diff Overlay (when ␣go overlay is active)
```
gH      ↩️  undo hunk under cursor             ★ selective undo
gHip    ↩️  undo hunks in paragraph
vip gH  ↩️  undo hunks in visual selection
]h /[h  ⏭️  navigate between hunks
␣go     ❌  close overlay

Safety:
  Typed gH by mistake?  →  u (vim undo)
```

### 🗂️ Buffer Navigation
```
]b      ▶️  next buffer
[b      ◀️  previous buffer
␣,      🗂️  buffer picker
```

### 🪟 Window Management
```
␣wh     ⬅️  move to left window
␣wj     ⬇️  move to down window
␣wk     ⬆️  move to up window
␣wl     ➡️  move to right window

␣ws     ➖  split horizontal
␣wv     ➕  split vertical
␣ww     🔁  cycle to next window

⌃w =    📐  equalize window sizes
⌃w _    📏  maximize height
⌃w |    📏  maximize width
```

### 🤖 Claude Code (paired Zellij pane)
```
␣ac     🤖  spawn paired Claude pane
␣as     📤  (visual) send selection to Claude
␣ab     📥  add current buffer to Claude context
␣aa     ✅  accept Claude diff
␣ad     ❌  reject Claude diff
␣a?     ❓  Claude connection status
```

### 📓 Notes
```
␣ne     📁  explore notes (~/notes)
␣nt     ✏️  open todo
␣ni     🖼️  paste image from clipboard → assets/
␣yp     📋  copy current file path to clipboard
```

### 📔 Jupyter / Notebooks (.qmd, .ipynb)
Run `nix develop` first — the kernel lives in the project shell.
```
␣ji     🔌  attach kernel (pick from list)
␣jI     🔌  detach kernel

␣jr     ▶️   run cell        (visual: run selection)
␣jl     ▶️   run line
␣ja     ▶️   run all
␣jb     ▶️   run cell + below
␣jA     ▶️   run above

␣jo     📤  enter output window
␣jh     🙈  hide output
␣jv     👁️   toggle virtual output

␣jx     🛑  interrupt kernel
␣jX     ♻️   restart kernel
␣jd     🗑️   delete cell
␣jn     ⬇️   next cell (evaluated only)
␣jp     ⬆️   previous cell (evaluated only)
]m      ⬇️   next fence (run or not)
[m      ⬆️   previous fence
␣jP     🌐  render + preview document
```
Output renders inline as virtual text, plots included. Inline images
need Ghostty directly, or Zellij ≥ 0.45 for its graphics passthrough.

Math in prose (`$..$`, `$$..$$`) is typeset by tectonic rather than
approximated in Unicode; the first render downloads a TeX bundle.

### 🏠 Dashboard & Help
```
␣h      🏠  open dashboard
␣?      ❓  open this cheat sheet
```


## ⚡ Completion & Snippets (blink-cmp)

### Completion menu (insert mode)
```
⌃j      ⬇️  next item in menu
⌃k      ⬆️  previous item in menu
⏎       ✅  accept selected item
⇥       ✅  accept (or jump snippet placeholder if no menu)
⇧⇥      ⬅️  previous snippet placeholder
```

### Snippet placeholders (after expanding a snippet)
```
⇥       ➡️  jump to next placeholder
⇧⇥      ⬅️  jump to previous placeholder

Tab past the last placeholder → snippet session ends, highlights clear.
```

### Useful C++ snippet prefixes (friendly-snippets)
```
st          starter template (#include <iostream> + main)
for         indexed for-loop
forr        reverse for-loop
foreach     range-based for-loop (auto / var / collection)
while       while-loop
do          do-while loop
if          if statement
else        else / else-if blocks
class       class with constructor/destructor + rule-of-five
enum        enum block
ns          namespace
t           template<typename T>
```


## Visual Mode

### Entering Visual Mode
```
v         character-wise visual mode
V         line-wise visual mode
⌃v        block/column visual mode

gv        reselect last visual selection
o         move to other end of selection
```

### Visual Mode Operations
```
d         delete selection
c         change selection
y         yank selection
>         indent right
<         indent left
=         auto-indent

Example workflow:
    vip   select paragraph
    >     indent it right
    .     repeat (indent more)
```


## Registers — Copy/Paste System

### Named Registers
```
"a        use register 'a' (any letter a–z)

"ayy      yank line to register 'a'
"ap       paste from register 'a'
"Ayy      APPEND line to register 'a'

Use case: save something before deleting other stuff
    "ayiw   yank word to register 'a'
    dd      delete lines (changes default register)
    "ap     paste word from 'a' (still there!)
```

### Special Registers
```
"0        last yank (NOT affected by deletes!)
"+        system clipboard
"_        black hole (delete without saving)
".        last inserted text
"%        current file path
":        last command

Example workflow:
    yiw   yank word (goes to default register)
    dd    delete line (overwrites default register)
    "0p   paste word from yank register (still there!)
```

### Your Custom Yank
```
␣yp     📋  copy current file path to clipboard
"+y     📋  yank to system clipboard
"+p     📋  paste from system clipboard
```


## Macros — Automate Repetitive Tasks

### Recording & Playing
```
qa        start recording to register 'a'
  ...do stuff...
q         stop recording

@a        replay macro from register 'a'
@@        replay last executed macro
10@a      replay macro 10 times
```

### Example: wrap words in quotes
```
qa        start recording
ciw"⎋pa"  change word, add quotes around it
⎋j        go to next line
q         stop

Now on each line with a word:
@a        applies macro once
10@a      applies to next 10 lines
```

### Pro Tip
```
★ Record macros with relative motions (j, k, w, b),
  not absolute motions (search, line numbers).
  Relative macros are reusable; absolute ones aren't.
```


## Search & Replace

### Basic Search
```
/pattern    search forward
?pattern    search backward
n           next match
N           previous match
*           search word under cursor
#           search word backward

/\cpattern  case-insensitive search
/\Cpattern  case-sensitive search
```

### Substitute (Replace)
```
:s/old/new/       replace first on current line
:s/old/new/g      replace all on current line
:%s/old/new/g     replace all in file
:%s/old/new/gc    replace all with confirmation

Visual mode substitute:
    '<,'>s/old/new/g    (added automatically when you type :)
```

### Useful Flags
```
g     global (all matches on line)
c     confirm each replacement
i     case insensitive
I     case sensitive
```


## Essential Tips

### Use the Dot Command
```
.     repeat last change

★ The single most powerful command in Vim.

Example:
    ciw"hello"⎋   change word to "hello"
    w             move to next word
    .             repeat change (changes next word too!)
```

### Use Counts
```
3w        move 3 words forward
2dd       delete 2 lines
5j        move down 5 lines
d3w       delete 3 words
```

### Combine Everything
```
d3w       delete 3 words
c2f,      change up to 2nd comma
y}        yank to end of paragraph
=G        auto-indent to end of file
```

### Center Screen
```
zz        center cursor line on screen
zt        move cursor line to top
zb        move cursor line to bottom
```

### Undo & Redo
```
u         undo
⌃r        redo
U         undo all changes on current line
```


## Quick Reference — Most Used

**Movement:** `w` `b` `e` `^` `$` `{` `}` `f` `;`

**Text Objects:** `iw` `aw` `i"` `a"` `i{` `a{` `it` `at` `af` `if` `ap`

**Operators:** `d` `c` `y` `v` `>` `<` `=`

**Your Keys:** 🔭 `␣␣` · 🔍 `␣/` · 🗂️ `␣,` · 🔁 `␣;` · 📁 `␣e` · 🔎 `␣sw`

**LSP:** 🎯 `␣cd` · 📃 `␣cs` · 🔁 `␣cR` · 🔧 `␣ca` · 🪪 `␣ch`

**Git:** 🪝 `]h` `[h` · 👁️ `␣go` · ↩️ `␣gu` · 📊 `␣gs`

**Snippets:** type prefix → ⏎ to accept → ⇥ through placeholders

**Remember:** `.` repeats your last change — use it constantly!


---

Press `q` to close • Press `␣h` to see dashboard
