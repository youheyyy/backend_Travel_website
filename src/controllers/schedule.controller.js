const TourSchedule = require('../models/TourSchedule');

class ScheduleController {
    static async getAll(req, res, next) {
        try {
            const filters = {
                tour_id: req.query.tour_id,
                status: req.query.status,
                from_date: req.query.from_date,
                to_date: req.query.to_date
            };
            const schedules = await TourSchedule.findAll(filters);
            res.json({ success: true, data: schedules, count: schedules.length });
        } catch (error) {
            next(error);
        }
    }

    static async getById(req, res, next) {
        try {
            const schedule = await TourSchedule.findById(req.params.id);
            if (!schedule) return res.status(404).json({ success: false, message: 'Schedule not found' });
            res.json({ success: true, data: schedule });
        } catch (error) {
            next(error);
        }
    }

    static async create(req, res, next) {
        try {
            const schedule = await TourSchedule.create(req.body);
            res.status(201).json({ success: true, message: 'Schedule created successfully', data: schedule });
        } catch (error) {
            next(error);
        }
    }

    static async update(req, res, next) {
        try {
            const schedule = await TourSchedule.update(req.params.id, req.body);
            if (!schedule) return res.status(404).json({ success: false, message: 'Schedule not found' });
            res.json({ success: true, message: 'Schedule updated successfully', data: schedule });
        } catch (error) {
            next(error);
        }
    }

    static async delete(req, res, next) {
        try {
            const schedule = await TourSchedule.delete(req.params.id);
            if (!schedule) return res.status(404).json({ success: false, message: 'Schedule not found' });
            res.json({ success: true, message: 'Schedule deleted successfully' });
        } catch (error) {
            next(error);
        }
    }

    static async checkAvailability(req, res, next) {
        try {
            const { id } = req.params;
            const { required_slots } = req.query;
            const availability = await TourSchedule.checkAvailability(id, required_slots || 1);
            res.json({ success: true, data: availability });
        } catch (error) {
            next(error);
        }
    }

    static async getUpcoming(req, res, next) {
        try {
            const { tour_id } = req.params;
            const schedules = await TourSchedule.getUpcoming(tour_id, req.query.limit || 10);
            res.json({ success: true, data: schedules, count: schedules.length });
        } catch (error) {
            next(error);
        }
    }
}

module.exports = ScheduleController;
