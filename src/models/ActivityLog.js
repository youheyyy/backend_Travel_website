const { query } = require('../config/database');

class ActivityLog {
    // Create activity log
    static async create(data) {
        const { user_id, action, module, record_id, ip_address, user_agent } = data;

        const result = await query(
            `INSERT INTO activity_logs (user_id, action, module, record_id, ip_address, user_agent)
       VALUES ($1, $2, $3, $4, $5, $6)
       RETURNING *`,
            [user_id, action, module, record_id, ip_address, user_agent]
        );
        return result.rows[0];
    }

    // Get all logs with filters
    static async findAll(filters = {}) {
        let queryText = `
      SELECT al.*,
             u.username as user_username, u.full_name as user_fullname
      FROM activity_logs al
      LEFT JOIN users u ON al.user_id = u.user_id
      WHERE 1=1
    `;
        const params = [];
        let paramCount = 1;

        if (filters.user_id) {
            queryText += ` AND al.user_id = $${paramCount++}`;
            params.push(filters.user_id);
        }

        if (filters.module) {
            queryText += ` AND al.module = $${paramCount++}`;
            params.push(filters.module);
        }

        if (filters.action) {
            queryText += ` AND al.action = $${paramCount++}`;
            params.push(filters.action);
        }

        if (filters.from_date) {
            queryText += ` AND al.created_at >= $${paramCount++}`;
            params.push(filters.from_date);
        }

        if (filters.to_date) {
            queryText += ` AND al.created_at <= $${paramCount++}`;
            params.push(filters.to_date);
        }

        queryText += ' ORDER BY al.created_at DESC';

        if (filters.limit) {
            queryText += ` LIMIT $${paramCount++}`;
            params.push(filters.limit);
        }

        const result = await query(queryText, params);
        return result.rows;
    }

    // Get logs by user
    static async findByUser(userId, limit = 50) {
        const result = await query(
            `SELECT * FROM activity_logs
       WHERE user_id = $1
       ORDER BY created_at DESC
       LIMIT $2`,
            [userId, limit]
        );
        return result.rows;
    }

    // Get logs by module
    static async findByModule(module, limit = 100) {
        const result = await query(
            `SELECT al.*,
              u.username as user_username
       FROM activity_logs al
       LEFT JOIN users u ON al.user_id = u.user_id
       WHERE al.module = $1
       ORDER BY al.created_at DESC
       LIMIT $2`,
            [module, limit]
        );
        return result.rows;
    }
}

module.exports = ActivityLog;
