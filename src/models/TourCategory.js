const { query } = require('../config/database');

class TourCategory {
    // Get all categories
    static async findAll() {
        const result = await query(
            'SELECT * FROM tour_categories ORDER BY category_name'
        );
        return result.rows;
    }

    // Get category by ID
    static async findById(id) {
        const result = await query(
            'SELECT * FROM tour_categories WHERE category_id = $1',
            [id]
        );
        return result.rows[0];
    }

    // Get category by name
    static async findByName(name) {
        const result = await query(
            'SELECT * FROM tour_categories WHERE category_name = $1',
            [name]
        );
        return result.rows[0];
    }

    // Create new category
    static async create(data) {
        const { category_name, description, icon_url } = data;
        const result = await query(
            `INSERT INTO tour_categories (category_name, description, icon_url)
       VALUES ($1, $2, $3)
       RETURNING *`,
            [category_name, description, icon_url]
        );
        return result.rows[0];
    }

    // Update category
    static async update(id, data) {
        const { category_name, description, icon_url } = data;
        const result = await query(
            `UPDATE tour_categories
       SET category_name = $1, description = $2, icon_url = $3
       WHERE category_id = $4
       RETURNING *`,
            [category_name, description, icon_url, id]
        );
        return result.rows[0];
    }

    // Delete category
    static async delete(id) {
        const result = await query(
            'DELETE FROM tour_categories WHERE category_id = $1 RETURNING *',
            [id]
        );
        return result.rows[0];
    }

    // Get category with tour count
    static async findAllWithTourCount() {
        const result = await query(
            `SELECT tc.*, COUNT(t.tour_id) as tour_count
       FROM tour_categories tc
       LEFT JOIN tours t ON tc.category_id = t.category_id
       GROUP BY tc.category_id
       ORDER BY tc.category_name`
        );
        return result.rows;
    }
}

module.exports = TourCategory;
