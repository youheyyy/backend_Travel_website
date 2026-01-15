const { query, getClient } = require('../config/database');

class Promotion {
    // Get all promotions with filters
    static async findAll(filters = {}) {
        let queryText = `
      SELECT p.*,
             u.username as created_by_username
      FROM promotions p
      LEFT JOIN users u ON p.created_by = u.user_id
      WHERE 1=1
    `;
        const params = [];
        let paramCount = 1;

        if (filters.status) {
            queryText += ` AND p.status = $${paramCount++}`;
            params.push(filters.status);
        }

        if (filters.active_only) {
            queryText += ` AND p.status = 'active' AND p.valid_from <= CURRENT_DATE AND p.valid_to >= CURRENT_DATE`;
        }

        queryText += ' ORDER BY p.created_at DESC';

        const result = await query(queryText, params);
        return result.rows;
    }

    // Get promotion by ID
    static async findById(id) {
        const result = await query(
            `SELECT p.*,
              u.username as created_by_username, u.full_name as created_by_fullname
       FROM promotions p
       LEFT JOIN users u ON p.created_by = u.user_id
       WHERE p.promotion_id = $1`,
            [id]
        );
        return result.rows[0];
    }

    // Get promotion by code
    static async findByCode(code) {
        const result = await query(
            'SELECT * FROM promotions WHERE code = $1',
            [code]
        );
        return result.rows[0];
    }

    // Create new promotion
    static async create(data) {
        const {
            code, description, discount_type, discount_value,
            max_discount_amount, min_purchase_amount, usage_limit,
            valid_from, valid_to, status, created_by
        } = data;

        const result = await query(
            `INSERT INTO promotions (
        code, description, discount_type, discount_value,
        max_discount_amount, min_purchase_amount, usage_limit,
        valid_from, valid_to, status, created_by
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
      RETURNING *`,
            [
                code, description, discount_type, discount_value,
                max_discount_amount, min_purchase_amount, usage_limit,
                valid_from, valid_to, status || 'active', created_by
            ]
        );
        return result.rows[0];
    }

    // Update promotion
    static async update(id, data) {
        const fields = [];
        const values = [];
        let paramCount = 1;

        const allowedFields = [
            'description', 'discount_type', 'discount_value',
            'max_discount_amount', 'min_purchase_amount', 'usage_limit',
            'valid_from', 'valid_to', 'status'
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
        const queryText = `UPDATE promotions SET ${fields.join(', ')} WHERE promotion_id = $${paramCount} RETURNING *`;

        const result = await query(queryText, values);
        return result.rows[0];
    }

    // Delete promotion
    static async delete(id) {
        const result = await query(
            'DELETE FROM promotions WHERE promotion_id = $1 RETURNING *',
            [id]
        );
        return result.rows[0];
    }

    // Validate promotion code
    static async validate(code, purchaseAmount) {
        const result = await query(
            `SELECT *,
        CASE
          WHEN status != 'active' THEN 'Promotion is not active'
          WHEN valid_from > CURRENT_DATE THEN 'Promotion has not started yet'
          WHEN valid_to < CURRENT_DATE THEN 'Promotion has expired'
          WHEN usage_limit IS NOT NULL AND used_count >= usage_limit THEN 'Promotion usage limit reached'
          WHEN min_purchase_amount IS NOT NULL AND $2 < min_purchase_amount THEN 'Minimum purchase amount not met'
          ELSE 'valid'
        END as validation_status
       FROM promotions
       WHERE code = $1`,
            [code, purchaseAmount]
        );

        const promotion = result.rows[0];
        if (!promotion) {
            return { valid: false, message: 'Invalid promotion code' };
        }

        if (promotion.validation_status !== 'valid') {
            return { valid: false, message: promotion.validation_status, promotion };
        }

        return { valid: true, promotion };
    }

    // Calculate discount amount
    static calculateDiscount(promotion, purchaseAmount) {
        let discountAmount = 0;

        if (promotion.discount_type === 'percentage') {
            discountAmount = (purchaseAmount * promotion.discount_value) / 100;
            if (promotion.max_discount_amount && discountAmount > promotion.max_discount_amount) {
                discountAmount = promotion.max_discount_amount;
            }
        } else if (promotion.discount_type === 'fixed_amount') {
            discountAmount = promotion.discount_value;
        }

        return Math.min(discountAmount, purchaseAmount);
    }

    // Use promotion
    static async use(promotionId, bookingId, userId, discountAmount) {
        const client = await getClient();

        try {
            await client.query('BEGIN');

            // Record usage
            await client.query(
                `INSERT INTO promotion_usage (promotion_id, booking_id, user_id, discount_amount)
         VALUES ($1, $2, $3, $4)`,
                [promotionId, bookingId, userId, discountAmount]
            );

            // Increment used count
            await client.query(
                'UPDATE promotions SET used_count = used_count + 1 WHERE promotion_id = $1',
                [promotionId]
            );

            await client.query('COMMIT');
            return true;
        } catch (error) {
            await client.query('ROLLBACK');
            throw error;
        } finally {
            client.release();
        }
    }

    // Get promotion usage history
    static async getUsageHistory(promotionId) {
        const result = await query(
            `SELECT pu.*,
              b.booking_code,
              u.username as user_username, u.full_name as user_fullname
       FROM promotion_usage pu
       LEFT JOIN bookings b ON pu.booking_id = b.booking_id
       LEFT JOIN users u ON pu.user_id = u.user_id
       WHERE pu.promotion_id = $1
       ORDER BY pu.used_at DESC`,
            [promotionId]
        );
        return result.rows;
    }

    // Get active promotions
    static async getActive() {
        const result = await query(
            `SELECT * FROM promotions
       WHERE status = 'active'
       AND valid_from <= CURRENT_DATE
       AND valid_to >= CURRENT_DATE
       AND (usage_limit IS NULL OR used_count < usage_limit)
       ORDER BY discount_value DESC`
        );
        return result.rows;
    }
}

module.exports = Promotion;
