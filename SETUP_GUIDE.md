# 🚀 Travel Website Backend - Setup Guide

## ✅ Hoàn thành

Backend đã được tạo hoàn chỉnh với **62+ files**!

---

## 📦 Cài đặt

### 1. Install Dependencies

```bash
cd "d:\Project\travel website\backend"
npm install
```

Các dependencies chính:
- `express` - Web framework
- `pg` - PostgreSQL client
- `bcryptjs` - Password hashing
- `jsonwebtoken` - JWT authentication
- `multer` - File upload
- `nodemailer` - Email service
- `express-validator` - Input validation
- `helmet` - Security headers
- `cors` - CORS middleware
- `morgan` - HTTP logger

---

## ⚙️ Cấu hình

### 1. Database

Đảm bảo PostgreSQL đang chạy và import schema:

```bash
psql -U postgres -d travel_website -f "d:\Project\travel website\database\travel_postgresql.sql"
```

### 2. Environment Variables

File `.env` đã được cấu hình với:

```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=travel_website
DB_USER=postgres
DB_PASSWORD=123

# Server
PORT=5000
NODE_ENV=development

# JWT
JWT_SECRET=...
JWT_EXPIRES_IN=7d

# Email (Nodemailer)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=thanhvinhly369@gmail.com
SMTP_PASS=amwe cziu tbwt arwj
APP_NAME=Travel Website
FRONTEND_URL=http://localhost:3000
```

**Lưu ý:** Để sử dụng Gmail SMTP, bạn cần:
1. Bật 2-Step Verification
2. Tạo App Password tại: https://myaccount.google.com/apppasswords

---

## 🚀 Khởi động

### Development Mode

```bash
npm run dev
```

### Production Mode

```bash
npm start
```

Server sẽ chạy tại: **http://localhost:5000**

---

## 📁 Cấu trúc thư mục

```
backend/
├── src/
│   ├── config/
│   │   └── database.js
│   ├── models/              (16 files)
│   ├── controllers/         (13 files)
│   ├── routes/              (15 files)
│   ├── middlewares/         (6 files)
│   ├── utils/               (6 files)
│   └── services/            (3 files)
├── uploads/                 (Auto-created)
│   ├── tours/
│   ├── avatars/
│   ├── blog/
│   └── destinations/
├── logs/                    (Auto-created)
│   ├── error.log
│   ├── info.log
│   ├── warning.log
│   ├── query.log
│   └── request.log
├── server.js
├── package.json
└── .env
```

---

## 🧪 Testing

### 1. Health Check

```bash
curl http://localhost:5000/api/health
```

### 2. Register User

```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "password123",
    "full_name": "Test User"
  }'
```

### 3. Login

```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

Lưu token từ response để sử dụng cho các request tiếp theo.

### 4. Get Tours

```bash
curl http://localhost:5000/api/tours
```

### 5. Upload Image

```bash
curl -X POST http://localhost:5000/api/tours/1/images \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -F "image=@/path/to/image.jpg" \
  -F "caption=Beautiful tour image"
```

---

## 📊 API Endpoints

### Root
- `GET /` - API information

### Authentication
- `POST /api/auth/register` - Register
- `POST /api/auth/login` - Login
- `GET /api/auth/profile` - Get profile
- `PUT /api/auth/profile` - Update profile
- `PUT /api/auth/change-password` - Change password

### Tours
- `GET /api/tours` - List tours
- `GET /api/tours/featured` - Featured tours
- `GET /api/tours/search` - Search tours
- `GET /api/tours/:id` - Get tour
- `POST /api/tours` - Create tour (auth required)
- `PUT /api/tours/:id` - Update tour (auth required)
- `DELETE /api/tours/:id` - Delete tour (auth required)
- `POST /api/tours/:id/images` - Add image (auth required)

### Bookings
- `GET /api/bookings` - List bookings (admin)
- `GET /api/bookings/my-bookings` - My bookings (auth required)
- `POST /api/bookings` - Create booking (auth required)
- `POST /api/bookings/:id/confirm` - Confirm booking (admin)
- `POST /api/bookings/:id/cancel` - Cancel booking (auth required)

### Payments
- `GET /api/payments` - List payments (admin)
- `POST /api/payments` - Create payment (admin)
- `PUT /api/payments/:id/status` - Update status (admin)

### Reviews
- `GET /api/reviews/tour/:tourId` - Tour reviews
- `POST /api/reviews` - Create review (auth required)
- `POST /api/reviews/:id/approve` - Approve review (admin)

### Notifications
- `GET /api/notifications/my` - My notifications (auth required)
- `GET /api/notifications/unread-count` - Unread count (auth required)
- `POST /api/notifications/:id/read` - Mark as read (auth required)

Xem đầy đủ tại: [API_DOCUMENTATION.md](file:///d:/Project/travel%20website/backend/API_DOCUMENTATION.md)

---

## 🔧 Utilities & Services

### File Upload

```javascript
const { uploadSingle } = require('./src/middlewares/uploadImage.middleware');

// In routes
router.post('/upload', uploadSingle('image', 'tours'), controller.upload);
```

### Email Service

```javascript
const emailService = require('./src/services/emailService');

await emailService.sendBookingConfirmation(booking, tour);
await emailService.sendPaymentConfirmation(payment, booking);
```

### Notification Service

```javascript
const notificationService = require('./src/services/notificationService');

await notificationService.notifyBookingConfirmed(userId, bookingCode);
```

### Activity Logger

```javascript
const { logAuth, logBooking } = require('./src/services/activityLogger');

logAuth.login(userId, req);
logBooking.create(userId, bookingId, req);
```

### Code Generator

```javascript
const { generateBookingCode } = require('./src/utils/codeGenerator');

const code = generateBookingCode(); // BK-20241224-A3F2
```

### Price Calculator

```javascript
const { calculateBookingPrice } = require('./src/utils/priceCalculator');

const price = calculateBookingPrice(tour, 2, 1, 0, promotion);
// { basePrice, tourDiscount, promotionDiscount, finalPrice }
```

---

## 🐛 Troubleshooting

### Database Connection Error

```
❌ Failed to start server: Error: connect ECONNREFUSED
```

**Giải pháp:**
1. Kiểm tra PostgreSQL đang chạy
2. Kiểm tra credentials trong `.env`
3. Kiểm tra database tồn tại

### Email Sending Error

```
Error: Invalid login
```

**Giải pháp:**
1. Kiểm tra SMTP credentials
2. Bật 2-Step Verification cho Gmail
3. Tạo App Password mới

### File Upload Error

```
Error: ENOENT: no such file or directory
```

**Giải pháp:**
Thư mục uploads sẽ tự động tạo khi server khởi động. Nếu vẫn lỗi, tạo thủ công:

```bash
mkdir -p uploads/tours uploads/avatars uploads/blog uploads/destinations
```

---

## 📝 Logs

Tất cả logs được ghi tự động vào folder `logs/`:

- `error.log` - Application errors
- `info.log` - General info
- `warning.log` - Warnings
- `query.log` - Database queries
- `request.log` - API requests

---

## 🎯 Next Steps

1. ✅ Backend đã hoàn thành
2. 🔄 Test tất cả endpoints với Postman
3. 🔄 Integrate với frontend
4. 🔄 Deploy lên production

---

## 📚 Documentation

- [API Documentation](file:///d:/Project/travel%20website/backend/API_DOCUMENTATION.md)
- [Walkthrough](file:///C:/Users/VINH/.gemini/antigravity/brain/60798747-5f43-4e45-b64e-67b6efa58c5a/walkthrough.md)
- [Complete Code Templates](file:///C:/Users/VINH/.gemini/antigravity/brain/60798747-5f43-4e45-b64e-67b6efa58c5a/COMPLETE_CODE.md)

---

## ✨ Features

✅ JWT Authentication  
✅ RBAC Authorization  
✅ File Upload (Multer)  
✅ Email Service (Nodemailer)  
✅ Notifications  
✅ Activity Logging  
✅ Error Logging  
✅ Price Calculator  
✅ Code Generators  
✅ Slug Generator  

🎉 **Backend sẵn sàng sử dụng!**
