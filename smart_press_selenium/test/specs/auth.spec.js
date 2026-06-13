describe('Smart Press Web - Authentication E2E Flow', () => {
    it('should load welcome page and navigate to Owner Login', async () => {
        // 1. Navigate to the website homepage with accessibility enabled
        console.log('Step 1: Open website URL with accessibility enabled');
        await browser.url('/?enable-accessibility=true');

        // 2. Locate and tap "Owner Login" button using web selectors
        console.log('Step 2: Locate and click "Owner Login" button');
        const ownerLoginBtn = await $('//flt-semantics[contains(@aria-label, "Owner Login")] | //*[contains(text(), "Owner Login")]');
        await ownerLoginBtn.waitForDisplayed({ timeout: 15000 });
        await ownerLoginBtn.click();
    });

    it('should enter mobile number and request OTP', async () => {
        // 3. Input mobile number on login page
        console.log('Step 3: Enter mobile number');
        const mobileInput = await $('//input[@type="tel"] | //flt-semantics[@role="text-field"] | //input');
        await mobileInput.waitForDisplayed({ timeout: 10000 });
        await mobileInput.setValue('9876543210');

        // 4. Submit mobile number
        console.log('Step 4: Click "Send OTP" button');
        const sendOtpBtn = await $('//button[contains(., "Send OTP")] | //flt-semantics[contains(@aria-label, "Send OTP")]');
        await sendOtpBtn.click();
    });

    it('should read the development OTP and complete verification', async () => {
        // 5. Capture the development OTP from the screen
        console.log('Step 5: Detect developmental OTP on screen');
        const devOtpEl = await $('//flt-semantics[contains(@aria-label, "Your OTP")] | //*[string-length(text()) = 6 and translate(text(), "0123456789", "") = ""]');
        await devOtpEl.waitForDisplayed({ timeout: 10000 });
        const devOtpText = await devOtpEl.getText();
        const cleanOtp = devOtpText.replace(/\D/g, '');
        console.log(`Development OTP Detected: ${cleanOtp}`);

        // 6. Enter the OTP into inputs
        console.log('Step 6: Fill the OTP input boxes');
        const otpInputs = await $$('//input[@type="number"] | //flt-semantics[@role="text-field"]');
        const otpChars = cleanOtp.split('');
        for (let i = 0; i < 6; i++) {
            await otpInputs[i].setValue(otpChars[i]);
            await browser.pause(200);
        }

        // 7. Verify & navigate
        console.log('Step 7: Tap "Verify & Continue"');
        const verifyBtn = await $('//button[contains(., "Verify")] | //flt-semantics[contains(@aria-label, "Verify & Continue")]');
        await verifyBtn.click();

        // 8. Confirm we load the Dashboard
        console.log('Step 8: Verify Dashboard load');
        const dashboardHeading = await $('//*[contains(text(), "Good Morning")] | //flt-semantics[contains(@aria-label, "Good Morning")]');
        await dashboardHeading.waitForDisplayed({ timeout: 15000 });
        expect(await dashboardHeading.isDisplayed()).toBe(true);
    });
});
