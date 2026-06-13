describe('Smart Press Android App - Home Dashboard E2E Flow', () => {
    it('should verify KPI metric cards are present', async () => {
        console.log('Step 1: Verify KPI cards and their metrics are displayed');
        
        // Orders KPI card
        const ordersKpiLabel = await $('android=new UiSelector().text("Orders")');
        const ordersKpiVal = await $('android=new UiSelector().text("24")');
        await ordersKpiLabel.waitForDisplayed({ timeout: 15000 });
        expect(await ordersKpiLabel.isDisplayed()).toBe(true);
        expect(await ordersKpiVal.isDisplayed()).toBe(true);

        // Pickups KPI card
        const pickupsKpiLabel = await $('android=new UiSelector().text("Pickups")');
        const pickupsKpiVal = await $('android=new UiSelector().text("8")');
        expect(await pickupsKpiLabel.isDisplayed()).toBe(true);
        expect(await pickupsKpiVal.isDisplayed()).toBe(true);

        // Delivered KPI card
        const deliveredKpiLabel = await $('android=new UiSelector().text("Delivered")');
        const deliveredKpiVal = await $('android=new UiSelector().text("12")');
        expect(await deliveredKpiLabel.isDisplayed()).toBe(true);
        expect(await deliveredKpiVal.isDisplayed()).toBe(true);
    });

    it('should verify Today\'s Revenue section and values', async () => {
        console.log('Step 2: Verify Today\'s Revenue banner');
        
        const revenueLabel = await $('android=new UiSelector().text("Today\'s Revenue")');
        const revenueValue = await $('android=new UiSelector().text("₹ 3,840")');
        expect(await revenueLabel.isDisplayed()).toBe(true);
        expect(await revenueValue.isDisplayed()).toBe(true);
    });

    it('should verify all Quick Action navigation tiles exist', async () => {
        console.log('Step 3: Verify Quick Actions exist on the screen');
        
        const quickActions = [
            'New Order', 'Pickups', 'Deliveries', 'Customers',
            'Invoices', 'Payments', 'Reports', 'Schedule'
        ];

        for (const action of quickActions) {
            const tile = await $(`android=new UiSelector().text("${action}")`);
            expect(await tile.isDisplayed()).toBe(true);
        }
    });
});
