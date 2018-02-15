(All commands assume we are in the `box` shell unless stated otherwise.)

1. Create a folder for your app on your hard drive called `soapbox`.
2. Scaffold out a new Coldbox application with TestBox included.

```
coldbox create app soapbox --installTestBox
```

3. Start up a local server

```
start port=42518
```

4. Open `http://localhost:42518/` in your browser. You should see the default ColdBox app template.

5. Open `/tests` in your browser. You should see the TestBox test browser.
   This is useful to find a specific test or group of tests to run _before_ running them.

6. Open `/tests/runner.cfm` in your browser. You should see the TestBox test runner for our project.
   This is running all of our tests by default. We can create our own test runners as needed.

All your tests should be passing at this point. 😉

7. Show routes file. Explain routing by convention.
8. Show `Main.index`.
9. Explain `event`, `rc`, and `prc`.
10. Explain views. Point out view conventions.
11. Briefly touch on layouts.
12. Show how `rc` and `prc` are used in the views.

13. Add an about page
    a. Add an `views/about/index.cfm`. It works!
    b. Add an `about` handler. Now it breaks! Talk about reinits.
    c. Add an `index` action. Back to working!

Reinits
What is cached?

* Singletons
* Handler discovery

7. Install [commandbox-migrations](https://www.forgebox.io/view/commandbox-migrations)

```
install commandbox-migrations
```

You should see a list of available commands with `migrate ?`.

8. Initalize migrations using `migrate init`

9. Install [commandbox-dotenv](https://www.forgebox.io/view/commandbox-dotenv)

10. Create a `.env` file
