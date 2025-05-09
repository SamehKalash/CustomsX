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
  lastLogin: { type: Date, default: null }
});

// Updated IMEI Schema with detailed device information
const imeiSchema = new mongoose.Schema({
  imei_number: {
    type: String,
    required: true,
    unique: true,
    maxlength: 15,
  },
  brand: {
    type: String,
    default: 'Unknown',
  },
  model: {
    type: String,
    default: 'Unknown',
  },
  device_type: {
    type: String,
    default: 'Unknown',
  },
  operating_system: {
    type: String,
    default: 'Unknown',
  },
  is_registered: {
    type: Boolean,
    default: false,
  },
  paid_at: {
    type: Date,
    default: null,
  },
});

// Models
const IMEI = mongoose.model('IMEI', imeiSchema);
const HSCode = mongoose.model('HSCode', hscodeSchema);
const Country = mongoose.model('Country', countrySchema);
const User = mongoose.model('User', userSchema);

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
// Updated helper function to call the IMEI.info API
// based on the provided documentation
async function fetchIMEIInfo(imei) {
  try {
    const apiKey = process.env.IMEI_API_KEY;
    const serviceId = process.env.IMEI_SERVICE_ID || '1'; // Default to service ID 1 if not specified
    
    // Based on the documentation, correct endpoint format
    const apiUrl = 'https://dash.imei.info/api/check';
    
    console.log(`Checking IMEI ${imei} with service ID ${serviceId}`);
    
    const response = await axios.get(`${apiUrl}/${serviceId}/`, {
      params: {
        imei: imei,
        API_KEY: apiKey
      },
      timeout: 10000 // 10 second timeout
    });

    if (response.data && response.status === 200) {
      console.log('IMEI API response received:', response.status);
      return {
        success: true,
        data: response.data
      };
    } else {
      throw new Error('IMEI lookup failed with status: ' + response.status);
    }
  } catch (error) {
    console.error('IMEI API error:', error.message);
    
    // Better error handling with more specific error messages
    if (error.response) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx
      return {
        success: false,
        error: error.response.data?.detail || 
               error.response.data?.message || 
               `Error ${error.response.status}: Failed to lookup IMEI`
      };
    } else if (error.request) {
      // The request was made but no response was received
      return {
        success: false,
        error: 'No response received from IMEI service. Please try again later.'
      };
    } else {
      // Something happened in setting up the request that triggered an Error
      return {
        success: false,
        error: 'Error contacting IMEI.info API: ' + error.message
      };
    }
  }
}

// Updated IMEI Endpoints
app.get('/api/phone-type/:imei', async (req, res) => {
  const { imei } = req.params;

  if (!imei || imei.length !== 15 || !/^\d{15}$/.test(imei)) {
    return res.status(400).json({ error: 'Invalid IMEI number. It must be 15 digits.' });
  }

  try {
    // Find the IMEI record in the database
    const imeiRecord = await IMEI.findOne({ imei_number: imei });

    if (imeiRecord) {
      // If device is found in database, return its info
      const responseData = imeiRecord.toObject();
      responseData.fee = 5000; // Standard fee
      return res.status(200).json(responseData);
    }

    // If not found in database, fetch from IMEI.info API
    const imeiInfo = await fetchIMEIInfo(imei);
    
    if (!imeiInfo.success) {
      return res.status(404).json({ error: imeiInfo.error || 'Unable to verify IMEI information.' });
    }
    
    // Format the response to match our expected structure
    // Based on the API documentation
    const deviceInfo = {
      imei_number: imei,
      brand: imeiInfo.data.brand || imeiInfo.data.manufacturer || 'Unknown',
      model: imeiInfo.data.model || imeiInfo.data.device_model || 'Unknown',
      device_type: imeiInfo.data.device_type || imeiInfo.data.type || 'Smartphone',
      operating_system: imeiInfo.data.os || imeiInfo.data.operating_system || 'Unknown',
      is_registered: false,
      fee: 5000  // Standard fee for device registration
    };

    // Return the device info without saving it yet
    res.status(200).json(deviceInfo);
  } catch (error) {
    console.error('Error fetching phone information:', error);
    res.status(500).json({ error: 'An error occurred while checking the IMEI.' });
  }
});

app.post('/api/register-imei', async (req, res) => {
  const { imei_number } = req.body;

  if (!imei_number || imei_number.length !== 15 || !/^\d{15}$/.test(imei_number)) {
    return res.status(400).json({ error: 'Invalid IMEI number. It must be 15 digits.' });
  }

  try {
    // Find the IMEI record or create a new one
    let imeiRecord = await IMEI.findOne({ imei_number });

    if (imeiRecord && imeiRecord.is_registered) {
      return res.status(400).json({ error: 'IMEI is already registered.' });
    }

    if (!imeiRecord) {
      // If not found, fetch from IMEI.info API
      const imeiInfo = await fetchIMEIInfo(imei_number);
      
      if (!imeiInfo.success) {
        return res.status(404).json({ error: 'Unable to verify IMEI. ' + (imeiInfo.error || 'Unknown error') });
      }
      
      // Create a new record with the retrieved information
      imeiRecord = new IMEI({
        imei_number,
        brand: imeiInfo.data.brand || imeiInfo.data.manufacturer || 'Unknown',
        model: imeiInfo.data.model || imeiInfo.data.device_model || 'Unknown',
        device_type: imeiInfo.data.device_type || imeiInfo.data.type || 'Smartphone',
        operating_system: imeiInfo.data.os || imeiInfo.data.operating_system || 'Unknown',
        is_registered: false
      });
    }

    // Register the IMEI
    imeiRecord.is_registered = true;
    imeiRecord.paid_at = new Date();
    await imeiRecord.save();

    // Return the updated record with fee for consistency
    const responseData = imeiRecord.toObject();
    responseData.fee = 5000; // Add fee to response
    
    res.status(200).json({ 
      message: 'IMEI registered successfully.',
      imeiRecord: responseData
    });
  } catch (error) {
    console.error('Error registering IMEI:', error);
    res.status(500).json({ error: 'An error occurred while registering the IMEI.' });
  }
});

// New endpoint to get detailed IMEI information
app.get('/api/imei-details/:imei', async (req, res) => {
  const { imei } = req.params;

  if (!imei || imei.length !== 15 || !/^\d{15}$/.test(imei)) {
    return res.status(400).json({ error: 'Invalid IMEI number. It must be 15 digits.' });
  }

  try {
    // First check if we have this IMEI in our database
    const imeiRecord = await IMEI.findOne({ imei_number: imei });
    
    // Always fetch the latest data from the API for detailed information
    const imeiInfo = await fetchIMEIInfo(imei);
    
    if (!imeiInfo.success) {
      // If API call fails but we have a record, return what we know
      if (imeiRecord) {
        const basicInfo = imeiRecord.toObject();
        basicInfo.is_registered = imeiRecord.is_registered;
        basicInfo.registration_date = imeiRecord.paid_at;
        basicInfo.note = "Limited information available - using local records only";
        return res.status(200).json(basicInfo);
      }
      
      return res.status(404).json({ error: imeiInfo.error || 'Unable to retrieve IMEI information.' });
    }
    
    // Merge the API data with any local data we have
    const detailedInfo = {
      imei_number: imei,
      brand: imeiInfo.data.brand || imeiInfo.data.manufacturer || 'Unknown',
      model: imeiInfo.data.model || imeiInfo.data.device_model || 'Unknown',
      device_type: imeiInfo.data.device_type || imeiInfo.data.type || 'Smartphone',
      operating_system: imeiInfo.data.os || imeiInfo.data.operating_system || 'Unknown',
      
      // Additional details from the API response
      serial_number: imeiInfo.data.serial_number || null,
      manufacture_date: imeiInfo.data.manufacture_date || null,
      country_origin: imeiInfo.data.country || imeiInfo.data.origin || null,
      specifications: {
        memory: imeiInfo.data.memory || imeiInfo.data.ram || null,
        storage: imeiInfo.data.storage || null,
        display: imeiInfo.data.display || null,
        camera: imeiInfo.data.camera || null,
        processor: imeiInfo.data.processor || imeiInfo.data.cpu || null
      },
      
      // If we have local registration data, include it
      is_registered: imeiRecord ? imeiRecord.is_registered : false,
      registration_date: imeiRecord ? imeiRecord.paid_at : null,
      
      // Include the raw API response for diagnostic purposes
      api_data: process.env.NODE_ENV === 'development' ? imeiInfo.data : undefined
    };
    
    // If this is a device we haven't registered yet but have info for, save the basic details
    if (!imeiRecord) {
      const newImeiRecord = new IMEI({
        imei_number: imei,
        brand: detailedInfo.brand,
        model: detailedInfo.model,
        device_type: detailedInfo.device_type,
        operating_system: detailedInfo.operating_system,
        is_registered: false
      });
      
      // Save asynchronously without waiting
      newImeiRecord.save().catch(err => {
        console.error('Error saving new IMEI record:', err);
      });
    }
    
    res.status(200).json(detailedInfo);
  } catch (error) {
    console.error('Error fetching detailed IMEI information:', error);
    res.status(500).json({ 
      error: 'An error occurred while retrieving detailed IMEI information.',
      message: error.message
    });
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