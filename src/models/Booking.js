const { query, getClient } = require('../config/database');

class Booking {
    // Generate unique booking code
    static generateBookingCode() {
        const prefix = 'BK';
        const timestamp = Date.now().toString(36).toUpperCase();
        const random = Math.random().toString(36).substring(2, 6).toUpperCase();
        return `${prefix}${timestamp}${random}`;
    }

    // Get all bookings with filters
    static async findAll(filters = {}) {
        let queryText = `
      SELECT b.*,
             ts.departure_date, ts.return_date,
             t.title as tour_title, t.tour_code,
             u.username as user_username,
             cu.username as confirmed_by_username
      FROM bookings b
      LEFT JOIN tour_schedules ts ON b.schedule_id = ts.schedule_id
      LEFT JOIN tours t ON ts.tour_id = t.tour_id
      LEFT JOIN users u ON b.user_id = u.user_id
      LEFT JOIN users cu ON b.confirmed_by = cu.user_id
      WHERE 1=1
    `;
        const params = [];
        let paramCount = 1;

        if (filters.user_id) {
            queryText += ` AND b.user_id = $${paramCount++}`;
            params.push(filters.user_id);
        }

        if (filters.booking_status) {
            queryText += ` AND b.booking_status = $${paramCount++}`;
            params.push(filters.booking_status);
        }

        if (filters.payment_status) {
            queryText += ` AND b.payment_status = $${paramCount++}`;
            params.push(filters.payment_status);
        }

        if (filters.from_date) {
            queryText += ` AND b.created_at >= $${paramCount++}`;
            params.push(filters.from_date);
        }

        queryText += ' ORDER BY b.created_at DESC';

        const result = await query(queryText, params);
        return result.rows;
    }

    // Get booking by ID with full details
    static async findById(id) {
        const result = await query(
            `SELECT b.*,
              ts.departure_date, ts.return_date, ts.available_slots, ts.booked_slots,
              t.title as tour_title, t.tour_code, t.duration_days, t.duration_nights,
              t.price_adult, t.price_child, t.price_infant,
              d.name as destination_name,
              u.username as user_username, u.email as user_email, u.phone as user_phone,
              cu.username as confirmed_by_username
       FROM bookings b
       LEFT JOIN tour_schedules ts ON b.schedule_id = ts.schedule_id
       LEFT JOIN tours t ON ts.tour_id = t.tour_id
       LEFT JOIN destinations d ON t.destination_id = d.destination_id
       LEFT JOIN users u ON b.user_id = u.user_id
       LEFT JOIN users cu ON b.confirmed_by = cu.user_id
       WHERE b.booking_id = $1`,
            [id]
        );
        return result.rows[0];
    }

    // Get booking by code
    static async findByCode(code) {
        const result = await query(
            'SELECT * FROM bookings WHERE booking_code = $1',
            [code]
        );
        return result.rows[0];
    }

    // Create new booking with participants
    static async create(data) {
        const client = await getClient();

        try {
            await client.query('BEGIN');

            const {
                schedule_id, tour_id, departure_date,
                user_id, customer_name, customer_email, customer_phone,
                num_adults, num_children, num_infants, total_amount,
                special_requests, participants
            } = data;

            let finalScheduleId = schedule_id;

            // If no schedule_id provided, try to find or create one
            if (!finalScheduleId && tour_id && departure_date) {
                // Try to find existing schedule
                const scheduleResult = await client.query(
                    'SELECT schedule_id FROM tour_schedules WHERE tour_id = $1 AND departure_date = $2',
                    [tour_id, departure_date]
                );

                if (scheduleResult.rows.length > 0) {
                    finalScheduleId = scheduleResult.rows[0].schedule_id;
                } else {
                    // Get tour duration to calculate return_date
                    const tourResult = await client.query(
                        'SELECT duration_days FROM tours WHERE tour_id = $1',
                        [tour_id]
                    );

                    if (tourResult.rows.length === 0) {
                        throw new Error('Tour not found');
                    }

                    const durationDays = tourResult.rows[0].duration_days;
                    const departureDateTime = new Date(departure_date);
                    const returnDateTime = new Date(departureDateTime);
                    returnDateTime.setDate(returnDateTime.getDate() + durationDays - 1);
                    const return_date = returnDateTime.toISOString().split('T')[0];

                    // Create new schedule
                    const newScheduleResult = await client.query(
                        `INSERT INTO tour_schedules (tour_id, departure_date, return_date, available_slots, booked_slots, status)
                         VALUES ($1, $2, $3, 50, 0, 'available')
                         RETURNING schedule_id`,
                        [tour_id, departure_date, return_date]
                    );
                    finalScheduleId = newScheduleResult.rows[0].schedule_id;
                }
            }

            if (!finalScheduleId) {
                throw new Error('Schedule ID is required or provide tour_id and departure_date');
            }

            const booking_code = this.generateBookingCode();

            // Create booking
            const bookingResult = await client.query(
                `INSERT INTO bookings (
          booking_code, schedule_id, user_id, customer_name, customer_email, customer_phone,
          num_adults, num_children, num_infants, total_amount, special_requests
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
        RETURNING *`,
                [
                    booking_code, finalScheduleId, user_id, customer_name, customer_email, customer_phone,
                    num_adults || 0, num_children || 0, num_infants || 0, total_amount, special_requests
                ]
            );

            const booking = bookingResult.rows[0];

            // Add participants if provided
            if (participants && participants.length > 0) {
                for (const participant of participants) {
                    await client.query(
                        `INSERT INTO booking_participants (booking_id, full_name, date_of_birth, passport_number, participant_type)
             VALUES ($1, $2, $3, $4, $5)`,
                        [booking.booking_id, participant.full_name, participant.date_of_birth,
                        participant.passport_number, participant.participant_type]
                    );
                }
            }

            // Update schedule booked slots
            const totalParticipants = (num_adults || 0) + (num_children || 0) + (num_infants || 0);
            await client.query(
                'UPDATE tour_schedules SET booked_slots = booked_slots + $1 WHERE schedule_id = $2',
                [totalParticipants, finalScheduleId]
            );

            await client.query('COMMIT');
            return booking;
        } catch (error) {
            await client.query('ROLLBACK');
            throw error;
        } finally {
            client.release();
        }
    }

    // Update booking
    static async update(id, data) {
        const fields = [];
        const values = [];
        let paramCount = 1;

        const allowedFields = [
            'customer_name', 'customer_email', 'customer_phone',
            'num_adults', 'num_children', 'num_infants', 'total_amount',
            'paid_amount', 'payment_status', 'booking_status', 'special_requests'
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
        const queryText = `UPDATE bookings SET ${fields.join(', ')} WHERE booking_id = $${paramCount} RETURNING *`;

        const result = await query(queryText, values);
        return result.rows[0];
    }

    // Confirm booking
    static async confirm(id, confirmedBy) {
        const result = await query(
            `UPDATE bookings 
       SET booking_status = 'confirmed', confirmed_by = $1, confirmed_at = CURRENT_TIMESTAMP
       WHERE booking_id = $2
       RETURNING *`,
            [confirmedBy, id]
        );
        return result.rows[0];
    }

    // Cancel booking
    static async cancel(id) {
        const client = await getClient();

        try {
            await client.query('BEGIN');

            // Get booking details
            const bookingResult = await client.query(
                'SELECT * FROM bookings WHERE booking_id = $1',
                [id]
            );
            const booking = bookingResult.rows[0];

            if (!booking) {
                throw new Error('Booking not found');
            }

            // Update booking status
            await client.query(
                'UPDATE bookings SET booking_status = $1 WHERE booking_id = $2',
                ['cancelled', id]
            );

            // Return slots to schedule
            const totalParticipants = booking.num_adults + booking.num_children + booking.num_infants;
            await client.query(
                'UPDATE tour_schedules SET booked_slots = booked_slots - $1 WHERE schedule_id = $2',
                [totalParticipants, booking.schedule_id]
            );

            await client.query('COMMIT');
            return booking;
        } catch (error) {
            await client.query('ROLLBACK');
            throw error;
        } finally {
            client.release();
        }
    }

    // Get booking participants
    static async getParticipants(bookingId) {
        const result = await query(
            'SELECT * FROM booking_participants WHERE booking_id = $1 ORDER BY participant_id',
            [bookingId]
        );
        return result.rows;
    }

    // Add participant
    static async addParticipant(data) {
        const { booking_id, full_name, date_of_birth, passport_number, participant_type } = data;
        const result = await query(
            `INSERT INTO booking_participants (booking_id, full_name, date_of_birth, passport_number, participant_type)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING *`,
            [booking_id, full_name, date_of_birth, passport_number, participant_type]
        );
        return result.rows[0];
    }

    // Update payment status
    static async updatePaymentStatus(id, paidAmount, paymentStatus) {
        const result = await query(
            `UPDATE bookings 
       SET paid_amount = $1, payment_status = $2
       WHERE booking_id = $3
       RETURNING *`,
            [paidAmount, paymentStatus, id]
        );
        return result.rows[0];
    }

    // Find booking by ID
    static async findById(id) {
        const result = await query(
            `SELECT b.*, ts.departure_date, ts.return_date, t.title as tour_title
       FROM bookings b
       LEFT JOIN tour_schedules ts ON b.schedule_id = ts.schedule_id
       LEFT JOIN tours t ON ts.tour_id = t.tour_id
       WHERE b.booking_id = $1`,
            [id]
        );
        return result.rows[0];
    }

    // Find booking by booking code
    static async findByCode(code) {
        const result = await query(
            `SELECT b.*, ts.departure_date, ts.return_date, t.title as tour_title, t.tour_id
       FROM bookings b
       LEFT JOIN tour_schedules ts ON b.schedule_id = ts.schedule_id
       LEFT JOIN tours t ON ts.tour_id = t.tour_id
       WHERE b.booking_code = $1`,
            [code]
        );
        return result.rows[0];
    }

    // Get user bookings
    static async findByUser(userId) {
        const result = await query(
            `SELECT b.*,
              ts.departure_date, ts.return_date,
              t.title as tour_title, t.tour_code, t.featured_image
       FROM bookings b
       LEFT JOIN tour_schedules ts ON b.schedule_id = ts.schedule_id
       LEFT JOIN tours t ON ts.tour_id = t.tour_id
       WHERE b.user_id = $1
       ORDER BY b.created_at DESC`,
            [userId]
        );
        return result.rows;
    }

    // Get booking statistics
    static async getStatistics(filters = {}) {
        let queryText = `
      SELECT 
        COUNT(*) as total_bookings,
        COUNT(CASE WHEN booking_status = 'confirmed' THEN 1 END) as confirmed_bookings,
        COUNT(CASE WHEN booking_status = 'pending' THEN 1 END) as pending_bookings,
        COUNT(CASE WHEN booking_status = 'cancelled' THEN 1 END) as cancelled_bookings,
        SUM(total_amount) as total_revenue,
        SUM(paid_amount) as total_paid,
        SUM(num_adults + num_children + num_infants) as total_participants
      FROM bookings
      WHERE 1=1
    `;
        const params = [];
        let paramCount = 1;

        if (filters.from_date) {
            queryText += ` AND created_at >= $${paramCount++}`;
            params.push(filters.from_date);
        }

        if (filters.to_date) {
            queryText += ` AND created_at <= $${paramCount++}`;
            params.push(filters.to_date);
        }

        const result = await query(queryText, params);
        return result.rows[0];
    }
}

module.exports = Booking;
