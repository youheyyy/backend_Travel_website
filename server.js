require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const path = require('path');
const fs = require('fs');
const { pool } = require('./src/config/database');
const routes = require('./src/routes');
const { errorHandler, notFound } = require('./src/middlewares/error.middleware');
const { logRequest } = require('./src/utils/logger');

const app = express();
const PORT = process.env.PORT || 5000;

// Create necessary directories
const directories = ['uploads/tours', 'uploads/avatars', 'uploads/blog', 'uploads/destinations', 'logs'];
directories.forEach(dir => {
    if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
    }
});

// Middleware
app.use(helmet({
    crossOriginResourcePolicy: { policy: "cross-origin" } // Allow cross-origin requests for static files
})); // Security headers
app.use(cors()); // Enable CORS

// Logging middleware
if (process.env.NODE_ENV === 'development') {
    app.use(morgan('dev')); // Detailed logging in development
} else {
    app.use(morgan('combined')); // Standard logging in production
}

// Custom request logger
app.use((req, res, next) => {
    logRequest(req);
    next();
});

app.use(express.json()); // Parse JSON bodies
app.use(express.urlencoded({ extended: true })); // Parse URL-encoded bodies

// Serve static files (uploaded images)
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
app.use('/images', express.static(path.join(__dirname, 'images')));

// API Routes
app.use('/api', routes);

// Root endpoint
app.get('/', (req, res) => {
    res.json({
        success: true,
        message: 'Travel Website API',
        version: '1.0.0',
        documentation: '/api/health',
        endpoints: {
            health: '/api/health',
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
        },
        features: {
            authentication: 'JWT-based',
            authorization: 'RBAC with permissions',
            fileUpload: 'Multer (images)',
            emailService: 'Nodemailer',
            notifications: 'In-app notifications',
            logging: 'Activity & error logging',
            database: 'PostgreSQL'
        }
    });
});

// 404 handler
app.use(notFound);

// Error handler
app.use(errorHandler);

// Start server
const startServer = async () => {
    try {
        // Test database connection
        const result = await pool.query('SELECT NOW() as current_time, version() as db_version');
        console.log('✅ Database connection successful');
        console.log(`📊 PostgreSQL version: ${result.rows[0].db_version.split(' ')[1]}`);
        console.log(`⏰ Database time: ${result.rows[0].current_time}`);

        app.listen(PORT, () => {
            console.log('\n🎉 ========================================');
            console.log('   Travel Website Backend API');
            console.log('========================================');
            console.log(`🚀 Server running on port ${PORT}`);
            console.log(`📍 API URL: http://localhost:${PORT}/api`);
            console.log(`🏥 Health check: http://localhost:${PORT}/api/health`);
            console.log(`📁 Uploads: http://localhost:${PORT}/uploads`);
            console.log(`🌍 Environment: ${process.env.NODE_ENV || 'development'}`);
            console.log('========================================\n');

            console.log('📦 Available modules:');
            console.log('  ✓ Authentication & Authorization (RBAC)');
            console.log('  ✓ Tour Management');
            console.log('  ✓ Booking System');
            console.log('  ✓ Payment Processing');
            console.log('  ✓ Review System');
            console.log('  ✓ Blog Management');
            console.log('  ✓ Promotion System');
            console.log('  ✓ Notification System');
            console.log('  ✓ File Upload (Images)');
            console.log('  ✓ Email Service');
            console.log('  ✓ Activity Logging\n');
        });
    } catch (error) {
        console.error('❌ Failed to start server:', error);
        console.error('💡 Please check:');
        console.error('  - PostgreSQL is running');
        console.error('  - Database credentials in .env are correct');
        console.error('  - Database exists and schema is imported');
        process.exit(1);
    }
};

// Handle unhandled promise rejections
process.on('unhandledRejection', (err) => {
    console.error('❌ Unhandled Promise Rejection:', err);
    console.error('Stack:', err.stack);
    process.exit(1);
});

// Handle uncaught exceptions
process.on('uncaughtException', (err) => {
    console.error('❌ Uncaught Exception:', err);
    console.error('Stack:', err.stack);
    process.exit(1);
});

// Graceful shutdown
const gracefulShutdown = async (signal) => {
    console.log(`\n${signal} received, closing server gracefully...`);

    try {
        await pool.end();
        console.log('✅ Database connection closed');
        console.log('👋 Server shutdown complete');
        process.exit(0);
    } catch (error) {
        console.error('❌ Error during shutdown:', error);
        process.exit(1);
    }
};

process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));

startServer();

