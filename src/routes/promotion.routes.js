const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const PromotionController = require('../controllers/promotion.controller');
const { authenticate } = require('../middlewares/auth.middleware');
const { requirePermission } = require('../middlewares/permission.middleware');
const validate = require('../middlewares/validate.middleware');

const promotionValidation = [
    body('code').trim().notEmpty(),
    body('discount_type').isIn(['percentage', 'fixed_amount']),
    body('discount_value').isDecimal(),
    body('valid_from').isISO8601(),
    body('valid_to').isISO8601()
];

router.get('/', PromotionController.getAll);
router.get('/active', PromotionController.getActive);
router.get('/:id', authenticate, requirePermission('promotion.view'), PromotionController.getById);
router.get('/:id/usage', authenticate, requirePermission('promotion.view'), PromotionController.getUsageHistory);
router.get('/validate/:code', PromotionController.validate);
router.post('/', authenticate, requirePermission('promotion.create'), promotionValidation, validate, PromotionController.create);
router.put('/:id', authenticate, requirePermission('promotion.create'), PromotionController.update);
router.delete('/:id', authenticate, requirePermission('promotion.create'), PromotionController.delete);

module.exports = router;
