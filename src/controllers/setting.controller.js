const SystemSetting = require('../models/SystemSetting');

class SettingController {
    static async getAll(req, res, next) {
        try {
            const settings = await SystemSetting.findAll();
            res.json({ success: true, data: settings, count: settings.length });
        } catch (error) {
            next(error);
        }
    }

    static async getAsObject(req, res, next) {
        try {
            const settings = await SystemSetting.getAsObject();
            res.json({ success: true, data: settings });
        } catch (error) {
            next(error);
        }
    }

    static async getById(req, res, next) {
        try {
            const setting = await SystemSetting.findById(req.params.id);
            if (!setting) return res.status(404).json({ success: false, message: 'Setting not found' });
            res.json({ success: true, data: setting });
        } catch (error) {
            next(error);
        }
    }

    static async getByKey(req, res, next) {
        try {
            const setting = await SystemSetting.findByKey(req.params.key);
            if (!setting) return res.status(404).json({ success: false, message: 'Setting not found' });
            res.json({ success: true, data: setting });
        } catch (error) {
            next(error);
        }
    }

    static async create(req, res, next) {
        try {
            const setting = await SystemSetting.create({ ...req.body, updated_by: req.user.user_id });
            res.status(201).json({ success: true, message: 'Setting created successfully', data: setting });
        } catch (error) {
            next(error);
        }
    }

    static async update(req, res, next) {
        try {
            const setting = await SystemSetting.update(req.params.id, { ...req.body, updated_by: req.user.user_id });
            if (!setting) return res.status(404).json({ success: false, message: 'Setting not found' });
            res.json({ success: true, message: 'Setting updated successfully', data: setting });
        } catch (error) {
            next(error);
        }
    }

    static async delete(req, res, next) {
        try {
            const setting = await SystemSetting.delete(req.params.id);
            if (!setting) return res.status(404).json({ success: false, message: 'Setting not found' });
            res.json({ success: true, message: 'Setting deleted successfully' });
        } catch (error) {
            next(error);
        }
    }
}

module.exports = SettingController;
