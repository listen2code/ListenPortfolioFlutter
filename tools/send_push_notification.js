const crypto = require('crypto');
const https = require('https');

const fs = require('fs');

let serviceAccountJson = process.env.FIREBASE_SERVICE_ACCOUNT_KEY;
let appVersion = process.env.APP_VERSION;
let appDesc = 'A new version has been released! ';

// Try to read version.json from pages/ folder
try {
  if (fs.existsSync('pages/version.json')) {
    const versionData = JSON.parse(fs.readFileSync('pages/version.json', 'utf8'));
    if (!appVersion && versionData.version) {
      appVersion = versionData.version;
    }
    if (versionData.changelog) {
      appDesc = versionData.changelog.en || versionData.changelog.ja || versionData.changelog.zh || appDesc;
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

// Parse command-line arguments
const args = process.argv.slice(2);
const options = {
  type: '',
  tab: '',
  token: '',
  title: '',
  body: ''
};

for (let i = 0; i < args.length; i++) {
  if (args[i] === '-h' || args[i] === '--help') {
    console.log(`Usage: node tools/send_push_notification.js [options]

Options:
  --type <type>        Type of notification: "update", "tab"(default: "update")
  --tab <tab>          HomeTab name: "settings", "overview", "aboutMe", "projects", "architecture"
  --token <token>      Send to specific FCM registration token instead of version_updates topic
  --title <title>      Custom notification title
  --body <body>        Custom notification body
  -h, --help           Show this help message`);
    process.exit(0);
  }
  if (args[i] === '--type' && args[i + 1]) {
    options.type = args[i + 1];
    i++;
  } else if (args[i] === '--tab' && args[i + 1]) {
    options.tab = args[i + 1];
    i++;
  } else if (args[i] === '--token' && args[i + 1]) {
    options.token = args[i + 1];
    i++;
  } else if (args[i] === '--title' && args[i + 1]) {
    options.title = args[i + 1];
    i++;
  } else if (args[i] === '--body' && args[i + 1]) {
    options.body = args[i + 1];
    i++;
  }
}

// Infer type if not explicitly set
if (!options.type) {
  if (options.tab) {
    options.type = 'tab';
  } else {
    options.type = 'update';
  }
}

// Send FCM v1 Message
async function main() {
  try {
    console.log("FCM: Generating access token...");
    const token = await getAccessToken();
    console.log("FCM: Access token generated successfully.");

    const fcmProjectId = serviceAccount.project_id;
    if (!fcmProjectId) {
      throw new Error("project_id is missing from service account credentials");
    }

    // Construct FCM v1 message structure
    const message = {
      data: {
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      }
    };

    // Set recipient (Token or Topic)
    if (options.token) {
      message.token = options.token;
      console.log(`FCM: Direct delivery target -> token: ${options.token.substring(0, 20)}...`);
    } else {
      message.topic = 'version_updates';
      console.log("FCM: Broadcast delivery target -> topic: 'version_updates'");
    }

    // Populate title, body, and data fields based on message type
    if (options.type === 'update') {
      message.notification = {
        title: options.title || `New version v${appVersion} has been released!`,
        body: options.body || appDesc
      };
      message.data.tab = 'settings';
      message.data.version = appVersion;
      message.data.desc = appDesc;
    } else if (options.type === 'tab') {
      const targetTab = options.tab || 'overview';
      message.notification = {
        title: options.title || `Featured Section Available`,
        body: options.body || `Tap to open the ${targetTab} view directly.`
      };
      message.data.tab = targetTab;
    } else {
      // Freeform custom type
      message.notification = {
        title: options.title || "Listen Portfolio Update",
        body: options.body || "Open App to see what's new"
      };
      if (options.tab) message.data.tab = options.tab;
    }

    const payload = JSON.stringify({ message });

    console.log(`FCM: Dispatching payload (Type: ${options.type})...`);

    const response = await request({
      hostname: 'fcm.googleapis.com',
      path: `/v1/projects/${fcmProjectId}/messages:send`,
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(payload)
      }
    }, payload);

    console.log("FCM: Notification sent successfully! Response Message Name:", response.name);
  } catch (error) {
    console.error("Error sending FCM notification:", error);
    process.exit(1);
  }
}

main();
