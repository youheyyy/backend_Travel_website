const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const TourCategoryController = require('../controllers/tourCategory.controller');
const { authenticate } = require('../middlewares/auth.middleware');
const { requirePermission } = require('../middlewares/permission.middleware');
const validate = require('../middlewares/validate.middleware');

const categoryValidation = [
    body('category_name').trim().isLength({ min: 2, max: 100 })
];

router.get('/', TourCategoryController.getAll);
router.get('/:id', TourCategoryController.getById);
router.post('/', authenticate, requirePermission('tour.create'), categoryValidation, validate, TourCategoryController.create);
router.put('/:id', authenticate, requirePermission('tour.edit'), categoryValidation, validate, TourCategoryController.update);
router.delete('/:id', authenticate, requirePermission('tour.delete'), TourCategoryController.delete);

module.exports = router;
