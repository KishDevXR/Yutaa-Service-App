const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    name: {
        type: String,
        trim: true,
    },
    phone: {
        type: String,
        required: [true, 'Phone number is required'],
        unique: true,
        trim: true,
    },
    email: {
        type: String,
        unique: true,
        sparse: true, // Allow null/unique
        trim: true,
        lowercase: true,
    },
    role: {
        type: String,
        enum: ['customer', 'partner', 'admin'],
        default: 'customer',
    },
    profileImage: {
        type: String,
    },
    addresses: [{
        label: String,
        fullAddress: String,
        city: String,
        pincode: String,
        lat: Number,
        lng: Number,
        isDefault: { type: Boolean, default: false }
    }],
    fcmToken: {
        type: String,
    },
    isActive: {
        type: Boolean,
        default: true,
    },
    createdAt: {
        type: Date,
        default: Date.now,
    }
});

module.exports = mongoose.model('User', userSchema);
