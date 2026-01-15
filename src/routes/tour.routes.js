const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const TourController = require('../controllers/tour.controller');
const { authenticate } = require('../middlewares/auth.middleware');
const { requirePermission } = require('../middlewares/permission.middleware');
const validate = require('../middlewares/validate.middleware');

const tourValidation = [
    body('tour_code').trim().notEmpty(),
    body('title').trim().isLength({ min: 5, max: 255 }),
    body('category_id').isInt(),
    body('destination_id').isInt(),
    body('duration_days').isInt({ min: 1 }),
    body('duration_nights').isInt({ min: 0 }),
    body('price_adult').isDecimal()
];

router.get('/', TourController.getAll);
router.get('/featured', TourController.getFeatured);
router.get('/search', TourController.search);
router.get('/:id', TourController.getById);
router.post('/', authenticate, requirePermission('tour.create'), tourValidation, validate, TourController.create);
router.put('/:id', authenticate, requirePermission('tour.edit'), TourController.update);
router.delete('/:id', authenticate, requirePermission('tour.delete'), TourController.delete);
router.post('/:id/images', authenticate, requirePermission('tour.edit'), TourController.addImage);
router.delete('/images/:imageId', authenticate, requirePermission('tour.edit'), TourController.deleteImage);

module.exports = router;
