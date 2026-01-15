const Destination = require('../models/Destination');

class DestinationController {
    static async getAll(req, res, next) {
        try {
            const { is_popular, country } = req.query;
            const destinations = await Destination.findAll({ is_popular, country });

            res.json({
                success: true,
                data: destinations,
                count: destinations.length
            });
        } catch (error) {
            next(error);
        }
    }

    static async getById(req, res, next) {
        try {
            const { id } = req.params;
            const destination = await Destination.findById(id);

            if (!destination) {
                return res.status(404).json({
                    success: false,
                    message: 'Destination not found'
                });
            }

            res.json({
                success: true,
                data: destination
            });
        } catch (error) {
            next(error);
        }
    }

    static async create(req, res, next) {
        try {
            const destination = await Destination.create({
                ...req.body,
                created_by: req.user.user_id
            });

            res.status(201).json({
                success: true,
                message: 'Destination created successfully',
                data: destination
            });
        } catch (error) {
            next(error);
        }
    }

    static async update(req, res, next) {
        try {
            const { id } = req.params;
            const destination = await Destination.update(id, req.body);

            if (!destination) {
                return res.status(404).json({
                    success: false,
                    message: 'Destination not found'
                });
            }

            res.json({
                success: true,
                message: 'Destination updated successfully',
                data: destination
            });
        } catch (error) {
            next(error);
        }
    }

    static async delete(req, res, next) {
        try {
            const { id } = req.params;
            const destination = await Destination.delete(id);

            if (!destination) {
                return res.status(404).json({
                    success: false,
                    message: 'Destination not found'
                });
            }

            res.json({
                success: true,
                message: 'Destination deleted successfully'
            });
        } catch (error) {
            next(error);
        }
    }

    static async getPopular(req, res, next) {
        try {
            const destinations = await Destination.getPopular();

            res.json({
                success: true,
                data: destinations,
                count: destinations.length
            });
        } catch (error) {
            next(error);
        }
    }
}

module.exports = DestinationController;
