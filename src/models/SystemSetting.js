const { query } = require('../config/database');

class SystemSetting {
    // Get all settings
    static async findAll() {
        const result = await query(
            `SELECT ss.*,
              u.username as updated_by_username
       FROM system_settings ss
       LEFT JOIN users u ON ss.updated_by = u.user_id
       ORDER BY ss.setting_key`
        );
        return result.rows;
    }

    // Get setting by ID
    static async findById(id) {
        const result = await query(
            'SELECT * FROM system_settings WHERE setting_id = $1',
            [id]
        );
        return result.rows[0];
    }

    // Get setting by key
    static async findByKey(key) {
        const result = await query(
            'SELECT * FROM system_settings WHERE setting_key = $1',
            [key]
        );
        return result.rows[0];
    }

    // Create new setting
    static async create(data) {
        const { setting_key, setting_value, description, updated_by } = data;

        const result = await query(
            `INSERT INTO system_settings (setting_key, setting_value, description, updated_by)
       VALUES ($1, $2, $3, $4)
       RETURNING *`,
            [setting_key, setting_value, description, updated_by]
        );
        return result.rows[0];
    }

    // Update setting
    static async update(id, data) {
        const { setting_value, description, updated_by } = data;

        const result = await query(
            `UPDATE system_settings
       SET setting_value = $1, description = $2, updated_by = $3
       WHERE setting_id = $4
       RETURNING *`,
            [setting_value, description, updated_by, id]
        );
        return result.rows[0];
    }

    // Update setting by key
    static async updateByKey(key, value, updatedBy) {
        const result = await query(
            `UPDATE system_settings
       SET setting_value = $1, updated_by = $2
       WHERE setting_key = $3
       RETURNING *`,
            [value, updatedBy, key]
        );
        return result.rows[0];
    }

    // Delete setting
    static async delete(id) {
        const result = await query(
            'DELETE FROM system_settings WHERE setting_id = $1 RETURNING *',
            [id]
        );
        return result.rows[0];
    }

    // Get settings as key-value object
    static async getAsObject() {
        const result = await query('SELECT setting_key, setting_value FROM system_settings');
        const settings = {};
        result.rows.forEach(row => {
            settings[row.setting_key] = row.setting_value;
        });
        return settings;
    }
}

module.exports = SystemSetting;
