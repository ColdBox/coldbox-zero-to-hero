# ColdBox: Zero to Hero

## Getting Started

This repo contains a sample application built to showcase ColdBox.
To get the most out of the workshop, it is expected that a person
following along with this workshop will build their own app from scratch,
using this repository only as a guide. The code for the finished sample
app is included here with branches as a reference.

Check out the [prerequisites guide](PREREQUISITES.md) to make sure your system is ready to go.

## Running the Completed App

To view the completed sample app, clone the repository and install the dependencies.

```
git clone https://github.com/ortus-solutions/coldbox-zero-to-hero.git
cd coldbox-zero-to-hero
box install
```

Ensure that [`commandbox-dotenv`](https://www.forgebox.io/view/commandbox-dotenv)
and [`commandbox-migrations`](https://www.forgebox.io/view/commandbox-migrations)
are installed in CommandBox.

Next, copy the `.env.example` file to `.env`. Fill in the values to connect to
your database server.

Run your database migrations:

```
box migrate up
```

Start your local server with `box start`. You should be able to view the app at
`http://localhost:42518`
