const Review = require('../models/Review');

class ReviewController {
    static async getAll(req, res, next) {
        try {
            const filters = {
                tour_id: req.query.tour_id,
                user_id: req.query.user_id,
                status: req.query.status,
                rating: req.query.rating
            };
            const reviews = await Review.findAll(filters);
            res.json({ success: true, data: reviews, count: reviews.length });
        } catch (error) {
            next(error);
        }
    }

    static async getById(req, res, next) {
        try {
            const review = await Review.findById(req.params.id);
            if (!review) return res.status(404).json({ success: false, message: 'Review not found' });
            res.json({ success: true, data: review });
        } catch (error) {
            next(error);
        }
    }

    static async create(req, res, next) {
        try {
            const review = await Review.create({ ...req.body, user_id: req.user.user_id });
            res.status(201).json({ success: true, message: 'Review created successfully', data: review });
        } catch (error) {
            next(error);
        }
    }

    static async update(req, res, next) {
        try {
            const review = await Review.update(req.params.id, req.body);
            if (!review) return res.status(404).json({ success: false, message: 'Review not found' });
            res.json({ success: true, message: 'Review updated successfully', data: review });
        } catch (error) {
            next(error);
        }
    }

    static async approve(req, res, next) {
        try {
            const review = await Review.approve(req.params.id, req.user.user_id);
            if (!review) return res.status(404).json({ success: false, message: 'Review not found' });
            res.json({ success: true, message: 'Review approved successfully', data: review });
        } catch (error) {
            next(error);
        }
    }

    static async reject(req, res, next) {
        try {
            const review = await Review.reject(req.params.id, req.user.user_id);
            if (!review) return res.status(404).json({ success: false, message: 'Review not found' });
            res.json({ success: true, message: 'Review rejected successfully', data: review });
        } catch (error) {
            next(error);
        }
    }

    static async delete(req, res, next) {
        try {
            const review = await Review.delete(req.params.id);
            if (!review) return res.status(404).json({ success: false, message: 'Review not found' });
            res.json({ success: true, message: 'Review deleted successfully' });
        } catch (error) {
            next(error);
        }
    }

    static async getByTour(req, res, next) {
        try {
            const reviews = await Review.findByTour(req.params.tourId, req.query.limit || 10);
            res.json({ success: true, data: reviews, count: reviews.length });
        } catch (error) {
            next(error);
        }
    }

    static async getTourRating(req, res, next) {
        try {
            const rating = await Review.getTourRating(req.params.tourId);
            res.json({ success: true, data: rating });
        } catch (error) {
            next(error);
        }
    }

    static async getPending(req, res, next) {
        try {
            const reviews = await Review.getPending();
            res.json({ success: true, data: reviews, count: reviews.length });
        } catch (error) {
            next(error);
        }
    }
}

module.exports = ReviewController;
