# New Year Countdown Screensaver

Roku screensaver showing an elegant real-time countdown to midnight on New Year's Eve — dark navy design with gold accents and sparkle animation.

## Deploy

Make sure your Roku devices are in **Developer Mode** and on the same network, then:

```bash
npm install                  # first time only
npm run deploy:living-room   # → 192.168.6.36
npm run deploy:guest         # → 192.168.4.39
npm run deploy:master        # → 192.168.4.35
npm run deploy:kids          # → 192.168.4.34
npm run deploy:all           # → all four devices
```

## Device Map

| Script | Room | IP |
|---|---|---|
| `deploy:living-room` | Living Room | 192.168.6.36 |
| `deploy:guest` | Guest Room | 192.168.4.39 |
| `deploy:master` | Master Bedroom | 192.168.4.35 |
| `deploy:kids` | Kids Room | 192.168.4.34 |

## Other Scripts

```bash
npm run lint   # BrightScript lint via bslint
npm run sca    # Roku static code analysis
```

## How Deploy Works

`deploy.js` uses [roku-deploy](https://github.com/rokucommunity/roku-deploy) to zip and sideload the channel directly to the Roku device over HTTP (Roku's developer web interface on port 80). Configuration is in `rokudeploy.json`.

Files deployed to the device:
```
manifest
source/**/*
components/**/*
images/**/*
```

Output package is written to `/tmp/NewYearCountdown.zip`.

## Enabling Developer Mode on a Roku

1. From the Roku home screen press: **Home × 3, Up × 2, Right, Left, Right, Left, Right**
2. Follow the prompts to enable dev mode
3. Note the device IP shown on screen — update `package.json` if it changes

## Project Structure

```
screeensaverRoku/
├── manifest           # Roku app metadata (title, version, screensaver flags)
├── source/            # BrightScript source files
├── components/        # SceneGraph XML components
├── images/            # App icons and assets
├── deploy.js          # Deploy helper (wraps roku-deploy)
├── rokudeploy.json    # roku-deploy config (credentials, output settings)
└── package.json       # npm scripts for per-device and all-device deployment
```
