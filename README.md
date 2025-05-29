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
- `cp .env.example .env`, then fill out your information
- vendor your own `basecamp/kamal-proxy` image: `bin/dotenv bin/update_kamal_proxy`
- first time: `bin/deploy_setup`
- subsequent deploys: `bin/deploy`

## Logo

To generate the `favicon.ico`:

```
inkscape app/assets/images/icon.svg --export-width=256 --export-filename=tmp.png
convert tmp.png -define icon:auto-resize=256,64,48,32,16 app/assets/images/favicon.ico
rm tmp.png
```

## I18n

Users can change their language in-app to either English or Spanish.

Non-logged in pages (e.g, sign-in) aren't translated yet.

Non-english translations were performed (crudely) using Duckduckgo translate.

Spanish `datetime.distance_in_words` translations are from [svenfuchs/rails-i18n](https://github.com/svenfuchs/rails-i18n/blob/16ed6762fb666e91251e350572fadbea68c68359/rails/locale/es.yml#L63C1-L101C31) ([MIT](https://github.com/svenfuchs/rails-i18n/blob/16ed6762fb666e91251e350572fadbea68c68359/MIT-LICENSE.txt)).

## License

Notes is released under the [GNU Affero General Public License Version 3 (AGPLv3) or any later version](https://spdx.org/licenses/AGPL-3.0-or-later.html).

Copyright 2025 Mark Delk. All rights reserved.

## Contributing

While the code is released under the AGPL, I'd still like to be able to release it under something like the [MIT license](https://spdx.org/licenses/MIT.html) eventually.

To that end, contributions aren't accepted (yet).
