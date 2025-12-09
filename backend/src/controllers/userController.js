const User = require('../models/User');

exports.getUsers = async (req, res) => {
    try {
        const { role } = req.query;

        const filter = {};
        if (role) filter.role = role;

        const users = await User.aggregate([
            { $match: filter },
            {
                $lookup: {
                    from: 'bookings',
                    localField: '_id',
                    foreignField: 'customerId',
                    as: 'bookings'
                }
            },
            {
                $addFields: {
                    bookingsCount: { $size: '$bookings' },
                    totalSpent: { $sum: '$bookings.totalAmount' },
                    lastActive: { $max: '$bookings.createdAt' }
                }
            },
            { $project: { bookings: 0 } }
        ]);

        res.json({ success: true, users });
    } catch (error) {
        console.error('Get Users Error:', error);
        res.status(500).json({ success: false, message: 'Server Error' });
    }
};

// Get current user profile
exports.getProfile = async (req, res) => {
    try {
        const userId = req.user.id; // From auth middleware

        const user = await User.findById(userId).select('-password');

        if (!user) {
            return res.status(404).json({ success: false, message: 'User not found' });
        }

        res.json({ success: true, user });
    } catch (error) {
        console.error('Get Profile Error:', error);
        res.status(500).json({ success: false, message: 'Server Error' });
    }
};

// Update user profile
exports.updateProfile = async (req, res) => {
    try {
        const userId = req.user.id; // From auth middleware
        const { name, email, phone, profileImage, gender, dob, serviceCategory, experienceYears, bio } = req.body;

        const updateData = {};
        if (name !== undefined) updateData.name = name;
        if (email !== undefined) updateData.email = email;
        if (phone !== undefined) updateData.phone = phone;
        if (profileImage !== undefined) updateData.profileImage = profileImage;
        if (gender !== undefined) updateData.gender = gender;
        if (dob !== undefined) updateData.dob = dob;

        // Partner-specific fields
        if (serviceCategory !== undefined) updateData.serviceCategory = serviceCategory;
        if (experienceYears !== undefined) updateData.experienceYears = experienceYears;
        if (bio !== undefined) updateData.bio = bio;

        const user = await User.findByIdAndUpdate(
            userId,
            updateData,
            { new: true, runValidators: true }
        );

        if (!user) {
            return res.status(404).json({ success: false, message: 'User not found' });
        }

        res.json({ success: true, user });
    } catch (error) {
        console.error('Update Profile Error:', error);
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

// Upload document for partner verification
exports.uploadDocument = async (req, res) => {
    try {
        const userId = req.user.id;
        const { type } = req.body; // document type: id_proof, address_proof, certificate

        if (!req.file) {
            return res.status(400).json({ success: false, message: 'No file uploaded' });
        }

        if (!type || !['id_proof', 'address_proof', 'certificate', 'other'].includes(type)) {
            return res.status(400).json({ success: false, message: 'Invalid document type' });
        }

        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({ success: false, message: 'User not found' });
        }

        // Add document to user's documents array
        const document = {
            type,
            fileName: req.file.filename,
            url: `/uploads/documents/${req.file.filename}`,
            uploadedAt: new Date(),
            status: 'pending'
        };

        user.documents.push(document);
        await user.save();

        res.json({
            success: true,
            message: 'Document uploaded successfully',
            document
        });
    } catch (error) {
        console.error('Upload Document Error:', error);
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

// Update partner availability status
exports.updateAvailability = async (req, res) => {
    try {
        const userId = req.user.id;
        const { isAvailable } = req.body;

        if (typeof isAvailable !== 'boolean') {
            return res.status(400).json({ success: false, message: 'isAvailable must be a boolean' });
        }

        const user = await User.findByIdAndUpdate(
            userId,
            { isAvailable },
            { new: true }
        ).select('-password');

        if (!user) {
            return res.status(404).json({ success: false, message: 'User not found' });
        }

        res.json({
            success: true,
            isAvailable: user.isAvailable,
            message: `Availability updated to ${isAvailable ? 'Online' : 'Offline'}`
        });
    } catch (error) {
        console.error('Update Availability Error:', error);
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

// Add new address
exports.addAddress = async (req, res) => {
    try {
        const userId = req.user.id;
        const { label, fullAddress, city, pincode, lat, lng } = req.body;

        if (!fullAddress || !lat || !lng) {
            return res.status(400).json({ success: false, message: 'Address and coordinates are required' });
        }

        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({ success: false, message: 'User not found' });
        }

        const newAddress = {
            label: label || 'Home',
            fullAddress,
            city,
            pincode,
            location: {
                lat,
                lng
            },
            isDefault: user.addresses.length === 0 // Make default if it's the first address
        };

        user.addresses.push(newAddress);
        await user.save();

        res.json({
            success: true,
            message: 'Address added successfully',
            addresses: user.addresses
        });
    } catch (error) {
        console.error('Add Address Error:', error);
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};
