const User = require('../models/User');

exports.getPendingPartners = async (req, res) => {
    try {
        const partners = await User.find({
            role: 'partner',
            verificationStatus: 'pending'
        }).select('name email phone serviceCategory experienceYears documents createdAt');

        res.json({
            success: true,
            partners,
            total: partners.length
        });
    } catch (error) {
        console.error('Get pending partners error:', error);
        res.status(500).json({ success: false, message: 'Server error' });
    }
};

exports.getPartnerDetails = async (req, res) => {
    try {
        const { id } = req.params;
        const partner = await User.findOne({ _id: id, role: 'partner' })
            .populate('verifiedBy', 'name email');

        if (!partner) {
            return res.status(404).json({ success: false, message: 'Partner not found' });
        }

        res.json({
            success: true,
            partner
        });
    } catch (error) {
        console.error('Get partner details error:', error);
        res.status(500).json({ success: false, message: 'Server error' });
    }
};

exports.verifyPartner = async (req, res) => {
    try {
        const { id } = req.params;
        const { status, adminNotes } = req.body; // status: 'verified' or 'rejected'

        if (!['verified', 'rejected'].includes(status)) {
            return res.status(400).json({ success: false, message: 'Invalid status' });
        }

        const partner = await User.findOneAndUpdate(
            { _id: id, role: 'partner' },
            {
                verificationStatus: status,
                adminNotes,
                ...(status === 'verified' && {
                    verifiedAt: new Date(),
                    verifiedBy: req.user.userId // From auth middleware
                })
            },
            { new: true }
        );

        if (!partner) {
            return res.status(404).json({ success: false, message: 'Partner not found' });
        }

        res.json({
            success: true,
            message: `Partner ${status} successfully`,
            partner
        });
    } catch (error) {
        console.error('Verify partner error:', error);
        res.status(500).json({ success: false, message: 'Server error' });
    }
};

exports.verifyDocument = async (req, res) => {
    try {
        const { id, documentId } = req.params;
        const { status, rejectionReason } = req.body; // status: 'verified' or 'rejected'

        if (!['verified', 'rejected'].includes(status)) {
            return res.status(400).json({ success: false, message: 'Invalid status' });
        }

        const partner = await User.findOne({ _id: id, role: 'partner' });

        if (!partner) {
            return res.status(404).json({ success: false, message: 'Partner not found' });
        }

        const document = partner.documents.id(documentId);
        if (!document) {
            return res.status(404).json({ success: false, message: 'Document not found' });
        }

        document.status = status;
        if (status === 'rejected' && rejectionReason) {
            document.rejectionReason = rejectionReason;
        }

        await partner.save();

        res.json({
            success: true,
            message: `Document ${status} successfully`,
            document
        });
    } catch (error) {
        console.error('Verify document error:', error);
        res.status(500).json({ success: false, message: 'Server error' });
    }
};
