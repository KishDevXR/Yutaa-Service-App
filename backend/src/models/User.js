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
    gender: {
        type: String,
        enum: ['Male', 'Female', 'Other'],
    },
    dob: {
        type: String, // Storing as String "DD/MM/YYYY" to match UI for simplicity
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
    // Partner-specific fields
    serviceCategory: {
        type: String,
    },
    experienceYears: {
        type: Number,
    },
    bio: {
        type: String,
    },
    isAvailable: {
        type: Boolean,
        default: false // Partners start offline, must manually go online
    },
    verificationStatus: {
        type: String,
        enum: ['pending', 'verified', 'rejected'],
        default: function () {
            return this.role === 'partner' ? 'pending' : null;
        }
    },
    documents: [{
        type: {
            type: String,
            enum: ['id_proof', 'address_proof', 'certificate', 'other'],
            required: true
        },
        fileName: String,
        url: String,
        uploadedAt: {
            type: Date,
            default: Date.now
        },
        status: {
            type: String,
            enum: ['pending', 'verified', 'rejected'],
            default: 'pending'
        },
        rejectionReason: String
    }],
    adminNotes: {
        type: String,
    },
    verifiedAt: {
        type: Date,
    },
    verifiedBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    },
    createdAt: {
        type: Date,
        default: Date.now,
    }
});

module.exports = mongoose.model('User', userSchema);
