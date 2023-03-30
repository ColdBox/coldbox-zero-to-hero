/**
 * Debugger config
 */
component accessors="true" {

	function configure(){
		return {
			// Master switch to enable/disable request tracking into storage facilities.
			enabled          : true,
			// Turn the debugger UI on/off by default. You can always enable it via the URL using your debug password
			// Please note that this is not the same as the master switch above
			// The debug mode can be false and the debugger will still collect request tracking
			debugMode        : true,
			// The URL password to use to activate it on demand
			debugPassword    : "cb:null",
			// This flag enables/disables the end of request debugger panel docked to the bottom of the page.
			// If you disable it, then the only way to visualize the debugger is via the `/cbdebugger` endpoint
			requestPanelDock : true,
			// Request Tracker Options
			requestTracker   : {
				// Track all cbdebugger events, by default this is off, turn on, when actually profiling yourself :) How Meta!
				trackDebuggerEvents          : false,
				// Store the request profilers in heap memory or in cachebox, default is memory. Options are: memory, cachebox
				storage                      : "memory",
				// Which cache region to store the profilers in if storage == cachebox
				cacheName                    : "template",
				// Expand by default the tracker panel or not
				expanded                     : true,
				// Slow request threshold in milliseconds, if execution time is above it, we mark those transactions as red
				slowExecutionThreshold       : 1000,
				// How many tracking profilers to keep in stack: Default is to monitor the last 20 requests
				maxProfilers                 : 50,
				// If enabled, the debugger will monitor the creation time of CFC objects via WireBox
				profileWireBoxObjectCreation : false,
				// Profile model objects annotated with the `profile` annotation
				profileObjects               : false,
				// If enabled, will trace the results of any methods that are being profiled
				traceObjectResults           : false,
				// Profile Custom or Core interception points
				profileInterceptions         : false,
				// By default all interception events are excluded, you must include what you want to profile
				includedInterceptions        : [],
				// Control the execution timers
				executionTimers              : {
					expanded           : true,
					// Slow transaction timers in milliseconds, if execution time of the timer is above it, we mark it
					slowTimerThreshold : 250
				},
				// Control the coldbox info reporting
				coldboxInfo : { expanded : false },
				// Control the http request reporting
				httpRequest : {
					expanded        : false,
					// If enabled, we will profile HTTP Body content, disabled by default as it contains lots of data
					profileHTTPBody : false
				}
			},
			// ColdBox Tracer Appender Messages
			tracers     : { enabled : true, expanded : false },
			// Request Collections Reporting
			collections : {
				// Enable tracking
				enabled      : false,
				// Expanded panel or not
				expanded     : false,
				// How many rows to dump for object collections
				maxQueryRows : 50,
				// Max number to use when dumping objects via the top argument
				maxDumpTop   : 5
			},
			// CacheBox Reporting
			cachebox : { enabled : false, expanded : false },
			// Modules Reporting
			modules  : { enabled : false, expanded : false },
			// Quick and QB Reporting
			qb       : {
				enabled   : true,
				expanded  : false,
				// Log the binding parameters
				logParams : true
			},
			// cborm Reporting
			cborm : {
				enabled   : false,
				expanded  : false,
				// Log the binding parameters (requires CBORM 3.2.0+)
				logParams : true
			},
			// Adobe ColdFusion SQL Collector
			acfSql : {
				enabled   : false,
				expanded  : false,
				// Log the binding parameters
				logParams : true
			},
			// Async Manager Reporting
			async : { enabled : true, expanded : false }
		};
	}

}
