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

// Update user profile
exports.updateProfile = async (req, res) => {
    try {
        const userId = req.user.id; // From auth middleware
        const { name, email, profileImage } = req.body;

        const updateData = {};
        if (name !== undefined) updateData.name = name;
        if (email !== undefined) updateData.email = email;
        if (profileImage !== undefined) updateData.profileImage = profileImage;

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
