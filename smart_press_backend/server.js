// server.js
'use strict';

require('dotenv').config();

if (!process.env.MONGO_URI) {
  process.env.MONGO_URI  = 'mongodb://127.0.0.1:27017/smartpress';
  process.env.JWT_SECRET = 'smartpress_super_secret_2026';
  process.env.NODE_ENV   = 'development';
}

const mongoose = require('mongoose');
const app      = require('./src/app');

// Railway sets PORT automatically
const PORT  = process.env.PORT || 5000;
const MONGO = process.env.MONGO_URI;

console.log(`🌍 Environment : ${process.env.NODE_ENV}`);
console.log(`🔌 Port        : ${PORT}`);
console.log(`🗄️  MongoDB     : ${MONGO ? '✅ set' : '❌ missing'}`);

// Connect to MongoDB first so all data persists directly to MongoDB database
mongoose.connect(MONGO, { serverSelectionTimeoutMS: 5000 })
  .then(() => {
    console.log(`✅ MongoDB Connected to: ${mongoose.connection.host}`);
    app.listen(PORT, '0.0.0.0', () => {
      console.log(`\n🚀 Iron Buddy API running on port ${PORT}`);
    });
  })
  .catch((err) => {
    console.error('❌ MongoDB Error:', err.message);
    app.listen(PORT, '0.0.0.0', () => {
      console.log(`\n🚀 Iron Buddy API running on port ${PORT} (Database Offline)`);
    });
  });