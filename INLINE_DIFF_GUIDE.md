# Inline Diff Overlay - Quick Guide

## What is it?

The inline diff overlay shows your git changes directly in your file with detailed diff information. You can selectively accept or reject (undo) individual changes without committing.

## Usage

### Toggle Overlay
```
<space>go     toggle inline diff overlay on/off
```

### In Overlay Mode

**Navigate hunks:**
```
]h            next hunk
[h            previous hunk
```

**Selective undo (the main feature!):**
```
gH            undo changes in hunk under cursor
gHip          undo changes in paragraph
vip then gH   undo changes in visual selection
gH_           undo current line
```

After using `gH`, that specific change reverts back to the git version.

**Stage hunks (optional):**
```
gh            stage hunk to git (like git add)
              useful before committing changes you want to keep
```

## Workflow Example

### Scenario: You made several changes and want to review them

1. **Open the file with changes**
   ```
   vim myfile.cpp
   ```

2. **Toggle overlay to see all changes inline**
   ```
   <space>go
   ```
   Now you see:
   - Added lines highlighted
   - Changed lines highlighted
   - Deleted lines shown inline
   - Exact diff details

3. **Navigate through changes**
   ```
   ]h    go to next change
   [h    go to previous change
   ```

4. **Selectively undo unwanted changes**

   Found a change you want to revert?
   ```
   gH    undo this hunk (reverts to git version)
   ```

   The change disappears from your buffer - gone!

5. **Toggle overlay off when done**
   ```
   <space>go
   ```

## Advanced Usage

### Text Objects with Hunks

Combine with motions for precise control:

```
gHip          undo hunks in current paragraph
gHap          undo hunks around paragraph
gH3j          undo hunks from current to 3 lines down
```

### Visual Selection

Select specific regions:

```
vip           select paragraph
gH            undo all hunks in selection

V3j           select 3 lines
gH            undo all hunks in those lines
```

### Dot Repeat

Hunk operations are dot-repeatable:

```
gHip          undo hunks in paragraph
]h            go to next hunk
.             repeat (undo next paragraph's hunks)
```

### Undo Safety

**Accidentally typed `gH`? (reverted when you didn't want to)**
```
gH            oops! reverted my changes
u             vim undo - brings them back!
```

**Accidentally typed `gh`? (staged when you meant to revert)**

`gh` stages changes to git (like `git add`), NOT a buffer operation!

```
gh            oops! staged the hunk (meant to type gH)
<space>gu     unstage it (gitsigns undo stage)
gH            NOW revert the change (what you wanted)
```

Remember:
- `gH` = buffer operation → undo with `u`
- `gh` = git staging operation → unstage with `<space>gu`

## Tips

1. **Use overlay for review** - Turn it on, review all changes, turn it off
2. **Quick selective undo** - Made unwanted edits? `gH` to undo specific hunks
3. **Navigate first** - Use `]h`/`[h` to jump between hunks quickly
4. **Save after undoing** - Remember to `:w` to save after reverting changes
5. **Accident protection** - Pressed `gH` by mistake? Just press `u` to undo!

## Comparison to Other Git Tools

**vs. `<space>gp` (preview hunk):**
- Preview: Shows one hunk in a popup
- Overlay: Shows ALL hunks inline at once

**vs. `<space>gv` (diffview):**
- Diffview: Split view, good for comparing entire files
- Overlay: Inline view, good for quick selective undo

**vs. `<space>gh` (stage hunk from gitsigns):**
- Stage hunk: Stages changes for git commit
- Overlay + gH: Reverts changes in your buffer (before commit)

## Common Workflows

### Code Review of Your Own Changes
```
<space>go     toggle overlay
]h ]h ]h      jump through changes
gH            undo unwanted changes
<space>go     close overlay
:w            save the file
```

### Fixing Accidental Edits
```
<space>go     see all changes
]h            find the bad change
gH            undo it
<space>go     close overlay
```

### Reviewing Bulk Edits (find/replace, refactor, etc)
```
<space>go     see all changes inline
]h            jump to next change
gH            undo if wrong
]h            next change
]h            next change
<space>go     done reviewing
```

---

Press `q` to close this file
