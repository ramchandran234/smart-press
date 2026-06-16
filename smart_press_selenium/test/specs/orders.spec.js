describe('Smart Press Web - Order Management E2E Flow', () => {
    it('should open the Create New Order modal/page', async () => {
        console.log('Step 1: Click "New Order" quick action');
        const newOrderBtn = await $('//*[contains(text(), "New Order")] | //flt-semantics[contains(@aria-label, "New Order")]');
        await newOrderBtn.waitForDisplayed({ timeout: 15000 });
        await newOrderBtn.click();

        console.log('Step 2: Verify Create New Order header');
        const header = await $('//*[contains(text(), "Create New Order")] | //flt-semantics[contains(@aria-label, "Create New Order")]');
        await header.waitForDisplayed({ timeout: 10000 });
        expect(await header.isDisplayed()).toBe(true);
    });

    it('should configure order items and instructions', async () => {
        console.log('Step 3: Click "Add Item" button');
        const addItemBtn = await $('//*[contains(text(), "Add Item")] | //flt-semantics[contains(@aria-label, "Add Item")]');
        await addItemBtn.waitForDisplayed({ timeout: 10000 });
        await addItemBtn.click();

        console.log('Step 4: Select Saree garment');
        const sareeItem = await $('//*[contains(text(), "Saree")] | //flt-semantics[contains(@aria-label, "Saree")]');
        await sareeItem.waitForDisplayed({ timeout: 5000 });
        await sareeItem.click();

        console.log('Step 5: Fill special instructions text box');
        const instructionsInput = await $('//textarea | //input[@type="text"] | //flt-semantics[@role="text-field"]');
        await instructionsInput.setValue('Dry clean only, do not iron.');
    });

    it('should submit the order and check confirmation', async () => {
        console.log('Step 6: Click "Save Order" button');
        const saveBtn = await $('//*[contains(text(), "Save Order")] | //flt-semantics[contains(@aria-label, "Save Order & Print QR")]');
        await saveBtn.waitForDisplayed({ timeout: 10000 });
        await saveBtn.click();

        console.log('Step 7: Confirm order created successfully message');
        const snackbar = await $('//*[contains(text(), "Order created successfully!")] | //flt-semantics[contains(@aria-label, "Order created successfully!")]');
        await snackbar.waitForDisplayed({ timeout: 10000 });
        expect(await snackbar.isDisplayed()).toBe(true);
    });
});
