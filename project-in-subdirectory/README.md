This project shows how to enable debugging and language support when your entire Roku project is in a subdirector (`./src` in this case).

## Language support
You will need to configure a `bsconfig.json` file and set the `rootDir` to point to the folder your code resides in.

## Debugging support
By default, the debugger will read the information from `bsconfig.json`. However, if you need to manually configure it, set the `rootDir` field in the first configuration in `.vscode/launch.json`. 