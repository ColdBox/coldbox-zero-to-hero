## 7 - Using Models in Handlers and Views

### Inject the `UserService` into your Main Handler.

Add the injection into your `/handlers/Main.cfc`

```js
property name="userService"		inject="UserService";
```

### Use the `userService.list()` call to retrieve the user list

Call the userService.list() function and store it in a prc variable.

```js
function index(event,rc,prc){
    prc.userList = userService.list();
    prc.welcomeMessage = "Welcome to ColdBox!";
    event.setView("main/index");
}
```

Hit `/` in your browser, and you'll get an error - `Messages: variable [USERSERVICE] doesn't exist.`  What happened? Who can tell me why are we getting this error?


### Reinit the Framework

Hit '/?fwreinit=1' and now you will not see the error.

### Check the List call is working

Add a writeDump in the handler, to ensure the call is succeeding.

```js
writeDump( prc.userList );abort;
```

You'll see something like this

```sh
Array (from Query)
Template: /YourAppDirectory/models/UserService.cfc
Execution Time: 1.08 ms
Record Count: 0
Cached: No
SQL:
select * from users
```

### Access the data from the View

Remove the `writeDump` from the handler.

Add the following into the `/views/main/index.cfm` file, replacing the contents completely.

```html
<cfdump var="#prc.userList#">
```

Reload your `/` page, and you'll see the layout ( which wasn't present in the handler dump ) and the dump of an empty array.

Now we can build our registration flow.
