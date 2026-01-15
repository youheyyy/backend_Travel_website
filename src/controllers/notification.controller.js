const Notification = require('../models/Notification');

class NotificationController {
    static async getAll(req, res, next) {
        try {
            const filters = {
                user_id: req.query.user_id,
                notification_type: req.query.notification_type,
                is_read: req.query.is_read,
                limit: req.query.limit
            };
            const notifications = await Notification.findAll(filters);
            res.json({ success: true, data: notifications, count: notifications.length });
        } catch (error) {
            next(error);
        }
    }

    static async getMyNotifications(req, res, next) {
        try {
            const notifications = await Notification.findByUser(req.user.user_id, req.query.limit || 20);
            res.json({ success: true, data: notifications, count: notifications.length });
        } catch (error) {
            next(error);
        }
    }

    static async getUnreadCount(req, res, next) {
        try {
            const count = await Notification.getUnreadCount(req.user.user_id);
            res.json({ success: true, data: { unread_count: count } });
        } catch (error) {
            next(error);
        }
    }

    static async create(req, res, next) {
        try {
            const notification = await Notification.create(req.body);
            res.status(201).json({ success: true, message: 'Notification created successfully', data: notification });
        } catch (error) {
            next(error);
        }
    }

    static async markAsRead(req, res, next) {
        try {
            const notification = await Notification.markAsRead(req.params.id);
            if (!notification) return res.status(404).json({ success: false, message: 'Notification not found' });
            res.json({ success: true, message: 'Notification marked as read', data: notification });
        } catch (error) {
            next(error);
        }
    }

    static async markAllAsRead(req, res, next) {
        try {
            const notifications = await Notification.markAllAsRead(req.user.user_id);
            res.json({ success: true, message: 'All notifications marked as read', count: notifications.length });
        } catch (error) {
            next(error);
        }
    }

    static async delete(req, res, next) {
        try {
            const notification = await Notification.delete(req.params.id);
            if (!notification) return res.status(404).json({ success: false, message: 'Notification not found' });
            res.json({ success: true, message: 'Notification deleted successfully' });
        } catch (error) {
            next(error);
        }
    }
}

module.exports = NotificationController;
