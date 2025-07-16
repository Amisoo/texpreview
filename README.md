## texpreview

A LaTeX plugin that preview a math environnement in the os browser

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
  "Amisoo/texpreview",
  config = function()
    require("texpreview").setup({
      notify = true,
    })
  end,
  ft = { "tex", "latex"}, -- Specify filetypes for which this plugin should be loaded
}
```
## mapping

`:Mathenv` &rarr; display current equation