const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const PermissionController = require('../controllers/permission.controller');
const { authenticate } = require('../middlewares/auth.middleware');
const { requirePermission } = require('../middlewares/permission.middleware');
const validate = require('../middlewares/validate.middleware');

// Validation rules
const permissionValidation = [
    body('permission_name')
        .trim()
        .isLength({ min: 2, max: 100 })
        .withMessage('Permission name must be between 2 and 100 characters'),
    body('permission_description')
        .optional()
        .trim(),
    body('module')
        .trim()
        .isLength({ min: 2, max: 50 })
        .withMessage('Module must be between 2 and 50 characters')
];

// Routes
router.get('/', authenticate, requirePermission('user.manage_roles'), PermissionController.getAllPermissions);
router.get('/modules', authenticate, requirePermission('user.manage_roles'), PermissionController.getModules);
router.get('/module/:module', authenticate, requirePermission('user.manage_roles'), PermissionController.getPermissionsByModule);
router.get('/:id', authenticate, requirePermission('user.manage_roles'), PermissionController.getPermissionById);
router.post('/', authenticate, requirePermission('user.manage_roles'), permissionValidation, validate, PermissionController.createPermission);
router.put('/:id', authenticate, requirePermission('user.manage_roles'), permissionValidation, validate, PermissionController.updatePermission);
router.delete('/:id', authenticate, requirePermission('user.manage_roles'), PermissionController.deletePermission);

module.exports = router;
