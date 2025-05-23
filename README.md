# notes

A simple note-taking web app.

## Tech stack

Rails with Hotwire, Stimulus, Importmaps, Tailwind, and SQLite.

## Getting started

```sh
# clone the repo
git clone https://github.com/jethrodaniel/notes
cd notes

# setup the app
bundle
bin/setup

# run it locally
bin/dev
```

Then visit http://localhost:3000 in your browser.

You can sign in with the default credentials (see `db/seeds.rb` for details):

```
email: admin@example.com
password: password
```

## Logo

To generate the `favicon.ico`:

```
inkscape app/assets/images/icon.svg --export-width=256 --export-filename=tmp.png
convert tmp.png -define icon:auto-resize=256,64,48,32,16 app/assets/images/favicon.ico
rm tmp.png
```

## Testing

```sh
bin/ci
```

You may also need to install dependencies for system tests:

```sh
snap install chromium # e.g, on ubuntu 24.04
```

## Deployment

You can deploy with [kamal](https://kamal-deploy.org/) like so:

- provision a server
- vendor your own `basecamp/kamal-proxy:v0.8.7` image
- `cp .env.example .env`, and fill out your information
- first time: `bin/deploy_setup`
  - TODO: fix/clean up this setup step (might not work on a new server atm)
- subsequent deploys: `bin/deploy`

To vendor your own `kamal-proxy`:

```sh
bin/dotenv bin/update_kamal_proxy
```

## License

Notes is released under the [GNU Affero General Public License Version 3 (AGPLv3) or any later version](https://spdx.org/licenses/AGPL-3.0-or-later.html).

Copyright 2025 Mark Delk. All rights reserved.

## Contributing

While the code is released under the AGPL, I'd still like to be able to release it under something like the [MIT license](https://spdx.org/licenses/MIT.html) eventually.

To that end, contributions aren't accepted (yet).
