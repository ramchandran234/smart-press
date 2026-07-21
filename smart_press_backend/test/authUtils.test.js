const test = require('node:test');
const assert = require('node:assert/strict');
const { normalizeMobile, hashPassword, comparePassword } = require('../src/utils/authUtils');

test('normalizeMobile strips formatting and country code', () => {
  assert.equal(normalizeMobile('+91 98765 43210'), '9876543210');
  assert.equal(normalizeMobile('9876543210'), '9876543210');
});

test('hashPassword and comparePassword work for login', async () => {
  const hash = await hashPassword('MySecret123');
  assert.notEqual(hash, 'MySecret123');
  const isMatch = await comparePassword('MySecret123', hash);
  assert.equal(isMatch, true);
});
