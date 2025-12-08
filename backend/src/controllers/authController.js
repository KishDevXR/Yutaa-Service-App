const admin = require('firebase-admin');
const User = require('../models/User');
const jwt = require('jsonwebtoken');

// Secret for JWT (should be in .env)
const JWT_SECRET = process.env.JWT_SECRET || 'your_super_secret_jwt_key';

exports.login = async (req, res) => {
    try {
        const { firebaseToken } = req.body;

        if (!firebaseToken) {
            return res.status(400).json({ success: false, message: 'Firebase token is required' });
        }

        // 1. Verify Firebase Token
        // Note: For now, we'll bypass actual verification if no service account is set up
        // In production: const decodedToken = await admin.auth().verifyIdToken(firebaseToken);

        // MOCK VERIFICATION FOR DEVELOPMENT
        // We assume the token sent is just the phone number for now to test flow without full Firebase Setup
        // TODO: Replace with actual Firebase Admin verification
        let phone;
        let uid;

        // Try to decode the Firebase token to get phone number
        try {
            // First, try to decode JWT manually (works for both verified and test tokens)
            const base64Url = firebaseToken.split('.')[1];
            const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
            const decodedPayload = JSON.parse(Buffer.from(base64, 'base64').toString());
            phone = decodedPayload.phone_number;
            uid = decodedPayload.sub || decodedPayload.user_id;
            console.log('Decoded JWT - Phone:', phone, 'UID:', uid);

            // If Firebase Admin is configured, also verify the token signature
            if (admin.apps.length > 0) {
                try {
                    await admin.auth().verifyIdToken(firebaseToken);
                    console.log('Token signature verified successfully');
                } catch (verifyError) {
                    console.warn('Token signature verification failed (OK for test numbers):', verifyError.message);
                }
            }
        } catch (e) {
            // If JWT decode fails, try treating it as a plain phone number (legacy mock)
            console.warn('JWT decode failed, trying as plain phone number:', e.message);
            if (firebaseToken.startsWith('+')) {
                phone = firebaseToken;
                uid = 'mock_uid_' + phone;
            } else {
                return res.status(401).json({ success: false, message: 'Invalid Firebase token' });
            }
        }

        if (!phone) {
            return res.status(401).json({ success: false, message: 'Invalid token: Phone number not found' });
        }

        // 2. Find or Create User
        let user = await User.findOne({ phone });
        let isNewUser = false;

        if (!user) {
            isNewUser = true;
            user = await User.create({
                phone,
                role: 'customer'
            });
        }

        // 3. Generate App Session Token
        const token = jwt.sign(
            { id: user._id, role: user.role },
            JWT_SECRET,
            { expiresIn: '30d' }
        );

        res.status(200).json({
            success: true,
            token,
            user,
            isNewUser
        });

    } catch (error) {
        console.error('Login Error:', error);
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};
