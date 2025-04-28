// Load environment variables FIRST
require('dotenv').config();
// Add this right after requiring dotenv
console.log('Current directory:', __dirname);
console.log('Environment file path:', require('path').join(__dirname, '.env'));

const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

// Create Express app
const app = express();

// Middleware
app.use(cors());
app.use(express.json()); // For parsing JSON request bodies

// Debugging: Show loaded environment variables
console.log('Environment Variables:');
console.log('PORT:', process.env.PORT);
console.log('MONGO_URI:', process.env.MONGO_URI ? '***exists***' : 'missing');

// Database Connection
mongoose.connect(process.env.MONGO_URI)
.then(() => console.log('🎉 Connected to MongoDB successfully!'))
.catch(err => console.error('💥 MongoDB connection error:', err));

// User Schema
const userSchema = new mongoose.Schema({
  firstName: String,
  lastName: String,
  email: { type: String, unique: true },
  password: String,
}, { timestamps: true }); // Adds createdAt and updatedAt fields

const User = mongoose.model('User', userSchema);

// Test Route
app.get('/', (req, res) => {
  res.json({ message: '🚀 Flutter Backend is running!' });
});

// Registration Endpoint
app.post('/register', async (req, res) => {
  try {
    const user = new User(req.body);
    await user.save();
    res.status(201).json({
      success: true,
      message: '✅ User created successfully!',
      user: user
    });
  } catch (error) {
    console.error('Registration error:', error);
    res.status(400).json({
      success: false,
      error: error.message
    });
  }
});

// Set port and start server
const port = process.env.PORT || 5000; // Fallback to 5000 if not in .env
app.listen(port, () => {
  console.log(`\n🚀 Server running on http://localhost:${port}`);
  console.log('📡 Waiting for connections...');
});
