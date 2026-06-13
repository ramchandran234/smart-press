const path = require('path');
const excelReporter = require('./excel-reporter');

exports.config = {
    // ── Auto Compile Option ───────────────────────
    autoCompileOpts: {
        autoCompile: false
    },

    // ── Runner Configuration ──────────────────────
    runner: 'local',
    port: 4723,
    path: '/',

    // ── Spec Files ────────────────────────────────
    specs: [
        './test/specs/**/*.js'
    ],
    exclude: [],

    // ── Capabilities ──────────────────────────────
    maxInstances: 1,
    capabilities: [{
        platformName: 'Android',
        'appium:automationName': 'UiAutomator2',
        'appium:deviceName': 'RZCX9321DCA',
        'appium:udid': 'RZCX9321DCA',
        // Points to the standard Flutter debug build APK path
        'appium:app': path.join(__dirname, '../smart_press/build/app/outputs/flutter-apk/app-debug.apk'),
        'appium:appPackage': 'com.example.smart_press',
        'appium:appActivity': '.MainActivity',
        'appium:noReset': false,
        'appium:fullReset': false,
        'appium:newCommandTimeout': 240
    }],

    // ── Test Configurations ───────────────────────
    logLevel: 'info',
    bail: 0,
    waitforTimeout: 10000,
    connectionRetryTimeout: 120000,
    connectionRetryCount: 3,
    services: ['appium'],

    framework: 'mocha',
    reporters: ['spec'],

    mochaOpts: {
        ui: 'bdd',
        timeout: 180000 // Appium tests can take longer
    },

    // ── Lifecycle Hooks ──────────────────────────
    afterTest: function (test, context, { error, result, duration, passed, retries }) {
        const suiteName = test.parent || 'E2E Suite';
        const stepName = test.title;
        const status = passed ? 'PASS' : 'FAIL';
        const errMessage = error ? error.message : 'N/A';
        
        excelReporter.addStep(suiteName, stepName, status, duration, errMessage);
    },

    after: async function (exitCode, config, capabilities) {
        const reportPath = path.join(__dirname, 'reports/E2E_Test_Report.xlsx');
        console.log('\n=========================================');
        console.log('Generating Excel Analysis Report...');
        await excelReporter.generate(reportPath);
        console.log('=========================================\n');
    }
};
