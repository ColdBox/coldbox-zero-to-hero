# Step 1 - Scaffold Your Application

Create a folder for your app on your hard drive called `soapbox`.  Our just use the `src` folder from this repo.

## Scaffold the application

```sh
cd src
coldbox create app name=soapbox
# This is the same as above, the default is 'default'
coldbox create app name=soapbox skeleton=default
```

Also run a `coldbox create app ?` to see all the different ways to generate an app.  You can also use `coldbox create app-wizard ?` and follow our lovely wizard.

## Start up a local server

We use a standard port, so that in the steps and in the training we can all use the same port.  It makes it easier for the class. However, please note that you can omit this and use whatever port is available in your machine.  If the `42518` port is already in use, please make sure you use another port.

```sh
server start port=42518
```

- Open `http://localhost:42518/` in your browser. You should see the default ColdBox app template
- Open `/tests` in your browser. You should see the TestBox test browser.  This is useful to find a specific test or group of tests to run _before_ running them.
- Open `/tests/runner.cfm` in your browser. You should see the TestBox test runner for our project

This is running all of our tests by default. We can create our own test runners as needed.

All your tests should be passing at this point. 😉

## Testing via CommandBox

```sh
testbox run
```

You can also configure the way TestBox runs the tests via the `box.json`.  Open it and look for the `testbox` section. You can also find much more detailed information in the docs here:

- https://commandbox.ortusbooks.com/package-management/box.json/testbox
- https://commandbox.ortusbooks.com/testbox-integration/test-runner
- https://commandbox.ortusbooks.com/testbox-integration/test-watcher

Now run the help command to check out all the different ways we can test via the CLI: `testbox run ?`

## CommandBox Test Watchers

CommandBox supports Test Watchers. This allows you to automatically run your tests as you make changes to tests or CFCs in your application. You can start CommandBox Test watchers with the following command:

```sh
testbox watch
```

You can also control what files to watch via the command or via the `testbox` structure in your `box.json` file.

```sh
testbox watch **.cfc
```

`ctl-c` will escape and stop the watching.  Start it up again and now go open the `handlers/Main.cfc` that was generated: [Open](../src/handlers/Main.cfc:8).  Change the `setView()` and introduce a bug by renaming it to `setVView()`. Save the file and check out the watcher!
