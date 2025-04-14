# README

A simple note-taking app.

## Install

- Prerequisites:
  - Ruby 3.4.x (https://www.ruby-lang.org/en/documentation/installation/)
  - Bundler (`gem install bundler`)
- Clone the repository (`git clone xxx`)
- Run `bin/setup` (only needed once)
- Run `bin/dev`
- Visit `http://localhost:3000` in your browser

## Tech stack

Rails 8 with Hotwire, Stimulus, Tailwind, and SQLite.

## Deployment

Copy the sample config, and fill in your information:

```
cp .env.example .env
```

Then deploy with [kamal](https://kamal-deploy.org/):

```
# first-time
bundle exec dotenv bin/kamal deploy

# everytime afterwards
bundle exec dotenv bin/kamal redeploy
```

## Development

### Tests

```
bin/rails test
bin/rails test:all # includes system tests
```

For system tests, you'll also need `chromium`:

```
# e.g, on ubuntu 24.04
snap install chromium
```

### Mobile dev

The `Procfile` is updated to run `rails s` with `-b 0.0.0.0`, so other devices on the same network can access it.

This is useful for testing on your phone at `<YOUR IP>:3000`.

E.g, on Ubuntu, if we run `ip addr show | grep 192`, and find we're running on `192.168.0.26`, then we'd visit http://192.168.0.26:3000

TODO: self-signed SSL for testing PWA functionality

## Contributing

You don't, this isn't open-source.
