# Remarkable Splashes

**These scripts are to be used at your own risk, and come with no gaurenttees. Back up your device before running, and know how to restore the back up. It's possible that this script could brick your device. Use with caution**

A utility script that allows for the management and upload of templates to the
remarkable2 device.

Add new template files to the `remarkable-splashes.sketch` file. Export `.pngs` to the
templates directory.

_Note: it is not nessisary for pngs to exist in the sketch file but it is nice to keep page dimensions in check, and provide easy editing in furture_

```
----------------------- Remarkable Splasher -----------------------

Usage: template-upload.sh [-v | -h | ssh address]

Options:
-v			Display version and exit
-h			Display usage and exit
-d			Run script in dry run mode, without ssh access to the device.
-dc		    Clean up previous dry runs.
ip			SSH address of the device (default set to 10.11.99.1)

By defauly when no flag is provided, script will run and copy templates to the device via ssh

```

See [here](https://remarkablewiki.com/tips/templates) for further troubleshooting 
