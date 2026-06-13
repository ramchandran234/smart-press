describe('Smart Press Android App - Authentication E2E Flow', () => {
    it('should navigate to Owner Login and submit mobile number', async () => {
        // 1. Wait for Welcome Screen to display and tap "Owner Login"
        console.log('Step 1: Locate and tap "Owner Login" button');
        const ownerLoginBtn = await $('android=new UiSelector().textContains("Owner Login")');
        await ownerLoginBtn.waitForDisplayed({ timeout: 20000 });
        await ownerLoginBtn.click();

        // 2. Input mobile number on OTP Login screen
        console.log('Step 2: Enter mobile number');
        const mobileInput = await $('android=new UiSelector().className("android.widget.EditText")');
        await mobileInput.waitForDisplayed({ timeout: 10000 });
        await mobileInput.setValue('9876543210');

        // 3. Send OTP
        console.log('Step 3: Click "Send OTP"');
        const sendOtpBtn = await $('android=new UiSelector().textContains("Send OTP")');
        await sendOtpBtn.click();
    });

    it('should read the development OTP and verify login', async () => {
        // 4. Capture the OTP displayed on the screen in Development Mode
        console.log('Step 4: Capture Dev OTP');
        const devOtpEl = await $('android=new UiSelector().textMatches("\\\\d{6}")');
        await devOtpEl.waitForDisplayed({ timeout: 15000 });
        const devOtp = await devOtpEl.getText();
        console.log(`Detected Development OTP: ${devOtp}`);

        // 5. Fill OTP inputs (index 0 is mobile field, indices 1 to 6 are the OTP inputs)
        console.log('Step 5: Fill the 6-digit OTP fields');
        const otpChars = devOtp.trim().split('');
        const editTexts = await $$('android.widget.EditText');
        
        for (let i = 0; i < 6; i++) {
            await editTexts[i + 1].setValue(otpChars[i]);
            // Small pause to simulate human interaction and allow focusing
            await browser.pause(300);
        }

        // 6. Tap Verify and Continue button
        console.log('Step 6: Click "Verify & Continue"');
        const verifyBtn = await $('android=new UiSelector().textContains("Verify & Continue")');
        await verifyBtn.click();

        // 7. Verify transitions to Home Dashboard
        console.log('Step 7: Confirm successful navigation to Home Dashboard');
        const goodMorningText = await $('android=new UiSelector().textContains("Good Morning")');
        await goodMorningText.waitForDisplayed({ timeout: 20000 });
        const isHeaderDisplayed = await goodMorningText.isDisplayed();
        expect(isHeaderDisplayed).toBe(true);
    });
});
