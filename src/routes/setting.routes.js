const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const SettingController = require('../controllers/setting.controller');
const { authenticate } = require('../middlewares/auth.middleware');
const { requirePermission } = require('../middlewares/permission.middleware');
const validate = require('../middlewares/validate.middleware');

const settingValidation = [
    body('setting_key').trim().notEmpty(),
    body('setting_value').trim().notEmpty()
];

router.get('/', SettingController.getAll);
router.get('/object', SettingController.getAsObject);
router.get('/key/:key', SettingController.getByKey);
router.get('/:id', authenticate, requirePermission('system.edit_settings'), SettingController.getById);
router.post('/', authenticate, requirePermission('system.edit_settings'), settingValidation, validate, SettingController.create);
router.put('/:id', authenticate, requirePermission('system.edit_settings'), SettingController.update);
router.delete('/:id', authenticate, requirePermission('system.edit_settings'), SettingController.delete);

module.exports = router;
