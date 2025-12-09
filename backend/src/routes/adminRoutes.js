const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');
const authMiddleware = require('../middleware/authMiddleware');

// All admin routes require authentication
router.use(authMiddleware);

// Partner verification routes
router.get('/partners/pending', adminController.getPendingPartners);
router.get('/partners/:id', adminController.getPartnerDetails);
router.put('/partners/:id/verify', adminController.verifyPartner);
router.put('/partners/:id/documents/:documentId/verify', adminController.verifyDocument);

module.exports = router;
