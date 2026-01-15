const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const DestinationController = require('../controllers/destination.controller');
const { authenticate } = require('../middlewares/auth.middleware');
const { requirePermission } = require('../middlewares/permission.middleware');
const validate = require('../middlewares/validate.middleware');

const destinationValidation = [
    body('name').trim().isLength({ min: 2, max: 200 }),
    body('country').trim().notEmpty(),
    body('city').optional().trim()
];

router.get('/', DestinationController.getAll);
router.get('/popular', DestinationController.getPopular);
router.get('/:id', DestinationController.getById);
router.post('/', authenticate, requirePermission('tour.create'), destinationValidation, validate, DestinationController.create);
router.put('/:id', authenticate, requirePermission('tour.edit'), destinationValidation, validate, DestinationController.update);
router.delete('/:id', authenticate, requirePermission('tour.delete'), DestinationController.delete);

module.exports = router;
