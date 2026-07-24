// src/utils/memoryDb.js
const crypto = require('crypto');

class MemoryDb {
  constructor() {
    this.users = [];
    this.customers = [];
    this.orders = [];
    this.invoices = [];
    this.expenses = [];
    this.suppliers = [];
  }

  // ── Helper search methods ────────────────────────
  findUserById(id) {
    return this.users.find(u => u._id === id || u.id === id);
  }

  findUserByMobile(mobile) {
    return this.users.find(u => u.mobile === mobile);
  }

  findCustomerById(id) {
    return this.customers.find(c => c._id === id || c.id === id);
  }

  findOrderById(id) {
    return this.orders.find(o => o._id === id || o.id === id || o.orderId === id);
  }

  generateId() {
    return new crypto.randomBytes(12).toString('hex');
  }

  createUser(userData) {
    const newUser = { _id: this.generateId(), id: this.generateId(), ...userData };
    this.users.push(newUser);
    return newUser;
  }


  generateOrderId() {
    const num = Math.floor(1000 + Math.random() * 9000);
    return `ORD${num}`;
  }
}

module.exports = new MemoryDb();
