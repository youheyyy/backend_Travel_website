const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const BookingController = require('../controllers/booking.controller');
const { authenticate } = require('../middlewares/auth.middleware');
const { requirePermission, requireAnyPermission } = require('../middlewares/permission.middleware');
const validate = require('../middlewares/validate.middleware');

const bookingValidation = [
    body('customer_name').trim().notEmpty().withMessage('Customer name is required'),
    body('customer_email').isEmail().withMessage('Valid email is required'),
    body('customer_phone').trim().notEmpty().withMessage('Phone number is required'),
    body('total_amount').isDecimal().withMessage('Total amount must be a valid number'),
    // Either schedule_id OR (tour_id + departure_date) is required
    body().custom((value, { req }) => {
        if (!req.body.schedule_id && !(req.body.tour_id && req.body.departure_date)) {
            throw new Error('Either schedule_id or (tour_id and departure_date) is required');
        }
        return true;
    })
];

router.get('/', authenticate, requirePermission('booking.view_all'), BookingController.getAll);
router.get('/my-bookings', authenticate, BookingController.getMyBookings);
router.get('/statistics', authenticate, requirePermission('report.view_bookings'), BookingController.getStatistics);
router.get('/code/:code', authenticate, BookingController.getByCode);
router.get('/:id', authenticate, requireAnyPermission(['booking.view_all', 'booking.view_own']), BookingController.getById);
router.get('/:id/participants', authenticate, BookingController.getParticipants);
router.post('/', authenticate, bookingValidation, validate, BookingController.create);
router.put('/:id', authenticate, requirePermission('booking.view_all'), BookingController.update);
router.post('/:id/confirm', authenticate, requirePermission('booking.confirm'), BookingController.confirm);
router.post('/:id/cancel', authenticate, BookingController.cancel);

module.exports = router;
