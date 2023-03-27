<cfoutput>
<!doctype html>
<html lang="en">
<head>
	<!--- Metatags --->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="description" content="ColdBox Application Template">
    <meta name="author" content="Ortus Solutions, Corp">

	<!---Base URL --->
	<base href="#event.getHTMLBaseURL()#" />

	<!---
		CSS
		- Bootstrap
		- Alpine.js
		- App
	--->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
	<link rel="stylesheet" href="/includes/css/app.css">

	<!--- Title --->
	<title>Welcome to Coldbox!</title>
</head>
<body
	data-spy="scroll"
	data-target=".navbar"
	data-offset="50"
	class="d-flex flex-column h-100"
>
	<!---Top NavBar --->
	<header>
		<cfif flash.exists( "notice" )>
			<div class="alert alert-#flash.get( "notice" ).type#" role="alert">
				#flash.get( "notice" ).message#
			</div>
		</cfif>

		#view( "partials/navigation" )#
	</header>

	<!---Container And Views --->
	<main class="flex-shrink-0">
		#view()#
	</main>

	<!--- Footer --->
	#view( "partials/footer" )#

	<!---
		JavaScript
		- Bootstrap
		- Alpine.js
	--->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>
	<script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
	<script>
		// self executing function here
		(function() {
		// your page initialization code here
		// the DOM will be available here
			const aTooltips = document.querySelectorAll( '[data-bs-toggle="tooltip"]' );
			const tooltipList = [...aTooltips ].map( el => new bootstrap.Tooltip( el ) );
		})();
	</script>
</body>
</html>
</cfoutput>
