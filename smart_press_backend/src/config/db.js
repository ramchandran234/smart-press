// src/config/db.js
const mongoose = require('mongoose');

const connectDB = async () => {
  const uri = process.env.MONGO_URI;

  if (!uri) {
    console.error('❌ MONGO_URI is undefined!');
    console.error('Current env keys:', Object.keys(process.env).filter(k => k.includes('MONGO')));
    throw new Error('MONGO_URI not set');
  }

  console.log('🔄 Connecting to MongoDB Atlas...');

  const conn = await mongoose.connect(uri, {
    serverSelectionTimeoutMS: 10000,
  });

  console.log(`✅ MongoDB Connected: ${conn.connection.host}`);
};

module.exports = connectDB;