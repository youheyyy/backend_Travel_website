const ActivityLog = require('../models/ActivityLog');

/**
 * Log user activity
 */
const logActivity = async (userId, action, module, recordId = null, req = null) => {
    try {
        const ipAddress = req ? (req.ip || req.connection.remoteAddress) : null;
        const userAgent = req ? req.get('user-agent') : null;

        await ActivityLog.create({
            user_id: userId,
            action,
            module,
            record_id: recordId,
            ip_address: ipAddress,
            user_agent: userAgent
        });
    } catch (error) {
        console.error('Activity log error:', error);
    }
};

/**
 * Log authentication activities
 */
const logAuth = {
    login: (userId, req) => logActivity(userId, 'login', 'auth', null, req),
    logout: (userId, req) => logActivity(userId, 'logout', 'auth', null, req),
    register: (userId, req) => logActivity(userId, 'register', 'auth', null, req),
    passwordChange: (userId, req) => logActivity(userId, 'password_change', 'auth', null, req)
};

/**
 * Log tour activities
 */
const logTour = {
    create: (userId, tourId, req) => logActivity(userId, 'create', 'tour', tourId, req),
    update: (userId, tourId, req) => logActivity(userId, 'update', 'tour', tourId, req),
    delete: (userId, tourId, req) => logActivity(userId, 'delete', 'tour', tourId, req),
    view: (userId, tourId, req) => logActivity(userId, 'view', 'tour', tourId, req)
};

/**
 * Log booking activities
 */
const logBooking = {
    create: (userId, bookingId, req) => logActivity(userId, 'create', 'booking', bookingId, req),
    confirm: (userId, bookingId, req) => logActivity(userId, 'confirm', 'booking', bookingId, req),
    cancel: (userId, bookingId, req) => logActivity(userId, 'cancel', 'booking', bookingId, req),
    update: (userId, bookingId, req) => logActivity(userId, 'update', 'booking', bookingId, req)
};

/**
 * Log payment activities
 */
const logPayment = {
    create: (userId, paymentId, req) => logActivity(userId, 'create', 'payment', paymentId, req),
    process: (userId, paymentId, req) => logActivity(userId, 'process', 'payment', paymentId, req),
    complete: (userId, paymentId, req) => logActivity(userId, 'complete', 'payment', paymentId, req),
    fail: (userId, paymentId, req) => logActivity(userId, 'fail', 'payment', paymentId, req)
};

/**
 * Log review activities
 */
const logReview = {
    create: (userId, reviewId, req) => logActivity(userId, 'create', 'review', reviewId, req),
    approve: (userId, reviewId, req) => logActivity(userId, 'approve', 'review', reviewId, req),
    reject: (userId, reviewId, req) => logActivity(userId, 'reject', 'review', reviewId, req)
};

module.exports = {
    logActivity,
    logAuth,
    logTour,
    logBooking,
    logPayment,
    logReview
};
