# 15 - Extra Credit

We have reached the end of our course.  There are still so many things to do, so let's make a list of extra credit work we can do:

- [ ] Don't let a user poop and bump the same rant
- [ ] When you bump or poop from the user profile page - take the user back to that page, not the main rant page. Ie - return them to where they started
- [ ] Convert the bump and poop to AJAX calls
- [ ] Move `queryExecute` to `qb`

## 16 - Install `qb`

```sh
install qb
```

Now create its configuration file:

```js
// config/modules/qb.cfc
component accessors="true" {

	function configure(){
		return { defaultGrammar : "MySQLGrammar" };
	}

}
```

Now go update all the queries to use QB instead: https://qb.ortusbooks.com/
