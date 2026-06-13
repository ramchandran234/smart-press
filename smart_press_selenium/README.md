# Smart Press Web E2E Selenium Testing Framework

This directory houses the **Web E2E Selenium Testing Framework** built for the **Smart Press** website (the web build of the Flutter application). It runs on top of **WebDriverIO** (v8), automating Chrome browser sessions and generating a styled **Excel Analysis Report**.

---

## 📂 Directory Structure

```text
smart_press_selenium/
├── package.json                  # Dependencies and run scripts
├── wdio.conf.js                  # WebdriverIO configurations and Chrome capabilities
├── excel-reporter.js             # Core excel report generation logic (via exceljs)
├── test/
│   └── specs/                    # Web automation test suites
│       ├── auth.spec.js          # Web Login & OTP flow test
│       ├── dashboard.spec.js     # Web Dashboard KPIs & action grids test
│       ├── orders.spec.js        # Web Order creation modal flow test
│       └── reports.spec.js       # Web Reports dashboard & Excel export test
└── reports/
    └── E2E_Web_Test_Report.xlsx  # Auto-generated Excel analysis report (created after test execution)
```

---

## 🛠️ Prerequisites

Before executing the tests, ensure your system has the following dependencies configured:

1. **Node.js**: `v18` or higher installed.
2. **Google Chrome**: Web browser installed on your machine. (WebdriverIO automatically manages the matching ChromeDriver binary for you!).
3. **Flutter SDK**: Required to compile the app for the web.

---

## 🚀 Setup & Installation

### Step 1: Install Dependencies
From the root of this `smart_press_selenium` directory, run:
```bash
npm install
```

---

## 📦 Build & Run the Web Application

To execute tests against the website, you must compile and serve the Flutter web app:

### Step 1: Compile the Flutter Web Build
Navigate to the `smart_press` directory and run:
```bash
flutter build web
```

### Step 2: Serve the Website
Navigate back to this `smart_press_selenium` directory and run the helper serve command:
```bash
npm run serve:web
```
This launches a local web server serving the compiled static assets at `http://localhost:8080`, which is the targeted URL in `wdio.conf.js`.

---

## 🏃 Running the Tests

Ensure the local web server is running on `http://localhost:8080` in a background terminal. Then, execute the tests from this `smart_press_selenium` directory:
```bash
npm run test
```

WebDriverIO will automatically:
1. Spin up a local Chrome browser window.
2. Navigate through the Welcome, Login, Dashboard, Order, and Reports flows.
3. Record each step status, execution time, and potential failures.
4. Save the compiled statistics to an Excel analysis report.

---

## 📊 Excel Web Analysis Report Generation

Upon test run completion, a styled Excel spreadsheet report is compiled at:
`smart_press_selenium/reports/E2E_Web_Test_Report.xlsx`

The Excel workbook contains two sheets:
1. **Summary**:
   - Metrics overview (Execution Date, Total steps, Pass rate, Failures).
   - **Overall Pass Rate** styled and highlighted.
2. **Execution Details**:
   - Tabular, step-by-step detail logs containing `Time`, `Test Suite`, `Test Step Description`, `Status` (green for PASS, red for FAIL), `Duration (ms)`, and detailed `Error / Failure Details`.
