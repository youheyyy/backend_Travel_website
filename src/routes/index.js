const express = require('express');
const router = express.Router();

// Import all routes
const authRoutes = require('./auth.routes');
const roleRoutes = require('./role.routes');
const permissionRoutes = require('./permission.routes');
const userRoutes = require('./user.routes');
const destinationRoutes = require('./destination.routes');
const tourCategoryRoutes = require('./tourCategory.routes');
const tourRoutes = require('./tour.routes');
const scheduleRoutes = require('./schedule.routes');
const bookingRoutes = require('./booking.routes');
const paymentRoutes = require('./payment.routes');
const reviewRoutes = require('./review.routes');
const blogRoutes = require('./blog.routes');
const promotionRoutes = require('./promotion.routes');
const notificationRoutes = require('./notification.routes');
const settingRoutes = require('./setting.routes');
const uploadRoutes = require('./upload.routes');

// Mount routes
router.use('/auth', authRoutes);
router.use('/roles', roleRoutes);
router.use('/permissions', permissionRoutes);
router.use('/users', userRoutes);
router.use('/destinations', destinationRoutes);
router.use('/tour-categories', tourCategoryRoutes);
router.use('/tours', tourRoutes);
router.use('/schedules', scheduleRoutes);
router.use('/bookings', bookingRoutes);
router.use('/payments', paymentRoutes);
router.use('/reviews', reviewRoutes);
router.use('/blog', blogRoutes);
router.use('/promotions', promotionRoutes);
router.use('/notifications', notificationRoutes);
router.use('/settings', settingRoutes);
router.use('/upload', uploadRoutes);

// Health check endpoint
router.get('/health', (req, res) => {
    res.json({
        success: true,
        message: 'Travel Website API is running',
        timestamp: new Date().toISOString(),
        version: '1.0.0',
        endpoints: {
            auth: '/api/auth',
            roles: '/api/roles',
            permissions: '/api/permissions',
            users: '/api/users',
            destinations: '/api/destinations',
            tourCategories: '/api/tour-categories',
            tours: '/api/tours',
            schedules: '/api/schedules',
            bookings: '/api/bookings',
            payments: '/api/payments',
            reviews: '/api/reviews',
            blog: '/api/blog',
            promotions: '/api/promotions',
            notifications: '/api/notifications',
            settings: '/api/settings'
        }
    });
});

module.exports = router;
