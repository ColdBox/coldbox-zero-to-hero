# 1 - Scaffold Your Application

### Create a folder for your app on your hard drive called `soapbox`

### Scaffold out a new Coldbox application with TestBox included


```sh
coldbox create app soapbox
```
`

### Start up a local server

```sh
start port=42518
```

### Open `http://localhost:42518/` in your browser. You should see the default ColdBox app template

### Open `/tests` in your browser. You should see the TestBox test browser

This is useful to find a specific test or group of tests to run _before_ running them.

### Open `/tests/runner.cfm` in your browser. You should see the TestBox test runner for our project

This is running all of our tests by default. We can create our own test runners as needed.

All your tests should be passing at this point. 😉

### Let's run the Tests via CommandBox

```sh
testbox run "http://localhost:42518/tests/runner.cfm"
```

### Lets add this url to our server.json

We can set the testbox runner into our server.json, and then we can easily run the tests at a later stage without having to type out the whole url. To do so, we use the `package set` command.

```sh
package set testbox.runner="http://localhost:42518/tests/runner.cfm"
testbox run
```

### Use CommandBox Test Watchers

CommandBox now supports Test Watchers. This allows you to automatically run your tests run as you make changes to tests or cfcs. You can start CommandBox Test watchers with the following command

```sh
testbox watch
```

You can also control what files to watch.

```sh
testbox watch **.cfc
```

`ctl-c` will escape and stop the watching.
