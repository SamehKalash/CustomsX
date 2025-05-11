require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const axios = require('axios');
const speakeasy = require('speakeasy');
const QRCode = require('qrcode');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// MongoDB Connection
mongoose.connect(process.env.MONGO_URI, { dbName: 'countrydb' })
  .then(() => console.log('MongoDB Connected'))
  .catch(err => console.error('MongoDB Connection Error:', err));

// Schemas
const hscodeSchema = new mongoose.Schema({
  Code: String,
  NameAz: String,
  NameEn: String,
  NameRu: String,
  ChildGoods: [mongoose.Schema.Types.Mixed]
}, { collection: 'hscodes' });

const countrySchema = new mongoose.Schema({
  name: String,
  code: String,
  emoji: String,
  image: String,
  dialCodes: [String],
  slug: String
});

const userSchema = new mongoose.Schema({
  firstName: { type: String, required: true },
  lastName: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  dob: { type: Date, required: true },
  gender: { type: String, required: true },
  address: { type: String, required: true },
  country: { type: String, required: true },
  mobile: { type: String, required: true },
  countryCode: { type: String, required: true },
  createdAt: { type: Date, default: Date.now },
  lastLogin: { type: Date, default: null },
  accounttype: { type: String, default: "Personal" },
  // 2FA fields
  twoFactorEnabled: { type: Boolean, default: false },
  twoFactorSecret: { type: String, default: null },
  twoFactorTempSecret: { type: String, default: null },
  twoFactorVerified: { type: Boolean, default: false },
  phoneVerificationCode: { type: String, default: null },
  phoneVerificationExpires: { type: Date, default: null },
  phoneVerified: { type: Boolean, default: false }
});

const imeiSchema = new mongoose.Schema({
  imei_number: { 
    type: String, 
    required: true, 
    unique: true,
    validate: {
      validator: v => /^\d{15}$/.test(v),
      message: props => `${props.value} is not a valid 15-digit IMEI number!`
    }
  },
  device_type: String,
  brand: String,
  model: String,
  operating_system: String,
  fee: Number,
  is_registered: { type: Boolean, default: false },
  registration_date: { type: Date, default: null },
  technical_specs: mongoose.Schema.Types.Mixed,
  valid_tac: Boolean,
  origin_country: String,
  release_year: Number
}, { collection: 'imeis' });

// Models
const HSCode = mongoose.model('HSCode', hscodeSchema);
const Country = mongoose.model('Country', countrySchema);
const User = mongoose.model('User', userSchema);
const IMEI = mongoose.model('IMEI', imeiSchema);

// Utility function to send verification SMS
const sendVerificationSMS = async (phone, code) => {
  // Log the verification code to terminal for testing/development
  console.log('\n==================================================');
  console.log(`📱 VERIFICATION CODE for ${phone}: ${code}`);
  console.log('==================================================\n');
  
  // In a real implementation, you would integrate with an SMS service provider
  // like Twilio, Nexmo, or any other SMS gateway.
  // For now, we'll just simulate sending and return a success response
  
  console.log('SMS sending simulated. In production, integrate with an SMS provider.');
  return { success: true, message: 'Verification code sent' };
};

// Generate a random 6-digit code
const generateVerificationCode = () => {
  return Math.floor(100000 + Math.random() * 900000).toString();
};

// ================== IMEI Endpoints ==================
app.get('/api/imei/:imei', async (req, res) => {
  try {
    const { imei } = req.params;
    
    if (!/^\d{15}$/.test(imei)) {
      return res.status(400).json({ error: 'Invalid IMEI format - must be 15 digits' });
    }

    const imeiRecord = await IMEI.findOne({ imei_number: imei });
    
    if (!imeiRecord) {
      return res.status(404).json({ error: 'IMEI not found in database' });
    }

    if (!imeiRecord.valid_tac) {
      return res.status(400).json({ error: 'Invalid TAC - Device not recognized' });
    }

    res.json({
      imei_number: imeiRecord.imei_number,
      device_type: imeiRecord.device_type,
      brand: imeiRecord.brand,
      model: imeiRecord.model,
      operating_system: imeiRecord.operating_system,
      fee: imeiRecord.fee,
      is_registered: imeiRecord.is_registered,
      registration_date: imeiRecord.registration_date,
      technical_specs: imeiRecord.technical_specs,
      valid_tac: imeiRecord.valid_tac,
      origin_country: imeiRecord.origin_country,
      release_year: imeiRecord.release_year
    });

  } catch (error) {
    console.error('IMEI check error:', error);
    res.status(500).json({ error: 'Server error during IMEI check' });
  }
});

app.post('/api/imei/register', async (req, res) => {
  try {
    const { imei_number } = req.body;
    
    if (!/^\d{15}$/.test(imei_number)) {
      return res.status(400).json({ error: 'Invalid IMEI format - must be 15 digits' });
    }

    let imeiRecord = await IMEI.findOne({ imei_number });

    if (!imeiRecord) {
      return res.status(404).json({ error: 'IMEI not found in database' });
    }

    if (imeiRecord.is_registered) {
      return res.status(400).json({ error: 'IMEI already registered' });
    }

    imeiRecord.is_registered = true;
    imeiRecord.registration_date = new Date();
    await imeiRecord.save();

    res.json({
      message: 'IMEI registered successfully',
      imeiRecord: {
        imei_number: imeiRecord.imei_number,
        brand: imeiRecord.brand,
        model: imeiRecord.model,
        fee: imeiRecord.fee,
        is_registered: imeiRecord.is_registered,
        registration_date: imeiRecord.registration_date,
        device_type: imeiRecord.device_type,
        operating_system: imeiRecord.operating_system
      }
    });

  } catch (error) {
    console.error('IMEI registration error:', error);
    res.status(500).json({ error: 'Server error during IMEI registration' });
  }
});


// HS Code Endpoints
app.get('/api/hscodes', async (req, res) => {
  try {
    const { search } = req.query;
    const query = search ? { 
      $or: [
        { Code: new RegExp(search, 'i') },
        { NameEn: new RegExp(search, 'i') }
      ]
    } : {};
    
    const codes = await HSCode.find(query)
      .limit(50)
      .select('Code NameEn -_id');
      
    res.json(codes);
  } catch (error) {
    res.status(500).json({ error: 'Error fetching HS Codes' });
  }
});

// Customs API Endpoints
app.post('/api/customs/check-code', async (req, res) => {
  try {
    const response = await axios.get(
      'https://c2b-fbusiness.customs.gov.az/api/v1/goods/check-code',
      {
        params: req.body,
        headers: {
          'Authorization': `Bearer ${process.env.CUSTOMS_API_KEY}`,
          'lang': req.headers.lang || 'en',
          'requestSource': 'ECustoms'
        }
      }
    );
    res.json(response.data);
  } catch (error) {
    res.status(error.response?.status || 500).json(error.response?.data || { error: 'Error checking code' });
  }
});

app.post('/api/customs/calculate-duty', async (req, res) => {
  try {
    const hscode = await HSCode.findOne({ Code: req.body.hsCode })
      .select('NameEn -_id');

    const response = await axios.post(
      'https://c2b-fbusiness.customs.gov.az/api/v1/goods/calculate-duty',
      req.body,
      {
        headers: {
          'Authorization': `Bearer ${process.env.CUSTOMS_API_KEY}`,
          'lang': req.headers.lang || 'en',
          'requestSource': 'ECustoms',
          'Content-Type': 'application/json'
        }
      }
    );

    const responseData = response.data;
    if (responseData.data) {
      responseData.data.productNameEn = hscode?.NameEn || 'Unknown product';
    }

    res.json(responseData);
  } catch (error) {
    res.status(error.response?.status || 500).json(error.response?.data || { error: 'Error calculating duty' });
  }
});

// Country Endpoints
app.get('/countries', async (req, res) => {
  try {
    const countries = await Country.find().sort('name');
    res.json(countries);
  } catch (err) {
    res.status(500).json({ error: 'Failed to load countries' });
  }
});

// User Authentication Endpoints
app.post('/register', async (req, res) => {
  try {
    const { firstName, lastName, email, password, dob, gender, address, country, mobile, countryCode } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ error: 'Email already registered' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const verificationCode = generateVerificationCode();
    const expirationTime = new Date();
    expirationTime.setMinutes(expirationTime.getMinutes() + 10); // Code expires in 10 minutes

    console.log(`\n🔐 NEW USER REGISTRATION - ${email}`);

    const newUser = new User({
      firstName,
      lastName,
      email,
      password: hashedPassword,
      dob: new Date(dob),
      gender,
      address,
      country,
      mobile: `${mobile}`,
      countryCode,
      phoneVerificationCode: verificationCode,
      phoneVerificationExpires: expirationTime,
      phoneVerified: false
    });

    await newUser.save();
    
    // Send verification SMS
    try {
      await sendVerificationSMS(mobile, verificationCode);
    } catch (smsError) {
      console.error('SMS sending error:', smsError);
      // Continue with registration even if SMS fails
    }

    res.status(201).json({
      message: 'Registration initiated. Please verify your phone.',
      user: { 
        id: newUser._id, 
        email: newUser.email,
        requiresPhoneVerification: true
      }
    });

  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({ error: 'Server error during registration' });
  }
});

// Endpoint to verify phone
app.post('/verify-phone', async (req, res) => {
  try {
    const { userId, code } = req.body;
    
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    if (user.phoneVerified) {
      return res.status(400).json({ error: 'Phone already verified' });
    }
    
    if (!user.phoneVerificationCode || 
        user.phoneVerificationCode !== code || 
        new Date() > user.phoneVerificationExpires) {
      return res.status(400).json({ error: 'Invalid or expired verification code' });
    }
    
    // Mark phone as verified
    user.phoneVerified = true;
    user.phoneVerificationCode = null;
    user.phoneVerificationExpires = null;
    
    // Skip 2FA setup
    await user.save();
    
    res.json({ 
      message: 'Phone verified successfully.',
      twoFactorSetupRequired: false
    });
    
  } catch (error) {
    console.error('Phone verification error:', error);
    res.status(500).json({ error: 'Server error during phone verification' });
  }
});

// Endpoint to verify and enable 2FA
app.post('/verify-2fa-setup', async (req, res) => {
  try {
    const { userId, token } = req.body;
    
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    if (!user.twoFactorTempSecret) {
      return res.status(400).json({ error: 'No temporary 2FA secret found' });
    }
    
    const verified = speakeasy.totp.verify({
      secret: user.twoFactorTempSecret,
      encoding: 'base32',
      token
    });
    
    if (!verified) {
      return res.status(400).json({ error: 'Invalid 2FA token' });
    }
    
    user.twoFactorSecret = user.twoFactorTempSecret;
    user.twoFactorTempSecret = null;
    user.twoFactorEnabled = true;
    user.twoFactorVerified = true;
    
    await user.save();
    
    res.json({
      message: '2FA setup completed successfully',
      twoFactorEnabled: true,
      user: { 
        id: user._id, 
        firstName: user.firstName, 
        email: user.email,
        accounttype: user.accounttype 
      }
    });
    
  } catch (error) {
    console.error('2FA setup error:', error);
    res.status(500).json({ error: 'Server error during 2FA setup' });
  }
});

app.post('/login', async (req, res) => {
  try {
    const { email, password, token } = req.body;
    const user = await User.findOne({ email });

    if (!user) return res.status(404).json({ error: 'Account not found' });
    
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(401).json({ error: 'Invalid credentials' });

    // Check if phone is verified
    if (!user.phoneVerified) {
      // Generate a new verification code
      const verificationCode = generateVerificationCode();
      const expirationTime = new Date();
      expirationTime.setMinutes(expirationTime.getMinutes() + 10);
      
      console.log(`\n⚠️ LOGIN ATTEMPT WITH UNVERIFIED PHONE - ${email}`);
      
      user.phoneVerificationCode = verificationCode;
      user.phoneVerificationExpires = expirationTime;
      await user.save();
      
      // Send new verification SMS
      try {
        await sendVerificationSMS(user.mobile, verificationCode);
      } catch (smsError) {
        console.error('SMS sending error:', smsError);
      }
      
      return res.json({ 
        requiresPhoneVerification: true,
        user: {
          id: user._id,
          mobile: user.mobile
        }
      });
    }

    // We're skipping all 2FA checks
    user.lastLogin = Date.now();
    await user.save();

    // Return user data after successful authentication
    return res.json({
      user: {
        id: user._id,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        mobile: user.mobile,
        accounttype: user.accounttype,
        twoFactorEnabled: false
      }
    });

  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: 'Server error during login' });
  }
});

// Endpoint to verify 2FA during login
app.post('/verify-2fa', async (req, res) => {
  try {
    const { userId, token } = req.body;
    
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    if (!user.twoFactorEnabled || !user.twoFactorSecret) {
      return res.status(400).json({ error: '2FA not enabled for this user' });
    }
    
    const verified = speakeasy.totp.verify({
      secret: user.twoFactorSecret,
      encoding: 'base32',
      token,
      window: 1 // Allow 30 seconds leeway
    });
    
    if (!verified) {
      return res.status(401).json({ error: 'Invalid 2FA token' });
    }
    
    user.lastLogin = Date.now();
    await user.save();
    
    res.json({
      user: {
        id: user._id,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        mobile: user.mobile,
        accounttype: user.accounttype,
        twoFactorEnabled: user.twoFactorEnabled
      }
    });
    
  } catch (error) {
    console.error('2FA verification error:', error);
    res.status(500).json({ error: 'Server error during 2FA verification' });
  }
});

// User Management Endpoints
app.post('/updateProfile', async (req, res) => {
  try {
    const { email, firstName, lastName, address, country, mobile } = req.body;
    const user = await User.findOne({ email });

    if (!user) return res.status(404).json({ error: 'User not found' });

    user.firstName = firstName ?? user.firstName;
    user.lastName = lastName ?? user.lastName;
    user.address = address ?? user.address;
    user.country = country ?? user.country;
    user.mobile = mobile ?? user.mobile;

    await user.save();
    
    // Return updated user data
    res.json({ 
      message: 'Profile updated successfully',
      user: {
        id: user._id,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        mobile: user.mobile,
        address: user.address,
        country: user.country,
        accounttype: user.accounttype
      }
    });
  } catch (error) {
    console.error('Profile update error:', error);
    res.status(500).json({ error: 'Server error during profile update' });
  }
});

app.post('/changePassword', async (req, res) => {
  try {
    const { email, oldPassword, newPassword } = req.body;
    const user = await User.findOne({ email });

    if (!user) return res.status(404).json({ error: 'User not found' });
    
    const isMatch = await bcrypt.compare(oldPassword, user.password);
    if (!isMatch) return res.status(401).json({ error: 'Old password is incorrect' });

    user.password = await bcrypt.hash(newPassword, 10);
    await user.save();
    res.json({ message: 'Password changed successfully' });
  } catch (error) {
    console.error('Password change error:', error);
    res.status(500).json({ error: 'Server error during password change' });
  }
});

// Update user profile type
app.put('/users/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { accounttype, companyName, registrationNumber, authorizedRepresentatives } = req.body;
    
    const user = await User.findById(id);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    user.accounttype = accounttype;
    user.companyName = companyName;
    user.registrationNumber = registrationNumber;
    user.authorizedRepresentatives = authorizedRepresentatives;

    await user.save();

    res.json({
      message: 'Profile type updated successfully',
      user: {
        id: user._id,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        accounttype: user.accounttype,
        companyName: user.companyName,
        registrationNumber: user.registrationNumber,
        authorizedRepresentatives: user.authorizedRepresentatives
      }
    });
  } catch (error) {
    console.error('Profile type update error:', error);
    res.status(500).json({ error: 'Server error during profile type update' });
  }
});

// Resend verification code endpoint
app.post('/api/resend-verification-code', async (req, res) => {
  try {
    const { userId, phone } = req.body;
    
    if (!userId || !phone) {
      return res.status(400).json({ error: 'User ID and phone are required' });
    }
    
    // Find the user
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    // Check if the phone matches
    if (user.mobile !== phone) {
      return res.status(400).json({ error: 'Phone number does not match user record' });
    }
    
    // Generate a new verification code
    const code = generateVerificationCode();
    const codeExpiry = new Date();
    codeExpiry.setMinutes(codeExpiry.getMinutes() + 10); // Code expires in 10 minutes
    
    console.log(`\n🔄 RESENDING VERIFICATION CODE - ${phone}`);
    
    // Update user with new code
    user.phoneVerificationCode = code;
    user.phoneVerificationExpires = codeExpiry;
    await user.save();
    
    // Send the verification SMS
    await sendVerificationSMS(phone, code);
    
    res.json({ message: 'Verification code has been resent' });
  } catch (error) {
    console.error('Error resending verification code:', error);
    res.status(500).json({ error: 'Server error while resending verification code' });
  }
});

// Get user profile
app.get('/api/user/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    const user = await User.findById(id);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    res.json({
      user: {
        id: user._id,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        mobile: user.mobile,
        address: user.address,
        country: user.country,
        accounttype: user.accounttype,
        twoFactorEnabled: user.twoFactorEnabled
      }
    });
    
  } catch (error) {
    console.error('Get user profile error:', error);
    res.status(500).json({ error: 'Server error during profile retrieval' });
  }
});

// FOR DEVELOPMENT ONLY: Endpoint to manually verify phone
app.get('/dev/verify-phone/:email', async (req, res) => {
  // This endpoint should only be accessible in development mode
  if (process.env.NODE_ENV === 'production') {
    return res.status(404).json({ error: 'Endpoint not found' });
  }
  
  try {
    const { email } = req.params;
    
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    // Mark phone as verified
    user.phoneVerified = true;
    user.phoneVerificationCode = null;
    user.phoneVerificationExpires = null;
    await user.save();
    
    console.log(`\n✅ DEV MODE: Manually verified phone for ${email}`);
    
    res.json({ 
      message: 'Phone manually verified successfully.',
      user: {
        id: user._id,
        email: user.email,
        phoneVerified: user.phoneVerified
      }
    });
    
  } catch (error) {
    console.error('Manual phone verification error:', error);
    res.status(500).json({ error: 'Server error during manual phone verification' });
  }
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));