const Role = require('../models/Role');
const RolePermission = require('../models/RolePermission');

class RoleController {
    // Get all roles
    static async getAllRoles(req, res, next) {
        try {
            const roles = await Role.findAll();

            res.json({
                success: true,
                data: roles,
                count: roles.length
            });
        } catch (error) {
            next(error);
        }
    }

    // Get role by ID
    static async getRoleById(req, res, next) {
        try {
            const { id } = req.params;
            const role = await Role.findByIdWithPermissions(id);

            if (!role) {
                return res.status(404).json({
                    success: false,
                    message: 'Role not found'
                });
            }

            res.json({
                success: true,
                data: role
            });
        } catch (error) {
            next(error);
        }
    }

    // Create new role
    static async createRole(req, res, next) {
        try {
            const { role_name, role_description } = req.body;

            const role = await Role.create({
                role_name,
                role_description
            });

            res.status(201).json({
                success: true,
                message: 'Role created successfully',
                data: role
            });
        } catch (error) {
            next(error);
        }
    }

    // Update role
    static async updateRole(req, res, next) {
        try {
            const { id } = req.params;
            const { role_name, role_description } = req.body;

            const role = await Role.update(id, {
                role_name,
                role_description
            });

            if (!role) {
                return res.status(404).json({
                    success: false,
                    message: 'Role not found'
                });
            }

            res.json({
                success: true,
                message: 'Role updated successfully',
                data: role
            });
        } catch (error) {
            next(error);
        }
    }

    // Delete role
    static async deleteRole(req, res, next) {
        try {
            const { id } = req.params;

            const role = await Role.delete(id);

            if (!role) {
                return res.status(404).json({
                    success: false,
                    message: 'Role not found'
                });
            }

            res.json({
                success: true,
                message: 'Role deleted successfully'
            });
        } catch (error) {
            next(error);
        }
    }

    // Get role permissions
    static async getRolePermissions(req, res, next) {
        try {
            const { id } = req.params;

            const permissions = await RolePermission.getRolePermissions(id);

            res.json({
                success: true,
                data: permissions,
                count: permissions.length
            });
        } catch (error) {
            next(error);
        }
    }

    // Assign permissions to role
    static async assignPermissions(req, res, next) {
        try {
            const { id } = req.params;
            const { permission_ids } = req.body;

            if (!Array.isArray(permission_ids)) {
                return res.status(400).json({
                    success: false,
                    message: 'permission_ids must be an array'
                });
            }

            const permissions = await RolePermission.bulkAssign(id, permission_ids);

            res.json({
                success: true,
                message: 'Permissions assigned successfully',
                data: permissions,
                count: permissions.length
            });
        } catch (error) {
            next(error);
        }
    }
}

module.exports = RoleController;
