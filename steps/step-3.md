# 3 - Layouts

In ColdBox, you can have as many layouts as you want.  You can also have layouts render inside of them other layouts by calling the `layout()` method.  This allows you to easily create nested layouts and view combinations.

## Custom CSS

* Add a custom css file: `includes/css/app.css` with the content below.  You can easily create a new file with CommandBox: `touch includes/css/app.css`

```css
/* includes/css/app.css */

body {
    font-family: "Lato", sans-serif;
    min-height: 75rem;
    padding-top: 3.5rem;
}

main{
	margin-bottom: 100px;
}

.main-navbar {
    box-shadow: 0 15px 30px 0 rgba(0, 0, 0, 0.11), 0 5px 15px 0 rgba(0, 0, 0, 0.08);
}

.text-blue { color:#379BC1; }
```

Now let's add this include to our header in our `layouts/Main.cfm`:

```html
<!---
    CSS
    - Bootstrap
    - Alpine.js
    - App
--->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
<link rel="stylesheet" href="/includes/css/app.css">
```

## Layout Updates

Let's update a few things in our layout:

* Add a `<title>SoapBox : Micro-blogging platform</title>` tag
* Let's create the About navigation in the header section
* Use the request context's `routeIs()` method to set the `active` css
* Use the request context's `buildLink()` method to build a link to the `about` route

Our layout should end up like this:

```html
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
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
	<link rel="stylesheet" href="/includes/css/app.css">

	<!--- Title --->
	<title>SoapBox : Micro-blogging platform</title>
</head>
<body
	data-spy="scroll"
	data-target=".navbar"
	data-offset="50"
	style="padding-top: 60px"
	class="d-flex flex-column h-100"
>
	<!---Top NavBar --->
	<header>
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
            <div class="container-fluid">

                <!---Brand --->
                <a class="navbar-brand text-info" href="#event.buildLink( 'main' )#">
                    <i class="bi bi-boombox"></i>
                    <strong>SoapBox</strong>
                </a>

                <!--- Mobile Toggler --->
                <button
                    class="navbar-toggler"
                    type="button"
                    data-bs-toggle="collapse"
                    data-bs-target="##navbarSupportedContent"
                    aria-controls="navbarSupportedContent"
                    aria-expanded="false"
                    aria-label="Toggle navigation"
                >
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="navbarSupportedContent">

                    <li class="nav-item me-2">
                        <a
                            class="nav-link #event.routeIs( "about" ) ? 'active' : ''#"
                            href="#event.buildLink( 'about' )#"
                            >
                            About
                        </a>
                    </li>

                </div>
            </div>
        </nav>
	</header>

	<!---Container And Views --->
	<main class="flex-shrink-0">
		#view()#
	</main>

	<!--- Footer --->
	<footer class="w-100 bottom-0 position-fixed border-top py-3 mt-5 bg-light">
        <div class="container">
            <p class="float-end">
                <a href="##" class="btn btn-info rounded-circle shadow" role="button">
                    <i class="bi bi-arrow-bar-up"></i> <span class="visually-hidden">Top</span>
                </a>
            </p>
            <p>
                <a href="https://github.com/ColdBox/coldbox-platform/stargazers">ColdBox Platform</a> is a copyright-trademark software by
                <a href="https://www.ortussolutions.com">Ortus Solutions, Corp</a>
            </p>

            <span
                class="badge rounded-pill text-bg-dark"
                data-bs-toggle="tooltip"
                title="Environment"
            >
                <i class="bi bi-hdd-stack"></i>
                #getSetting( "environment" )#
            </span>

            <span
                class="badge rounded-pill text-bg-dark"
                data-bs-toggle="tooltip"
                title="Debug Mode"
            >
                <i class="bi bi-bug"></i>
                #isDebugMode()#
            </span>

            <span
                class="badge rounded-pill text-bg-dark"
                data-bs-toggle="tooltip"
                title="Request Date/Time"
            >
                <i class="bi bi-calendar"></i>
                #getIsoTime()#
            </span>
        </div>
    </footer>

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

```

## Partials

View partials, are just that, partial views or includes that can be rendered in any layout, view, model, etc.  Let's use CommandBox for that:

```bash
coldbox create view partials/navigation
coldbox create view partials/footer
```

Then we can add partials into our layout:

```html
<!---Top NavBar --->
<header>
    #view( "partials/navigation" )#
</header>

<!---Container And Views --->
<main class="flex-shrink-0">
    #view()#
</main>

<!--- Footer --->
#view( "partials/footer" )#
```

This is the final layout for this section

```html
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
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
	<link rel="stylesheet" href="/includes/css/app.css">

	<!--- Title --->
	<title>Welcome to Coldbox!</title>
</head>
<body
	data-spy="scroll"
	data-target=".navbar"
	data-offset="50"
	style="padding-top: 60px"
	class="d-flex flex-column h-100"
>
	<!---Top NavBar --->
	<header>
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
```
