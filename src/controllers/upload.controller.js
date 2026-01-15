const multer = require('multer');
const path = require('path');
const fs = require('fs');

// Ensure uploads directory exists
const uploadsDir = path.join(__dirname, '../../uploads/avatars');
if (!fs.existsSync(uploadsDir)) {
    fs.mkdirSync(uploadsDir, { recursive: true });
}

// Configure multer storage
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, uploadsDir);
    },
    filename: function (req, file, cb) {
        // Generate unique filename: userId_timestamp.ext
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        const ext = path.extname(file.originalname);
        cb(null, `avatar-${req.user.user_id}-${uniqueSuffix}${ext}`);
    }
});

// File filter to accept only images
const fileFilter = (req, file, cb) => {
    const allowedTypes = /jpeg|jpg|png|gif|webp/;
    const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
    const mimetype = allowedTypes.test(file.mimetype);

    if (mimetype && extname) {
        return cb(null, true);
    } else {
        cb(new Error('Only image files are allowed (jpeg, jpg, png, gif, webp)'));
    }
};

// Configure multer upload
const upload = multer({
    storage: storage,
    limits: {
        fileSize: 5 * 1024 * 1024 // 5MB max file size
    },
    fileFilter: fileFilter
});

class UploadController {
    // Upload avatar
    static uploadAvatar = upload.single('avatar');

    static async handleAvatarUpload(req, res, next) {
        try {
            if (!req.file) {
                return res.status(400).json({
                    success: false,
                    message: 'No file uploaded'
                });
            }

            // Generate URL for the uploaded file
            const avatarUrl = `/uploads/avatars/${req.file.filename}`;

            // Update user's avatar_url in database
            const User = require('../models/User');
            await User.update(req.user.user_id, {
                avatar_url: avatarUrl
            });

            res.json({
                success: true,
                message: 'Avatar uploaded successfully',
                data: {
                    avatar_url: avatarUrl,
                    filename: req.file.filename,
                    size: req.file.size
                }
            });
        } catch (error) {
            // Delete uploaded file if database update fails
            if (req.file) {
                fs.unlinkSync(req.file.path);
            }
            next(error);
        }
    }

    // Delete old avatar file
    static deleteOldAvatar(avatarUrl) {
        if (!avatarUrl || !avatarUrl.startsWith('/uploads/avatars/')) {
            return;
        }

        const filePath = path.join(__dirname, '../../', avatarUrl);
        if (fs.existsSync(filePath)) {
            fs.unlinkSync(filePath);
        }
    }
}

module.exports = UploadController;
