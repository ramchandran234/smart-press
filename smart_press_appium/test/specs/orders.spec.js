describe('Smart Press Android App - Order Management E2E Flow', () => {
    it('should navigate to Create New Order page', async () => {
        console.log('Step 1: Go back to Home and tap "New Order" action');
        // If we are not on dashboard, we would click Home tab, but assuming sequential run we are on dashboard
        const newOrderTile = await $('android=new UiSelector().text("New Order")');
        await newOrderTile.waitForDisplayed({ timeout: 15000 });
        await newOrderTile.click();

        console.log('Step 2: Verify Create New Order screen title');
        const screenTitle = await $('android=new UiSelector().text("Create New Order")');
        await screenTitle.waitForDisplayed({ timeout: 15000 });
        expect(await screenTitle.isDisplayed()).toBe(true);
    });

    it('should add a garment and write special instructions', async () => {
        console.log('Step 3: Check default items exist');
        const shirtLabel = await $('android=new UiSelector().text("Shirt")');
        expect(await shirtLabel.isDisplayed()).toBe(true);

        console.log('Step 4: Tap "Add Item" to add another garment');
        const addItemBtn = await $('android=new UiSelector().text("Add Item")');
        await addItemBtn.click();

        console.log('Step 5: Select "Saree" garment from bottom sheet');
        const garmentChoice = await $('android=new UiSelector().text("Saree")');
        await garmentChoice.waitForDisplayed({ timeout: 5000 });
        await garmentChoice.click();

        console.log('Step 6: Confirm "Saree" is added to the garment list');
        const sareeLabel = await $('android=new UiSelector().text("Saree")');
        await sareeLabel.waitForDisplayed({ timeout: 5000 });
        expect(await sareeLabel.isDisplayed()).toBe(true);

        console.log('Step 7: Enter special instructions in the text field');
        // Locating the Special Instructions multi-line text input
        const instructionsInput = await $('android=new UiSelector().className("android.widget.EditText")');
        await instructionsInput.setValue('Dry clean only, handle with care.');
    });

    it('should save order and verify success message', async () => {
        console.log('Step 8: Tap "Save Order & Print QR"');
        const saveOrderBtn = await $('android=new UiSelector().text("Save Order & Print QR")');
        await saveOrderBtn.click();

        console.log('Step 9: Verify Order Created toast/snack message');
        const successToast = await $('android=new UiSelector().text("Order created successfully!")');
        await successToast.waitForDisplayed({ timeout: 10000 });
        expect(await successToast.isDisplayed()).toBe(true);
    });
});
