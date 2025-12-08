const express = require('express');
const router = express.Router();
const dashboardController = require('../controllers/dashboardController');

// GET /api/v1/dashboard/stats
router.get('/stats', dashboardController.getStats);

// GET /api/v1/dashboard/bookings
router.get('/bookings', dashboardController.getBookings);

// POST /api/v1/dashboard/mock-booking (dev only)
router.post('/mock-booking', dashboardController.createMockBooking);

module.exports = router;
