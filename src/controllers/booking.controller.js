const Booking = require('../models/Booking');

class BookingController {
    static async getAll(req, res, next) {
        try {
            const filters = {
                user_id: req.query.user_id,
                booking_status: req.query.booking_status,
                payment_status: req.query.payment_status,
                from_date: req.query.from_date
            };
            const bookings = await Booking.findAll(filters);
            res.json({ success: true, data: bookings, count: bookings.length });
        } catch (error) {
            next(error);
        }
    }

    static async getById(req, res, next) {
        try {
            const booking = await Booking.findById(req.params.id);
            if (!booking) return res.status(404).json({ success: false, message: 'Booking not found' });
            const participants = await Booking.getParticipants(req.params.id);
            res.json({ success: true, data: { ...booking, participants } });
        } catch (error) {
            next(error);
        }
    }

    static async create(req, res, next) {
        try {
            console.log('Booking request body:', req.body);
            console.log('User from token:', req.user);
            const booking = await Booking.create({ ...req.body, user_id: req.user.user_id });
            res.status(201).json({ success: true, message: 'Booking created successfully', data: booking });
        } catch (error) {
            console.error('Booking creation error:', error);
            next(error);
        }
    }

    static async getByCode(req, res, next) {
        try {
            const booking = await Booking.findByCode(req.params.code);
            if (!booking) return res.status(404).json({ success: false, message: 'Booking not found' });
            res.json({ success: true, data: booking });
        } catch (error) {
            console.error('Error fetching booking by code:', error);
            next(error);
        }
    }

    static async update(req, res, next) {
        try {
            const booking = await Booking.update(req.params.id, req.body);
            if (!booking) return res.status(404).json({ success: false, message: 'Booking not found' });
            res.json({ success: true, message: 'Booking updated successfully', data: booking });
        } catch (error) {
            next(error);
        }
    }

    static async confirm(req, res, next) {
        try {
            const booking = await Booking.confirm(req.params.id, req.user.user_id);
            if (!booking) return res.status(404).json({ success: false, message: 'Booking not found' });
            res.json({ success: true, message: 'Booking confirmed successfully', data: booking });
        } catch (error) {
            next(error);
        }
    }

    static async cancel(req, res, next) {
        try {
            const booking = await Booking.cancel(req.params.id);
            if (!booking) return res.status(404).json({ success: false, message: 'Booking not found' });
            res.json({ success: true, message: 'Booking cancelled successfully', data: booking });
        } catch (error) {
            next(error);
        }
    }

    static async getParticipants(req, res, next) {
        try {
            const participants = await Booking.getParticipants(req.params.id);
            res.json({ success: true, data: participants, count: participants.length });
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
            const stats = await Booking.getStatistics(filters);
            res.json({ success: true, data: stats });
        } catch (error) {
            next(error);
        }
    }

    static async getMyBookings(req, res, next) {
        try {
            const bookings = await Booking.findByUser(req.user.user_id);
            res.json({ success: true, data: bookings, count: bookings.length });
        } catch (error) {
            next(error);
        }
    }
}

module.exports = BookingController;
