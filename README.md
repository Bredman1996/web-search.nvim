# web-search.nvim
This plugin is mostly just my first attempt at writing a plugin. 

The main purpose of this is to make searching while developing easier. Rather than having to open a browser and type out a search, this plugin does that for you. As an extension of this, it can also attempt to open directly to Terraform docs. 

## Opts
When opening to a resource/data-source's documentation in the terraform registry, you need to know the `source` for the provider, i.e. `hashicorp/aws`. By default this plugin has the sources for the aws and azurerm providers. These providers are always included in the list, though the source value can be overridden. 

Opts example:
```lua
{
    sourceMaps = {
        { name = "cloudflare", source = "cloudflare/cloudflare" },
    },
}
```

## Commands

### :WebSearch
This opens a prompt and upon the user pressing `ENTER` will open a browser to google with the text entered supplied as the query. 

### :WebSearchSelection
This opens a browser to google with the selected text supplied as the query

### :WebSearchTerraform
This attempts to open a browser to the terraform registry documentation for the highlighted resource/data. 

For example, if you have an `aws_s3_bucket` resource selected, then a browser will be opened to https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket

To appropriately build the url for this, you must ensure that the provider source is specified in the sourceMaps, as shown above.
