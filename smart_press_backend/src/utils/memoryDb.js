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

    // Pre-seed demo owner & customer accounts for instant offline / cloud testing
    this.seedDemoData();
  }

  seedDemoData() {
    const defaultOwnerId = '666000111222333444555666';
    const defaultCustomerId = '777000111222333444555777';

    this.users.push({
      _id: defaultOwnerId,
      name: 'Smart Press Admin',
      mobile: '9876543210',
      password: '$2a$10$wT0X8XqJ2gXv2qX2qX2qX.X2qX2qX2qX2qX2qX2qX2qX2qX2qX2q', // hashed demo
      role: 'owner',
      shopName: 'Smart Press Express',
      addressLine1: '123 Main Street',
      area: 'Vadapalani',
      city: 'Chennai',
      address: '123 Main Street, Vadapalani, Chennai',
      isVerified: true,
      recoveryPin: '123456',
      createdAt: new Date(),
    });

    this.customers.push({
      _id: defaultCustomerId,
      owner: defaultOwnerId,
      name: 'Priya Sharma',
      mobile: '9876500000',
      whatsapp: '9876500000',
      area: 'Vadapalani',
      address: '76 Alwarthirunagar',
      city: 'Chennai',
      totalOrders: 3,
      totalSpend: 1200,
      balance: 0,
      isActive: true,
      lastOrderAt: new Date(),
      createdAt: new Date(),
    });
  }

  generateId() {
    return crypto.randomBytes(12).toString('hex');
  }

  // ── USER HELPER METHODS ──────────────────────────────
  findUserByMobile(mobile) {
    return this.users.find(u => u.mobile === mobile);
  }

  findUserById(id) {
    return this.users.find(u => u._id === id || u._id.toString() === id.toString());
  }

  createUser(userData) {
    const newUser = {
      _id: this.generateId(),
      isVerified: true,
      isActive: true,
      createdAt: new Date(),
      updatedAt: new Date(),
      ...userData,
    };
    this.users.push(newUser);
    return newUser;
  }

  updateUser(mobile, updateData) {
    const user = this.findUserByMobile(mobile);
    if (!user) return null;
    Object.assign(user, updateData, { updatedAt: new Date() });
    return user;
  }
}

module.exports = new MemoryDb();
