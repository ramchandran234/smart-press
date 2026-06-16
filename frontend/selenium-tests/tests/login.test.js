const { Builder, By, until } = require('selenium-webdriver');
const chrome = require('selenium-webdriver/chrome');
const assert = require('assert');

describe('Smart Press - Login E2E Tests', function () {
  let driver;

  before(async function () {
    let options = new chrome.Options();
    // Run headless in CI or when specifically requested
    if (process.env.CI || process.env.HEADLESS) {
      options.addArguments('--headless');
      options.addArguments('--no-sandbox');
      options.addArguments('--disable-dev-shm-usage');
      options.addArguments('--disable-gpu');
    }

    driver = await new Builder()
      .forBrowser('chrome')
      .setChromeOptions(options)
      .build();
  });

  after(async function () {
    if (driver) {
      await driver.quit();
    }
  });

  it('should log in successfully and redirect to dashboard', async function () {
    // Navigate to local or live URL (defaulting to the live Render website)
    const targetUrl = process.env.TARGET_URL || 'https://smart-press-website.onrender.com/#/login';
    console.log(`Navigating to target URL: ${targetUrl}`);
    await driver.get(targetUrl);

    // Wait for the email field to become available
    console.log('Locating email field by id "email"');
    const emailInput = await driver.wait(until.elementLocated(By.id('email')), 15000);
    await driver.wait(until.elementIsVisible(emailInput), 10000);

    // Locate password and button
    console.log('Locating password field and login button');
    const passwordInput = await driver.findElement(By.id('password'));
    const loginButton = await driver.findElement(By.id('login-button'));

    // Input values and submit
    console.log('Filling in credentials');
    await emailInput.sendKeys('admin@smartpress.com');
    await passwordInput.sendKeys('password123');

    console.log('Clicking the login button');
    await loginButton.click();

    // Verify routing redirect to the dashboard
    console.log('Waiting for URL redirect to contain dashboard');
    await driver.wait(until.urlContains('dashboard'), 15000);
    const currentUrl = await driver.getCurrentUrl();
    console.log(`Current URL after redirect: ${currentUrl}`);
    assert.ok(currentUrl.includes('dashboard'), `Expected URL to contain dashboard, but got: ${currentUrl}`);
  });
});
