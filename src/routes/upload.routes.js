const express = require('express');
const router = express.Router();
const UploadController = require('../controllers/upload.controller');
const { authenticate } = require('../middlewares/auth.middleware');

// @route   POST /api/upload/avatar
// @desc    Upload user avatar
// @access  Private
router.post(
    '/avatar',
    authenticate,
    UploadController.uploadAvatar,
    UploadController.handleAvatarUpload
);

module.exports = router;
