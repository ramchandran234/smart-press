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

// Start Express API server immediately so health checks & HTTP requests never block
app.listen(PORT, '0.0.0.0', () => {
  console.log(`\n🚀 Smart Press API running on port ${PORT}`);
});

// Disable Mongoose query buffering so API calls fail fast if database is disconnected instead of freezing
mongoose.set('bufferCommands', false);

// Connect to MongoDB asynchronously with 5s timeout
mongoose.connect(MONGO, { serverSelectionTimeoutMS: 5000 })
  .then(() => {
    console.log(`✅ MongoDB Connected to: ${mongoose.connection.host}`);
  })
  .catch((err) => {
    console.error('❌ MongoDB Error:', err.message);
  });