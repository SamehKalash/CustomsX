require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bcrypt = require('bcryptjs');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// MongoDB Connection
mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log('MongoDB Connected'))
  .catch(err => console.error('MongoDB Connection Error:', err));


// Schemas
const countrySchema = new mongoose.Schema({
  name: String,
  code: String,
  emoji: String,
  image: String,
  dialCodes: [String],
  slug: String
});

// === CONTACT FORM API START ===

// 1. Contact Schema
const contactSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true },
  message: { type: String, required: true },
  inquiryType: { type: String, required: true },
  attachmentUrl: { type: String, default: null },
  createdAt: { type: Date, default: Date.now },
  ticketId: { type: String, required: true }
});

const Contact = mongoose.model('Contact', contactSchema);

// 2. Multer Setup for File Uploads
const multer = require('multer');
const upload = multer({ dest: 'uploads/' });  // Or configure cloud storage later

// 3. SendGrid Email Setup
const sgMail = require('@sendgrid/mail');
if (process.env.SENDGRID_API_KEY) {
  sgMail.setApiKey(process.env.SENDGRID_API_KEY);
}

// 4. POST /contact - Handles Contact Form Submission
app.post('/contact', upload.single('attachment'), async (req, res) => {
  try {
    const { name, email, message, inquiryType } = req.body;

    // Basic validation
    if (!name || !email || !message || !inquiryType) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    // Generate unique Ticket ID
    const ticketId = 'TKT-' + Math.random().toString(36).substring(2, 10).toUpperCase();

    // Save contact to database
    const newContact = new Contact({
      name,
      email,
      message,
      inquiryType,
      ticketId,
      attachmentUrl: req.file ? req.file.path : null
    });

    await newContact.save();

    // Optional: Send auto-confirmation email
    if (process.env.SENDGRID_API_KEY) {
      const msg = {
        to: email,
        from: 'support@example.com', // 🔧 CHANGE THIS to your verified sender
        subject: `Support Request Received (ID: ${ticketId})`,
        text: `Hi ${name},\n\nWe’ve received your message regarding "${inquiryType}". Our team will respond shortly.\n\nTicket ID: ${ticketId}\n\nThank you!`,
      };
      await sgMail.send(msg);
    }

    res.status(200).json({ message: 'Submitted successfully', ticketId });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// === CONTACT FORM API END ===


app.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ error: 'Account not found' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    user.lastLogin = Date.now();
    await user.save();

    res.json({
      message: 'Login successful',
      user: {
        id: user._id,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        country: user.country,
        address: user.address,
        mobile: user.mobile,
        dob: user.dob,
        createdAt: user.createdAt,
        lastLogin: user.lastLogin,
      }
    });

  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: 'Server error during login' });
  }
});

// New: Update Profile
app.post('/updateProfile', async (req, res) => {
  try {
    const { email, firstName, lastName, address, country, mobile } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    user.firstName = firstName ?? user.firstName;
    user.lastName = lastName ?? user.lastName;
    user.address = address ?? user.address;
    user.country = country ?? user.country;
    user.mobile = mobile ?? user.mobile;

    await user.save();

    res.json({ message: 'Profile updated successfully' });
  } catch (error) {
    console.error('Profile update error:', error);
    res.status(500).json({ error: 'Server error during profile update' });
  }
});

// New: Change Password
app.post('/changePassword', async (req, res) => {
  try {
    const { email, oldPassword, newPassword } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    const isMatch = await bcrypt.compare(oldPassword, user.password);
    if (!isMatch) {
      return res.status(401).json({ error: 'Old password is incorrect' });
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);
    user.password = hashedPassword;
    await user.save();

    res.json({ message: 'Password changed successfully' });
  } catch (error) {
    console.error('Password change error:', error);
    res.status(500).json({ error: 'Server error during password change' });
  }
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

const mongoose = require('mongoose');

const InquirySchema = new mongoose.Schema({
  name: String,
  email: String,
  message: String,
  inquiryType: String,
  attachmentPath: String, // path to saved file
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Inquiry', InquirySchema);
const Inquiry = require('./models/Inquiry'); // Adjust the path as necessary