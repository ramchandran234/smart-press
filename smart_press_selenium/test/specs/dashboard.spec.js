describe('Smart Press Web - Home Dashboard E2E Flow', () => {
    it('should verify metric cards are displayed properly', async () => {
        console.log('Step 1: Check KPI titles and counters');
        
        // Orders KPI
        const ordersCard = await $('//*[contains(text(), "Orders")] | //flt-semantics[contains(@aria-label, "Orders")]');
        await ordersCard.waitForDisplayed({ timeout: 15000 });
        expect(await ordersCard.isDisplayed()).toBe(true);

        // Pickups KPI
        const pickupsCard = await $('//*[contains(text(), "Pickups")] | //flt-semantics[contains(@aria-label, "Pickups")]');
        expect(await pickupsCard.isDisplayed()).toBe(true);

        // Delivered KPI
        const deliveredCard = await $('//*[contains(text(), "Delivered")] | //flt-semantics[contains(@aria-label, "Delivered")]');
        expect(await deliveredCard.isDisplayed()).toBe(true);
    });

    it('should verify Today\'s Revenue section values', async () => {
        console.log('Step 2: Check revenue numbers');
        const revenueVal = await $('//*[contains(text(), "₹ 3,840")] | //flt-semantics[contains(@aria-label, "₹ 3,840")]');
        expect(await revenueVal.isDisplayed()).toBe(true);
    });

    it('should check all Quick Action buttons exist', async () => {
        console.log('Step 3: Confirm presence of quick action grid tiles');
        const actions = [
            'New Order', 'Pickups', 'Deliveries', 'Customers',
            'Invoices', 'Payments', 'Reports', 'Schedule'
        ];

        for (const action of actions) {
            const tile = await $(`//*[contains(text(), "${action}")] | //flt-semantics[contains(@aria-label, "${action}")]`);
            expect(await tile.isDisplayed()).toBe(true);
        }
    });
});
