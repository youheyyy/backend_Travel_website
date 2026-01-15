const { query } = require('../config/database');

class Destination {
    // Get all destinations
    static async findAll(filters = {}) {
        let queryText = `
      SELECT d.*, u.username as created_by_username
      FROM destinations d
      LEFT JOIN users u ON d.created_by = u.user_id
      WHERE 1=1
    `;
        const params = [];
        let paramCount = 1;

        if (filters.is_popular !== undefined) {
            queryText += ` AND d.is_popular = $${paramCount++}`;
            params.push(filters.is_popular);
        }

        if (filters.country) {
            queryText += ` AND d.country ILIKE $${paramCount++}`;
            params.push(`%${filters.country}%`);
        }

        queryText += ' ORDER BY d.destination_id DESC';

        const result = await query(queryText, params);
        return result.rows;
    }

    // Get destination by ID
    static async findById(id) {
        const result = await query(
            `SELECT d.*, u.username as created_by_username
       FROM destinations d
       LEFT JOIN users u ON d.created_by = u.user_id
       WHERE d.destination_id = $1`,
            [id]
        );
        return result.rows[0];
    }

    // Create new destination
    static async create(data) {
        const { name, country, city, description, image_url, is_popular, created_by } = data;
        const result = await query(
            `INSERT INTO destinations (name, country, city, description, image_url, is_popular, created_by)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING *`,
            [name, country, city, description, image_url, is_popular || false, created_by]
        );
        return result.rows[0];
    }

    // Update destination
    static async update(id, data) {
        const { name, country, city, description, image_url, is_popular } = data;
        const result = await query(
            `UPDATE destinations
       SET name = $1, country = $2, city = $3, description = $4, 
           image_url = $5, is_popular = $6
       WHERE destination_id = $7
       RETURNING *`,
            [name, country, city, description, image_url, is_popular, id]
        );
        return result.rows[0];
    }

    // Delete destination
    static async delete(id) {
        const result = await query(
            'DELETE FROM destinations WHERE destination_id = $1 RETURNING *',
            [id]
        );
        return result.rows[0];
    }

    // Get popular destinations
    static async getPopular() {
        const result = await query(
            'SELECT * FROM destinations WHERE is_popular = true ORDER BY name'
        );
        return result.rows;
    }

    // Get destinations by country
    static async findByCountry(country) {
        const result = await query(
            'SELECT * FROM destinations WHERE country ILIKE $1 ORDER BY name',
            [`%${country}%`]
        );
        return result.rows;
    }
}

module.exports = Destination;
