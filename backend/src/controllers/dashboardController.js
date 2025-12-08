const Booking = require('../models/Booking');
const User = require('../models/User');

exports.getStats = async (req, res) => {
    try {
        // Calculate real total revenue from completed bookings
        const revenueResult = await Booking.aggregate([
            { $match: { status: 'Completed' } },
            { $group: { _id: null, total: { $sum: '$amount' } } }
        ]);
        const totalRevenue = revenueResult.length > 0 ? revenueResult[0].total : 0;

        const activePartners = await User.countDocuments({ role: 'partner', isActive: true });
        const pendingBookings = await Booking.countDocuments({ status: 'Pending' });

        const today = new Date();
        today.setHours(0, 0, 0, 0);
        const completedToday = await Booking.countDocuments({
            status: 'Completed',
            updatedAt: { $gte: today }
        });

        // Get real recent activity from database
        const recentBookings = await Booking.find()
            .populate('customer', 'name')
            .populate('provider', 'name')
            .sort({ createdAt: -1 })
            .limit(5);

        const recentUsers = await User.find({ role: 'partner' })
            .sort({ createdAt: -1 })
            .limit(3);

        const recentCustomers = await User.find({ role: 'customer' })
            .sort({ createdAt: -1 })
            .limit(3);

        // Build real activity feed
        const recentActivity = [];

        // Add recent bookings
        for (const booking of recentBookings) {
            const timeDiff = Date.now() - new Date(booking.createdAt).getTime();
            const minutesAgo = Math.floor(timeDiff / 60000);
            const timeText = minutesAgo < 60 ? `${minutesAgo} minutes ago` : `${Math.floor(minutesAgo / 60)} hours ago`;

            if (booking.status === 'Completed') {
                recentActivity.push({
                    type: 'booking_completed',
                    text: `${booking.customer?.name || 'Customer'} completed a ${booking.serviceName || 'service'}`,
                    time: timeText,
                    icon: 'check',
                    timestamp: new Date(booking.createdAt).getTime()
                });
            } else if (booking.status === 'Pending') {
                recentActivity.push({
                    type: 'booking_pending',
                    text: `${booking.customer?.name || 'Customer'} requested a ${booking.serviceName || 'service'}`,
                    time: timeText,
                    icon: 'clock',
                    timestamp: new Date(booking.createdAt).getTime()
                });
            }
        }

        // Add recent partners
        for (const partner of recentUsers.slice(0, 2)) {
            const timeDiff = Date.now() - new Date(partner.createdAt).getTime();
            const minutesAgo = Math.floor(timeDiff / 60000);
            const timeText = minutesAgo < 60 ? `${minutesAgo} minutes ago` : `${Math.floor(minutesAgo / 60)} hours ago`;

            recentActivity.push({
                type: 'new_partner',
                text: `${partner.name || 'New partner'} joined as a service provider`,
                time: timeText,
                icon: 'user_add',
                timestamp: new Date(partner.createdAt).getTime()
            });
        }

        // Add recent customer registrations
        for (const customer of recentCustomers.slice(0, 2)) {
            const timeDiff = Date.now() - new Date(customer.createdAt).getTime();
            const minutesAgo = Math.floor(timeDiff / 60000);
            const timeText = minutesAgo < 60 ? `${minutesAgo} minutes ago` : `${Math.floor(minutesAgo / 60)} hours ago`;

            recentActivity.push({
                type: 'new_customer',
                text: `${customer.name || 'New customer'} joined the platform`,
                time: timeText,
                icon: 'user_add',
                timestamp: new Date(customer.createdAt).getTime()
            });
        }

        // Sort by timestamp (most recent first) and limit to 5
        recentActivity.sort((a, b) => b.timestamp - a.timestamp);

        res.status(200).json({
            success: true,
            stats: {
                totalRevenue,
                activePartners,
                pendingBookings,
                completedToday
            },
            recentActivity: recentActivity.slice(0, 5)
        });

    } catch (error) {
        console.error('Stats Error:', error);
        res.status(500).json({ success: false, message: 'Server Error' });
    }
};

exports.getBookings = async (req, res) => {
    try {
        const { status, date } = req.query;
        const query = {};
        if (status) query.status = status;

        // Populate customer and provider details
        const bookings = await Booking.find(query)
            .populate('customer', 'name email phone avatar')
            .populate('provider', 'name email phone avatar')
            .sort({ createdAt: -1 });

        res.status(200).json({
            success: true,
            count: bookings.length,
            bookings
        });
    } catch (error) {
        console.error('Get Bookings Error:', error);
        res.status(500).json({ success: false, message: 'Server Error' });
    }
};

// Create a mock booking for testing
exports.createMockBooking = async (req, res) => {
    try {
        const { customerId, serviceName, amount } = req.body;
        const booking = await Booking.create({
            customer: customerId,
            serviceName: serviceName || 'General Service',
            amount: amount || 500,
            date: new Date(),
            time: '10:00 AM',
            status: 'Pending'
        });
        res.status(201).json({ success: true, booking });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
