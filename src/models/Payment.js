const { query } = require('../config/database');

class Payment {
    // Get all payments with filters
    static async findAll(filters = {}) {
        let queryText = `
      SELECT p.*,
             b.booking_code, b.customer_name,
             u.username as processed_by_username
      FROM payments p
      LEFT JOIN bookings b ON p.booking_id = b.booking_id
      LEFT JOIN users u ON p.processed_by = u.user_id
      WHERE 1=1
    `;
        const params = [];
        let paramCount = 1;

        if (filters.booking_id) {
            queryText += ` AND p.booking_id = $${paramCount++}`;
            params.push(filters.booking_id);
        }

        if (filters.payment_status) {
            queryText += ` AND p.payment_status = $${paramCount++}`;
            params.push(filters.payment_status);
        }

        if (filters.payment_method) {
            queryText += ` AND p.payment_method = $${paramCount++}`;
            params.push(filters.payment_method);
        }

        queryText += ' ORDER BY p.payment_date DESC';

        const result = await query(queryText, params);
        return result.rows;
    }

    // Get payment by ID
    static async findById(id) {
        const result = await query(
            `SELECT p.*,
              b.booking_code, b.customer_name, b.customer_email, b.total_amount as booking_total,
              u.username as processed_by_username, u.full_name as processed_by_fullname
       FROM payments p
       LEFT JOIN bookings b ON p.booking_id = b.booking_id
       LEFT JOIN users u ON p.processed_by = u.user_id
       WHERE p.payment_id = $1`,
            [id]
        );
        return result.rows[0];
    }

    // Get payment by transaction ID
    static async findByTransactionId(transactionId) {
        const result = await query(
            'SELECT * FROM payments WHERE transaction_id = $1',
            [transactionId]
        );
        return result.rows[0];
    }

    // Create new payment
    static async create(data) {
        const {
            booking_id, payment_method, amount, transaction_id,
            payment_status, processed_by, notes
        } = data;

        const result = await query(
            `INSERT INTO payments (
        booking_id, payment_method, amount, transaction_id,
        payment_status, processed_by, notes
      ) VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING *`,
            [
                booking_id, payment_method, amount, transaction_id,
                payment_status || 'pending', processed_by, notes
            ]
        );
        return result.rows[0];
    }

    // Update payment status
    static async updateStatus(id, status, processedBy) {
        const result = await query(
            `UPDATE payments 
       SET payment_status = $1, processed_by = $2
       WHERE payment_id = $3
       RETURNING *`,
            [status, processedBy, id]
        );
        return result.rows[0];
    }

    // Update payment
    static async update(id, data) {
        const fields = [];
        const values = [];
        let paramCount = 1;

        const allowedFields = ['payment_method', 'amount', 'transaction_id', 'payment_status', 'notes'];

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
        const queryText = `UPDATE payments SET ${fields.join(', ')} WHERE payment_id = $${paramCount} RETURNING *`;

        const result = await query(queryText, values);
        return result.rows[0];
    }

    // Get payments for a booking
    static async findByBooking(bookingId) {
        const result = await query(
            `SELECT p.*, u.username as processed_by_username
       FROM payments p
       LEFT JOIN users u ON p.processed_by = u.user_id
       WHERE p.booking_id = $1
       ORDER BY p.payment_date DESC`,
            [bookingId]
        );
        return result.rows;
    }

    // Get payment statistics
    static async getStatistics(filters = {}) {
        let queryText = `
      SELECT 
        COUNT(*) as total_payments,
        COUNT(CASE WHEN payment_status = 'completed' THEN 1 END) as completed_payments,
        COUNT(CASE WHEN payment_status = 'pending' THEN 1 END) as pending_payments,
        COUNT(CASE WHEN payment_status = 'failed' THEN 1 END) as failed_payments,
        SUM(CASE WHEN payment_status = 'completed' THEN amount ELSE 0 END) as total_revenue,
        SUM(amount) as total_amount
      FROM payments
      WHERE 1=1
    `;
        const params = [];
        let paramCount = 1;

        if (filters.from_date) {
            queryText += ` AND payment_date >= $${paramCount++}`;
            params.push(filters.from_date);
        }

        if (filters.to_date) {
            queryText += ` AND payment_date <= $${paramCount++}`;
            params.push(filters.to_date);
        }

        const result = await query(queryText, params);
        return result.rows[0];
    }
}

module.exports = Payment;
