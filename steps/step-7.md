# 7 - Using Models in Handlers and Views

Now that we have created our first model and unit tested it.  Let's just quickly see how to leverage models in our controller layer in ColdBox, which are called Event Handlers.  There are basically two ways to interact with models:

- Retrieval via WireBox's `getInstance()` method calls
- Injection via Wirebox and CFML `cfproperty`

As a rule of thumb, injections should be done for all singletons.  Meaning, it's ok to inject singletons but not ok to inject transient objects as they could produce scope-widening injection.  Meaning that transients which are supposed to be created and destroyed, can create memory leaks or share scope with other users.

In ColdBox, all event handlers are singletons.  So it's safe to inject singleton models into it.

## Simple Example

Let's just do an example run to see how easy it is to interact with our created model.  Open the [`handlers/Main.cfc`](../src/handlers/Main.cfc) and add the injection of the service:

```js
// Long-format
property name="userService"		inject="UserService";
// Short-format
property name="userService"		inject;
```

> Hint: If the name of the model you want to inject is the same name as the property, then you can simple say `inject`.

Call the `userService.list()` function and store it in a prc variable so our view can use it.

```js
function index(event,rc,prc){
    prc.aUsers = userService.list();
    prc.welcomeMessage = "Welcome to ColdBox!";
    event.setView("main/index");
}
```

Hit `/` in your browser, and you'll get an error - `Messages: variable [USERSERVICE] doesn't exist.`  What happened? Who can tell me why are we getting this error?

### Reinit the Framework

Do you remember how?

### Access Data From the View

Let's now visualize the user listing in our view.  Add the following into the [`/views/main/index.cfm`](../src/views/main/index.cfm) file:

```html
<cfdump var="#prc.aUsers#">
```

What do you get? Cool, our records are there.  Ok, let's try something fun now, let's use a magic helper in ColdBox called the `HTMLHelper` (https://coldbox.ortusbooks.com/digging-deeper/html-helper), which is an object that can help you produce semantic HTML and automatically bind to arrays, objects, orm objects and more.

The `HTMLHelper` is injected in all layouts and views as simply: `html`.  Then you can call methods on it.

```html
#html.table( data : prc.aUsers, class : "table table-striped", excludes : "password,id" )#
```

This will build a nice HTML table for you and present the data in the array.  You can also pass any attribute to this function and it will treat it as an HTML attribute.  If you pass a struct, it will add each key as well.

### Cleanup

Ok, that was fun, now remove the code you just added in this step, let's get down to business and start registering users!
