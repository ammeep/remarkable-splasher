# Remarkable Splashes

**These scripts are to be used at your own risk, and come with no gaurenttees. Back up your device before running, and know how to restore the back up. It's possible that this script could brick your device. Use with caution**

Remarkable Spashes utility script that allows for the management and upload of templates (& :soon: splash screens) to be uploaded to the remarkable2 device.

## Dependencies

- nc
- jq
- ssh
- pngquant

## Usage

`Usage: template-compress.sh [-v | -h ]`

`Usage: template-upload.sh [-v | -h | ssh address]`

## Adding Templates

Add new template files to the `remarkable-splashes.sketch` file. Ensure [dimensions](https://remarkablewiki.com/tips/templates) are correct

Each template file is a new page. Name the page and the canvas following the convention `{Category} | {Name}`. `{Category}` is the name of the category that this template will appear under on the device. `{Name}` is the template name on the device.

Export `.pngs` and optionally `.svg` to the project `./templates` directory.

## Troubleshooting

See [here](https://remarkablewiki.com/tips/templates) for further troubleshooting 
