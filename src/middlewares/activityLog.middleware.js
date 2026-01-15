const { logActivity } = require('../services/activityLogger');

/**
 * Middleware to automatically log activities
 */
const activityLogMiddleware = (action, module) => {
    return async (req, res, next) => {
        // Store original send function
        const originalSend = res.send;

        // Override send function
        res.send = function (data) {
            // Only log successful operations (2xx status codes)
            if (res.statusCode >= 200 && res.statusCode < 300) {
                const userId = req.user?.user_id;
                const recordId = req.params?.id || null;

                if (userId) {
                    logActivity(userId, action, module, recordId, req);
                }
            }

            // Call original send
            originalSend.call(this, data);
        };

        next();
    };
};

module.exports = activityLogMiddleware;
