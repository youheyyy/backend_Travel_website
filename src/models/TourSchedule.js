const { query } = require('../config/database');

class TourSchedule {
    // Get all schedules with filters
    static async findAll(filters = {}) {
        let queryText = `
      SELECT ts.*, 
             t.title as tour_title, t.tour_code,
             u.username as guide_username, u.full_name as guide_fullname
      FROM tour_schedules ts
      LEFT JOIN tours t ON ts.tour_id = t.tour_id
      LEFT JOIN users u ON ts.guide_id = u.user_id
      WHERE 1=1
    `;
        const params = [];
        let paramCount = 1;

        if (filters.tour_id) {
            queryText += ` AND ts.tour_id = $${paramCount++}`;
            params.push(filters.tour_id);
        }

        if (filters.status) {
            queryText += ` AND ts.status = $${paramCount++}`;
            params.push(filters.status);
        }

        if (filters.from_date) {
            queryText += ` AND ts.departure_date >= $${paramCount++}`;
            params.push(filters.from_date);
        }

        if (filters.to_date) {
            queryText += ` AND ts.departure_date <= $${paramCount++}`;
            params.push(filters.to_date);
        }

        queryText += ' ORDER BY ts.departure_date ASC';

        const result = await query(queryText, params);
        return result.rows;
    }

    // Get schedule by ID
    static async findById(id) {
        const result = await query(
            `SELECT ts.*, 
              t.title as tour_title, t.tour_code, t.price_adult, t.price_child, t.price_infant,
              u.username as guide_username, u.full_name as guide_fullname
       FROM tour_schedules ts
       LEFT JOIN tours t ON ts.tour_id = t.tour_id
       LEFT JOIN users u ON ts.guide_id = u.user_id
       WHERE ts.schedule_id = $1`,
            [id]
        );
        return result.rows[0];
    }

    // Create new schedule
    static async create(data) {
        const {
            tour_id, departure_date, return_date, available_slots,
            booked_slots, status, guide_id
        } = data;

        const result = await query(
            `INSERT INTO tour_schedules (
        tour_id, departure_date, return_date, available_slots,
        booked_slots, status, guide_id
      ) VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING *`,
            [
                tour_id, departure_date, return_date, available_slots,
                booked_slots || 0, status || 'available', guide_id
            ]
        );
        return result.rows[0];
    }

    // Update schedule
    static async update(id, data) {
        const fields = [];
        const values = [];
        let paramCount = 1;

        const allowedFields = [
            'departure_date', 'return_date', 'available_slots',
            'booked_slots', 'status', 'guide_id'
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
        const queryText = `UPDATE tour_schedules SET ${fields.join(', ')} WHERE schedule_id = $${paramCount} RETURNING *`;

        const result = await query(queryText, values);
        return result.rows[0];
    }

    // Delete schedule
    static async delete(id) {
        const result = await query(
            'DELETE FROM tour_schedules WHERE schedule_id = $1 RETURNING *',
            [id]
        );
        return result.rows[0];
    }

    // Update booked slots
    static async updateBookedSlots(id, increment) {
        const result = await query(
            `UPDATE tour_schedules 
       SET booked_slots = booked_slots + $1
       WHERE schedule_id = $2
       RETURNING *`,
            [increment, id]
        );
        return result.rows[0];
    }

    // Check availability
    static async checkAvailability(id, requiredSlots) {
        const result = await query(
            `SELECT 
        (available_slots - booked_slots) >= $1 as is_available,
        (available_slots - booked_slots) as remaining_slots
       FROM tour_schedules
       WHERE schedule_id = $2`,
            [requiredSlots, id]
        );
        return result.rows[0];
    }

    // Get upcoming schedules for a tour
    static async getUpcoming(tourId, limit = 10) {
        const result = await query(
            `SELECT ts.*, u.username as guide_username
       FROM tour_schedules ts
       LEFT JOIN users u ON ts.guide_id = u.user_id
       WHERE ts.tour_id = $1 
       AND ts.departure_date >= CURRENT_DATE
       AND ts.status = 'available'
       ORDER BY ts.departure_date ASC
       LIMIT $2`,
            [tourId, limit]
        );
        return result.rows;
    }

    // Auto-update status based on availability
    static async autoUpdateStatus(id) {
        const result = await query(
            `UPDATE tour_schedules
       SET status = CASE
         WHEN booked_slots >= available_slots THEN 'full'
         WHEN departure_date < CURRENT_DATE THEN 'cancelled'
         ELSE 'available'
       END
       WHERE schedule_id = $1
       RETURNING *`,
            [id]
        );
        return result.rows[0];
    }
}

module.exports = TourSchedule;
