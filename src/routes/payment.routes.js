const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const PaymentController = require('../controllers/payment.controller');
const { authenticate } = require('../middlewares/auth.middleware');
const { requirePermission } = require('../middlewares/permission.middleware');
const validate = require('../middlewares/validate.middleware');

const paymentValidation = [
    body('booking_id').isInt(),
    body('payment_method').isIn(['credit_card', 'debit_card', 'bank_transfer', 'cash', 'e_wallet']),
    body('amount').isDecimal()
];

router.get('/', authenticate, requirePermission('payment.process'), PaymentController.getAll);
router.get('/statistics', authenticate, requirePermission('report.view_bookings'), PaymentController.getStatistics);
router.get('/:id', authenticate, PaymentController.getById);
router.get('/booking/:bookingId', authenticate, PaymentController.getByBooking);
router.post('/', authenticate, requirePermission('payment.process'), paymentValidation, validate, PaymentController.create);
router.put('/:id/status', authenticate, requirePermission('payment.process'), PaymentController.updateStatus);

module.exports = router;
