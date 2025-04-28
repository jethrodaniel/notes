# notes

A simple note-taking app.

## Tech stack

Rails with Hotwire, Stimulus, Tailwind, and SQLite.

## Install

- Prerequisites:
  - Ruby 3.4.x (https://www.ruby-lang.org/en/documentation/installation/)
  - Bundler (`gem install bundler`)
- Clone the repository (`git clone xxx`)
- Run `bin/setup` (only needed once)
- Run `bin/dev`
- Visit `http://localhost:3000` in your browser

## Deployment

The app is deployed with [kamal](https://kamal-deploy.org/).

One-time setup:

1) Copy the sample config, and fill in your information:

```
cp .env.example .env
```

2) Vendor basecamp/kamal-proxy, and configure deployments to use that

We use our own private image, instead of basecamp/kamal-proxy, otherwise we
hit docker.com rate-limiting:

> Unable to find image 'basecamp/kamal-proxy:v0.8.7' locally
> docker: Error response from daemon: toomanyrequests: You have reached your unauthenticated pull rate limit. https://www.docker.com/increase-rate-limit.

To vendor the image:

```
docker pull basecamp/kamal-proxy:v0.8.4

docker login <REGISTRY>

docker tag basecamp/kamal-proxy:v0.8.4 <REGISTRY>/<USER>/kamal-proxy:v0.8.4
docker push <REGISTRY>/<USER>/kamal-proxy:v0.8.4
```

To configure the server to use that image:

```
bin/dotenv kamal proxy boot_config set --registry=<REGISTRY> --image-version=v0.8.7 --repository=<USER>
```

3) Install everything on the server

```
bin/dotenv kamal deploy
```

Afterwards, regular deployments just need this:

```
bin/dotenv kamal redeploy
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
