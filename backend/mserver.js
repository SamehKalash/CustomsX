require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const axios = require('axios');

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
  accounttype: { type: String, default: "Personal" }
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
      countryCode
    });

    await newUser.save();
    res.status(201).json({
      message: 'Registration successful',
      user: { id: newUser._id, firstName: newUser.firstName, email: newUser.email }
    });

  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({ error: 'Server error during registration' });
  }
});

app.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });

    if (!user) return res.status(404).json({ error: 'Account not found' });
    
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(401).json({ error: 'Invalid credentials' });

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
    res.json({ message: 'Profile updated successfully' });
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

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));