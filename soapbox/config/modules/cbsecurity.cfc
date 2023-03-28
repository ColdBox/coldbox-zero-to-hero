component {

	function configure(){
		return {
			/**
			 * --------------------------------------------------------------------------
			 * Authentication Services
			 * --------------------------------------------------------------------------
			 * Here you will configure which service is in charge of providing authentication for your application.
			 * By default we leverage the cbauth module which expects you to connect it to a database via your own User Service.
			 *
			 * Available authentication providers:
			 * - cbauth : Leverages your own UserService that determines authentication and user retrieval
			 * - basicAuth : Leverages basic authentication and basic in-memory user registration in our configuration
			 * - custom : Any other service that adheres to our IAuthService interface
			 */
			authentication : {
				// The WireBox ID of the authentication service to use which must adhere to the cbsecurity.interfaces.IAuthService interface.
				"provider"        : "authenticationService@cbauth",
				// The name of the variable to use to store an authenticated user in prc scope on all incoming authenticated requests
				"prcUserVariable" : "oCurrentUser"
			},
			/**
			 * --------------------------------------------------------------------------
			 * CSRF - Cross Site Request Forgery Settings
			 * --------------------------------------------------------------------------
			 * These settings configures the cbcsrf module. Look at the module configuration for more information
			 */
			csrf : {
				// By default we load up an interceptor that verifies all non-GET incoming requests against the token validations
				enableAutoVerifier     : false,
				// A list of events to exclude from csrf verification, regex allowed: e.g. stripe\..*
				verifyExcludes         : [],
				// By default, all csrf tokens have a life-span of 30 minutes. After 30 minutes, they expire and we aut-generate new ones.
				// If you do not want expiring tokens, then set this value to 0
				rotationTimeout        : 30,
				// Enable the /cbcsrf/generate endpoint to generate cbcsrf tokens for secured users.
				enableEndpoint         : false,
				// The WireBox mapping to use for the CacheStorage
				cacheStorage           : "CacheStorage@cbstorages",
				// Enable/Disable the cbAuth login/logout listener in order to rotate keys
				enableAuthTokenRotator : true
			},
			/**
			 * --------------------------------------------------------------------------
			 * Firewall Settings
			 * --------------------------------------------------------------------------
			 * The firewall is used to block/check access on incoming requests via security rules or via annotation on handler actions.
			 * Here you can configure the operation of the firewall and especially what Validator will be in charge of verifying authentication/authorization
			 * during a matched request.
			 */
			firewall : {
				// Auto load the global security firewall automatically, else you can load it a-la-carte via the `Security` interceptor
				"autoLoadFirewall"            : true,
				// The Global validator is an object that will validate the firewall rules and annotations and provide feedback on either authentication or authorization issues.
				"validator"                   : "CBAuthValidator@cbsecurity",
				// Activate handler/action based annotation security
				"handlerAnnotationSecurity"   : true,
				// The global invalid authentication event or URI or URL to go if an invalid authentication occurs
				"invalidAuthenticationEvent"  : "login",
				// Default Auhtentication Action: override or redirect when a user has not logged in
				"defaultAuthenticationAction" : "redirect",
				// The global invalid authorization event or URI or URL to go if an invalid authorization occurs
				"invalidAuthorizationEvent"   : "rants",
				// Default Authorization Action: override or redirect when a user does not have enough permissions to access something
				"defaultAuthorizationAction"  : "redirect",
				// Firewall database event logs.
				"logs"                        : {
					"enabled"    : true,
					"dsn"        : "",
					"schema"     : "",
					"table"      : "cbsecurity_logs",
					"autoCreate" : true
				},
				// Firewall Rules, this can be a struct of detailed configuration
				// or a simple array of inline rules
				"rules" : {
					// Use regular expression matching on the rule match types
					"useRegex" : true,
					// Force SSL for all relocations
					"useSSL"   : false,
					// A collection of default name-value pairs to add to ALL rules
					// This way you can add global roles, permissions, redirects, etc
					"defaults" : {},
					// You can store all your rules in this inline array
					"inline"   : [
						{
							"whitelist"   : "",
							"securelist"  : "rants/(new|create),poops,bumps",
							"match"       : "url",
							"roles"       : "",
							"permissions" : ""
						}
					]
				}
			},
			/**
			 * --------------------------------------------------------------------------
			 * Security Visualizer
			 * --------------------------------------------------------------------------
			 * This is a debugging panel that when active, a developer can visualize security settings and more.
			 * You can use the `securityRule` to define what rule you want to use to secure the visualizer but make sure the `secured` flag is turned to true.
			 * You don't have to specify the `secureList` key, we will do that for you.
			 */
			visualizer : { "enabled" : true, "secured" : true, "securityRule" : {} }
		};
	}

}
