const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const ReviewController = require('../controllers/review.controller');
const { authenticate } = require('../middlewares/auth.middleware');
const { requirePermission } = require('../middlewares/permission.middleware');
const validate = require('../middlewares/validate.middleware');

const reviewValidation = [
    body('tour_id').isInt(),
    body('rating').isInt({ min: 1, max: 5 }),
    body('title').optional().trim(),
    body('comment').optional().trim()
];

router.get('/', ReviewController.getAll);
router.get('/pending', authenticate, requirePermission('review.approve'), ReviewController.getPending);
router.get('/tour/:tourId', ReviewController.getByTour);
router.get('/tour/:tourId/rating', ReviewController.getTourRating);
router.get('/:id', ReviewController.getById);
router.post('/', authenticate, reviewValidation, validate, ReviewController.create);
router.put('/:id', authenticate, ReviewController.update);
router.post('/:id/approve', authenticate, requirePermission('review.approve'), ReviewController.approve);
router.post('/:id/reject', authenticate, requirePermission('review.approve'), ReviewController.reject);
router.delete('/:id', authenticate, requirePermission('review.approve'), ReviewController.delete);

module.exports = router;
