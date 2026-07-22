// server.js
'use strict';

require('dotenv').config();

// Ensure required env vars have defaults
if (!process.env.JWT_SECRET) {
  process.env.JWT_SECRET = 'smartpress_super_secret_2026';
}
if (!process.env.NODE_ENV) {
  process.env.NODE_ENV = 'production';
}

const mongoose = require('mongoose');
const app      = require('./src/app');

const PORT  = process.env.PORT || 5000;
const MONGO = process.env.MONGO_URI;

console.log(`🌍 Environment : ${process.env.NODE_ENV}`);
console.log(`🔌 Port        : ${PORT}`);
console.log(`🗄️  MongoDB     : ${MONGO ? '✅ set' : '⚠️ missing – running without DB'}`);

// ── ALWAYS start HTTP server FIRST so Render health check passes ──────────
// This prevents "Exited with status 1" crash on Render when MongoDB is slow
app.listen(PORT, '0.0.0.0', () => {
  console.log(`\n🚀 Iron Buddy API running on port ${PORT}`);
});

// ── Connect to MongoDB in background AFTER server is already up ────────────
if (MONGO) {
  mongoose.connect(MONGO, {
    serverSelectionTimeoutMS: 15000,
    socketTimeoutMS: 45000,
  })
    .then(() => {
      console.log(`✅ MongoDB Connected: ${mongoose.connection.host}`);
    })
    .catch((err) => {
      console.error('⚠️ MongoDB connection failed (server still running):', err.message);
    });
} else {
  console.warn('⚠️ MONGO_URI not set — running in memoryDb fallback mode');
}