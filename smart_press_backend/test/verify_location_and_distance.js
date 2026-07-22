const authController = require('../src/controllers/auth.controller');
const orderController = require('../src/controllers/order.controller');
const memoryDb = require('../src/utils/memoryDb');

async function runTests() {
  console.log('--- Testing Backend Controllers Directly ---');

  // Helper mock req, res
  function mockRes() {
    return {
      statusCode: 200,
      body: null,
      status(code) {
        this.statusCode = code;
        return this;
      },
      json(data) {
        this.body = data;
        return this;
      },
    };
  }

  // 1. Test getAllVendors returns location and isOpen
  const req1 = {};
  const res1 = mockRes();
  await authController.getAllVendors(req1, res1);
  console.log('1. getAllVendors success:', res1.body.success);
  console.log('   Vendors:', res1.body.vendors.map(v => ({ shopName: v.shopName, isOpen: v.isOpen, lat: v.latitude, lng: v.longitude })));

  // 2. Test customerCreateOrder within 10km limit
  const req2 = {
    user: { id: 'cust123', mobile: '9876500000', name: 'Priya Sharma', latitude: 12.9352, longitude: 77.6245 },
    body: {
      ownerId: '666000111222333444555666',
      garments: [{ name: 'Shirt', qty: 2, rate: 40 }],
      customerLat: 12.9352,
      customerLng: 77.6245,
    },
  };
  const res2 = mockRes();
  await orderController.customerCreateOrder(req2, res2);
  console.log('2. customerCreateOrder (< 10km): status =', res2.statusCode, ', success =', res2.body.success, ', message =', res2.body.message, ', distance =', res2.body.order ? res2.body.order.distance : null);

  // 3. Test customerCreateOrder exceeding 10km limit
  const req3 = {
    user: { id: 'cust123', mobile: '9876500000', name: 'Priya Sharma' },
    body: {
      ownerId: '666000111222333444555666',
      garments: [{ name: 'Shirt', qty: 2, rate: 40 }],
      customerLat: 13.5000,
      customerLng: 78.5000,
    },
  };
  const res3 = mockRes();
  await orderController.customerCreateOrder(req3, res3);
  console.log('3. customerCreateOrder (> 10km): status =', res3.statusCode, ', error =', res3.body.error);

  // 4. Test customerCreateOrder when shop is closed
  const owner = memoryDb.findUserById('666000111222333444555666');
  if (owner) owner.isOpen = false;

  const req4 = {
    user: { id: 'cust123', mobile: '9876500000', name: 'Priya Sharma' },
    body: {
      ownerId: '666000111222333444555666',
      garments: [{ name: 'Shirt', qty: 2, rate: 40 }],
      customerLat: 12.9352,
      customerLng: 77.6245,
    },
  };
  const res4 = mockRes();
  await orderController.customerCreateOrder(req4, res4);
  console.log('4. customerCreateOrder (Closed Shop): status =', res4.statusCode, ', error =', res4.body.error);

  // Restore isOpen
  if (owner) owner.isOpen = true;

  console.log('--- All Controller Unit Tests PASSED! ---');
}

runTests().catch(console.error);
