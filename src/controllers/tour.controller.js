const Tour = require('../models/Tour');

class TourController {
    static async getAll(req, res, next) {
        try {
            const filters = {
                status: req.query.status,
                category_id: req.query.category_id,
                destination_id: req.query.destination_id,
                search: req.query.search,
                limit: req.query.limit
            };
            const tours = await Tour.findAll(filters);
            res.json({ success: true, data: tours, count: tours.length });
        } catch (error) {
            next(error);
        }
    }

    static async getById(req, res, next) {
        try {
            const tour = await Tour.findById(req.params.id);
            if (!tour) return res.status(404).json({ success: false, message: 'Tour not found' });
            const images = await Tour.getImages(req.params.id);
            res.json({ success: true, data: { ...tour, images } });
        } catch (error) {
            next(error);
        }
    }

    static async create(req, res, next) {
        try {
            const tour = await Tour.create({ ...req.body, created_by: req.user.user_id });
            res.status(201).json({ success: true, message: 'Tour created successfully', data: tour });
        } catch (error) {
            next(error);
        }
    }

    static async update(req, res, next) {
        try {
            const tour = await Tour.update(req.params.id, req.body);
            if (!tour) return res.status(404).json({ success: false, message: 'Tour not found' });
            res.json({ success: true, message: 'Tour updated successfully', data: tour });
        } catch (error) {
            next(error);
        }
    }

    static async delete(req, res, next) {
        try {
            const tour = await Tour.delete(req.params.id);
            if (!tour) return res.status(404).json({ success: false, message: 'Tour not found' });
            res.json({ success: true, message: 'Tour deleted successfully' });
        } catch (error) {
            next(error);
        }
    }

    static async getFeatured(req, res, next) {
        try {
            const tours = await Tour.getFeatured(req.query.limit || 6);
            res.json({ success: true, data: tours, count: tours.length });
        } catch (error) {
            next(error);
        }
    }

    static async search(req, res, next) {
        try {
            const { q, min_price, max_price, duration_days } = req.query;
            const tours = await Tour.search(q, { min_price, max_price, duration_days });
            res.json({ success: true, data: tours, count: tours.length });
        } catch (error) {
            next(error);
        }
    }

    static async addImage(req, res, next) {
        try {
            const image = await Tour.addImage({ ...req.body, uploaded_by: req.user.user_id });
            res.status(201).json({ success: true, message: 'Image added successfully', data: image });
        } catch (error) {
            next(error);
        }
    }

    static async deleteImage(req, res, next) {
        try {
            const image = await Tour.deleteImage(req.params.imageId);
            if (!image) return res.status(404).json({ success: false, message: 'Image not found' });
            res.json({ success: true, message: 'Image deleted successfully' });
        } catch (error) {
            next(error);
        }
    }
}

module.exports = TourController;
