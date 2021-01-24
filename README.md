# Remarkable Splashes

**These scripts are to be used at your own risk, and come with no gaurenttees. Back up your device before running, and know how to restore the back up. It's possible that this script could brick your device. Use with caution**

Remarkable Spashes utility script that allows for the management and upload of templates (& :soon: splash screens) to be uploaded to the remarkable2 device. These script will not preserve any existing custom templates by default. 

## Dependencies

- nc
- jq
- ssh
- pngquant

## Usage

Upload template images to the device

`Usage:rm2-templates [-v | -h ]`

Utility script to provide maximum image compression. Large template file sizes consume valuable storage on the device. Space is at a premium, and image compression is advised.

`Usage: rm2-compress [-v | -h | ssh address]`

## Adding Templates

Add new template files to the `remarkable-splashes.sketch` file. Ensure [dimensions](https://remarkablewiki.com/tips/templates) are correct

Each template file is a new page. Name the page and the canvas following the convention `{Category} | {Name}`. `{Category}` is the name of the category that this template will appear under on the device. `{Name}` is the template name on the device.

Export `.pngs` and optionally `.svg` to the project `./templates` directory.

## Preserving Existing Custom Templates
This script will not preserve any of your existing installed custom templates. However, can preserve these templates with some additional work. Built in support for this may come in the future.

Copy from the device your existing `templates.json`. Place it in this directory, replacing the existing file in the repository.

## Troubleshooting

See [here](https://remarkablewiki.com/tips/templates) for further troubleshooting 
