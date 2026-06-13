# Smart Press E2E Appium Testing Framework

This directory contains a complete, self-contained **Appium E2E Automation Testing Framework** built for the **Smart Press** Android mobile application. It uses **WebDriverIO** (v8) as the test runner and includes a custom **Excel Reporting System** to log detailed execution reports.

---

## 📂 Directory Structure

```text
smart_press_appium/
├── package.json             # Dependencies and test run scripts
├── wdio.conf.js             # WebdriverIO configurations and Appium capabilities
├── excel-reporter.js        # Core excel report generation logic (via exceljs)
├── test/
│   └── specs/               # Automation test suites
│       ├── auth.spec.js     # E2E Login & OTP flow test
│       ├── dashboard.spec.js# E2E Dashboard metrics & components test
│       ├── orders.spec.js   # E2E Order creation and listings test
│       └── reports.spec.js  # E2E Reports navigation & export format test
└── reports/
    └── E2E_Test_Report.xlsx # Auto-generated Excel analysis report (created after test execution)
```

---

## 🛠️ Prerequisites

Before executing the tests, ensure your system has the following dependencies configured:

1. **Node.js**: `v18` or higher installed.
2. **Java JDK**: `Java 11` or `Java 17` installed, and `JAVA_HOME` environment variable configured.
3. **Android SDK**: Android command line tools and Platform tools installed, and `ANDROID_HOME` environment variable set.
4. **Android Emulator / Device**: A running Android emulator or a physical device connected via USB with Developer Mode and USB Debugging enabled. (Check connectivity using `adb devices`).
5. **Flutter SDK**: Required to build the target APK.

---

## 🚀 Setup & Installation

### Step 1: Install Node Dependencies
From the root of this `smart_press_appium` directory, run:
```bash
npm install
```

### Step 2: Install Appium Drivers
Install the Appium `UiAutomator2` driver:
```bash
npx appium driver install uiautomator2
```

---

## 📦 Build the Mobile Application APK

The testing framework is configured to look for the **Smart Press** Debug APK at:
`smart_press/build/app/outputs/flutter-apk/app-debug.apk`.

To build this APK from the Flutter source code:
1. Navigate to the `smart_press` directory.
2. Run:
```bash
flutter build apk --debug
```
> [!NOTE]
> Debug mode (`--debug`) is used here as it preserves developmental helper indicators, enables widget keys in the tree, and displays the **Development Mode OTP** on-screen during the login phase, which our Appium script reads automatically to authenticate.

---

## 🏃 Running the Tests

Follow these steps to spin up the automation suite:

### Step 1: Start the Android Emulator or Connect a Device
Make sure your emulator is booted or your physical device is connected. Run the command below to verify that it is listed:
```bash
adb devices
```

### Step 2: Run the Appium Server
Appium needs to run in the background. In a separate terminal session, start the Appium server:
```bash
npm run appium:run
```

### Step 3: Start the Test Suite
Once the Appium server and emulator are active, execute the tests from the `smart_press_appium` directory:
```bash
npm run test
```

WebDriverIO will automatically:
1. Install the built APK onto the running Android device.
2. Launch the app and run the E2E suites sequentially.
3. Compile all step logs and results.
4. Save the results into a formatted Excel analysis report.

---

## 📊 Excel Analysis Report Generation

Upon test suite completion, a polished, styled Excel report is created at:
`smart_press_appium/reports/E2E_Test_Report.xlsx`

The Excel report has two key tabs:
1. **Summary Sheet**:
   - High-level test metadata (Execution date, Total test steps, Pass/Fail counts).
   - **Overall Pass Rate** dynamically calculated and color-coded.
2. **Execution Details Sheet**:
   - A step-by-step breakdown of the automation run.
   - Includes columns: `Time`, `Test Suite`, `Test Step Description`, `Status` (color-coded **PASS** in light green, **FAIL** in light red), `Duration (ms)`, and `Error / Failure Details`.
