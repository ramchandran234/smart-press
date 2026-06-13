describe('Smart Press Android App - Reports & Export E2E Flow', () => {
    it('should navigate to Revenue Dashboard and verify elements', async () => {
        console.log('Step 1: Navigate to Reports via Bottom Navigation Bar');
        
        // Find the Reports tab on the bottom navigation bar (it contains "Reports" text)
        const reportsTab = await $('android=new UiSelector().text("Reports")');
        await reportsTab.waitForDisplayed({ timeout: 15000 });
        await reportsTab.click();

        console.log('Step 2: Confirm Revenue Dashboard header title is visible');
        const dashboardTitle = await $('android=new UiSelector().text("Revenue Dashboard")');
        await dashboardTitle.waitForDisplayed({ timeout: 15000 });
        expect(await dashboardTitle.isDisplayed()).toBe(true);

        console.log('Step 3: Confirm daily revenue trends section exists');
        const trendTitle = await $('android=new UiSelector().text("Daily Revenue Trend")');
        expect(await trendTitle.isDisplayed()).toBe(true);
    });

    it('should navigate to Export Screen and select Excel format', async () => {
        console.log('Step 4: Tap the "Export" sub-navigation tile');
        // Scroll or locate the Export tile at the bottom of the reports list
        const exportTile = await $('android=new UiSelector().text("Export")');
        await exportTile.waitForDisplayed({ timeout: 5000 });
        await exportTile.click();

        console.log('Step 5: Confirm Export Report screen title is visible');
        const exportTitle = await $('android=new UiSelector().text("Export Report")');
        await exportTitle.waitForDisplayed({ timeout: 10000 });
        expect(await exportTitle.isDisplayed()).toBe(true);

        console.log('Step 6: Click on the "Excel" format selector');
        // Locate the Excel format button in the Row of formats (PDF, CSV, Excel)
        const excelBtn = await $('android=new UiSelector().text("Excel")');
        await excelBtn.click();
    });

    it('should trigger report export and verify success notification', async () => {
        console.log('Step 7: Tap the "Export Excel" action button');
        const exportActionBtn = await $('android=new UiSelector().text("Export Excel")');
        await exportActionBtn.click();

        console.log('Step 8: Verify Exporting as Excel toast/snackbar is shown');
        const exportToast = await $('android=new UiSelector().text("Exporting as Excel...")');
        await exportToast.waitForDisplayed({ timeout: 10000 });
        expect(await exportToast.isDisplayed()).toBe(true);
    });
});
