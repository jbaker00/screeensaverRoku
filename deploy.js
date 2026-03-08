#!/usr/bin/env node
// Deploy helper - calls roku-deploy with host override
const { deploy } = require('roku-deploy');
const path = require('path');
const fs = require('fs');

const host = process.argv[2];
if (!host) {
    console.error('Usage: node deploy.js <roku-ip>');
    process.exit(1);
}

const configPath = path.join(__dirname, 'rokudeploy.json');
const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
config.host = host;

console.log(`\n🚀 Deploying to ${host}...`);
deploy(config).then(() => {
    console.log(`✅ Successfully deployed to ${host}\n`);
}).catch(err => {
    console.error(`❌ Failed to deploy to ${host}: ${err.message}\n`);
    process.exit(1);
});
