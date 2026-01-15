const { query } = require('../config/database');

class Notification {
    // Get all notifications with filters
    static async findAll(filters = {}) {
        let queryText = `
      SELECT n.*,
             u.username as user_username, u.full_name as user_fullname
      FROM notifications n
      LEFT JOIN users u ON n.user_id = u.user_id
      WHERE 1=1
    `;
        const params = [];
        let paramCount = 1;

        if (filters.user_id) {
            queryText += ` AND n.user_id = $${paramCount++}`;
            params.push(filters.user_id);
        }

        if (filters.notification_type) {
            queryText += ` AND n.notification_type = $${paramCount++}`;
            params.push(filters.notification_type);
        }

        if (filters.is_read !== undefined) {
            queryText += ` AND n.is_read = $${paramCount++}`;
            params.push(filters.is_read);
        }

        queryText += ' ORDER BY n.created_at DESC';

        if (filters.limit) {
            queryText += ` LIMIT $${paramCount++}`;
            params.push(filters.limit);
        }

        const result = await query(queryText, params);
        return result.rows;
    }

    // Get notification by ID
    static async findById(id) {
        const result = await query(
            'SELECT * FROM notifications WHERE notification_id = $1',
            [id]
        );
        return result.rows[0];
    }

    // Create new notification
    static async create(data) {
        const { user_id, title, message, notification_type } = data;

        const result = await query(
            `INSERT INTO notifications (user_id, title, message, notification_type)
       VALUES ($1, $2, $3, $4)
       RETURNING *`,
            [user_id, title, message, notification_type]
        );
        return result.rows[0];
    }

    // Mark as read
    static async markAsRead(id) {
        const result = await query(
            'UPDATE notifications SET is_read = true WHERE notification_id = $1 RETURNING *',
            [id]
        );
        return result.rows[0];
    }

    // Mark all as read for a user
    static async markAllAsRead(userId) {
        const result = await query(
            'UPDATE notifications SET is_read = true WHERE user_id = $1 AND is_read = false RETURNING *',
            [userId]
        );
        return result.rows;
    }

    // Delete notification
    static async delete(id) {
        const result = await query(
            'DELETE FROM notifications WHERE notification_id = $1 RETURNING *',
            [id]
        );
        return result.rows[0];
    }

    // Get unread count for user
    static async getUnreadCount(userId) {
        const result = await query(
            'SELECT COUNT(*) as unread_count FROM notifications WHERE user_id = $1 AND is_read = false',
            [userId]
        );
        return parseInt(result.rows[0].unread_count);
    }

    // Get user notifications
    static async findByUser(userId, limit = 20) {
        const result = await query(
            `SELECT * FROM notifications
       WHERE user_id = $1
       ORDER BY created_at DESC
       LIMIT $2`,
            [userId, limit]
        );
        return result.rows;
    }

    // Create bulk notifications
    static async createBulk(userIds, title, message, notificationType) {
        const values = userIds.map((userId, index) =>
            `($${index * 4 + 1}, $${index * 4 + 2}, $${index * 4 + 3}, $${index * 4 + 4})`
        ).join(', ');

        const params = [];
        userIds.forEach(userId => {
            params.push(userId, title, message, notificationType);
        });

        const queryText = `
      INSERT INTO notifications (user_id, title, message, notification_type)
      VALUES ${values}
      RETURNING *
    `;

        const result = await query(queryText, params);
        return result.rows;
    }
}

module.exports = Notification;
