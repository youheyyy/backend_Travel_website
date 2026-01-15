const User = require('../models/User');

class UserController {
    // Get all users
    static async getAllUsers(req, res, next) {
        try {
            const users = await User.findAll();

            // Remove password hashes from response
            const sanitizedUsers = users.map(user => {
                const { password_hash, ...userWithoutPassword } = user;
                return userWithoutPassword;
            });

            res.json({
                success: true,
                data: sanitizedUsers,
                count: sanitizedUsers.length
            });
        } catch (error) {
            next(error);
        }
    }

    // Get user by ID
    static async getUserById(req, res, next) {
        try {
            const { id } = req.params;
            const user = await User.findById(id);

            if (!user) {
                return res.status(404).json({
                    success: false,
                    message: 'User not found'
                });
            }

            // Get user permissions
            const permissions = await User.getUserPermissions(id);

            res.json({
                success: true,
                data: {
                    ...user,
                    permissions
                }
            });
        } catch (error) {
            next(error);
        }
    }

    // Create new user
    static async createUser(req, res, next) {
        try {
            const { username, email, password, full_name, phone, role_id } = req.body;

            // Check if user already exists
            const existingUser = await User.findByEmail(email);
            if (existingUser) {
                return res.status(409).json({
                    success: false,
                    message: 'Email already registered'
                });
            }

            const existingUsername = await User.findByUsername(username);
            if (existingUsername) {
                return res.status(409).json({
                    success: false,
                    message: 'Username already taken'
                });
            }

            const user = await User.create({
                username,
                email,
                password,
                full_name,
                phone,
                role_id
            });

            res.status(201).json({
                success: true,
                message: 'User created successfully',
                data: user
            });
        } catch (error) {
            next(error);
        }
    }

    // Update user
    static async updateUser(req, res, next) {
        try {
            const { id } = req.params;
            const { username, email, full_name, phone, avatar_url, role_id, status, email_verified } = req.body;

            const user = await User.update(id, {
                username,
                email,
                full_name,
                phone,
                avatar_url,
                role_id,
                status,
                email_verified
            });

            if (!user) {
                return res.status(404).json({
                    success: false,
                    message: 'User not found'
                });
            }

            // Remove password from response
            const { password_hash, ...userWithoutPassword } = user;

            res.json({
                success: true,
                message: 'User updated successfully',
                data: userWithoutPassword
            });
        } catch (error) {
            next(error);
        }
    }

    // Delete user
    static async deleteUser(req, res, next) {
        try {
            const { id } = req.params;

            const user = await User.delete(id);

            if (!user) {
                return res.status(404).json({
                    success: false,
                    message: 'User not found'
                });
            }

            res.json({
                success: true,
                message: 'User deleted successfully'
            });
        } catch (error) {
            next(error);
        }
    }

    // Assign role to user
    static async assignRole(req, res, next) {
        try {
            const { id } = req.params;
            const { role_id } = req.body;

            const user = await User.update(id, { role_id });

            if (!user) {
                return res.status(404).json({
                    success: false,
                    message: 'User not found'
                });
            }

            res.json({
                success: true,
                message: 'Role assigned successfully',
                data: user
            });
        } catch (error) {
            next(error);
        }
    }

    // Get user permissions
    static async getUserPermissions(req, res, next) {
        try {
            const { id } = req.params;

            const permissions = await User.getUserPermissions(id);

            res.json({
                success: true,
                data: permissions,
                count: permissions.length
            });
        } catch (error) {
            next(error);
        }
    }

    // Get users by role
    static async getUsersByRole(req, res, next) {
        try {
            const { roleId } = req.params;

            const users = await User.findByRole(roleId);

            // Remove password hashes
            const sanitizedUsers = users.map(user => {
                const { password_hash, ...userWithoutPassword } = user;
                return userWithoutPassword;
            });

            res.json({
                success: true,
                data: sanitizedUsers,
                count: sanitizedUsers.length
            });
        } catch (error) {
            next(error);
        }
    }
}

module.exports = UserController;
