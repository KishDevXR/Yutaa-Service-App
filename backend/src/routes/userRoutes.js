const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const authMiddleware = require('../middleware/authMiddleware');

// GET /api/v1/users
router.get('/', userController.getUsers);

// PUT /api/v1/users/profile (Authenticated)
router.put('/profile', authMiddleware, userController.updateProfile);

module.exports = router;
