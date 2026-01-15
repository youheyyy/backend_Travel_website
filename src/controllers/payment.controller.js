const Payment = require('../models/Payment');

class PaymentController {
    static async getAll(req, res, next) {
        try {
            const filters = {
                booking_id: req.query.booking_id,
                payment_status: req.query.payment_status,
                payment_method: req.query.payment_method
            };
            const payments = await Payment.findAll(filters);
            res.json({ success: true, data: payments, count: payments.length });
        } catch (error) {
            next(error);
        }
    }

    static async getById(req, res, next) {
        try {
            const payment = await Payment.findById(req.params.id);
            if (!payment) return res.status(404).json({ success: false, message: 'Payment not found' });
            res.json({ success: true, data: payment });
        } catch (error) {
            next(error);
        }
    }

    static async create(req, res, next) {
        try {
            const payment = await Payment.create({ ...req.body, processed_by: req.user.user_id });
            res.status(201).json({ success: true, message: 'Payment created successfully', data: payment });
        } catch (error) {
            next(error);
        }
    }

    static async updateStatus(req, res, next) {
        try {
            const { status } = req.body;
            const payment = await Payment.updateStatus(req.params.id, status, req.user.user_id);
            if (!payment) return res.status(404).json({ success: false, message: 'Payment not found' });
            res.json({ success: true, message: 'Payment status updated successfully', data: payment });
        } catch (error) {
            next(error);
        }
    }

    static async getByBooking(req, res, next) {
        try {
            const payments = await Payment.findByBooking(req.params.bookingId);
            res.json({ success: true, data: payments, count: payments.length });
        } catch (error) {
            next(error);
        }
    }

    static async getStatistics(req, res, next) {
        try {
            const filters = {
                from_date: req.query.from_date,
                to_date: req.query.to_date
            };
            const stats = await Payment.getStatistics(filters);
            res.json({ success: true, data: stats });
        } catch (error) {
            next(error);
        }
    }
}

module.exports = PaymentController;
