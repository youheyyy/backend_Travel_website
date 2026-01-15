const { upload } = require('../utils/fileUpload');

/**
 * Middleware for single image upload
 */
const uploadSingle = (fieldName, uploadType = 'tours') => {
    return (req, res, next) => {
        req.uploadType = uploadType;

        const uploadMiddleware = upload.single(fieldName);

        uploadMiddleware(req, res, (err) => {
            if (err) {
                return res.status(400).json({
                    success: false,
                    message: err.message
                });
            }

            // Add file URL to request
            if (req.file) {
                req.fileUrl = req.file.path.replace(/\\/g, '/');
            }

            next();
        });
    };
};

/**
 * Middleware for multiple image upload
 */
const uploadMultiple = (fieldName, maxCount = 10, uploadType = 'tours') => {
    return (req, res, next) => {
        req.uploadType = uploadType;

        const uploadMiddleware = upload.array(fieldName, maxCount);

        uploadMiddleware(req, res, (err) => {
            if (err) {
                return res.status(400).json({
                    success: false,
                    message: err.message
                });
            }

            // Add file URLs to request
            if (req.files && req.files.length > 0) {
                req.fileUrls = req.files.map(file => file.path.replace(/\\/g, '/'));
            }

            next();
        });
    };
};

module.exports = {
    uploadSingle,
    uploadMultiple
};
