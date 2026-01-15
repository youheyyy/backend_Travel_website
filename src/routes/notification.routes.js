const express = require('express');
const router = express.Router();
const NotificationController = require('../controllers/notification.controller');
const { authenticate } = require('../middlewares/auth.middleware');

router.get('/my', authenticate, NotificationController.getMyNotifications);
router.get('/unread-count', authenticate, NotificationController.getUnreadCount);
router.post('/:id/read', authenticate, NotificationController.markAsRead);
router.post('/read-all', authenticate, NotificationController.markAllAsRead);
router.delete('/:id', authenticate, NotificationController.delete);

module.exports = router;
