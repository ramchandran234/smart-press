// check_db.js - Database Data Inspector
const mongoose = require('mongoose');

const mongoUri = process.env.MONGO_URI || 'mongodb://127.0.0.1:27017/smartpress';

async function checkDb() {
  try {
    await mongoose.connect(mongoUri, { serverSelectionTimeoutMS: 5000 });
    console.log(`\n========================================`);
    console.log(`Connected to MongoDB: ${mongoUri}`);
    console.log(`========================================\n`);

    const db = mongoose.connection.db;

    // 1. Fetch Users
    const users = await db.collection('users').find({}).toArray();
    console.log(`📌 USERS (${users.length} total):`);
    if (users.length === 0) {
      console.log('   No users found in DB.');
    } else {
      console.table(users.map(u => ({
        ID: u._id.toString(),
        Name: u.name,
        Mobile: u.mobile,
        Role: u.role,
        Shop: u.shopName || 'N/A',
        Lat: u.latitude || 'N/A',
        Lng: u.longitude || 'N/A',
        IsOpen: u.isOpen !== undefined ? u.isOpen : true,
      })));
    }

    // 2. Fetch Customers
    const customers = await db.collection('customers').find({}).toArray();
    console.log(`\n📌 CUSTOMER PROFILES (${customers.length} total):`);
    if (customers.length === 0) {
      console.log('   No customer profiles found in DB.');
    } else {
      console.table(customers.map(c => ({
        ID: c._id.toString(),
        Name: c.name,
        Mobile: c.mobile,
        Owner: c.owner ? c.owner.toString() : 'N/A',
        TotalOrders: c.totalOrders || 0,
        TotalSpend: c.totalSpend || 0,
      })));
    }

    // 3. Fetch Orders
    const orders = await db.collection('orders').find({}).toArray();
    console.log(`\n📌 ORDERS (${orders.length} total):`);
    if (orders.length === 0) {
      console.log('   No orders found in DB.');
    } else {
      console.table(orders.map(o => ({
        OrderID: o.orderId || o._id.toString(),
        Owner: o.owner ? o.owner.toString() : 'N/A',
        Status: o.status,
        Distance: o.distance != null ? `${o.distance} km` : 'N/A',
        TotalAmount: `₹${o.totalAmount || 0}`,
        OrderType: o.orderType || 'walk-in',
      })));
    }

    console.log('\n========================================\n');
  } catch (err) {
    console.error('❌ Error inspecting DB:', err.message);
  } finally {
    await mongoose.connection.close();
    process.exit(0);
  }
}

checkDb();
