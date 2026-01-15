const Permission = require('../models/Permission');

class PermissionController {
    // Get all permissions
    static async getAllPermissions(req, res, next) {
        try {
            const permissions = await Permission.findAll();

            res.json({
                success: true,
                data: permissions,
                count: permissions.length
            });
        } catch (error) {
            next(error);
        }
    }

    // Get permission by ID
    static async getPermissionById(req, res, next) {
        try {
            const { id } = req.params;
            const permission = await Permission.findById(id);

            if (!permission) {
                return res.status(404).json({
                    success: false,
                    message: 'Permission not found'
                });
            }

            res.json({
                success: true,
                data: permission
            });
        } catch (error) {
            next(error);
        }
    }

    // Get permissions by module
    static async getPermissionsByModule(req, res, next) {
        try {
            const { module } = req.params;
            const permissions = await Permission.findByModule(module);

            res.json({
                success: true,
                data: permissions,
                count: permissions.length
            });
        } catch (error) {
            next(error);
        }
    }

    // Get all modules
    static async getModules(req, res, next) {
        try {
            const modules = await Permission.getModules();

            res.json({
                success: true,
                data: modules,
                count: modules.length
            });
        } catch (error) {
            next(error);
        }
    }

    // Create new permission
    static async createPermission(req, res, next) {
        try {
            const { permission_name, permission_description, module } = req.body;

            const permission = await Permission.create({
                permission_name,
                permission_description,
                module
            });

            res.status(201).json({
                success: true,
                message: 'Permission created successfully',
                data: permission
            });
        } catch (error) {
            next(error);
        }
    }

    // Update permission
    static async updatePermission(req, res, next) {
        try {
            const { id } = req.params;
            const { permission_name, permission_description, module } = req.body;

            const permission = await Permission.update(id, {
                permission_name,
                permission_description,
                module
            });

            if (!permission) {
                return res.status(404).json({
                    success: false,
                    message: 'Permission not found'
                });
            }

            res.json({
                success: true,
                message: 'Permission updated successfully',
                data: permission
            });
        } catch (error) {
            next(error);
        }
    }

    // Delete permission
    static async deletePermission(req, res, next) {
        try {
            const { id } = req.params;

            const permission = await Permission.delete(id);

            if (!permission) {
                return res.status(404).json({
                    success: false,
                    message: 'Permission not found'
                });
            }

            res.json({
                success: true,
                message: 'Permission deleted successfully'
            });
        } catch (error) {
            next(error);
        }
    }
}

module.exports = PermissionController;
