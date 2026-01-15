const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const ScheduleController = require('../controllers/schedule.controller');
const { authenticate } = require('../middlewares/auth.middleware');
const { requirePermission } = require('../middlewares/permission.middleware');
const validate = require('../middlewares/validate.middleware');

const scheduleValidation = [
    body('tour_id').isInt(),
    body('departure_date').isISO8601(),
    body('return_date').isISO8601(),
    body('available_slots').isInt({ min: 1 })
];

router.get('/', ScheduleController.getAll);
router.get('/:id', ScheduleController.getById);
router.get('/:id/availability', ScheduleController.checkAvailability);
router.get('/tour/:tour_id/upcoming', ScheduleController.getUpcoming);
router.post('/', authenticate, requirePermission('tour.edit'), scheduleValidation, validate, ScheduleController.create);
router.put('/:id', authenticate, requirePermission('tour.edit'), ScheduleController.update);
router.delete('/:id', authenticate, requirePermission('tour.delete'), ScheduleController.delete);

module.exports = router;
