const { query } = require('../config/database');

class Permission {
    // Get all permissions
    static async findAll() {
        const result = await query('SELECT * FROM permissions ORDER BY module, permission_name');
        return result.rows;
    }

    // Get permission by ID
    static async findById(id) {
        const result = await query('SELECT * FROM permissions WHERE permission_id = $1', [id]);
        return result.rows[0];
    }

    // Get permission by name
    static async findByName(name) {
        const result = await query('SELECT * FROM permissions WHERE permission_name = $1', [name]);
        return result.rows[0];
    }

    // Get permissions by module
    static async findByModule(module) {
        const result = await query(
            'SELECT * FROM permissions WHERE module = $1 ORDER BY permission_name',
            [module]
        );
        return result.rows;
    }

    // Get all unique modules
    static async getModules() {
        const result = await query('SELECT DISTINCT module FROM permissions ORDER BY module');
        return result.rows.map(row => row.module);
    }

    // Create new permission
    static async create(data) {
        const { permission_name, permission_description, module } = data;
        const result = await query(
            'INSERT INTO permissions (permission_name, permission_description, module) VALUES ($1, $2, $3) RETURNING *',
            [permission_name, permission_description, module]
        );
        return result.rows[0];
    }

    // Update permission
    static async update(id, data) {
        const { permission_name, permission_description, module } = data;
        const result = await query(
            'UPDATE permissions SET permission_name = $1, permission_description = $2, module = $3 WHERE permission_id = $4 RETURNING *',
            [permission_name, permission_description, module, id]
        );
        return result.rows[0];
    }

    // Delete permission
    static async delete(id) {
        const result = await query('DELETE FROM permissions WHERE permission_id = $1 RETURNING *', [id]);
        return result.rows[0];
    }
}

module.exports = Permission;
