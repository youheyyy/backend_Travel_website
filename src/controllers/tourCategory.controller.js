const TourCategory = require('../models/TourCategory');

class TourCategoryController {
    static async getAll(req, res, next) {
        try {
            const categories = await TourCategory.findAllWithTourCount();
            res.json({ success: true, data: categories, count: categories.length });
        } catch (error) {
            next(error);
        }
    }

    static async getById(req, res, next) {
        try {
            const category = await TourCategory.findById(req.params.id);
            if (!category) return res.status(404).json({ success: false, message: 'Category not found' });
            res.json({ success: true, data: category });
        } catch (error) {
            next(error);
        }
    }

    static async create(req, res, next) {
        try {
            const category = await TourCategory.create(req.body);
            res.status(201).json({ success: true, message: 'Category created successfully', data: category });
        } catch (error) {
            next(error);
        }
    }

    static async update(req, res, next) {
        try {
            const category = await TourCategory.update(req.params.id, req.body);
            if (!category) return res.status(404).json({ success: false, message: 'Category not found' });
            res.json({ success: true, message: 'Category updated successfully', data: category });
        } catch (error) {
            next(error);
        }
    }

    static async delete(req, res, next) {
        try {
            const category = await TourCategory.delete(req.params.id);
            if (!category) return res.status(404).json({ success: false, message: 'Category not found' });
            res.json({ success: true, message: 'Category deleted successfully' });
        } catch (error) {
            next(error);
        }
    }
}

module.exports = TourCategoryController;
