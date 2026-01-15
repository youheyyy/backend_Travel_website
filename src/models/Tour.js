const { query, getClient } = require('../config/database');

class Tour {
    // Get all tours with filters
    static async findAll(filters = {}) {
        let queryText = `
      SELECT t.*, 
             tc.category_name,
             d.name as destination_name, d.country as destination_country,
             u.username as created_by_username
      FROM tours t
      LEFT JOIN tour_categories tc ON t.category_id = tc.category_id
      LEFT JOIN destinations d ON t.destination_id = d.destination_id
      LEFT JOIN users u ON t.created_by = u.user_id
      WHERE 1=1
    `;
        const params = [];
        let paramCount = 1;

        if (filters.status) {
            queryText += ` AND t.status = $${paramCount++}`;
            params.push(filters.status);
        }

        if (filters.category_id) {
            queryText += ` AND t.category_id = $${paramCount++}`;
            params.push(filters.category_id);
        }

        if (filters.destination_id) {
            queryText += ` AND t.destination_id = $${paramCount++}`;
            params.push(filters.destination_id);
        }

        if (filters.search) {
            queryText += ` AND (t.title ILIKE $${paramCount} OR t.description ILIKE $${paramCount})`;
            params.push(`%${filters.search}%`);
            paramCount++;
        }

        queryText += ' ORDER BY t.created_at DESC';

        if (filters.limit) {
            queryText += ` LIMIT $${paramCount++}`;
            params.push(filters.limit);
        }

        const result = await query(queryText, params);
        return result.rows;
    }

    // Get tour by ID with full details
    static async findById(id) {
        const result = await query(
            `SELECT t.*, 
              tc.category_name,
              d.name as destination_name, d.country as destination_country, d.city as destination_city,
              u.username as created_by_username, u.full_name as created_by_fullname
       FROM tours t
       LEFT JOIN tour_categories tc ON t.category_id = tc.category_id
       LEFT JOIN destinations d ON t.destination_id = d.destination_id
       LEFT JOIN users u ON t.created_by = u.user_id
       WHERE t.tour_id = $1`,
            [id]
        );
        return result.rows[0];
    }

    // Get tour by code
    static async findByCode(code) {
        const result = await query(
            'SELECT * FROM tours WHERE tour_code = $1',
            [code]
        );
        return result.rows[0];
    }

    // Create new tour
    static async create(data) {
        const {
            tour_code, title, category_id, destination_id, description,
            duration_days, duration_nights, max_participants, min_participants,
            price_adult, price_child, price_infant, discount_percentage,
            featured_image, status, created_by
        } = data;

        const result = await query(
            `INSERT INTO tours (
        tour_code, title, category_id, destination_id, description,
        duration_days, duration_nights, max_participants, min_participants,
        price_adult, price_child, price_infant, discount_percentage,
        featured_image, status, created_by
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)
      RETURNING *`,
            [
                tour_code, title, category_id, destination_id, description,
                duration_days, duration_nights, max_participants, min_participants || 1,
                price_adult, price_child, price_infant, discount_percentage || 0,
                featured_image, status || 'draft', created_by
            ]
        );
        return result.rows[0];
    }

    // Update tour
    static async update(id, data) {
        const fields = [];
        const values = [];
        let paramCount = 1;

        const allowedFields = [
            'title', 'category_id', 'destination_id', 'description',
            'duration_days', 'duration_nights', 'max_participants', 'min_participants',
            'price_adult', 'price_child', 'price_infant', 'discount_percentage',
            'featured_image', 'status'
        ];

        allowedFields.forEach(field => {
            if (data[field] !== undefined) {
                fields.push(`${field} = $${paramCount++}`);
                values.push(data[field]);
            }
        });

        if (fields.length === 0) {
            throw new Error('No fields to update');
        }

        values.push(id);
        const queryText = `UPDATE tours SET ${fields.join(', ')} WHERE tour_id = $${paramCount} RETURNING *`;

        const result = await query(queryText, values);
        return result.rows[0];
    }

    // Delete tour
    static async delete(id) {
        const result = await query(
            'DELETE FROM tours WHERE tour_id = $1 RETURNING *',
            [id]
        );
        return result.rows[0];
    }

    // Get tour images
    static async getImages(tourId) {
        const result = await query(
            `SELECT ti.*, u.username as uploaded_by_username
       FROM tour_images ti
       LEFT JOIN users u ON ti.uploaded_by = u.user_id
       WHERE ti.tour_id = $1
       ORDER BY ti.display_order, ti.image_id`,
            [tourId]
        );
        return result.rows;
    }

    // Add tour image
    static async addImage(data) {
        const { tour_id, image_url, caption, display_order, uploaded_by } = data;
        const result = await query(
            `INSERT INTO tour_images (tour_id, image_url, caption, display_order, uploaded_by)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING *`,
            [tour_id, image_url, caption, display_order || 0, uploaded_by]
        );
        return result.rows[0];
    }

    // Delete tour image
    static async deleteImage(imageId) {
        const result = await query(
            'DELETE FROM tour_images WHERE image_id = $1 RETURNING *',
            [imageId]
        );
        return result.rows[0];
    }

    // Get featured tours
    static async getFeatured(limit = 6) {
        const result = await query(
            `SELECT t.*, tc.category_name, d.name as destination_name
       FROM tours t
       LEFT JOIN tour_categories tc ON t.category_id = tc.category_id
       LEFT JOIN destinations d ON t.destination_id = d.destination_id
       WHERE t.status = 'published' AND t.discount_percentage > 0
       ORDER BY t.discount_percentage DESC, t.created_at DESC
       LIMIT $1`,
            [limit]
        );
        return result.rows;
    }

    // Search tours
    static async search(searchTerm, filters = {}) {
        let queryText = `
      SELECT t.*, tc.category_name, d.name as destination_name
      FROM tours t
      LEFT JOIN tour_categories tc ON t.category_id = tc.category_id
      LEFT JOIN destinations d ON t.destination_id = d.destination_id
      WHERE t.status = 'published'
      AND (t.title ILIKE $1 OR t.description ILIKE $1 OR d.name ILIKE $1)
    `;
        const params = [`%${searchTerm}%`];
        let paramCount = 2;

        if (filters.min_price) {
            queryText += ` AND t.price_adult >= $${paramCount++}`;
            params.push(filters.min_price);
        }

        if (filters.max_price) {
            queryText += ` AND t.price_adult <= $${paramCount++}`;
            params.push(filters.max_price);
        }

        if (filters.duration_days) {
            queryText += ` AND t.duration_days = $${paramCount++}`;
            params.push(filters.duration_days);
        }

        queryText += ' ORDER BY t.created_at DESC';

        const result = await query(queryText, params);
        return result.rows;
    }
}

module.exports = Tour;
