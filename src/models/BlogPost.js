const { query } = require('../config/database');

class BlogPost {
    // Generate slug from title
    static generateSlug(title) {
        return title
            .toLowerCase()
            .normalize('NFD')
            .replace(/[\u0300-\u036f]/g, '') // Remove diacritics
            .replace(/đ/g, 'd')
            .replace(/[^a-z0-9\s-]/g, '')
            .trim()
            .replace(/\s+/g, '-')
            .replace(/-+/g, '-');
    }

    // Get all blog posts with filters
    static async findAll(filters = {}) {
        let queryText = `
      SELECT bp.*,
             u.username as author_username, u.full_name as author_fullname
      FROM blog_posts bp
      LEFT JOIN users u ON bp.author_id = u.user_id
      WHERE 1=1
    `;
        const params = [];
        let paramCount = 1;

        if (filters.status) {
            queryText += ` AND bp.status = $${paramCount++}`;
            params.push(filters.status);
        }

        if (filters.author_id) {
            queryText += ` AND bp.author_id = $${paramCount++}`;
            params.push(filters.author_id);
        }

        if (filters.search) {
            queryText += ` AND (bp.title ILIKE $${paramCount} OR bp.content ILIKE $${paramCount})`;
            params.push(`%${filters.search}%`);
            paramCount++;
        }

        queryText += ' ORDER BY bp.created_at DESC';

        if (filters.limit) {
            queryText += ` LIMIT $${paramCount++}`;
            params.push(filters.limit);
        }

        if (filters.offset) {
            queryText += ` OFFSET $${paramCount++}`;
            params.push(filters.offset);
        }

        const result = await query(queryText, params);
        return result.rows;
    }

    // Get blog post by ID
    static async findById(id) {
        const result = await query(
            `SELECT bp.*,
              u.username as author_username, u.full_name as author_fullname, u.avatar_url as author_avatar
       FROM blog_posts bp
       LEFT JOIN users u ON bp.author_id = u.user_id
       WHERE bp.post_id = $1`,
            [id]
        );
        return result.rows[0];
    }

    // Get blog post by slug
    static async findBySlug(slug) {
        const result = await query(
            `SELECT bp.*,
              u.username as author_username, u.full_name as author_fullname, u.avatar_url as author_avatar
       FROM blog_posts bp
       LEFT JOIN users u ON bp.author_id = u.user_id
       WHERE bp.slug = $1`,
            [slug]
        );
        return result.rows[0];
    }

    // Create new blog post
    static async create(data) {
        const { title, content, excerpt, featured_image, author_id, status } = data;
        const slug = this.generateSlug(title);

        const result = await query(
            `INSERT INTO blog_posts (title, slug, content, excerpt, featured_image, author_id, status)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING *`,
            [title, slug, content, excerpt, featured_image, author_id, status || 'draft']
        );
        return result.rows[0];
    }

    // Update blog post
    static async update(id, data) {
        const fields = [];
        const values = [];
        let paramCount = 1;

        const allowedFields = ['title', 'content', 'excerpt', 'featured_image', 'status'];

        allowedFields.forEach(field => {
            if (data[field] !== undefined) {
                if (field === 'title') {
                    fields.push(`title = $${paramCount++}`);
                    values.push(data.title);
                    fields.push(`slug = $${paramCount++}`);
                    values.push(this.generateSlug(data.title));
                } else {
                    fields.push(`${field} = $${paramCount++}`);
                    values.push(data[field]);
                }
            }
        });

        if (fields.length === 0) {
            throw new Error('No fields to update');
        }

        values.push(id);
        const queryText = `UPDATE blog_posts SET ${fields.join(', ')} WHERE post_id = $${paramCount} RETURNING *`;

        const result = await query(queryText, values);
        return result.rows[0];
    }

    // Publish blog post
    static async publish(id) {
        const result = await query(
            `UPDATE blog_posts
       SET status = 'published', published_at = CURRENT_TIMESTAMP
       WHERE post_id = $1
       RETURNING *`,
            [id]
        );
        return result.rows[0];
    }

    // Delete blog post
    static async delete(id) {
        const result = await query(
            'DELETE FROM blog_posts WHERE post_id = $1 RETURNING *',
            [id]
        );
        return result.rows[0];
    }

    // Get published posts
    static async getPublished(limit = 10) {
        const result = await query(
            `SELECT bp.*,
              u.username as author_username, u.full_name as author_fullname
       FROM blog_posts bp
       LEFT JOIN users u ON bp.author_id = u.user_id
       WHERE bp.status = 'published'
       ORDER BY bp.published_at DESC
       LIMIT $1`,
            [limit]
        );
        return result.rows;
    }

    // Get posts by author
    static async findByAuthor(authorId) {
        const result = await query(
            `SELECT * FROM blog_posts
       WHERE author_id = $1
       ORDER BY created_at DESC`,
            [authorId]
        );
        return result.rows;
    }

    // Increment view count
    static async incrementViewCount(id) {
        const result = await query(
            `UPDATE blog_posts
       SET view_count = COALESCE(view_count, 0) + 1
       WHERE post_id = $1
       RETURNING *`,
            [id]
        );
        return result.rows[0];
    }
}

module.exports = BlogPost;
