const crypto = require('crypto');
const https = require('https');

const fs = require('fs');

let serviceAccountJson = process.env.FIREBASE_SERVICE_ACCOUNT_KEY;
let appVersion = process.env.APP_VERSION;
let appDesc = '新版本现已发布，点击查看最新更新日志！';

// Try to read version.json first
try {
  if (fs.existsSync('version.json')) {
    const versionData = JSON.parse(fs.readFileSync('version.json', 'utf8'));
    if (!appVersion && versionData.version) {
      appVersion = versionData.version;
    }
    if (versionData.changelog) {
      appDesc = versionData.changelog.en || versionData.changelog.zh || versionData.changelog.ja || appDesc;
    }
  }
} catch (e) {
  console.warn("FCM Warning: Failed to parse version.json:", e);
}

// Fallback to pubspec.yaml if version still not determined
if (!appVersion) {
  try {
    const pubspec = fs.readFileSync('pubspec.yaml', 'utf8');
    const match = pubspec.match(/^version:\s*([^\s+]+)/m);
    if (match) {
      appVersion = match[1];
    }
  } catch (e) {
    appVersion = '1.0.0';
  }
}

if (!serviceAccountJson) {
  const localKeyPath = 'firebase-service-account.json';
  if (fs.existsSync(localKeyPath)) {
    console.log(`FCM: FIREBASE_SERVICE_ACCOUNT_KEY env is missing, reading from local ${localKeyPath}...`);
    serviceAccountJson = fs.readFileSync(localKeyPath, 'utf8');
  }
}

if (!serviceAccountJson) {
  console.error("Error: FIREBASE_SERVICE_ACCOUNT_KEY env is missing, and local firebase-service-account.json not found.");
  process.exit(1);
}

let serviceAccount;
try {
  serviceAccount = JSON.parse(serviceAccountJson);
} catch (e) {
  console.error("Error: Failed to parse service account JSON", e);
  process.exit(1);
}

// Helper to make https requests
function request(options, postData) {
  return new Promise((resolve, reject) => {
    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => { data += chunk; });
      res.on('end', () => {
        if (res.statusCode >= 200 && res.statusCode < 300) {
          resolve(data ? JSON.parse(data) : {});
        } else {
          reject(new Error(`Status ${res.statusCode}: ${data}`));
        }
      });
    });
    req.on('error', reject);
    if (postData) {
      req.write(postData);
    }
    req.end();
  });
}

// Retrieve Google OAuth 2.0 Access Token using JWT
async function getAccessToken() {
  const header = { alg: 'RS256', typ: 'JWT' };
  const now = Math.floor(Date.now() / 1000);
  const claim = {
    iss: serviceAccount.client_email,
    scope: 'https://www.googleapis.com/auth/firebase.messaging',
    aud: 'https://oauth2.googleapis.com/token',
    exp: now + 3600,
    iat: now
  };

  const base64UrlEncode = (obj) => Buffer.from(JSON.stringify(obj)).toString('base64url');
  const jwtInput = `${base64UrlEncode(header)}.${base64UrlEncode(claim)}`;

  const sign = crypto.createSign('RSA-SHA256');
  sign.update(jwtInput);
  const signature = sign.sign(serviceAccount.private_key, 'base64url');
  const assertion = `${jwtInput}.${signature}`;

  const postData = `grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=${assertion}`;
  const response = await request({
    hostname: 'oauth2.googleapis.com',
    path: '/token',
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Content-Length': Buffer.byteLength(postData)
    }
  }, postData);

  return response.access_token;
}

// Send FCM v1 Topic Message
async function main() {
  try {
    console.log("FCM: Generating access token...");
    const token = await getAccessToken();
    console.log("FCM: Access token generated successfully.");

    const projectId = serviceAccount.project_id;
    if (!projectId) {
      throw new Error("project_id is missing from service account credentials");
    }

    const payload = JSON.stringify({
      message: {
        topic: 'version_updates',
        notification: {
          title: `新版本 v${appVersion} 已发布！`,
          body: appDesc
        },
        data: {
          tab: 'settings',
          version: appVersion,
          desc: appDesc,
          click_action: 'FLUTTER_NOTIFICATION_CLICK'
        }
      }
    });

    console.log(`FCM: Sending notification for version ${appVersion} to topic 'version_updates'...`);

    const response = await request({
      hostname: 'fcm.googleapis.com',
      path: `/v1/projects/${projectId}/messages:send`,
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(payload)
      }
    }, payload);

    console.log("FCM: Notification sent successfully! Message ID:", response.name);
  } catch (error) {
    console.error("Error sending FCM notification:", error);
    process.exit(1);
  }
}

main();
