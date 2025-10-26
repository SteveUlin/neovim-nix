# Neovim Mastery Cheat Sheet

Press `q` to close this file.


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
^         jump to first non-blank character  ⭐ USE THIS
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


## Text Objects - The Real Power

### The Concept
```
i         "inside" - excludes delimiters
a         "around" - includes delimiters

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


## Operators - Combine with Motions/Objects

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

### File Navigation
```
<space><space>    find file (smart picker)
<space>/          live grep across project
<space>,          switch between open buffers
<space>e          file explorer
<space>fr         recent files
<space>fb         grep in open buffers
<space>fs         save file
<space>q          close window
```

### Code Navigation (LSP)
```
<space>cd         go to definition
<space>cR         go to references
<space>cI         go to implementation
<space>cy         go to type definition
<space>cs         LSP symbols in current file  ⭐ GREAT FOR C++
<space>cS         workspace symbols (search all files)

<space>ca         code action (quick fixes, refactoring)
<space>cf         format code
<space>ck         LSP hover (documentation)
<space>ce         show line diagnostics

]]                next reference of word under cursor
[[                previous reference of word under cursor

gd                go to definition (built-in)
Ctrl-o            jump back to previous location
Ctrl-i            jump forward
```

### Search & Grep
```
/pattern          search forward
?pattern          search backward
n                 next match
N                 previous match
*                 search word under cursor forward
#                 search word under cursor backward

<space>sw         grep word under cursor (live grep prefilled)  ⭐
<space>sb         search lines in current buffer
<space>su         undo history picker
<space>;          resume last picker  ⭐ HUGE TIME SAVER

:noh              clear search highlight
```

### Git Navigation
```
]h                next git hunk
[h                previous git hunk

<space>gp         preview hunk (see change in popup)
<space>gh         stage hunk
<space>gu         undo stage hunk
<space>gb         git blame line

<space>gs         git status picker
<space>gd         git diff picker
<space>gl         git log picker
<space>gv         open diffview
<space>gc         close diffview
<space>gf         diffview file history
```

### Buffer Navigation
```
]b                next buffer
[b                previous buffer
<space>,          buffer picker
```

### Window Management
```
<space>wh         move to left window
<space>wj         move to down window
<space>wk         move to up window
<space>wl         move to right window

<space>ws         split horizontal
<space>wv         split vertical
<space>ww         cycle to next window

Ctrl-w =          equalize window sizes
Ctrl-w _          maximize height
Ctrl-w |          maximize width
```

### Dashboard & Help
```
<space>h          open dashboard
<space>?          open this cheat sheet
```


## Visual Mode

### Entering Visual Mode
```
v                 character-wise visual mode
V                 line-wise visual mode
Ctrl-v            block/column visual mode

gv                reselect last visual selection
o                 move to other end of selection
```

### Visual Mode Operations
```
d                 delete selection
c                 change selection
y                 yank selection
>                 indent right
<                 indent left
=                 auto-indent

Example workflow:
    vip           select paragraph
    >             indent it right
    .             repeat (indent more)
```


## Registers - Copy/Paste System

### Named Registers
```
"a                use register 'a' (any letter a-z)

"ayy              yank line to register 'a'
"ap               paste from register 'a'
"Ayy              APPEND line to register 'a'

Use case: Save something before deleting other stuff
    "ayiw         yank word to register 'a'
    dd            delete lines (changes default register)
    "ap           paste word from 'a' (still there!)
```

### Special Registers
```
"0                last yank (NOT affected by deletes!)
"+                system clipboard
"_                black hole (delete without saving)
".                last inserted text
"%                current file path
":                last command

Example workflow:
    yiw           yank word (goes to default register)
    dd            delete line (overwrites default register)
    "0p           paste word from yank register (still there!)
```

### Your Custom Yank
```
<space>yp         copy current file path to clipboard
"+y               yank to system clipboard
"+p               paste from system clipboard
```


## Macros - Automate Repetitive Tasks

### Recording & Playing
```
qa                start recording to register 'a'
  ...do stuff...
q                 stop recording

@a                replay macro from register 'a'
@@                replay last executed macro
10@a              replay macro 10 times
```

### Example: Wrap Words in Quotes
```
qa                start recording
ciw"<Esc>pa"      change word, add quotes around it
<Esc>j            go to next line
q                 stop

Now on each line with a word:
@a                applies macro once
10@a              applies to next 10 lines
```

### Pro Tip
```
Record macros with relative motions (j, k, w, b)
Not absolute motions (like search or line numbers)
This makes them more reusable!
```


## Search & Replace

### Basic Search
```
/pattern          search forward
?pattern          search backward
n                 next match
N                 previous match
*                 search word under cursor
#                 search word backward

/\cpattern        case-insensitive search
/\Cpattern        case-sensitive search
```

### Substitute (Replace)
```
:s/old/new/       replace first on current line
:s/old/new/g      replace all on current line
:%s/old/new/g     replace all in file
:%s/old/new/gc    replace all with confirmation

Visual mode substitute:
    '<,'>s/old/new/g    (automatically added when you type :)
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

This is the MOST POWERFUL command in Vim!

Example:
    ciw"hello"<Esc>     change word to "hello"
    w                    move to next word
    .                    repeat change (changes next word too!)
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
Ctrl-r    redo
U         undo all changes on current line
```


## Quick Reference - Most Used

**Movement:** `w` `b` `e` `^` `$` `{` `}` `f` `;`

**Text Objects:** `iw` `aw` `i"` `a"` `i{` `a{` `it` `at` `af` `if` `ap`

**Operators:** `d` `c` `y` `v` `>` `<` `=`

**Your Keys:** `<space><space>` `<space>/` `<space>,` `<space>;` `<space>e` `<space>sw`

**LSP:** `<space>cd` `<space>cs` `<space>cR` `<space>ca`

**Git:** `]h` `[h` `<space>gp` `<space>gh` `<space>gs`

**Remember:** `.` repeats your last change - use it constantly!


---

Press `q` to close • Press `<space>h` to see dashboard
