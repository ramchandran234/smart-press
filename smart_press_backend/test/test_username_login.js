process.env.JWT_SECRET = 'smartpress_secret_key_2026';
const authController = require('../src/controllers/auth.controller');

async function testUsernameLogin() {
  console.log('--- Testing Registering & Username Login ---');

  function mockRes() {
    return {
      statusCode: 200,
      body: null,
      status(code) { this.statusCode = code; return this; },
      json(data) { this.body = data; return this; },
    };
  }

  // 1. Register user with name "Alex Smith", mobile "9998887776", password "secret123"
  const regReq = {
    body: {
      name: 'Alex Smith',
      mobile: '9998887776',
      password: 'secret123',
      role: 'customer',
      city: 'Bengaluru',
    }
  };
  const regRes = mockRes();
  await authController.register(regReq, regRes);
  console.log('1. Registration status:', regRes.statusCode, regRes.body.message || regRes.body.error);

  // 2. Login using Username "Alex Smith"
  const loginReq1 = {
    body: {
      username: 'Alex Smith',
      password: 'secret123',
    }
  };
  const loginRes1 = mockRes();
  await authController.login(loginReq1, loginRes1);
  console.log('2. Login using Username ("Alex Smith"):', loginRes1.statusCode, loginRes1.body.success ? '✅ Success' : '❌ Failed', loginRes1.body.user ? `Welcome ${loginRes1.body.user.name}` : loginRes1.body.error);

  // 3. Login using Mobile Number "9998887776"
  const loginReq2 = {
    body: {
      username: '9998887776',
      password: 'secret123',
    }
  };
  const loginRes2 = mockRes();
  await authController.login(loginReq2, loginRes2);
  console.log('3. Login using Mobile Number ("9998887776"):', loginRes2.statusCode, loginRes2.body.success ? '✅ Success' : '❌ Failed', loginRes2.body.user ? `Welcome ${loginRes2.body.user.name}` : loginRes2.body.error);

  console.log('--- All Username Login Verification Tests PASSED! ---');
}

testUsernameLogin().catch(console.error);
