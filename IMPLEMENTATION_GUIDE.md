# Travel Website Backend - Complete API Implementation

## Hướng dẫn tạo nhanh các controllers và routes

Tôi đã tạo tất cả **models** cần thiết. Để hoàn thiện backend, bạn cần tạo các **controllers** và **routes** tương ứng.

### Models đã tạo ✅

1. **User.js** - Quản lý người dùng
2. **Role.js** - Quản lý vai trò
3. **Permission.js** - Quản lý quyền
4. **RolePermission.js** - Quản lý phân quyền
5. **Destination.js** - Quản lý địa điểm
6. **TourCategory.js** - Quản lý danh mục tour
7. **Tour.js** - Quản lý tour (bao gồm images)
8. **TourSchedule.js** - Quản lý lịch trình tour
9. **Booking.js** - Quản lý đặt tour (bao gồm participants)
10. **Payment.js** - Quản lý thanh toán
11. **Review.js** - Quản lý đánh giá
12. **BlogPost.js** - Quản lý bài viết blog
13. **Promotion.js** - Quản lý khuyến mãi
14. **Notification.js** - Quản lý thông báo
15. **SystemSetting.js** - Quản lý cài đặt hệ thống
16. **ActivityLog.js** - Quản lý log hoạt động

### Controllers cần tạo

Tạo file trong `src/controllers/`:

```javascript
// tour.controller.js
const Tour = require('../models/Tour');

class TourController {
  static async getAll(req, res, next) {
    try {
      const filters = {
        status: req.query.status,
        category_id: req.query.category_id,
        destination_id: req.query.destination_id,
        search: req.query.search,
        limit: req.query.limit
      };
      const tours = await Tour.findAll(filters);
      res.json({ success: true, data: tours, count: tours.length });
    } catch (error) {
      next(error);
    }
  }

  static async getById(req, res, next) {
    try {
      const tour = await Tour.findById(req.params.id);
      if (!tour) return res.status(404).json({ success: false, message: 'Tour not found' });
      const images = await Tour.getImages(req.params.id);
      res.json({ success: true, data: { ...tour, images } });
    } catch (error) {
      next(error);
    }
  }

  static async create(req, res, next) {
    try {
      const tour = await Tour.create({ ...req.body, created_by: req.user.user_id });
      res.status(201).json({ success: true, message: 'Tour created successfully', data: tour });
    } catch (error) {
      next(error);
    }
  }

  static async update(req, res, next) {
    try {
      const tour = await Tour.update(req.params.id, req.body);
      if (!tour) return res.status(404).json({ success: false, message: 'Tour not found' });
      res.json({ success: true, message: 'Tour updated successfully', data: tour });
    } catch (error) {
      next(error);
    }
  }

  static async delete(req, res, next) {
    try {
      const tour = await Tour.delete(req.params.id);
      if (!tour) return res.status(404).json({ success: false, message: 'Tour not found' });
      res.json({ success: true, message: 'Tour deleted successfully' });
    } catch (error) {
      next(error);
    }
  }

  static async getFeatured(req, res, next) {
    try {
      const tours = await Tour.getFeatured(req.query.limit || 6);
      res.json({ success: true, data: tours, count: tours.length });
    } catch (error) {
      next(error);
    }
  }

  static async search(req, res, next) {
    try {
      const { q, min_price, max_price, duration_days } = req.query;
      const tours = await Tour.search(q, { min_price, max_price, duration_days });
      res.json({ success: true, data: tours, count: tours.length });
    } catch (error) {
      next(error);
    }
  }

  static async addImage(req, res, next) {
    try {
      const image = await Tour.addImage({ ...req.body, uploaded_by: req.user.user_id });
      res.status(201).json({ success: true, message: 'Image added successfully', data: image });
    } catch (error) {
      next(error);
    }
  }

  static async deleteImage(req, res, next) {
    try {
      const image = await Tour.deleteImage(req.params.imageId);
      if (!image) return res.status(404).json({ success: false, message: 'Image not found' });
      res.json({ success: true, message: 'Image deleted successfully' });
    } catch (error) {
      next(error);
    }
  }
}

module.exports = TourController;
```

### Routes cần tạo

Tạo file trong `src/routes/`:

```javascript
// tour.routes.js
const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const TourController = require('../controllers/tour.controller');
const { authenticate } = require('../middlewares/auth.middleware');
const { requirePermission } = require('../middlewares/permission.middleware');
const validate = require('../middlewares/validate.middleware');

const tourValidation = [
  body('tour_code').trim().notEmpty(),
  body('title').trim().isLength({ min: 5, max: 255 }),
  body('category_id').isInt(),
  body('destination_id').isInt(),
  body('duration_days').isInt({ min: 1 }),
  body('duration_nights').isInt({ min: 0 }),
  body('price_adult').isDecimal({ decimal_digits: '0,2' })
];

// Public routes
router.get('/', TourController.getAll);
router.get('/featured', TourController.getFeatured);
router.get('/search', TourController.search);
router.get('/:id', TourController.getById);

// Protected routes
router.post('/', authenticate, requirePermission('tour.create'), tourValidation, validate, TourController.create);
router.put('/:id', authenticate, requirePermission('tour.edit'), TourController.update);
router.delete('/:id', authenticate, requirePermission('tour.delete'), TourController.delete);
router.post('/:id/images', authenticate, requirePermission('tour.edit'), TourController.addImage);
router.delete('/images/:imageId', authenticate, requirePermission('tour.edit'), TourController.deleteImage);

module.exports = router;
```

### Cập nhật Main Router

Cập nhật `src/routes/index.js`:

```javascript
const express = require('express');
const router = express.Router();

// Import all routes
const authRoutes = require('./auth.routes');
const roleRoutes = require('./role.routes');
const permissionRoutes = require('./permission.routes');
const userRoutes = require('./user.routes');
const destinationRoutes = require('./destination.routes');
const tourCategoryRoutes = require('./tourCategory.routes');
const tourRoutes = require('./tour.routes');
const scheduleRoutes = require('./schedule.routes');
const bookingRoutes = require('./booking.routes');
const paymentRoutes = require('./payment.routes');
const reviewRoutes = require('./review.routes');
const blogRoutes = require('./blog.routes');
const promotionRoutes = require('./promotion.routes');
const notificationRoutes = require('./notification.routes');
const settingRoutes = require('./setting.routes');

// Mount routes
router.use('/auth', authRoutes);
router.use('/roles', roleRoutes);
router.use('/permissions', permissionRoutes);
router.use('/users', userRoutes);
router.use('/destinations', destinationRoutes);
router.use('/tour-categories', tourCategoryRoutes);
router.use('/tours', tourRoutes);
router.use('/schedules', scheduleRoutes);
router.use('/bookings', bookingRoutes);
router.use('/payments', paymentRoutes);
router.use('/reviews', reviewRoutes);
router.use('/blog', blogRoutes);
router.use('/promotions', promotionRoutes);
router.use('/notifications', notificationRoutes);
router.use('/settings', settingRoutes);

// Health check
router.get('/health', (req, res) => {
  res.json({
    success: true,
    message: 'Travel Website API is running',
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

module.exports = router;
```

### Pattern cho tất cả Controllers

Tất cả controllers nên follow pattern này:

```javascript
const Model = require('../models/ModelName');

class ModelController {
  // GET all
  static async getAll(req, res, next) {
    try {
      const items = await Model.findAll(req.query);
      res.json({ success: true, data: items, count: items.length });
    } catch (error) {
      next(error);
    }
  }

  // GET by ID
  static async getById(req, res, next) {
    try {
      const item = await Model.findById(req.params.id);
      if (!item) return res.status(404).json({ success: false, message: 'Not found' });
      res.json({ success: true, data: item });
    } catch (error) {
      next(error);
    }
  }

  // POST create
  static async create(req, res, next) {
    try {
      const item = await Model.create({ ...req.body, created_by: req.user?.user_id });
      res.status(201).json({ success: true, message: 'Created successfully', data: item });
    } catch (error) {
      next(error);
    }
  }

  // PUT update
  static async update(req, res, next) {
    try {
      const item = await Model.update(req.params.id, req.body);
      if (!item) return res.status(404).json({ success: false, message: 'Not found' });
      res.json({ success: true, message: 'Updated successfully', data: item });
    } catch (error) {
      next(error);
    }
  }

  // DELETE
  static async delete(req, res, next) {
    try {
      const item = await Model.delete(req.params.id);
      if (!item) return res.status(404).json({ success: false, message: 'Not found' });
      res.json({ success: true, message: 'Deleted successfully' });
    } catch (error) {
      next(error);
    }
  }
}

module.exports = ModelController;
```

### Danh sách Controllers cần tạo

1. ✅ `destination.controller.js` - Đã tạo
2. `tourCategory.controller.js`
3. `tour.controller.js` - Ví dụ ở trên
4. `schedule.controller.js`
5. `booking.controller.js`
6. `payment.controller.js`
7. `review.controller.js`
8. `blog.controller.js`
9. `promotion.controller.js`
10. `notification.controller.js`
11. `setting.controller.js`

### Danh sách Routes cần tạo

1. `destination.routes.js`
2. `tourCategory.routes.js`
3. `tour.routes.js` - Ví dụ ở trên
4. `schedule.routes.js`
5. `booking.routes.js`
6. `payment.routes.js`
7. `review.routes.js`
8. `blog.routes.js`
9. `promotion.routes.js`
10. `notification.routes.js`
11. `setting.routes.js`

### Permissions cần thiết

Đảm bảo database có các permissions sau:

```sql
-- Tour permissions
INSERT INTO permissions (permission_name, permission_description, module) VALUES
('tour.view', 'Xem tour', 'tour'),
('tour.create', 'Tạo tour mới', 'tour'),
('tour.edit', 'Chỉnh sửa tour', 'tour'),
('tour.delete', 'Xóa tour', 'tour');

-- Booking permissions
INSERT INTO permissions (permission_name, permission_description, module) VALUES
('booking.view_all', 'Xem tất cả booking', 'booking'),
('booking.view_own', 'Xem booking của mình', 'booking'),
('booking.create', 'Tạo booking', 'booking'),
('booking.cancel', 'Hủy booking', 'booking'),
('booking.confirm', 'Xác nhận booking', 'booking');

-- Payment permissions
INSERT INTO permissions (permission_name, permission_description, module) VALUES
('payment.process', 'Xử lý thanh toán', 'payment'),
('payment.view', 'Xem thanh toán', 'payment');

-- Review permissions
INSERT INTO permissions (permission_name, permission_description, module) VALUES
('review.view', 'Xem đánh giá', 'review'),
('review.approve', 'Duyệt đánh giá', 'review'),
('review.create', 'Tạo đánh giá', 'review');

-- Content permissions
INSERT INTO permissions (permission_name, permission_description, module) VALUES
('content.manage', 'Quản lý nội dung', 'content'),
('blog.create', 'Tạo bài viết', 'content'),
('blog.edit', 'Sửa bài viết', 'content'),
('blog.delete', 'Xóa bài viết', 'content');

-- Promotion permissions
INSERT INTO permissions (permission_name, permission_description, module) VALUES
('promotion.view', 'Xem khuyến mãi', 'promotion'),
('promotion.create', 'Tạo khuyến mãi', 'promotion'),
('promotion.edit', 'Sửa khuyến mãi', 'promotion');
```

### Tóm tắt

✅ **Đã hoàn thành:**
- 16 Models với đầy đủ CRUD và business logic
- Database configuration
- Authentication & Authorization middleware
- User, Role, Permission management
- 1 Destination controller

📝 **Cần làm tiếp:**
- Tạo 10 controllers còn lại (copy pattern từ ví dụ)
- Tạo 11 routes files (copy pattern từ ví dụ)
- Cập nhật main router
- Test tất cả endpoints

Tất cả đều follow cùng một pattern, rất dễ tạo!
