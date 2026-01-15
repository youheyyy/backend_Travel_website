const Promotion = require('../models/Promotion');

class PromotionController {
    static async getAll(req, res, next) {
        try {
            const filters = {
                status: req.query.status,
                active_only: req.query.active_only
            };
            const promotions = await Promotion.findAll(filters);
            res.json({ success: true, data: promotions, count: promotions.length });
        } catch (error) {
            next(error);
        }
    }

    static async getById(req, res, next) {
        try {
            const promotion = await Promotion.findById(req.params.id);
            if (!promotion) return res.status(404).json({ success: false, message: 'Promotion not found' });
            res.json({ success: true, data: promotion });
        } catch (error) {
            next(error);
        }
    }

    static async create(req, res, next) {
        try {
            const promotion = await Promotion.create({ ...req.body, created_by: req.user.user_id });
            res.status(201).json({ success: true, message: 'Promotion created successfully', data: promotion });
        } catch (error) {
            next(error);
        }
    }

    static async update(req, res, next) {
        try {
            const promotion = await Promotion.update(req.params.id, req.body);
            if (!promotion) return res.status(404).json({ success: false, message: 'Promotion not found' });
            res.json({ success: true, message: 'Promotion updated successfully', data: promotion });
        } catch (error) {
            next(error);
        }
    }

    static async delete(req, res, next) {
        try {
            const promotion = await Promotion.delete(req.params.id);
            if (!promotion) return res.status(404).json({ success: false, message: 'Promotion not found' });
            res.json({ success: true, message: 'Promotion deleted successfully' });
        } catch (error) {
            next(error);
        }
    }

    static async validate(req, res, next) {
        try {
            const { code } = req.params;
            const { purchase_amount } = req.query;
            const result = await Promotion.validate(code, purchase_amount);

            if (!result.valid) {
                return res.status(400).json({ success: false, message: result.message });
            }

            const discountAmount = Promotion.calculateDiscount(result.promotion, purchase_amount);
            res.json({
                success: true,
                data: {
                    promotion: result.promotion,
                    discount_amount: discountAmount,
                    final_amount: purchase_amount - discountAmount
                }
            });
        } catch (error) {
            next(error);
        }
    }

    static async getActive(req, res, next) {
        try {
            const promotions = await Promotion.getActive();
            res.json({ success: true, data: promotions, count: promotions.length });
        } catch (error) {
            next(error);
        }
    }

    static async getUsageHistory(req, res, next) {
        try {
            const history = await Promotion.getUsageHistory(req.params.id);
            res.json({ success: true, data: history, count: history.length });
        } catch (error) {
            next(error);
        }
    }
}

module.exports = PromotionController;
