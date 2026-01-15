-- ============================================
-- DATABASE THIẾT KẾ CHO WEBSITE TOUR DU LỊCH - POSTGRESQL VERSION
-- ============================================

-- Drop existing tables if they exist
DROP TABLE IF EXISTS activity_logs CASCADE;
DROP TABLE IF EXISTS system_settings CASCADE;
DROP TABLE IF EXISTS notifications CASCADE;
DROP TABLE IF EXISTS promotion_usage CASCADE;
DROP TABLE IF EXISTS promotions CASCADE;
DROP TABLE IF EXISTS blog_posts CASCADE;
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS booking_participants CASCADE;
DROP TABLE IF EXISTS bookings CASCADE;
DROP TABLE IF EXISTS tour_schedules CASCADE;
DROP TABLE IF EXISTS tour_images CASCADE;
DROP TABLE IF EXISTS tours CASCADE;
DROP TABLE IF EXISTS tour_categories CASCADE;
DROP TABLE IF EXISTS destinations CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS role_permissions CASCADE;
DROP TABLE IF EXISTS permissions CASCADE;
DROP TABLE IF EXISTS roles CASCADE;

-- Bảng vai trò (Roles)
CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL,
    role_description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng quyền hạn (Permissions)
CREATE TABLE permissions (
    permission_id SERIAL PRIMARY KEY,
    permission_name VARCHAR(100) UNIQUE NOT NULL,
    permission_description TEXT,
    module VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng phân quyền cho vai trò
CREATE TABLE role_permissions (
    role_id INT,
    permission_id INT,
    PRIMARY KEY (role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES permissions(permission_id) ON DELETE CASCADE
);

-- Bảng người dùng
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    phone VARCHAR(20),
    avatar_url VARCHAR(255),
    role_id INT,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended')),
    email_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

-- Bảng địa điểm
CREATE TABLE destinations (
    destination_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    country VARCHAR(100),
    city VARCHAR(100),
    description TEXT,
    image_url VARCHAR(255),
    is_popular BOOLEAN DEFAULT FALSE,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- Bảng danh mục tour
CREATE TABLE tour_categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    icon_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng tour
CREATE TABLE tours (
    tour_id SERIAL PRIMARY KEY,
    tour_code VARCHAR(50) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    category_id INT,
    destination_id INT,
    description TEXT,
    duration_days INT NOT NULL,
    duration_nights INT NOT NULL,
    max_participants INT,
    min_participants INT DEFAULT 1,
    price_adult DECIMAL(10, 2) NOT NULL,
    price_child DECIMAL(10, 2),
    price_infant DECIMAL(10, 2),
    discount_percentage DECIMAL(5, 2) DEFAULT 0,
    featured_image VARCHAR(255),
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES tour_categories(category_id),
    FOREIGN KEY (destination_id) REFERENCES destinations(destination_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- Bảng hình ảnh tour
CREATE TABLE tour_images (
    image_id SERIAL PRIMARY KEY,
    tour_id INT,
    image_url VARCHAR(255) NOT NULL,
    caption TEXT,
    display_order INT DEFAULT 0,
    uploaded_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tour_id) REFERENCES tours(tour_id) ON DELETE CASCADE,
    FOREIGN KEY (uploaded_by) REFERENCES users(user_id)
);

-- Bảng lịch trình tour
CREATE TABLE tour_schedules (
    schedule_id SERIAL PRIMARY KEY,
    tour_id INT,
    departure_date DATE NOT NULL,
    return_date DATE NOT NULL,
    available_slots INT NOT NULL,
    booked_slots INT DEFAULT 0,
    status VARCHAR(20) DEFAULT 'available' CHECK (status IN ('available', 'full', 'cancelled')),
    guide_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tour_id) REFERENCES tours(tour_id) ON DELETE CASCADE,
    FOREIGN KEY (guide_id) REFERENCES users(user_id)
);

-- Bảng đặt tour
CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    booking_code VARCHAR(50) UNIQUE NOT NULL,
    schedule_id INT,
    user_id INT,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(100) NOT NULL,
    customer_phone VARCHAR(20) NOT NULL,
    num_adults INT DEFAULT 0,
    num_children INT DEFAULT 0,
    num_infants INT DEFAULT 0,
    total_amount DECIMAL(10, 2) NOT NULL,
    paid_amount DECIMAL(10, 2) DEFAULT 0,
    payment_status VARCHAR(20) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'partial', 'completed', 'refunded')),
    booking_status VARCHAR(20) DEFAULT 'pending' CHECK (booking_status IN ('pending', 'confirmed', 'cancelled', 'completed')),
    special_requests TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    confirmed_by INT,
    confirmed_at TIMESTAMP NULL,
    FOREIGN KEY (schedule_id) REFERENCES tour_schedules(schedule_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (confirmed_by) REFERENCES users(user_id)
);

-- Bảng thông tin khách hàng trong booking
CREATE TABLE booking_participants (
    participant_id SERIAL PRIMARY KEY,
    booking_id INT,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    passport_number VARCHAR(50),
    participant_type VARCHAR(20) NOT NULL CHECK (participant_type IN ('adult', 'child', 'infant')),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE
);

-- Bảng thanh toán
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    booking_id INT,
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('credit_card', 'debit_card', 'bank_transfer', 'cash', 'e_wallet')),
    amount DECIMAL(10, 2) NOT NULL,
    transaction_id VARCHAR(100),
    payment_status VARCHAR(20) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'completed', 'failed', 'refunded')),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed_by INT,
    notes TEXT,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (processed_by) REFERENCES users(user_id)
);

-- Bảng đánh giá tour
CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    tour_id INT,
    booking_id INT,
    user_id INT,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    title VARCHAR(200),
    comment TEXT,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_by INT,
    reviewed_at TIMESTAMP NULL,
    FOREIGN KEY (tour_id) REFERENCES tours(tour_id),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (reviewed_by) REFERENCES users(user_id)
);

-- Bảng bài viết blog
CREATE TABLE blog_posts (
    post_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    content TEXT,
    excerpt TEXT,
    featured_image VARCHAR(255),
    author_id INT,
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
    published_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES users(user_id)
);

-- Bảng khuyến mãi
CREATE TABLE promotions (
    promotion_id SERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    discount_type VARCHAR(20) NOT NULL CHECK (discount_type IN ('percentage', 'fixed_amount')),
    discount_value DECIMAL(10, 2) NOT NULL,
    max_discount_amount DECIMAL(10, 2),
    min_purchase_amount DECIMAL(10, 2),
    usage_limit INT,
    used_count INT DEFAULT 0,
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'expired')),
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- Bảng sử dụng khuyến mãi
CREATE TABLE promotion_usage (
    usage_id SERIAL PRIMARY KEY,
    promotion_id INT,
    booking_id INT,
    user_id INT,
    discount_amount DECIMAL(10, 2),
    used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (promotion_id) REFERENCES promotions(promotion_id),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Bảng thông báo
CREATE TABLE notifications (
    notification_id SERIAL PRIMARY KEY,
    user_id INT,
    title VARCHAR(200) NOT NULL,
    message TEXT,
    notification_type VARCHAR(20) NOT NULL CHECK (notification_type IN ('booking', 'payment', 'promotion', 'system')),
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Bảng cấu hình hệ thống
CREATE TABLE system_settings (
    setting_id SERIAL PRIMARY KEY,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT,
    description TEXT,
    updated_by INT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (updated_by) REFERENCES users(user_id)
);

-- Bảng log hoạt động
CREATE TABLE activity_logs (
    log_id SERIAL PRIMARY KEY,
    user_id INT,
    action VARCHAR(100) NOT NULL,
    module VARCHAR(50) NOT NULL,
    record_id INT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Tạo functions để tự động cập nhật updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Tạo triggers cho các bảng cần auto-update
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_destinations_updated_at BEFORE UPDATE ON destinations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_tours_updated_at BEFORE UPDATE ON tours FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_tour_schedules_updated_at BEFORE UPDATE ON tour_schedules FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_bookings_updated_at BEFORE UPDATE ON bookings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_blog_posts_updated_at BEFORE UPDATE ON blog_posts FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_system_settings_updated_at BEFORE UPDATE ON system_settings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- DỮ LIỆU MẪU
-- ============================================

-- Insert Roles (cần insert trước users)
INSERT INTO roles (role_name, role_description) VALUES
('Super Admin', 'Quản trị viên cấp cao nhất'),
('Admin', 'Quản trị viên'),
('Tour Manager', 'Quản lý tour'),
('Content Manager', 'Quản lý nội dung'),
('Customer Service', 'Nhân viên chăm sóc khách hàng'),
('Tour Guide', 'Hướng dẫn viên'),
('Customer', 'Khách hàng');

-- Insert Permissions
INSERT INTO permissions (permission_name, permission_description, module) VALUES
('user.manage_roles', 'Quản lý vai trò người dùng', 'user'),
('system.edit_settings', 'Chỉnh sửa cài đặt hệ thống', 'system'),
('tour.view', 'Xem tour', 'tour'),
('tour.create', 'Tạo tour mới', 'tour'),
('tour.edit', 'Chỉnh sửa tour', 'tour'),
('tour.delete', 'Xóa tour', 'tour'),
('booking.view_all', 'Xem tất cả booking', 'booking'),
('booking.view_own', 'Xem booking của mình', 'booking'),
('booking.create', 'Tạo booking', 'booking'),
('booking.cancel', 'Hủy booking', 'booking'),
('booking.confirm', 'Xác nhận booking', 'booking'),
('payment.process', 'Xử lý thanh toán', 'payment'),
('review.view', 'Xem đánh giá', 'review'),
('review.approve', 'Duyệt đánh giá', 'review'),
('content.manage', 'Quản lý nội dung', 'content'),
('promotion.view', 'Xem khuyến mãi', 'promotion'),
('promotion.create', 'Tạo khuyến mãi', 'promotion'),
('report.view_bookings', 'Xem báo cáo booking', 'report'),
('report.export', 'Xuất báo cáo', 'report'),
('customer.view', 'Xem thông tin khách hàng', 'customer');
