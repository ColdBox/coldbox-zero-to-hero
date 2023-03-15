## 15 - Extra Credit

+ Don't let a user poop and bump the same rant
+ When you bump or poop from the user profile page - take the user back to that page, not the main rant page. Ie - return them to where they started
+ Convert the bump and poop to AJAX calls
+ CSRF tokens for login, register, and new rant
+ Move `queryExecute` to `qb`

Other Ideas:
+ Environments in ColdBox.cfc
+ Domain Names in CommandBox






### 16.1 - Install `qb`

```sh
install qb
```

### 16.2 - Configure `qb`

#### 16.2.1 - Add the following settings to your `/config/Coldbox.cfc` file. You can place this modules setting struct under the settings struct.

```js
// config/ColdBox.cfc
moduleSettings = {
    qb = {
        defaultGrammar = "MySQLGrammar"
    }
};
```
