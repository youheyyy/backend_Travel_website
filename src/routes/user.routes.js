const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const UserController = require('../controllers/user.controller');
const { authenticate } = require('../middlewares/auth.middleware');
const { requirePermission, requireAnyPermission } = require('../middlewares/permission.middleware');
const validate = require('../middlewares/validate.middleware');

// Validation rules
const userValidation = [
    body('username')
        .trim()
        .isLength({ min: 3, max: 50 })
        .withMessage('Username must be between 3 and 50 characters'),
    body('email')
        .isEmail()
        .normalizeEmail()
        .withMessage('Please provide a valid email'),
    body('password')
        .isLength({ min: 6 })
        .withMessage('Password must be at least 6 characters'),
    body('full_name')
        .optional()
        .trim()
        .isLength({ max: 100 })
        .withMessage('Full name must not exceed 100 characters'),
    body('phone')
        .optional()
        .trim()
        .matches(/^[0-9+\-\s()]*$/)
        .withMessage('Please provide a valid phone number'),
    body('role_id')
        .isInt()
        .withMessage('Role ID must be an integer')
];

const userUpdateValidation = [
    body('username')
        .optional()
        .trim()
        .isLength({ min: 3, max: 50 })
        .withMessage('Username must be between 3 and 50 characters'),
    body('email')
        .optional()
        .isEmail()
        .normalizeEmail()
        .withMessage('Please provide a valid email'),
    body('full_name')
        .optional()
        .trim()
        .isLength({ max: 100 })
        .withMessage('Full name must not exceed 100 characters'),
    body('phone')
        .optional()
        .trim()
        .matches(/^[0-9+\-\s()]*$/)
        .withMessage('Please provide a valid phone number'),
    body('role_id')
        .optional()
        .isInt()
        .withMessage('Role ID must be an integer'),
    body('status')
        .optional()
        .isIn(['active', 'inactive', 'suspended'])
        .withMessage('Status must be active, inactive, or suspended')
];

const assignRoleValidation = [
    body('role_id')
        .isInt()
        .withMessage('Role ID must be an integer')
];

// Routes
router.get('/', authenticate, requirePermission('customer.view'), UserController.getAllUsers);
router.get('/role/:roleId', authenticate, requirePermission('customer.view'), UserController.getUsersByRole);
router.get('/:id', authenticate, requireAnyPermission(['customer.view', 'booking.view_own']), UserController.getUserById);
router.post('/', authenticate, requirePermission('user.manage_roles'), userValidation, validate, UserController.createUser);
router.put('/:id', authenticate, requirePermission('user.manage_roles'), userUpdateValidation, validate, UserController.updateUser);
router.delete('/:id', authenticate, requirePermission('user.manage_roles'), UserController.deleteUser);
router.post('/:id/assign-role', authenticate, requirePermission('user.manage_roles'), assignRoleValidation, validate, UserController.assignRole);
router.get('/:id/permissions', authenticate, UserController.getUserPermissions);

module.exports = router;
