# Markview Test Document

Welcome to your newly customized Neovim Markdown experience! This document is designed to test all the custom rendering rules we added to your `markview.nvim` configuration.

## 1. Headings

Notice how each heading level has a unique icon and background color!

### Heading Level 3 (Red/Delete background)

#### Heading Level 4 (CursorLine background)

##### Heading Level 5 (CursorLine background)

###### Heading Level 6 (CursorLine background)

---

## 2. Callouts and Block Quotes

Standard block quotes should have a nice, thick left border:

> "The only way to do great work is to love what you do."
> — Someone on the internet

You also have custom GitHub-style callouts configured. These should render as
colorful, floating boxes:

> [!NOTE]
> This is a standard note. It should have a blueish hue and a specific icon.

> [!WARNING]
> This is a warning callout! It should grab your attention with a yellow/orange theme.

> [!DANGER]
> This is a danger callout. It should look very critical.

---

## 3. Code Blocks

Code blocks should have a distinct background color (CursorLine) and nice
padding. If you enter insert mode inside this block, you'll see the hybrid mode
in action!

```lua
local function hello_world()
    print("Markview hybrid mode is amazing!")
    return true
end
```

```python
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)
```

---

## 4. Checklists

Your lists and checkboxes should be replaced with custom symbols:

- [ ] Unchecked item (Should be a red ✗)
- [x] Checked item (Should be a green ✔)
- [-] Pending item (Should be a yellow ◐)

And here is a standard unordered list:

- First item (Should be a yellow star ★)
- Second item
  - Nested item (Should be a yellow bullet •)
  * Another nested item (Should be a blue arrow ‣)

---

## 5. Tables

Tables should be perfectly aligned and render with clean borders.

| Feature              | Markview | Native Neovim |
| :------------------- | :------: | :-----------: |
| **Inline Rendering** |  ✅ Yes  |     ❌ No     |
| **Hybrid Mode**      |  ✅ Yes  |     ❌ No     |
| **Performance**      | 🚀 High  |    🐢 N/A     |

---

_Try placing your cursor on different elements and entering Insert mode (`i`) to watch them smoothly transition from rendered UI elements back into raw markdown text!_
