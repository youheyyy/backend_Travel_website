const { query } = require('../config/database');

class Role {
  // Get all roles
  static async findAll() {
    const result = await query('SELECT * FROM roles ORDER BY role_id');
    return result.rows;
  }

  // Get role by ID
  static async findById(id) {
    const result = await query('SELECT * FROM roles WHERE role_id = $1', [id]);
    return result.rows[0];
  }

  // Get role by name
  static async findByName(name) {
    const result = await query('SELECT * FROM roles WHERE role_name = $1', [name]);
    return result.rows[0];
  }

  // Create new role
  static async create(data) {
    const { role_name, role_description } = data;
    const result = await query(
      'INSERT INTO roles (role_name, role_description) VALUES ($1, $2) RETURNING *',
      [role_name, role_description]
    );
    return result.rows[0];
  }

  // Update role
  static async update(id, data) {
    const { role_name, role_description } = data;
    const result = await query(
      'UPDATE roles SET role_name = $1, role_description = $2 WHERE role_id = $3 RETURNING *',
      [role_name, role_description, id]
    );
    return result.rows[0];
  }

  // Delete role
  static async delete(id) {
    const result = await query('DELETE FROM roles WHERE role_id = $1 RETURNING *', [id]);
    return result.rows[0];
  }

  // Get all permissions for a role
  static async getPermissions(roleId) {
    const result = await query(
      `SELECT p.* FROM permissions p
       INNER JOIN role_permissions rp ON p.permission_id = rp.permission_id
       WHERE rp.role_id = $1
       ORDER BY p.module, p.permission_name`,
      [roleId]
    );
    return result.rows;
  }

  // Get role with permissions
  static async findByIdWithPermissions(id) {
    const role = await this.findById(id);
    if (role) {
      role.permissions = await this.getPermissions(id);
    }
    return role;
  }
}

module.exports = Role;
