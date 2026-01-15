const BlogPost = require('../models/BlogPost');

class BlogController {
    static async getAll(req, res, next) {
        try {
            const filters = {
                status: req.query.status,
                author_id: req.query.author_id,
                search: req.query.search,
                limit: req.query.limit,
                offset: req.query.offset
            };
            const posts = await BlogPost.findAll(filters);
            res.json({ success: true, data: posts, count: posts.length });
        } catch (error) {
            next(error);
        }
    }

    static async getById(req, res, next) {
        try {
            const post = await BlogPost.findById(req.params.id);
            if (!post) return res.status(404).json({ success: false, message: 'Post not found' });
            res.json({ success: true, data: post });
        } catch (error) {
            next(error);
        }
    }

    static async getBySlug(req, res, next) {
        try {
            const post = await BlogPost.findBySlug(req.params.slug);
            if (!post) return res.status(404).json({ success: false, message: 'Post not found' });
            res.json({ success: true, data: post });
        } catch (error) {
            next(error);
        }
    }

    static async create(req, res, next) {
        try {
            const post = await BlogPost.create({ ...req.body, author_id: req.user.user_id });
            res.status(201).json({ success: true, message: 'Post created successfully', data: post });
        } catch (error) {
            next(error);
        }
    }

    static async update(req, res, next) {
        try {
            const post = await BlogPost.update(req.params.id, req.body);
            if (!post) return res.status(404).json({ success: false, message: 'Post not found' });
            res.json({ success: true, message: 'Post updated successfully', data: post });
        } catch (error) {
            next(error);
        }
    }

    static async publish(req, res, next) {
        try {
            const post = await BlogPost.publish(req.params.id);
            if (!post) return res.status(404).json({ success: false, message: 'Post not found' });
            res.json({ success: true, message: 'Post published successfully', data: post });
        } catch (error) {
            next(error);
        }
    }

    static async delete(req, res, next) {
        try {
            const post = await BlogPost.delete(req.params.id);
            if (!post) return res.status(404).json({ success: false, message: 'Post not found' });
            res.json({ success: true, message: 'Post deleted successfully' });
        } catch (error) {
            next(error);
        }
    }

    static async getPublished(req, res, next) {
        try {
            const posts = await BlogPost.getPublished(req.query.limit || 10);
            res.json({ success: true, data: posts, count: posts.length });
        } catch (error) {
            next(error);
        }
    }

    static async incrementViewCount(req, res, next) {
        try {
            const post = await BlogPost.incrementViewCount(req.params.id);
            if (!post) return res.status(404).json({ success: false, message: 'Post not found' });
            res.json({ success: true, message: 'View count incremented', data: post });
        } catch (error) {
            next(error);
        }
    }
}

module.exports = BlogController;
