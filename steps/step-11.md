## 11 - Securing our App

We're going to use CBSecurity to help secure our app.

### Install CBSecurity

`install cbsecurity`

### Configure CBSecurity

Configure `cbsecurity`, add the settings in your `ColdBox.cfc` under the `moduleSettings`. You can find the keys here: https://forgebox.io/view/cbSecurity


```js
//config/Coldbox.cfc
// in the module settings struct
cbsecurity = {
	// The global invalid authentication event or URI or URL to go if an invalid authentication occurs
	"invalidAuthenticationEvent"	: "login",
	// Default Auhtentication Action: override or redirect when a user has not logged in
	"defaultAuthenticationAction"	: "redirect",
	// The global invalid authorization event or URI or URL to go if an invalid authorization occurs
	"invalidAuthorizationEvent"		: "login",
	// Default Authorization Action: override or redirect when a user does not have enough permissions to access something
	"defaultAuthorizationAction"	: "redirect",
	// You can define your security rules here or externally via a source
	"rules"							: [
        {
            "whitelist": "",
            "securelist": "rants/new",
            "match": "url"
        }
    ],
	// The validator is an object that will validate rules and annotations and provide feedback on either authentication or authorization issues.
	"validator"						: "CBAuthValidator@cbsecurity",
	// The WireBox ID of the authentication service to use in cbSecurity which must adhere to the cbsecurity.interfaces.IAuthService interface.
	"authenticationService"  		: "authenticationService@cbauth",
	// WireBox ID of the user service to use
	"userService"             		: "UserService",
	// Activate handler/action based annotation security
	"handlerAnnotationSecurity"		: true,
	// Activate security rule visualizer, defaults to false by default
	"enableSecurityVisualizer"		: true
}
```

Reinit the framework

`coldbox reinit`

Check out the security visualizer: http://127.0.0.1:42518/cbsecurity

Now, hit the page while logged out. if you hit `start a rant` link, you should redirect to the login page

Now log in and make sure you see the rant page.
