const http = require('http');
const fs = require('fs');
const util = require('util');
const path = require('path');
const url = require('url');

const port = 9898;
const readFileAsync = util.promisify(fs.readFile);

// Helper to get formatted current date/time
function getDate() {
    const now = new Date();
    return `${(now.getMonth() + 1).toString().padStart(2, '0')}/${now.getDate().toString().padStart(2, '0')}/${now.getFullYear()} ${now.getHours().toString().padStart(2, '0')}:${now.getMinutes().toString().padStart(2, '0')}:${now.getSeconds().toString().padStart(2, '0')}.${now.getMilliseconds().toString().padStart(3, '0')}`;
}

const server = http.createServer((req, res) => {
    // Collect body data for non-GET requests
    let body = '';
    req.on('data', chunk => {
        body += chunk.toString();
    });

    req.on('end', () => {
        handleRequest(req, res, body).catch(error => {
            console.error(`${getDate()} Global Error: ${error}`);
            const errorHeaders = { 'Content-Type': 'application/json' };
            console.log(`${getDate()} [Response Headers]:\n${JSON.stringify(errorHeaders, null, 2)}`);
            res.writeHead(500, errorHeaders);
            res.end(JSON.stringify({ result: "1", message: "Internal Server Error" }));
        });
    });
});

async function handleRequest(req, res, requestBody) {
    const parsedUrl = url.parse(req.url, true);
    const pathname = parsedUrl.pathname;
    const method = req.method.toLowerCase();
    const queryParams = parsedUrl.query;

    console.log(`\n${getDate()} >>> [${req.method.toUpperCase()}] ${pathname}`);

    // Log Request Headers
    console.log(`${getDate()} [Request Headers]:\n${JSON.stringify(req.headers, null, 2)}`);

    // Log Request Parameters
    if (method === 'get') {
        if (Object.keys(queryParams).length > 0) {
            console.log(`${getDate()} [Request Query]:\n${JSON.stringify(queryParams, null, 2)}`);
        }
    } else if (requestBody) {
        try {
            const jsonBody = JSON.parse(requestBody);
            console.log(`${getDate()} [Request Body]:\n${JSON.stringify(jsonBody, null, 2)}`);
        } catch (e) {
            console.log(`${getDate()} [Request Body (Raw)]: ${requestBody}`);
        }
    }

    // 1. Load configuration
    const configPath = path.join(__dirname, 'config.json');
    if (!fs.existsSync(configPath)) {
        const errorHeaders = { 'Content-Type': 'application/json' };
        console.log(`${getDate()} [Response Headers]:\n${JSON.stringify(errorHeaders, null, 2)}`);
        res.writeHead(500, errorHeaders);
        return res.end(JSON.stringify({ result: "1", message: "config.json not found" }));
    }
    const configData = await readFileAsync(configPath, 'utf-8');
    const config = JSON.parse(configData);

    // 2. Dynamic route matching logic
    let apiConfig = null;
    let matchedApiName = "";

    for (const entry of config) {
        if (entry.method.toLowerCase() !== method) continue;

        const configApi = entry.api;

        if (configApi.endsWith('/')) {
            const lastSlashIndex = pathname.lastIndexOf('/');
            if (lastSlashIndex !== -1) {
                const prefix = pathname.substring(0, lastSlashIndex + 1);
                if (prefix.endsWith(configApi)) {
                    apiConfig = entry;
                    matchedApiName = configApi;
                    break;
                }
            }
        } else {
            if (pathname.endsWith(configApi)) {
                apiConfig = entry;
                matchedApiName = configApi;
                break;
            }
        }
    }

    if (!apiConfig) {
        console.log(`${getDate()} [404] No match in config for: ${pathname}`);
        const errorHeaders = { 'Content-Type': 'application/json' };
        console.log(`${getDate()} [Response Headers]:\n${JSON.stringify(errorHeaders, null, 2)}`);
        res.writeHead(404, errorHeaders);
        return res.end(JSON.stringify({ result: "1", message: "API route not matched in config" }));
    }

    // 3. Optional artificial delay
    if (apiConfig.timeout) {
        await new Promise(resolve => setTimeout(resolve, apiConfig.timeout));
    }

    // 4. Resolve local JSON data path
    const pathParts = pathname.split('/').filter(p => p);
    let versionDir = "";
    if (pathParts.length > 0 && /^v\d+$/.test(pathParts[0])) {
        versionDir = pathParts[0];
    }

    const baseDir = path.join(__dirname, 'json', versionDir);
    const resourceName = matchedApiName.endsWith('/') ? matchedApiName.slice(0, -1) : matchedApiName;

    let targetFile = "";
    if (method === "get") {
        if (matchedApiName.endsWith('/')) {
            targetFile = path.join(baseDir, 'get', `${resourceName}.json`);
        } else {
            targetFile = path.join(baseDir, 'get', 'list', `${resourceName}.json`);
        }
    } else {
        targetFile = path.join(baseDir, method, `${resourceName}.json`);
    }

    // 5. Read file and log Response
    try {
        if (!fs.existsSync(targetFile)) {
            throw new Error(`Data file not found at ${targetFile}`);
        }

        const responseData = await readFileAsync(targetFile, 'utf-8');

        // Log Response Headers first
        const successHeaders = { 'Content-Type': 'application/json' };
        console.log(`${getDate()} [Response Headers]:\n${JSON.stringify(successHeaders, null, 2)}`);

        // Log formatted JSON response
        try {
            const formattedJson = JSON.stringify(JSON.parse(responseData), null, 2);
            console.log(`${getDate()} [Response JSON]:\n${formattedJson}`);
        } catch (e) {
            console.log(`${getDate()} [Response Data]: ${responseData}`);
        }

        res.writeHead(apiConfig.httpCode || 200, successHeaders);
        res.end(responseData);
        console.log(`${getDate()} [Success] Returned: ${targetFile} (HTTP ${apiConfig.httpCode || 200})`);
    } catch (err) {
        console.error(`${getDate()} [Error] ${err.message}`);
        const errorHeaders = { 'Content-Type': 'application/json' };
        console.log(`${getDate()} [Response Headers]:\n${JSON.stringify(errorHeaders, null, 2)}`);
        res.writeHead(404, errorHeaders);
        res.end(JSON.stringify({ result: "1", message: "Data source file missing", detail: err.message }));
    }
}

server.listen(port, () => {
    console.log(`Mock Server started on port ${port}`);
});
