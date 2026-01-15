const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const BlogController = require('../controllers/blog.controller');
const { authenticate } = require('../middlewares/auth.middleware');
const { requirePermission } = require('../middlewares/permission.middleware');
const validate = require('../middlewares/validate.middleware');

const blogValidation = [
    body('title').trim().isLength({ min: 5, max: 255 }),
    body('content').trim().notEmpty()
];

router.get('/', BlogController.getAll);
router.get('/published', BlogController.getPublished);
router.get('/slug/:slug', BlogController.getBySlug);
router.get('/:id', BlogController.getById);
router.post('/', authenticate, requirePermission('content.manage'), blogValidation, validate, BlogController.create);
router.put('/:id', authenticate, requirePermission('content.manage'), BlogController.update);
router.post('/:id/publish', authenticate, requirePermission('content.manage'), BlogController.publish);
router.post('/:id/view', BlogController.incrementViewCount);
router.delete('/:id', authenticate, requirePermission('content.manage'), BlogController.delete);

module.exports = router;
