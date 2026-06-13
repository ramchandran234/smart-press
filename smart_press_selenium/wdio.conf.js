const path = require('path');
const { spawn } = require('child_process');
const excelReporter = require('./excel-reporter');
const { startServer, notifyEvent, openBrowser } = require('./live-dashboard-server');

exports.config = {
    // ── Runner Configuration ──────────────────────
    runner: 'local',

    // ── Spec Files ────────────────────────────────
    specs: [
        [
            './test/specs/auth.spec.js',
            './test/specs/dashboard.spec.js',
            './test/specs/orders.spec.js',
            './test/specs/reports.spec.js'
        ]
    ],
    exclude: [],

    // ── Capabilities ──────────────────────────────
    maxInstances: 1,
    capabilities: [{
        browserName: 'chrome',
        'goog:chromeOptions': {
            args: process.env.CI 
                ? ['--headless', '--disable-gpu', '--no-sandbox', '--disable-dev-shm-usage', '--window-size=1280,800']
                : ['--disable-gpu', '--window-size=1280,800']
        }
    }],

    // ── Test Configurations ───────────────────────
    logLevel: 'info',
    bail: 0,
    baseUrl: 'http://localhost:8080',
    waitforTimeout: 10000,
    connectionRetryTimeout: 120000,
    connectionRetryCount: 3,

    framework: 'mocha',
    reporters: ['spec'],

    mochaOpts: {
        ui: 'bdd',
        timeout: 60000
    },

    // ── Lifecycle Hooks ──────────────────────────
    before: async function (capabilities, specs) {
        // Register custom shadow-piercing locator strategy for Flutter Web semantics
        browser.addLocatorStrategy('flutter', (selector) => {
            const glassPane = document.querySelector('flt-glass-pane');
            const root = glassPane && glassPane.shadowRoot ? glassPane.shadowRoot : document;
            const results = [];
            
            const parts = selector.split(' | ');
            for (const part of parts) {
                const trimmed = part.trim();
                
                // 1. Match contains(@aria-label, "value") or @aria-label="value"
                const ariaLabelMatch = trimmed.match(/@aria-label\s*,\s*["']([^"']+)["']/i) || trimmed.match(/@aria-label\s*=\s*["']([^"']+)["']/i);
                if (ariaLabelMatch) {
                    const val = ariaLabelMatch[1];
                    const elements = root.querySelectorAll(`[aria-label*="${val}"], [aria-label="${val}"]`);
                    elements.forEach(el => { if (!results.includes(el)) results.push(el); });
                    continue;
                }
                
                // 2. Match contains(., "value")
                const containsDotMatch = trimmed.match(/contains\(\s*\.\s*,\s*["']([^"']+)["']/i);
                if (containsDotMatch) {
                    const val = containsDotMatch[1];
                    const elements = root.querySelectorAll(`[aria-label*="${val}"], [aria-label="${val}"]`);
                    elements.forEach(el => { if (!results.includes(el)) results.push(el); });
                    continue;
                }

                // 3. Match contains(text(), "value") or text()="value"
                const textMatch = trimmed.match(/text\(\)\s*,\s*["']([^"']+)["']/i) || trimmed.match(/text\(\)\s*=\s*["']([^"']+)["']/i);
                if (textMatch) {
                    const val = textMatch[1];
                    const elements = root.querySelectorAll(`[aria-label*="${val}"], [aria-label="${val}"]`);
                    elements.forEach(el => { if (!results.includes(el)) results.push(el); });
                    continue;
                }
                
                // 4. Match inputs/textfields
                if (trimmed.includes('input[@type="tel"]')) {
                    const elements = root.querySelectorAll('input[type="tel"], input');
                    elements.forEach(el => { if (!results.includes(el)) results.push(el); });
                    continue;
                }
                if (trimmed.includes('input[@type="number"]') || trimmed.includes('role="text-field"')) {
                    const elements = root.querySelectorAll('input:not([type="tel"]), flt-semantics[role="text-field"]');
                    elements.forEach(el => { if (!results.includes(el)) results.push(el); });
                    continue;
                }
                if (trimmed.includes('textarea')) {
                    const elements = root.querySelectorAll('textarea');
                    elements.forEach(el => { if (!results.includes(el)) results.push(el); });
                    continue;
                }
                if (trimmed.includes('button')) {
                    const elements = root.querySelectorAll('button, [role="button"], flt-semantics[role="button"]');
                    elements.forEach(el => { if (!results.includes(el)) results.push(el); });
                    continue;
                }
                if (trimmed.includes('//input')) {
                    const elements = root.querySelectorAll('input');
                    elements.forEach(el => { if (!results.includes(el)) results.push(el); });
                    continue;
                }
                
                // 5. Match OTP
                if (trimmed.includes('string-length(text()) = 6') || trimmed.includes('Your OTP')) {
                    const elements = root.querySelectorAll('flt-semantics, [aria-label], *');
                    for (const el of elements) {
                        const lbl = el.getAttribute('aria-label') || '';
                        const txt = (el.innerText || el.textContent || '').trim();
                        if (/Your OTP:?\s*(\d{6})/i.test(lbl) || /^(\d{6})$/.test(lbl) || /^(\d{6})$/.test(txt)) {
                            if (!results.includes(el)) results.push(el);
                        }
                    }
                }
            }
            
            return results;
        });

        // Overwrite the $ command to automatically route XPath queries through our strategy
        browser.overwriteCommand('$', async function (orig$, selector) {
            if (typeof selector === 'string') {
                const isXPath = selector.startsWith('/') || selector.startsWith('.') || selector.startsWith('(');
                if (isXPath) {
                    return browser.custom$('flutter', selector);
                }
            }
            return orig$(selector);
        });

        // Overwrite the $$ command to automatically route XPath queries through our strategy
        browser.overwriteCommand('$$', async function (orig$$, selector) {
            if (typeof selector === 'string') {
                const isXPath = selector.startsWith('/') || selector.startsWith('.') || selector.startsWith('(');
                if (isXPath) {
                    return browser.custom$$('flutter', selector);
                }
            }
            return orig$$(selector);
        });
    },

    onPrepare: async function (config, capabilities) {
        console.log('\n🚀 Starting backend server automatically on port 5000...');
        global.backendProcess = spawn('npm', ['run', 'dev'], {
            cwd: path.resolve(__dirname, '../smart_press_backend'),
            shell: true,
            stdio: 'ignore'
        });

        console.log('🚀 Starting web application server automatically on port 8080...');
        global.webAppProcess = spawn('npx', ['serve', '-s', '../smart_press/build/web', '-l', '8080'], {
            shell: true,
            stdio: 'ignore'
        });

        console.log('📡 Initializing Live Dashboard Server...');
        startServer(4000);
        if (!process.env.CI) {
            openBrowser(4000);
        } else {
            console.log('CI environment detected. Live Dashboard Server started but browser window launch bypassed.');
        }
        notifyEvent('run:start');

        console.log('⏳ Waiting 5 seconds for application servers to warm up...');
        await new Promise(resolve => setTimeout(resolve, 5000));
        console.log('🏁 Application servers ready. Launching tests!\n');
    },

    beforeTest: function (test, context) {
        const suiteName = test.parent || 'Web E2E Suite';
        const stepName = test.title;
        notifyEvent('test:start', { suiteName, stepName });
    },

    afterTest: function (test, context, { error, result, duration, passed, retries }) {
        const suiteName = test.parent || 'Web E2E Suite';
        const stepName = test.title;
        const status = passed ? 'PASS' : 'FAIL';
        const errMessage = error ? error.message : 'N/A';
        
        excelReporter.addStep(suiteName, stepName, status, duration, errMessage);
        notifyEvent('test:result', {
            suiteName,
            stepName,
            status,
            duration,
            error: errMessage
        });
    },

    after: async function (exitCode, config, capabilities) {
        const reportPath = path.join(__dirname, 'reports/E2E_Web_Test_Report.xlsx');
        console.log('\n=========================================');
        console.log('Generating Web Excel Analysis Report...');
        await excelReporter.generate(reportPath);
        console.log('=========================================\n');
    },

    onComplete: async function (exitCode, config, capabilities, results) {
        notifyEvent('run:complete');
        
        console.log('\n================================================================');
        console.log('🎉 Web E2E Test Execution Completed!');
        console.log('📊 Live Dashboard running at: http://localhost:4000');
        
        if (!process.env.CI) {
            console.log('👉 Press ENTER in this terminal to terminate all servers.');
            console.log('================================================================\n');
            
            await new Promise((resolve) => {
                const timeout = setTimeout(resolve, 600000); // 10 minutes auto-shutdown
                process.stdin.resume();
                process.stdin.once('data', () => {
                    clearTimeout(timeout);
                    resolve();
                });
            });
        } else {
            console.log('CI Environment detected. Exiting immediately and terminating servers.');
            console.log('================================================================\n');
        }

        // Clean up spawned servers
        if (global.backendProcess) {
            console.log('🛑 Stopping backend server...');
            try {
                if (process.platform === 'win32') {
                    require('child_process').execSync(`taskkill /pid ${global.backendProcess.pid} /t /f`, { stdio: 'ignore' });
                } else {
                    global.backendProcess.kill();
                }
            } catch (e) {}
        }
        if (global.webAppProcess) {
            console.log('🛑 Stopping web app server...');
            try {
                if (process.platform === 'win32') {
                    require('child_process').execSync(`taskkill /pid ${global.webAppProcess.pid} /t /f`, { stdio: 'ignore' });
                } else {
                    global.webAppProcess.kill();
                }
            } catch (e) {}
        }
    }
};
