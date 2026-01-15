const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const RoleController = require('../controllers/role.controller');
const { authenticate } = require('../middlewares/auth.middleware');
const { requirePermission } = require('../middlewares/permission.middleware');
const validate = require('../middlewares/validate.middleware');

// Validation rules
const roleValidation = [
    body('role_name')
        .trim()
        .isLength({ min: 2, max: 50 })
        .withMessage('Role name must be between 2 and 50 characters'),
    body('role_description')
        .optional()
        .trim()
];

const assignPermissionsValidation = [
    body('permission_ids')
        .isArray()
        .withMessage('permission_ids must be an array'),
    body('permission_ids.*')
        .isInt()
        .withMessage('Each permission_id must be an integer')
];

// Routes
router.get('/', authenticate, requirePermission('user.manage_roles'), RoleController.getAllRoles);
router.get('/:id', authenticate, requirePermission('user.manage_roles'), RoleController.getRoleById);
router.post('/', authenticate, requirePermission('user.manage_roles'), roleValidation, validate, RoleController.createRole);
router.put('/:id', authenticate, requirePermission('user.manage_roles'), roleValidation, validate, RoleController.updateRole);
router.delete('/:id', authenticate, requirePermission('user.manage_roles'), RoleController.deleteRole);
router.get('/:id/permissions', authenticate, requirePermission('user.manage_roles'), RoleController.getRolePermissions);
router.post('/:id/permissions', authenticate, requirePermission('user.manage_roles'), assignPermissionsValidation, validate, RoleController.assignPermissions);

module.exports = router;
