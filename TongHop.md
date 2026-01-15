# TỔNG HỢP CHỨC NĂNG BACKEND VÀ DATABASE - WEBSITE DU LỊCH

## 📋 MỤC LỤC

1. [Tổng Quan Hệ Thống](#tổng-quan-hệ-thống)
2. [Cấu Trúc Database](#cấu-trúc-database)
3. [Chi Tiết Các Bảng Database](#chi-tiết-các-bảng-database)
4. [Chức Năng Backend](#chức-năng-backend)
5. [API Endpoints](#api-endpoints)

---

## 🎯 TỔNG QUAN HỆ THỐNG

Backend của website du lịch được xây dựng với:
- **Framework**: Node.js + Express
- **Database**: PostgreSQL
- **Authentication**: JWT (JSON Web Token)
- **Authorization**: RBAC (Role-Based Access Control)
- **Architecture**: MVC Pattern

---

## 🗄️ CẤU TRÚC DATABASE

Hệ thống bao gồm **16 bảng chính** được chia thành các nhóm chức năng:

### 1. **Nhóm Quản Lý Người Dùng & Phân Quyền**
- `users` - Người dùng
- `roles` - Vai trò
- `permissions` - Quyền hạn
- `role_permissions` - Liên kết vai trò và quyền

### 2. **Nhóm Quản Lý Tour**
- `destinations` - Điểm đến
- `tour_categories` - Danh mục tour
- `tours` - Tour du lịch
- `tour_images` - Hình ảnh tour
- `tour_schedules` - Lịch trình tour

### 3. **Nhóm Quản Lý Đặt Tour**
- `bookings` - Đơn đặt tour
- `booking_participants` - Thông tin người tham gia
- `payments` - Thanh toán

### 4. **Nhóm Đánh Giá & Nội Dung**
- `reviews` - Đánh giá tour
- `blog_posts` - Bài viết blog

### 5. **Nhóm Khuyến Mãi**
- `promotions` - Mã khuyến mãi
- `promotion_usage` - Lịch sử sử dụng khuyến mãi

### 6. **Nhóm Hệ Thống**
- `notifications` - Thông báo
- `system_settings` - Cài đặt hệ thống
- `activity_logs` - Nhật ký hoạt động

---

## 📊 CHI TIẾT CÁC BẢNG DATABASE

### 1. BẢNG `users` - Người Dùng

**Chức năng**: Lưu trữ thông tin tài khoản người dùng

**Các trường chính**:
- `user_id` (PK) - ID người dùng
- `username` - Tên đăng nhập (unique)
- `email` - Email (unique)
- `password_hash` - Mật khẩu đã mã hóa
- `full_name` - Họ tên đầy đủ
- `phone` - Số điện thoại
- `avatar_url` - URL ảnh đại diện
- `status` - Trạng thái (active/inactive/suspended)
- `email_verified` - Xác thực email (boolean)
- `role_id` (FK) - ID vai trò
- `last_login` - Lần đăng nhập cuối
- `created_at`, `updated_at` - Thời gian tạo/cập nhật

**Mối quan hệ**:
- Liên kết với `roles` (nhiều-một)
- Liên kết với `bookings`, `reviews`, `blog_posts` (một-nhiều)

---

### 2. BẢNG `roles` - Vai Trò

**Chức năng**: Định nghĩa các vai trò trong hệ thống

**Các trường chính**:
- `role_id` (PK) - ID vai trò
- `role_name` - Tên vai trò (Super Admin, Admin, Tour Manager, Content Manager, Customer Support, Accountant, Customer)
- `role_description` - Mô tả vai trò
- `created_at` - Thời gian tạo

**Vai trò mặc định**:
1. **Super Admin** - Quản trị viên cấp cao nhất
2. **Admin** - Quản trị viên
3. **Tour Manager** - Quản lý tour
4. **Content Manager** - Quản lý nội dung
5. **Customer Support** - Hỗ trợ khách hàng
6. **Accountant** - Kế toán
7. **Customer** - Khách hàng

---

### 3. BẢNG `permissions` - Quyền Hạn

**Chức năng**: Định nghĩa các quyền trong hệ thống

**Các trường chính**:
- `permission_id` (PK) - ID quyền
- `permission_name` - Tên quyền (format: module.action)
- `permission_description` - Mô tả quyền
- `module` - Module (user, system, tour, booking, payment, review, content, promotion, report, customer)
- `created_at` - Thời gian tạo

**Các module quyền**:
- **user**: Quản lý người dùng và vai trò
- **system**: Quản lý cài đặt hệ thống
- **tour**: Quản lý tour
- **booking**: Quản lý đặt tour
- **payment**: Quản lý thanh toán
- **review**: Quản lý đánh giá
- **content**: Quản lý nội dung
- **promotion**: Quản lý khuyến mãi
- **report**: Xem báo cáo
- **customer**: Quản lý khách hàng

---

### 4. BẢNG `role_permissions` - Liên Kết Vai Trò & Quyền

**Chức năng**: Gán quyền cho vai trò

**Các trường chính**:
- `role_id` (FK) - ID vai trò
- `permission_id` (FK) - ID quyền
- `assigned_at` - Thời gian gán

**Primary Key**: Composite key (role_id, permission_id)

---

### 5. BẢNG `destinations` - Điểm Đến

**Chức năng**: Lưu trữ thông tin các điểm đến du lịch

**Các trường chính**:
- `destination_id` (PK) - ID điểm đến
- `name` - Tên điểm đến
- `country` - Quốc gia
- `city` - Thành phố
- `description` - Mô tả
- `image_url` - URL hình ảnh
- `is_popular` - Điểm đến phổ biến (boolean)
- `created_by` (FK) - Người tạo
- `created_at`, `updated_at` - Thời gian tạo/cập nhật

**Chức năng hỗ trợ**:
- Lọc điểm đến phổ biến
- Tìm kiếm theo quốc gia/thành phố

---

### 6. BẢNG `tour_categories` - Danh Mục Tour

**Chức năng**: Phân loại các tour du lịch

**Các trường chính**:
- `category_id` (PK) - ID danh mục
- `category_name` - Tên danh mục
- `description` - Mô tả
- `icon_url` - URL icon
- `created_at` - Thời gian tạo

**Ví dụ danh mục**: Tour biển, Tour núi, Tour văn hóa, Tour ẩm thực, Tour mạo hiểm...

---

### 7. BẢNG `tours` - Tour Du Lịch

**Chức năng**: Lưu trữ thông tin chi tiết các tour

**Các trường chính**:
- `tour_id` (PK) - ID tour
- `tour_code` - Mã tour (unique)
- `title` - Tiêu đề tour
- `category_id` (FK) - ID danh mục
- `destination_id` (FK) - ID điểm đến
- `description` - Mô tả chi tiết
- `duration_days` - Số ngày
- `duration_nights` - Số đêm
- `max_participants` - Số người tối đa
- `min_participants` - Số người tối thiểu
- `price_adult` - Giá người lớn
- `price_child` - Giá trẻ em
- `price_infant` - Giá trẻ nhỏ
- `discount_percentage` - Phần trăm giảm giá
- `featured_image` - Hình ảnh nổi bật
- `status` - Trạng thái (draft/published/archived)
- `created_by` (FK) - Người tạo
- `created_at`, `updated_at` - Thời gian tạo/cập nhật

**Chức năng hỗ trợ**:
- Tìm kiếm tour theo nhiều tiêu chí
- Lọc tour nổi bật (có giảm giá)
- Tính giá sau giảm

---

### 8. BẢNG `tour_images` - Hình Ảnh Tour

**Chức năng**: Lưu trữ nhiều hình ảnh cho mỗi tour

**Các trường chính**:
- `image_id` (PK) - ID hình ảnh
- `tour_id` (FK) - ID tour
- `image_url` - URL hình ảnh
- `caption` - Chú thích
- `display_order` - Thứ tự hiển thị
- `uploaded_by` (FK) - Người upload
- `uploaded_at` - Thời gian upload

---

### 9. BẢNG `tour_schedules` - Lịch Trình Tour

**Chức năng**: Quản lý các chuyến đi cụ thể của tour

**Các trường chính**:
- `schedule_id` (PK) - ID lịch trình
- `tour_id` (FK) - ID tour
- `departure_date` - Ngày khởi hành
- `return_date` - Ngày về
- `available_slots` - Số chỗ khả dụng
- `booked_slots` - Số chỗ đã đặt
- `status` - Trạng thái (available/full/cancelled)
- `guide_id` (FK) - ID hướng dẫn viên
- `created_at`, `updated_at` - Thời gian tạo/cập nhật

**Chức năng hỗ trợ**:
- Kiểm tra tình trạng chỗ trống
- Tự động cập nhật trạng thái khi hết chỗ
- Lấy lịch trình sắp tới

---

### 10. BẢNG `bookings` - Đơn Đặt Tour

**Chức năng**: Quản lý đơn đặt tour của khách hàng

**Các trường chính**:
- `booking_id` (PK) - ID đơn đặt
- `booking_code` - Mã đơn đặt (unique, auto-generated)
- `schedule_id` (FK) - ID lịch trình
- `user_id` (FK) - ID người đặt
- `customer_name` - Tên khách hàng
- `customer_email` - Email khách hàng
- `customer_phone` - SĐT khách hàng
- `num_adults` - Số người lớn
- `num_children` - Số trẻ em
- `num_infants` - Số trẻ nhỏ
- `total_amount` - Tổng tiền
- `paid_amount` - Số tiền đã trả
- `payment_status` - Trạng thái thanh toán (pending/partial/completed/refunded)
- `booking_status` - Trạng thái đơn (pending/confirmed/cancelled/completed)
- `special_requests` - Yêu cầu đặc biệt
- `confirmed_by` (FK) - Người xác nhận
- `confirmed_at` - Thời gian xác nhận
- `created_at`, `updated_at` - Thời gian tạo/cập nhật

**Chức năng hỗ trợ**:
- Tự động tạo mã booking
- Cập nhật số chỗ đã đặt trong schedule
- Tính toán thống kê doanh thu

---

### 11. BẢNG `booking_participants` - Người Tham Gia

**Chức năng**: Lưu thông tin chi tiết người tham gia tour

**Các trường chính**:
- `participant_id` (PK) - ID người tham gia
- `booking_id` (FK) - ID đơn đặt
- `full_name` - Họ tên
- `date_of_birth` - Ngày sinh
- `passport_number` - Số hộ chiếu
- `participant_type` - Loại (adult/child/infant)

---

### 12. BẢNG `payments` - Thanh Toán

**Chức năng**: Quản lý các giao dịch thanh toán

**Các trường chính**:
- `payment_id` (PK) - ID thanh toán
- `booking_id` (FK) - ID đơn đặt
- `payment_method` - Phương thức (cash/bank_transfer/credit_card/e_wallet)
- `amount` - Số tiền
- `transaction_id` - Mã giao dịch
- `payment_status` - Trạng thái (pending/completed/failed/refunded)
- `payment_date` - Ngày thanh toán
- `processed_by` (FK) - Người xử lý
- `notes` - Ghi chú

**Chức năng hỗ trợ**:
- Thống kê doanh thu
- Lọc theo phương thức thanh toán
- Theo dõi lịch sử thanh toán của booking

---

### 13. BẢNG `reviews` - Đánh Giá Tour

**Chức năng**: Quản lý đánh giá của khách hàng

**Các trường chính**:
- `review_id` (PK) - ID đánh giá
- `tour_id` (FK) - ID tour
- `booking_id` (FK) - ID đơn đặt
- `user_id` (FK) - ID người đánh giá
- `rating` - Điểm đánh giá (1-5)
- `title` - Tiêu đề
- `comment` - Nội dung
- `status` - Trạng thái (pending/approved/rejected)
- `reviewed_by` (FK) - Người duyệt
- `reviewed_at` - Thời gian duyệt
- `created_at`, `updated_at` - Thời gian tạo/cập nhật

**Chức năng hỗ trợ**:
- Tính điểm trung bình của tour
- Thống kê phân bố đánh giá (1-5 sao)
- Duyệt/từ chối đánh giá

---

### 14. BẢNG `blog_posts` - Bài Viết Blog

**Chức năng**: Quản lý nội dung blog về du lịch

**Các trường chính**:
- `post_id` (PK) - ID bài viết
- `title` - Tiêu đề
- `slug` - URL slug (auto-generated từ title)
- `content` - Nội dung
- `excerpt` - Trích đoạn
- `featured_image` - Hình ảnh nổi bật
- `author_id` (FK) - ID tác giả
- `status` - Trạng thái (draft/published)
- `published_at` - Thời gian xuất bản
- `created_at`, `updated_at` - Thời gian tạo/cập nhật

**Chức năng hỗ trợ**:
- Tự động tạo slug từ tiêu đề
- Tìm kiếm bài viết
- Lọc bài viết theo tác giả

---

### 15. BẢNG `promotions` - Mã Khuyến Mãi

**Chức năng**: Quản lý các chương trình khuyến mãi

**Các trường chính**:
- `promotion_id` (PK) - ID khuyến mãi
- `code` - Mã khuyến mãi (unique)
- `description` - Mô tả
- `discount_type` - Loại giảm giá (percentage/fixed_amount)
- `discount_value` - Giá trị giảm
- `max_discount_amount` - Số tiền giảm tối đa
- `min_purchase_amount` - Số tiền mua tối thiểu
- `usage_limit` - Giới hạn số lần sử dụng
- `used_count` - Số lần đã sử dụng
- `valid_from` - Ngày bắt đầu
- `valid_to` - Ngày kết thúc
- `status` - Trạng thái (active/inactive/expired)
- `created_by` (FK) - Người tạo
- `created_at` - Thời gian tạo

**Chức năng hỗ trợ**:
- Validate mã khuyến mãi
- Tính toán số tiền giảm
- Theo dõi lịch sử sử dụng

---

### 16. BẢNG `promotion_usage` - Lịch Sử Sử Dụng Khuyến Mãi

**Chức năng**: Ghi lại việc sử dụng mã khuyến mãi

**Các trường chính**:
- `usage_id` (PK) - ID sử dụng
- `promotion_id` (FK) - ID khuyến mãi
- `booking_id` (FK) - ID đơn đặt
- `user_id` (FK) - ID người dùng
- `discount_amount` - Số tiền được giảm
- `used_at` - Thời gian sử dụng

---

### 17. BẢNG `notifications` - Thông Báo

**Chức năng**: Gửi thông báo cho người dùng

**Các trường chính**:
- `notification_id` (PK) - ID thông báo
- `user_id` (FK) - ID người nhận
- `title` - Tiêu đề
- `message` - Nội dung
- `notification_type` - Loại (booking/payment/promotion/system)
- `is_read` - Đã đọc (boolean)
- `created_at` - Thời gian tạo

**Chức năng hỗ trợ**:
- Đánh dấu đã đọc
- Đếm số thông báo chưa đọc
- Gửi thông báo hàng loạt

---

### 18. BẢNG `system_settings` - Cài Đặt Hệ Thống

**Chức năng**: Lưu trữ các cài đặt cấu hình

**Các trường chính**:
- `setting_id` (PK) - ID cài đặt
- `setting_key` - Key cài đặt (unique)
- `setting_value` - Giá trị
- `description` - Mô tả
- `updated_by` (FK) - Người cập nhật
- `updated_at` - Thời gian cập nhật

**Ví dụ settings**: 
- `site_name`, `site_email`, `currency`, `timezone`, `booking_expiry_hours`...

---

### 19. BẢNG `activity_logs` - Nhật Ký Hoạt Động

**Chức năng**: Ghi lại các hoạt động của người dùng

**Các trường chính**:
- `log_id` (PK) - ID log
- `user_id` (FK) - ID người dùng
- `action` - Hành động (create/update/delete/login/logout)
- `module` - Module (user/tour/booking/payment...)
- `record_id` - ID bản ghi liên quan
- `ip_address` - Địa chỉ IP
- `user_agent` - User agent
- `created_at` - Thời gian

**Chức năng hỗ trợ**:
- Theo dõi hoạt động người dùng
- Audit trail
- Phân tích hành vi

---

## ⚙️ CHỨC NĂNG BACKEND

### 1. **Authentication & Authorization**

#### Model: `User`, `Role`, `Permission`, `RolePermission`

**Chức năng**:
- ✅ Đăng ký tài khoản mới
- ✅ Đăng nhập với JWT
- ✅ Xác thực token
- ✅ Phân quyền dựa trên vai trò (RBAC)
- ✅ Quản lý profile người dùng
- ✅ Đổi mật khẩu
- ✅ Upload avatar
- ✅ Cập nhật thông tin cá nhân

**Controllers**: `auth.controller.js`, `user.controller.js`

**Middlewares**:
- `auth.middleware.js` - Xác thực JWT
- `permission.middleware.js` - Kiểm tra quyền

---

### 2. **Quản Lý Vai Trò & Quyền**

#### Model: `Role`, `Permission`, `RolePermission`

**Chức năng**:
- ✅ CRUD vai trò
- ✅ CRUD quyền hạn
- ✅ Gán quyền cho vai trò
- ✅ Lấy danh sách quyền theo module
- ✅ Lấy danh sách modules
- ✅ Kiểm tra quyền của người dùng

**Controllers**: `role.controller.js`, `permission.controller.js`

---

### 3. **Quản Lý Điểm Đến**

#### Model: `Destination`

**Chức năng**:
- ✅ CRUD điểm đến
- ✅ Lọc điểm đến phổ biến
- ✅ Tìm kiếm theo quốc gia
- ✅ Upload hình ảnh điểm đến

**Controller**: `destination.controller.js`

---

### 4. **Quản Lý Danh Mục Tour**

#### Model: `TourCategory`

**Chức năng**:
- ✅ CRUD danh mục tour
- ✅ Đếm số tour trong mỗi danh mục
- ✅ Upload icon danh mục

**Controller**: `tourCategory.controller.js`

---

### 5. **Quản Lý Tour**

#### Model: `Tour`, `TourImage`

**Chức năng**:
- ✅ CRUD tour
- ✅ Tìm kiếm tour (theo tên, điểm đến, giá, thời gian)
- ✅ Lọc tour theo danh mục, điểm đến, trạng thái
- ✅ Quản lý hình ảnh tour (nhiều ảnh)
- ✅ Lấy tour nổi bật (có giảm giá)
- ✅ Tự động tạo mã tour
- ✅ Tính giá sau giảm

**Controller**: `tour.controller.js`

**Utilities**:
- `slugGenerator.js` - Tạo slug
- `codeGenerator.js` - Tạo mã tour
- `priceCalculator.js` - Tính giá

---

### 6. **Quản Lý Lịch Trình Tour**

#### Model: `TourSchedule`

**Chức năng**:
- ✅ CRUD lịch trình
- ✅ Kiểm tra tình trạng chỗ trống
- ✅ Cập nhật số chỗ đã đặt
- ✅ Tự động cập nhật trạng thái (available/full/cancelled)
- ✅ Lấy lịch trình sắp tới
- ✅ Lọc theo ngày, tour, trạng thái

**Controller**: `schedule.controller.js`

---

### 7. **Quản Lý Đặt Tour**

#### Model: `Booking`, `BookingParticipant`

**Chức năng**:
- ✅ Tạo đơn đặt tour
- ✅ Tự động tạo mã booking (BK + timestamp)
- ✅ Quản lý thông tin người tham gia
- ✅ Xác nhận đơn đặt
- ✅ Hủy đơn đặt (hoàn trả chỗ)
- ✅ Cập nhật trạng thái thanh toán
- ✅ Lấy lịch sử đặt tour của khách hàng
- ✅ Thống kê đơn đặt (tổng số, doanh thu, số người)
- ✅ Lọc theo trạng thái, ngày, người dùng

**Controller**: `booking.controller.js`

**Features**:
- Transaction support (đảm bảo tính toàn vẹn dữ liệu)
- Tự động cập nhật số chỗ trong schedule

---

### 8. **Quản Lý Thanh Toán**

#### Model: `Payment`

**Chức năng**:
- ✅ Tạo giao dịch thanh toán
- ✅ Cập nhật trạng thái thanh toán
- ✅ Lấy lịch sử thanh toán của booking
- ✅ Thống kê doanh thu
- ✅ Lọc theo phương thức, trạng thái, ngày
- ✅ Hỗ trợ nhiều phương thức (tiền mặt, chuyển khoản, thẻ, ví điện tử)

**Controller**: `payment.controller.js`

---

### 9. **Quản Lý Đánh Giá**

#### Model: `Review`

**Chức năng**:
- ✅ Tạo đánh giá tour
- ✅ Cập nhật đánh giá
- ✅ Duyệt/từ chối đánh giá
- ✅ Xóa đánh giá
- ✅ Tính điểm trung bình tour
- ✅ Thống kê phân bố đánh giá (1-5 sao)
- ✅ Lấy đánh giá của tour (chỉ approved)
- ✅ Lấy đánh giá chờ duyệt

**Controller**: `review.controller.js`

---

### 10. **Quản Lý Blog**

#### Model: `BlogPost`

**Chức năng**:
- ✅ CRUD bài viết blog
- ✅ Tự động tạo slug từ tiêu đề
- ✅ Xuất bản bài viết
- ✅ Tìm kiếm bài viết
- ✅ Lọc theo tác giả, trạng thái
- ✅ Lấy bài viết đã xuất bản
- ✅ Upload hình ảnh nổi bật

**Controller**: `blog.controller.js`

---

### 11. **Quản Lý Khuyến Mãi**

#### Model: `Promotion`, `PromotionUsage`

**Chức năng**:
- ✅ CRUD mã khuyến mãi
- ✅ Validate mã khuyến mãi (kiểm tra hợp lệ, hết hạn, đã dùng hết)
- ✅ Tính toán số tiền giảm (percentage/fixed)
- ✅ Áp dụng mã cho booking
- ✅ Theo dõi lịch sử sử dụng
- ✅ Lấy khuyến mãi đang hoạt động
- ✅ Giới hạn số lần sử dụng
- ✅ Giới hạn số tiền giảm tối đa

**Controller**: `promotion.controller.js`

**Features**:
- Transaction support khi sử dụng mã
- Tự động tăng used_count

---

### 12. **Quản Lý Thông Báo**

#### Model: `Notification`

**Chức năng**:
- ✅ Tạo thông báo
- ✅ Gửi thông báo hàng loạt
- ✅ Đánh dấu đã đọc
- ✅ Đánh dấu tất cả đã đọc
- ✅ Đếm số thông báo chưa đọc
- ✅ Lấy thông báo của người dùng
- ✅ Xóa thông báo
- ✅ Lọc theo loại thông báo

**Controller**: `notification.controller.js`

**Loại thông báo**:
- booking - Thông báo về đặt tour
- payment - Thông báo thanh toán
- promotion - Thông báo khuyến mãi
- system - Thông báo hệ thống

---

### 13. **Quản Lý Cài Đặt Hệ Thống**

#### Model: `SystemSetting`

**Chức năng**:
- ✅ CRUD cài đặt
- ✅ Lấy cài đặt theo key
- ✅ Cập nhật cài đặt theo key
- ✅ Lấy tất cả cài đặt dạng object (key-value)

**Controller**: `setting.controller.js`

---

### 14. **Nhật Ký Hoạt Động**

#### Model: `ActivityLog`

**Chức năng**:
- ✅ Ghi log tự động cho các hành động
- ✅ Lọc log theo người dùng, module, hành động, ngày
- ✅ Lấy log của người dùng
- ✅ Lấy log theo module

**Middleware**: `activityLog.middleware.js`

**Tự động ghi log cho**:
- Login/Logout
- Create/Update/Delete operations
- Lưu IP address và User Agent

---

## 🔌 API ENDPOINTS

### **Authentication** (`/api/auth`)
```
POST   /register          - Đăng ký tài khoản
POST   /login             - Đăng nhập
GET    /profile           - Lấy thông tin profile
PUT    /profile           - Cập nhật profile
PUT    /change-password   - Đổi mật khẩu
```

### **Users** (`/api/users`)
```
GET    /                  - Lấy danh sách người dùng
GET    /:id               - Lấy thông tin người dùng
GET    /role/:roleId      - Lấy người dùng theo vai trò
POST   /                  - Tạo người dùng mới
PUT    /:id               - Cập nhật người dùng
DELETE /:id               - Xóa người dùng
PUT    /:id/role          - Thay đổi vai trò
PUT    /:id/status        - Thay đổi trạng thái
```

### **Roles** (`/api/roles`)
```
GET    /                  - Lấy danh sách vai trò
GET    /:id               - Lấy thông tin vai trò
POST   /                  - Tạo vai trò
PUT    /:id               - Cập nhật vai trò
DELETE /:id               - Xóa vai trò
GET    /:id/permissions   - Lấy quyền của vai trò
POST   /:id/permissions   - Gán quyền cho vai trò
```

### **Permissions** (`/api/permissions`)
```
GET    /                  - Lấy danh sách quyền
GET    /modules           - Lấy danh sách modules
GET    /module/:module    - Lấy quyền theo module
GET    /:id               - Lấy thông tin quyền
POST   /                  - Tạo quyền
PUT    /:id               - Cập nhật quyền
DELETE /:id               - Xóa quyền
```

### **Destinations** (`/api/destinations`)
```
GET    /                  - Lấy danh sách điểm đến
GET    /popular           - Lấy điểm đến phổ biến
GET    /:id               - Lấy thông tin điểm đến
POST   /                  - Tạo điểm đến
PUT    /:id               - Cập nhật điểm đến
DELETE /:id               - Xóa điểm đến
```

### **Tour Categories** (`/api/tour-categories`)
```
GET    /                  - Lấy danh sách danh mục
GET    /:id               - Lấy thông tin danh mục
POST   /                  - Tạo danh mục
PUT    /:id               - Cập nhật danh mục
DELETE /:id               - Xóa danh mục
```

### **Tours** (`/api/tours`)
```
GET    /                  - Lấy danh sách tour
GET    /featured          - Lấy tour nổi bật
GET    /search            - Tìm kiếm tour
GET    /:id               - Lấy thông tin tour
GET    /:id/images        - Lấy hình ảnh tour
POST   /                  - Tạo tour
POST   /:id/images        - Thêm hình ảnh
PUT    /:id               - Cập nhật tour
DELETE /:id               - Xóa tour
DELETE /images/:imageId   - Xóa hình ảnh
```

### **Schedules** (`/api/schedules`)
```
GET    /                  - Lấy danh sách lịch trình
GET    /:id               - Lấy thông tin lịch trình
GET    /tour/:tourId      - Lấy lịch trình của tour
POST   /                  - Tạo lịch trình
PUT    /:id               - Cập nhật lịch trình
DELETE /:id               - Xóa lịch trình
```

### **Bookings** (`/api/bookings`)
```
GET    /                  - Lấy danh sách đơn đặt
GET    /my-bookings       - Lấy đơn đặt của tôi
GET    /statistics        - Thống kê đơn đặt
GET    /:id               - Lấy thông tin đơn đặt
GET    /:id/participants  - Lấy người tham gia
POST   /                  - Tạo đơn đặt
PUT    /:id               - Cập nhật đơn đặt
PUT    /:id/confirm       - Xác nhận đơn đặt
PUT    /:id/cancel        - Hủy đơn đặt
```

### **Payments** (`/api/payments`)
```
GET    /                  - Lấy danh sách thanh toán
GET    /statistics        - Thống kê thanh toán
GET    /:id               - Lấy thông tin thanh toán
GET    /booking/:bookingId - Lấy thanh toán của booking
POST   /                  - Tạo thanh toán
PUT    /:id               - Cập nhật thanh toán
PUT    /:id/status        - Cập nhật trạng thái
```

### **Reviews** (`/api/reviews`)
```
GET    /                  - Lấy danh sách đánh giá
GET    /pending           - Lấy đánh giá chờ duyệt
GET    /tour/:tourId      - Lấy đánh giá của tour
GET    /my-reviews        - Lấy đánh giá của tôi
GET    /:id               - Lấy thông tin đánh giá
POST   /                  - Tạo đánh giá
PUT    /:id               - Cập nhật đánh giá
PUT    /:id/approve       - Duyệt đánh giá
PUT    /:id/reject        - Từ chối đánh giá
DELETE /:id               - Xóa đánh giá
```

### **Blog** (`/api/blog`)
```
GET    /                  - Lấy danh sách bài viết
GET    /published         - Lấy bài viết đã xuất bản
GET    /:id               - Lấy thông tin bài viết
GET    /slug/:slug        - Lấy bài viết theo slug
POST   /                  - Tạo bài viết
PUT    /:id               - Cập nhật bài viết
PUT    /:id/publish       - Xuất bản bài viết
DELETE /:id               - Xóa bài viết
```

### **Promotions** (`/api/promotions`)
```
GET    /                  - Lấy danh sách khuyến mãi
GET    /active            - Lấy khuyến mãi đang hoạt động
GET    /:id               - Lấy thông tin khuyến mãi
GET    /:id/usage         - Lấy lịch sử sử dụng
POST   /validate          - Validate mã khuyến mãi
POST   /                  - Tạo khuyến mãi
PUT    /:id               - Cập nhật khuyến mãi
DELETE /:id               - Xóa khuyến mãi
```

### **Notifications** (`/api/notifications`)
```
GET    /                  - Lấy thông báo của tôi
GET    /unread-count      - Đếm thông báo chưa đọc
PUT    /:id/read          - Đánh dấu đã đọc
PUT    /mark-all-read     - Đánh dấu tất cả đã đọc
DELETE /:id               - Xóa thông báo
```

### **Settings** (`/api/settings`)
```
GET    /                  - Lấy tất cả cài đặt
GET    /:key              - Lấy cài đặt theo key
POST   /                  - Tạo cài đặt
PUT    /:id               - Cập nhật cài đặt
DELETE /:id               - Xóa cài đặt
```

---

## 🔒 PHÂN QUYỀN

### Middleware Authentication
- Tất cả API (trừ register/login) yêu cầu JWT token
- Token được gửi qua header: `Authorization: Bearer <token>`

### Middleware Permission
- Kiểm tra quyền dựa trên `permission_name`
- Format: `module.action` (vd: `tour.create`, `booking.view`)

### Các Module Quyền
1. **user** - Quản lý người dùng
2. **system** - Quản lý hệ thống
3. **tour** - Quản lý tour
4. **booking** - Quản lý đặt tour
5. **payment** - Quản lý thanh toán
6. **review** - Quản lý đánh giá
7. **content** - Quản lý nội dung
8. **promotion** - Quản lý khuyến mãi
9. **report** - Xem báo cáo
10. **customer** - Quản lý khách hàng

---

## 📁 CẤU TRÚC THƯ MỤC BACKEND

```
backend/
├── src/
│   ├── config/
│   │   └── database.js           # Cấu hình kết nối PostgreSQL
│   ├── controllers/              # 15 controllers
│   │   ├── auth.controller.js
│   │   ├── user.controller.js
│   │   ├── role.controller.js
│   │   ├── permission.controller.js
│   │   ├── destination.controller.js
│   │   ├── tourCategory.controller.js
│   │   ├── tour.controller.js
│   │   ├── schedule.controller.js
│   │   ├── booking.controller.js
│   │   ├── payment.controller.js
│   │   ├── review.controller.js
│   │   ├── blog.controller.js
│   │   ├── promotion.controller.js
│   │   ├── notification.controller.js
│   │   └── setting.controller.js
│   ├── models/                   # 16 models
│   │   ├── User.js
│   │   ├── Role.js
│   │   ├── Permission.js
│   │   ├── RolePermission.js
│   │   ├── Destination.js
│   │   ├── TourCategory.js
│   │   ├── Tour.js
│   │   ├── TourSchedule.js
│   │   ├── Booking.js
│   │   ├── Payment.js
│   │   ├── Review.js
│   │   ├── BlogPost.js
│   │   ├── Promotion.js
│   │   ├── Notification.js
│   │   ├── SystemSetting.js
│   │   └── ActivityLog.js
│   ├── routes/                   # 16 route files
│   │   ├── index.js             # Main router
│   │   ├── auth.routes.js
│   │   ├── user.routes.js
│   │   ├── role.routes.js
│   │   ├── permission.routes.js
│   │   ├── destination.routes.js
│   │   ├── tourCategory.routes.js
│   │   ├── tour.routes.js
│   │   ├── schedule.routes.js
│   │   ├── booking.routes.js
│   │   ├── payment.routes.js
│   │   ├── review.routes.js
│   │   ├── blog.routes.js
│   │   ├── promotion.routes.js
│   │   ├── notification.routes.js
│   │   └── setting.routes.js
│   ├── middlewares/
│   │   ├── auth.middleware.js        # Xác thực JWT
│   │   ├── permission.middleware.js  # Kiểm tra quyền
│   │   ├── validate.middleware.js    # Validate dữ liệu
│   │   ├── error.middleware.js       # Xử lý lỗi
│   │   ├── uploadImage.middleware.js # Upload hình ảnh
│   │   └── activityLog.middleware.js # Ghi log
│   └── utils/
│       ├── logger.js                 # Winston logger
│       ├── fileUpload.js             # Multer upload
│       ├── slugGenerator.js          # Tạo slug
│       ├── codeGenerator.js          # Tạo mã
│       ├── priceCalculator.js        # Tính giá
│       └── dateHelper.js             # Xử lý ngày tháng
├── uploads/                      # Thư mục lưu file upload
│   └── images/
├── logs/                         # Thư mục log
├── .env                          # Biến môi trường
├── server.js                     # Entry point
└── package.json
```

---

## 🛠️ CÔNG NGHỆ & DEPENDENCIES

### Core Dependencies
- **express** - Web framework
- **pg** - PostgreSQL client
- **bcryptjs** - Mã hóa mật khẩu
- **jsonwebtoken** - JWT authentication
- **dotenv** - Quản lý biến môi trường
- **cors** - CORS middleware
- **helmet** - Security headers
- **morgan** - HTTP request logger
- **winston** - Application logger
- **multer** - File upload
- **express-validator** - Validation

---

## 📝 GHI CHÚ

### Transaction Support
Các chức năng sau sử dụng database transaction:
- Tạo booking (cập nhật schedule slots)
- Hủy booking (hoàn trả slots)
- Sử dụng promotion (tăng used_count)

### Auto-generated Fields
- `booking_code` - Tự động tạo (BK + timestamp + random)
- `tour_code` - Tự động tạo
- `slug` - Tự động tạo từ title (blog posts)

### File Upload
- Hỗ trợ upload: Avatar, Tour images, Blog images, Destination images
- Lưu trữ: Local filesystem (`uploads/images/`)
- Middleware: `uploadImage.middleware.js`

### Logging
- Application logs: Winston logger
- HTTP logs: Morgan middleware
- Activity logs: Database table `activity_logs`

---

**Tài liệu được tạo tự động từ source code backend**
**Ngày cập nhật**: 04/01/2026
