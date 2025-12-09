const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const authMiddleware = require('../middleware/authMiddleware');
const upload = require('../middleware/upload');

// GET /api/v1/users
router.get('/', userController.getUsers);

// GET /api/v1/users/profile (Authenticated) - Get current user profile
router.get('/profile', authMiddleware, userController.getProfile);

// PUT /api/v1/users/profile (Authenticated)
router.put('/profile', authMiddleware, userController.updateProfile);

// POST /api/v1/users/documents/upload (Authenticated)
router.post('/documents/upload', authMiddleware, upload.single('document'), userController.uploadDocument);

// PUT /api/v1/users/availability (Authenticated)
router.put('/availability', authMiddleware, userController.updateAvailability);

// POST /api/v1/users/address (Authenticated)
router.post('/address', authMiddleware, userController.addAddress);

module.exports = router;
