describe('Smart Press Web - Reports & Export E2E Flow', () => {
    it('should navigate to reports screen and verify sections', async () => {
        console.log('Step 1: Click "Reports" bottom navigation tab');
        const reportsTab = await $('//*[contains(text(), "Reports")] | //flt-semantics[contains(@aria-label, "Reports")]');
        await reportsTab.waitForDisplayed({ timeout: 15000 });
        await reportsTab.click();

        console.log('Step 2: Confirm Revenue Dashboard load');
        const dashboardHeader = await $('//*[contains(text(), "Revenue Dashboard")] | //flt-semantics[contains(@aria-label, "Revenue Dashboard")]');
        await dashboardHeader.waitForDisplayed({ timeout: 15000 });
        expect(await dashboardHeader.isDisplayed()).toBe(true);
    });

    it('should navigate to export screen and select formats', async () => {
        console.log('Step 3: Click "Export" tile button');
        const exportTile = await $('//*[contains(text(), "Export")] | //flt-semantics[contains(@aria-label, "Export")]');
        await exportTile.click();

        console.log('Step 4: Verify Export screen load');
        const exportHeader = await $('//*[contains(text(), "Export Report")] | //flt-semantics[contains(@aria-label, "Export Report")]');
        await exportHeader.waitForDisplayed({ timeout: 10000 });
        expect(await exportHeader.isDisplayed()).toBe(true);

        console.log('Step 5: Tap "Excel" format selector');
        const excelBtn = await $('//*[contains(text(), "Excel")] | //flt-semantics[contains(@aria-label, "Excel")]');
        await excelBtn.click();
    });

    it('should run export action and verify download start toast', async () => {
        console.log('Step 6: Click "Export Excel" action button');
        const exportActionBtn = await $('//button[contains(., "Export Excel")] | //flt-semantics[contains(@aria-label, "Export Excel")]');
        await exportActionBtn.click();

        console.log('Step 7: Confirm "Exporting as Excel..." toast');
        const toast = await $('//*[contains(text(), "Exporting as Excel...")] | //flt-semantics[contains(@aria-label, "Exporting as Excel...")]');
        await toast.waitForDisplayed({ timeout: 10000 });
        expect(await toast.isDisplayed()).toBe(true);
    });
});
