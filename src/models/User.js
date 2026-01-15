const { query } = require('../config/database');
const bcrypt = require('bcryptjs');

class User {
    // Get all users
    static async findAll() {
        const result = await query(
            `SELECT u.user_id, u.username, u.email, u.full_name, u.phone, u.avatar_url, 
              u.status, u.email_verified, u.created_at, u.updated_at, u.last_login,
              u.role_id, r.role_name, r.role_description
       FROM users u
       LEFT JOIN roles r ON u.role_id = r.role_id
       ORDER BY u.user_id`
        );
        return result.rows;
    }

    // Get user by ID
    static async findById(id) {
        const result = await query(
            `SELECT u.user_id, u.username, u.email, u.full_name, u.phone, u.avatar_url, 
              u.status, u.email_verified, u.created_at, u.updated_at, u.last_login,
              u.role_id, r.role_name, r.role_description
       FROM users u
       LEFT JOIN roles r ON u.role_id = r.role_id
       WHERE u.user_id = $1`,
            [id]
        );
        return result.rows[0];
    }

    // Get user by email (for login)
    static async findByEmail(email) {
        const result = await query(
            `SELECT u.*, r.role_name, r.role_description
       FROM users u
       LEFT JOIN roles r ON u.role_id = r.role_id
       WHERE u.email = $1`,
            [email]
        );
        return result.rows[0];
    }

    // Get user by username
    static async findByUsername(username) {
        const result = await query(
            `SELECT u.*, r.role_name, r.role_description
       FROM users u
       LEFT JOIN roles r ON u.role_id = r.role_id
       WHERE u.username = $1`,
            [username]
        );
        return result.rows[0];
    }

    // Create new user
    static async create(data) {
        const { username, email, password, full_name, phone, role_id } = data;

        // Hash password
        const password_hash = await bcrypt.hash(password, 10);

        const result = await query(
            `INSERT INTO users (username, email, password_hash, full_name, phone, role_id) 
       VALUES ($1, $2, $3, $4, $5, $6) 
       RETURNING user_id, username, email, full_name, phone, avatar_url, role_id, status, email_verified, created_at`,
            [username, email, password_hash, full_name, phone, role_id]
        );
        return result.rows[0];
    }

    // Update user
    static async update(id, data) {
        const fields = [];
        const values = [];
        let paramCount = 1;

        // Build dynamic update query
        if (data.username !== undefined) {
            fields.push(`username = $${paramCount++}`);
            values.push(data.username);
        }
        if (data.email !== undefined) {
            fields.push(`email = $${paramCount++}`);
            values.push(data.email);
        }
        if (data.full_name !== undefined) {
            fields.push(`full_name = $${paramCount++}`);
            values.push(data.full_name);
        }
        if (data.phone !== undefined) {
            fields.push(`phone = $${paramCount++}`);
            values.push(data.phone);
        }
        if (data.avatar_url !== undefined) {
            fields.push(`avatar_url = $${paramCount++}`);
            values.push(data.avatar_url);
        }
        if (data.role_id !== undefined) {
            fields.push(`role_id = $${paramCount++}`);
            values.push(data.role_id);
        }
        if (data.status !== undefined) {
            fields.push(`status = $${paramCount++}`);
            values.push(data.status);
        }
        if (data.email_verified !== undefined) {
            fields.push(`email_verified = $${paramCount++}`);
            values.push(data.email_verified);
        }

        if (fields.length === 0) {
            throw new Error('No fields to update');
        }

        values.push(id);
        const queryText = `UPDATE users SET ${fields.join(', ')} WHERE user_id = $${paramCount} RETURNING *`;

        const result = await query(queryText, values);
        return result.rows[0];
    }

    // Update password
    static async updatePassword(id, newPassword) {
        const password_hash = await bcrypt.hash(newPassword, 10);
        const result = await query(
            'UPDATE users SET password_hash = $1 WHERE user_id = $2 RETURNING user_id',
            [password_hash, id]
        );
        return result.rows[0];
    }

    // Verify password
    static async verifyPassword(plainPassword, hashedPassword) {
        return await bcrypt.compare(plainPassword, hashedPassword);
    }

    // Delete user
    static async delete(id) {
        const result = await query('DELETE FROM users WHERE user_id = $1 RETURNING *', [id]);
        return result.rows[0];
    }

    // Update last login
    static async updateLastLogin(id) {
        const result = await query(
            'UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE user_id = $1 RETURNING last_login',
            [id]
        );
        return result.rows[0];
    }

    // Get user permissions through role
    static async getUserPermissions(userId) {
        const result = await query(
            `SELECT DISTINCT p.permission_id, p.permission_name, p.permission_description, p.module
       FROM users u
       INNER JOIN roles r ON u.role_id = r.role_id
       INNER JOIN role_permissions rp ON r.role_id = rp.role_id
       INNER JOIN permissions p ON rp.permission_id = p.permission_id
       WHERE u.user_id = $1
       ORDER BY p.module, p.permission_name`,
            [userId]
        );
        return result.rows;
    }

    // Check if user has specific permission
    static async hasPermission(userId, permissionName) {
        const result = await query(
            `SELECT EXISTS(
        SELECT 1 FROM users u
        INNER JOIN roles r ON u.role_id = r.role_id
        INNER JOIN role_permissions rp ON r.role_id = rp.role_id
        INNER JOIN permissions p ON rp.permission_id = p.permission_id
        WHERE u.user_id = $1 AND p.permission_name = $2
      ) as has_permission`,
            [userId, permissionName]
        );
        return result.rows[0].has_permission;
    }

    // Get users by role
    static async findByRole(roleId) {
        const result = await query(
            `SELECT u.user_id, u.username, u.email, u.full_name, u.phone, u.avatar_url, 
              u.status, u.email_verified, u.created_at, u.updated_at, u.last_login,
              u.role_id, r.role_name, r.role_description
       FROM users u
       LEFT JOIN roles r ON u.role_id = r.role_id
       WHERE u.role_id = $1
       ORDER BY u.user_id`,
            [roleId]
        );
        return result.rows;
    }
}

module.exports = User;
