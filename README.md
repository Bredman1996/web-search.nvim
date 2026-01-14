# web-search.nvim

A Neovim plugin that simplifies web searching during development. Instead of manually opening a browser and typing searches, this plugin handles it for you. It also includes special support for opening Terraform documentation directly.

## Features

- Quick web search from Neovim
- Search selected text directly
- Direct links to Terraform registry documentation

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
