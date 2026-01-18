# web-search.nvim

A Neovim plugin that simplifies web searching during development. Instead of manually opening a browser and typing searches, this plugin handles it for you. It also includes special support for opening Terraform documentation directly.

## Features

- Quick web search from Neovim
- Search selected text directly
- Direct links to Terraform registry documentation

## Installation

### Lazy.nvim

```lua
{
  'bredman1996/web-search.nvim',
  config = function()
    require('web-search').setup({
        sourceMaps = {},
        browserCommand = 'chromium',
        browserArguments = {},
    })
    vim.keymap.set('n', '<leader>wS', '<cmd>WebSearch<CR>', { desc = 'WebSearch Prompt' })
    vim.keymap.set('v', '<leader>wS', '<cmd>WebSearchSelection<CR>', { desc = 'WebSearch Search Highlighted' })
    vim.keymap.set('v', '<leader>wt', '<cmd>WebSearchTerraform<CR>', { desc = 'WebSearch Search Terraform' })
  end,
  },
}
```

### Packer

```lua
use({
  'bredman1996/web-search.nvim',
  config = function()
    require('web-search').setup({
      sourceMaps = {},
      browserCommand = 'chromium',
      browserArguments = {},
    })
    vim.keymap.set('n', '<leader>wS', '<cmd>WebSearch<CR>', { desc = 'WebSearch Prompt' })
    vim.keymap.set('v', '<leader>wS', '<cmd>WebSearchSelection<CR>', { desc = 'WebSearch Search Highlighted' })
    vim.keymap.set('v', '<leader>wt', '<cmd>WebSearchTerraform<CR>', { desc = 'WebSearch Search Terraform' })
  end,
})
```

## Configuration

### Provider Source Maps

When opening Terraform resource or data-source documentation, the plugin needs to know the provider source (e.g., `hashicorp/aws`). By default, the plugin includes sources for:
- `aws` → `hashicorp/aws`
- `azurerm` → `hashicorp/azurerm`

These providers are always included, but their source values can be overridden. You can add additional providers via the `sourceMaps` option.

**Example configuration:**

```lua
require('web-search').setup({
    sourceMaps = {
        { name = "cloudflare", source = "cloudflare/cloudflare" },
    },
})
```

### Browser Command
By default the plugin uses `xdg-open`, this can be overridden by specifying the `browserCommand` configuration option. 

### Browser Arguments
If you need to send any custom arguments when opening the browser use the `browserArguments` option.

## Commands

### `:WebSearch`

Opens an input prompt. After entering your search query and pressing `ENTER`, it opens your browser to Google with the entered text as the search query.

### `:WebSearchSelection`

Opens your browser to Google with the currently selected/visual text as the search query.

### `:WebSearchTerraform`

Attempts to open your browser directly to the Terraform registry documentation for the highlighted resource or data source.

**Example:** If you have `aws_s3_bucket` selected, it will open:
```
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
```

**Note:** To use this command, ensure the provider source is specified in your `sourceMaps` configuration (see Configuration section above).
