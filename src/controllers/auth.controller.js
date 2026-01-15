const User = require('../models/User');
const jwt = require('jsonwebtoken');

class AuthController {
    // Register new user
    static async register(req, res, next) {
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

            // Create user (default role_id = 7 for Customer if not provided)
            const user = await User.create({
                username,
                email,
                password,
                full_name,
                phone,
                role_id: role_id || 7
            });

            // Generate JWT token
            const token = jwt.sign(
                { userId: user.user_id, email: user.email },
                process.env.JWT_SECRET || 'your-secret-key',
                { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
            );

            res.status(201).json({
                success: true,
                message: 'User registered successfully',
                data: {
                    user: {
                        user_id: user.user_id,
                        username: user.username,
                        email: user.email,
                        full_name: user.full_name,
                        phone: user.phone,
                        role_id: user.role_id
                    },
                    token
                }
            });
        } catch (error) {
            next(error);
        }
    }

    // Login
    static async login(req, res, next) {
        try {
            const { email, password } = req.body;

            // Find user by email
            const user = await User.findByEmail(email);
            if (!user) {
                return res.status(401).json({
                    success: false,
                    message: 'Invalid email or password'
                });
            }

            // Verify password
            const isValidPassword = await User.verifyPassword(password, user.password_hash);
            if (!isValidPassword) {
                return res.status(401).json({
                    success: false,
                    message: 'Invalid email or password'
                });
            }

            // Check if user is active
            if (user.status !== 'active') {
                return res.status(403).json({
                    success: false,
                    message: 'Your account is not active. Please contact administrator.'
                });
            }

            // Update last login
            await User.updateLastLogin(user.user_id);

            // Get user permissions
            const permissions = await User.getUserPermissions(user.user_id);

            // Generate JWT token
            const token = jwt.sign(
                { userId: user.user_id, email: user.email, role: user.role_name },
                process.env.JWT_SECRET || 'your-secret-key',
                { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
            );

            // Remove password from response
            delete user.password_hash;

            res.json({
                success: true,
                message: 'Login successful',
                data: {
                    user,
                    permissions: permissions.map(p => p.permission_name),
                    token
                }
            });
        } catch (error) {
            next(error);
        }
    }

    // Get current user profile
    static async getProfile(req, res, next) {
        try {
            const user = await User.findById(req.user.user_id);
            const permissions = await User.getUserPermissions(req.user.user_id);

            res.json({
                success: true,
                data: {
                    user,
                    permissions: permissions.map(p => p.permission_name)
                }
            });
        } catch (error) {
            next(error);
        }
    }

    // Update profile
    static async updateProfile(req, res, next) {
        try {
            const { full_name, phone, avatar_url } = req.body;

            const updatedUser = await User.update(req.user.user_id, {
                full_name,
                phone,
                avatar_url
            });

            res.json({
                success: true,
                message: 'Profile updated successfully',
                data: updatedUser
            });
        } catch (error) {
            next(error);
        }
    }

    // Change password
    static async changePassword(req, res, next) {
        try {
            const { current_password, new_password } = req.body;

            // Get user with password
            const user = await User.findByEmail(req.user.email);

            // Verify current password
            const isValidPassword = await User.verifyPassword(current_password, user.password_hash);
            if (!isValidPassword) {
                return res.status(401).json({
                    success: false,
                    message: 'Current password is incorrect'
                });
            }

            // Update password
            await User.updatePassword(req.user.user_id, new_password);

            res.json({
                success: true,
                message: 'Password changed successfully'
            });
        } catch (error) {
            next(error);
        }
    }
}

module.exports = AuthController;
