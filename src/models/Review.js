const { query } = require('../config/database');

class Review {
    // Get all reviews with filters
    static async findAll(filters = {}) {
        let queryText = `
      SELECT r.*,
             t.title as tour_title, t.tour_code,
             b.booking_code,
             u.username as user_username, u.full_name as user_fullname,
             ru.username as reviewed_by_username
      FROM reviews r
      LEFT JOIN tours t ON r.tour_id = t.tour_id
      LEFT JOIN bookings b ON r.booking_id = b.booking_id
      LEFT JOIN users u ON r.user_id = u.user_id
      LEFT JOIN users ru ON r.reviewed_by = ru.user_id
      WHERE 1=1
    `;
        const params = [];
        let paramCount = 1;

        if (filters.tour_id) {
            queryText += ` AND r.tour_id = $${paramCount++}`;
            params.push(filters.tour_id);
        }

        if (filters.user_id) {
            queryText += ` AND r.user_id = $${paramCount++}`;
            params.push(filters.user_id);
        }

        if (filters.status) {
            queryText += ` AND r.status = $${paramCount++}`;
            params.push(filters.status);
        }

        if (filters.rating) {
            queryText += ` AND r.rating = $${paramCount++}`;
            params.push(filters.rating);
        }

        queryText += ' ORDER BY r.created_at DESC';

        const result = await query(queryText, params);
        return result.rows;
    }

    // Get review by ID
    static async findById(id) {
        const result = await query(
            `SELECT r.*,
              t.title as tour_title, t.tour_code,
              b.booking_code,
              u.username as user_username, u.full_name as user_fullname, u.avatar_url as user_avatar,
              ru.username as reviewed_by_username
       FROM reviews r
       LEFT JOIN tours t ON r.tour_id = t.tour_id
       LEFT JOIN bookings b ON r.booking_id = b.booking_id
       LEFT JOIN users u ON r.user_id = u.user_id
       LEFT JOIN users ru ON r.reviewed_by = ru.user_id
       WHERE r.review_id = $1`,
            [id]
        );
        return result.rows[0];
    }

    // Create new review
    static async create(data) {
        const { tour_id, booking_id, user_id, rating, title, comment } = data;

        const result = await query(
            `INSERT INTO reviews (tour_id, booking_id, user_id, rating, title, comment, status)
       VALUES ($1, $2, $3, $4, $5, $6, 'pending')
       RETURNING *`,
            [tour_id, booking_id, user_id, rating, title, comment]
        );
        return result.rows[0];
    }

    // Update review
    static async update(id, data) {
        const { rating, title, comment } = data;
        const result = await query(
            `UPDATE reviews
       SET rating = $1, title = $2, comment = $3
       WHERE review_id = $4
       RETURNING *`,
            [rating, title, comment, id]
        );
        return result.rows[0];
    }

    // Approve review
    static async approve(id, reviewedBy) {
        const result = await query(
            `UPDATE reviews
       SET status = 'approved', reviewed_by = $1, reviewed_at = CURRENT_TIMESTAMP
       WHERE review_id = $2
       RETURNING *`,
            [reviewedBy, id]
        );
        return result.rows[0];
    }

    // Reject review
    static async reject(id, reviewedBy) {
        const result = await query(
            `UPDATE reviews
       SET status = 'rejected', reviewed_by = $1, reviewed_at = CURRENT_TIMESTAMP
       WHERE review_id = $2
       RETURNING *`,
            [reviewedBy, id]
        );
        return result.rows[0];
    }

    // Delete review
    static async delete(id) {
        const result = await query(
            'DELETE FROM reviews WHERE review_id = $1 RETURNING *',
            [id]
        );
        return result.rows[0];
    }

    // Get reviews for a tour (approved only)
    static async findByTour(tourId, limit = 10) {
        const result = await query(
            `SELECT r.*,
              u.username as user_username, u.full_name as user_fullname, u.avatar_url as user_avatar
       FROM reviews r
       LEFT JOIN users u ON r.user_id = u.user_id
       WHERE r.tour_id = $1 AND r.status = 'approved'
       ORDER BY r.created_at DESC
       LIMIT $2`,
            [tourId, limit]
        );
        return result.rows;
    }

    // Get average rating for a tour
    static async getTourRating(tourId) {
        const result = await query(
            `SELECT 
        AVG(rating) as average_rating,
        COUNT(*) as total_reviews,
        COUNT(CASE WHEN rating = 5 THEN 1 END) as five_star,
        COUNT(CASE WHEN rating = 4 THEN 1 END) as four_star,
        COUNT(CASE WHEN rating = 3 THEN 1 END) as three_star,
        COUNT(CASE WHEN rating = 2 THEN 1 END) as two_star,
        COUNT(CASE WHEN rating = 1 THEN 1 END) as one_star
       FROM reviews
       WHERE tour_id = $1 AND status = 'approved'`,
            [tourId]
        );
        return result.rows[0];
    }

    // Get user reviews
    static async findByUser(userId) {
        const result = await query(
            `SELECT r.*,
              t.title as tour_title, t.tour_code, t.featured_image
       FROM reviews r
       LEFT JOIN tours t ON r.tour_id = t.tour_id
       WHERE r.user_id = $1
       ORDER BY r.created_at DESC`,
            [userId]
        );
        return result.rows;
    }

    // Get pending reviews
    static async getPending() {
        const result = await query(
            `SELECT r.*,
              t.title as tour_title,
              u.username as user_username, u.full_name as user_fullname
       FROM reviews r
       LEFT JOIN tours t ON r.tour_id = t.tour_id
       LEFT JOIN users u ON r.user_id = u.user_id
       WHERE r.status = 'pending'
       ORDER BY r.created_at ASC`
        );
        return result.rows;
    }
}

module.exports = Review;
