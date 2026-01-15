const User = require('../models/User');

// Check if user has required permission
const requirePermission = (permissionName) => {
    return async (req, res, next) => {
        try {
            // Check if user is authenticated
            if (!req.user) {
                return res.status(401).json({
                    success: false,
                    message: 'Authentication required'
                });
            }

            // Check if user has the required permission
            const hasPermission = await User.hasPermission(req.user.user_id, permissionName);

            if (!hasPermission) {
                return res.status(403).json({
                    success: false,
                    message: `Access denied. Required permission: ${permissionName}`
                });
            }

            next();
        } catch (error) {
            console.error('Permission check error:', error);
            return res.status(500).json({
                success: false,
                message: 'Permission check failed'
            });
        }
    };
};

// Check if user has any of the required permissions
const requireAnyPermission = (permissionNames) => {
    return async (req, res, next) => {
        try {
            if (!req.user) {
                return res.status(401).json({
                    success: false,
                    message: 'Authentication required'
                });
            }

            // Check each permission
            for (const permissionName of permissionNames) {
                const hasPermission = await User.hasPermission(req.user.user_id, permissionName);
                if (hasPermission) {
                    return next();
                }
            }

            return res.status(403).json({
                success: false,
                message: `Access denied. Required one of: ${permissionNames.join(', ')}`
            });
        } catch (error) {
            console.error('Permission check error:', error);
            return res.status(500).json({
                success: false,
                message: 'Permission check failed'
            });
        }
    };
};

// Check if user has all required permissions
const requireAllPermissions = (permissionNames) => {
    return async (req, res, next) => {
        try {
            if (!req.user) {
                return res.status(401).json({
                    success: false,
                    message: 'Authentication required'
                });
            }

            // Check all permissions
            for (const permissionName of permissionNames) {
                const hasPermission = await User.hasPermission(req.user.user_id, permissionName);
                if (!hasPermission) {
                    return res.status(403).json({
                        success: false,
                        message: `Access denied. Missing permission: ${permissionName}`
                    });
                }
            }

            next();
        } catch (error) {
            console.error('Permission check error:', error);
            return res.status(500).json({
                success: false,
                message: 'Permission check failed'
            });
        }
    };
};

// Check if user has specific role
const requireRole = (roleName) => {
    return (req, res, next) => {
        if (!req.user) {
            return res.status(401).json({
                success: false,
                message: 'Authentication required'
            });
        }

        if (req.user.role_name !== roleName) {
            return res.status(403).json({
                success: false,
                message: `Access denied. Required role: ${roleName}`
            });
        }

        next();
    };
};

// Check if user has any of the specified roles
const requireAnyRole = (roleNames) => {
    return (req, res, next) => {
        if (!req.user) {
            return res.status(401).json({
                success: false,
                message: 'Authentication required'
            });
        }

        if (!roleNames.includes(req.user.role_name)) {
            return res.status(403).json({
                success: false,
                message: `Access denied. Required one of roles: ${roleNames.join(', ')}`
            });
        }

        next();
    };
};

module.exports = {
    requirePermission,
    requireAnyPermission,
    requireAllPermissions,
    requireRole,
    requireAnyRole
};
