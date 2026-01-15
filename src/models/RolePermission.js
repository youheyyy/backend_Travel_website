const { query, getClient } = require('../config/database');

class RolePermission {
    // Assign a single permission to a role
    static async assignPermission(roleId, permissionId) {
        const result = await query(
            'INSERT INTO role_permissions (role_id, permission_id) VALUES ($1, $2) ON CONFLICT DO NOTHING RETURNING *',
            [roleId, permissionId]
        );
        return result.rows[0];
    }

    // Remove permission from role
    static async removePermission(roleId, permissionId) {
        const result = await query(
            'DELETE FROM role_permissions WHERE role_id = $1 AND permission_id = $2 RETURNING *',
            [roleId, permissionId]
        );
        return result.rows[0];
    }

    // Get all permissions for a role
    static async getRolePermissions(roleId) {
        const result = await query(
            `SELECT p.* FROM permissions p
       INNER JOIN role_permissions rp ON p.permission_id = rp.permission_id
       WHERE rp.role_id = $1
       ORDER BY p.module, p.permission_name`,
            [roleId]
        );
        return result.rows;
    }

    // Bulk assign permissions to a role (replaces existing permissions)
    static async bulkAssign(roleId, permissionIds) {
        const client = await getClient();

        try {
            await client.query('BEGIN');

            // Remove all existing permissions for this role
            await client.query('DELETE FROM role_permissions WHERE role_id = $1', [roleId]);

            // Insert new permissions
            if (permissionIds && permissionIds.length > 0) {
                const values = permissionIds.map((permId, index) =>
                    `($1, $${index + 2})`
                ).join(', ');

                const queryText = `INSERT INTO role_permissions (role_id, permission_id) VALUES ${values}`;
                await client.query(queryText, [roleId, ...permissionIds]);
            }

            await client.query('COMMIT');

            // Return updated permissions
            return await this.getRolePermissions(roleId);
        } catch (error) {
            await client.query('ROLLBACK');
            throw error;
        } finally {
            client.release();
        }
    }

    // Check if role has specific permission
    static async hasPermission(roleId, permissionName) {
        const result = await query(
            `SELECT EXISTS(
        SELECT 1 FROM role_permissions rp
        INNER JOIN permissions p ON rp.permission_id = p.permission_id
        WHERE rp.role_id = $1 AND p.permission_name = $2
      ) as has_permission`,
            [roleId, permissionName]
        );
        return result.rows[0].has_permission;
    }

    // Get all roles that have a specific permission
    static async getRolesWithPermission(permissionId) {
        const result = await query(
            `SELECT r.* FROM roles r
       INNER JOIN role_permissions rp ON r.role_id = rp.role_id
       WHERE rp.permission_id = $1
       ORDER BY r.role_name`,
            [permissionId]
        );
        return result.rows;
    }
}

module.exports = RolePermission;
