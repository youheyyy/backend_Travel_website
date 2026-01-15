-- ============================================
-- DATABASE THIẾT KẾ CHO WEBSITE TOUR DU LỊCH
-- ============================================

-- Bảng vai trò (Roles)
CREATE TABLE roles (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) UNIQUE NOT NULL,
    role_description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng quyền hạn (Permissions)
CREATE TABLE permissions (
    permission_id INT PRIMARY KEY AUTO_INCREMENT,
    permission_name VARCHAR(100) UNIQUE NOT NULL,
    permission_description TEXT,
    module VARCHAR(50) NOT NULL, -- tour, booking, user, content, report
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
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    phone VARCHAR(20),
    avatar_url VARCHAR(255),
    role_id INT,
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
    email_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

-- Bảng địa điểm
CREATE TABLE destinations (
    destination_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    country VARCHAR(100),
    city VARCHAR(100),
    description TEXT,
    image_url VARCHAR(255),
    is_popular BOOLEAN DEFAULT FALSE,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- Bảng danh mục tour
CREATE TABLE tour_categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    icon_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng tour
CREATE TABLE tours (
    tour_id INT PRIMARY KEY AUTO_INCREMENT,
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
    status ENUM('draft', 'published', 'archived') DEFAULT 'draft',
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES tour_categories(category_id),
    FOREIGN KEY (destination_id) REFERENCES destinations(destination_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- Bảng hình ảnh tour
CREATE TABLE tour_images (
    image_id INT PRIMARY KEY AUTO_INCREMENT,
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
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    tour_id INT,
    departure_date DATE NOT NULL,
    return_date DATE NOT NULL,
    available_slots INT NOT NULL,
    booked_slots INT DEFAULT 0,
    status ENUM('available', 'full', 'cancelled') DEFAULT 'available',
    guide_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (tour_id) REFERENCES tours(tour_id) ON DELETE CASCADE,
    FOREIGN KEY (guide_id) REFERENCES users(user_id)
);

-- Bảng đặt tour
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
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
    payment_status ENUM('pending', 'partial', 'completed', 'refunded') DEFAULT 'pending',
    booking_status ENUM('pending', 'confirmed', 'cancelled', 'completed') DEFAULT 'pending',
    special_requests TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    confirmed_by INT,
    confirmed_at TIMESTAMP NULL,
    FOREIGN KEY (schedule_id) REFERENCES tour_schedules(schedule_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (confirmed_by) REFERENCES users(user_id)
);

-- Bảng thông tin khách hàng trong booking
CREATE TABLE booking_participants (
    participant_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    passport_number VARCHAR(50),
    participant_type ENUM('adult', 'child', 'infant') NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE
);

-- Bảng thanh toán
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT,
    payment_method ENUM('credit_card', 'debit_card', 'bank_transfer', 'cash', 'e_wallet') NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    transaction_id VARCHAR(100),
    payment_status ENUM('pending', 'completed', 'failed', 'refunded') DEFAULT 'pending',
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed_by INT,
    notes TEXT,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (processed_by) REFERENCES users(user_id)
);

-- Bảng đánh giá tour
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    tour_id INT,
    booking_id INT,
    user_id INT,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    title VARCHAR(200),
    comment TEXT,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
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
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    content TEXT,
    excerpt TEXT,
    featured_image VARCHAR(255),
    author_id INT,
    status ENUM('draft', 'published', 'archived') DEFAULT 'draft',
    published_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES users(user_id)
);

-- Bảng khuyến mãi
CREATE TABLE promotions (
    promotion_id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    discount_type ENUM('percentage', 'fixed_amount') NOT NULL,
    discount_value DECIMAL(10, 2) NOT NULL,
    max_discount_amount DECIMAL(10, 2),
    min_purchase_amount DECIMAL(10, 2),
    usage_limit INT,
    used_count INT DEFAULT 0,
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL,
    status ENUM('active', 'inactive', 'expired') DEFAULT 'active',
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- Bảng sử dụng khuyến mãi
CREATE TABLE promotion_usage (
    usage_id INT PRIMARY KEY AUTO_INCREMENT,
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
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    title VARCHAR(200) NOT NULL,
    message TEXT,
    notification_type ENUM('booking', 'payment', 'promotion', 'system') NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Bảng cấu hình hệ thống
CREATE TABLE system_settings (
    setting_id INT PRIMARY KEY AUTO_INCREMENT,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT,
    description TEXT,
    updated_by INT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (updated_by) REFERENCES users(user_id)
);

-- Bảng log hoạt động
CREATE TABLE activity_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    action VARCHAR(100) NOT NULL,
    module VARCHAR(50) NOT NULL,
    record_id INT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ============================================
-- DỮ LIỆU MẪU CHO TẤT CẢ CÁC BẢNG
-- ============================================

-- ============================================
-- 1. NGƯỜI DÙNG (Users)
-- ============================================
INSERT INTO users (username, email, password_hash, full_name, phone, avatar_url, role_id, status, email_verified, last_login) VALUES
-- Super Admin
('admin', 'admin@travelweb.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Nguyễn Văn Admin', '0901234567', 'https://i.pravatar.cc/150?img=1', 1, 'active', TRUE, '2024-12-24 08:00:00'),

-- Admins
('manager1', 'manager1@travelweb.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Trần Thị Lan', '0902345678', 'https://i.pravatar.cc/150?img=2', 2, 'active', TRUE, '2024-12-23 14:30:00'),

-- Tour Managers
('tourmanager1', 'tourmanager1@travelweb.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Lê Văn Hùng', '0903456789', 'https://i.pravatar.cc/150?img=3', 3, 'active', TRUE, '2024-12-24 07:00:00'),
('tourmanager2', 'tourmanager2@travelweb.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Phạm Thị Mai', '0904567890', 'https://i.pravatar.cc/150?img=4', 3, 'active', TRUE, '2024-12-23 16:00:00'),

-- Content Managers
('content1', 'content1@travelweb.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Hoàng Minh Tuấn', '0905678901', 'https://i.pravatar.cc/150?img=5', 4, 'active', TRUE, '2024-12-24 09:00:00'),

-- Customer Service
('cs1', 'cs1@travelweb.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Vũ Thị Hương', '0906789012', 'https://i.pravatar.cc/150?img=6', 5, 'active', TRUE, '2024-12-24 08:30:00'),
('cs2', 'cs2@travelweb.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Đặng Văn Nam', '0907890123', 'https://i.pravatar.cc/150?img=7', 5, 'active', TRUE, '2024-12-23 17:00:00'),

-- Tour Guides
('guide1', 'guide1@travelweb.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Bùi Minh Quân', '0908901234', 'https://i.pravatar.cc/150?img=8', 6, 'active', TRUE, '2024-12-24 06:00:00'),
('guide2', 'guide2@travelweb.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Đinh Thị Thảo', '0909012345', 'https://i.pravatar.cc/150?img=9', 6, 'active', TRUE, '2024-12-23 18:00:00'),
('guide3', 'guide3@travelweb.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Ngô Văn Đức', '0900123456', 'https://i.pravatar.cc/150?img=10', 6, 'active', TRUE, '2024-12-24 05:30:00'),

-- Customers
('customer1', 'customer1@gmail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Trương Văn Anh', '0911234567', 'https://i.pravatar.cc/150?img=11', 7, 'active', TRUE, '2024-12-23 20:00:00'),
('customer2', 'customer2@gmail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Lý Thị Bích', '0912345678', 'https://i.pravatar.cc/150?img=12', 7, 'active', TRUE, '2024-12-24 10:00:00'),
('customer3', 'customer3@gmail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Phan Văn Cường', '0913456789', 'https://i.pravatar.cc/150?img=13', 7, 'active', TRUE, '2024-12-22 15:00:00'),
('customer4', 'customer4@gmail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Võ Thị Diễm', '0914567890', 'https://i.pravatar.cc/150?img=14', 7, 'active', TRUE, '2024-12-21 11:00:00'),
('customer5', 'customer5@gmail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Cao Văn Em', '0915678901', 'https://i.pravatar.cc/150?img=15', 7, 'active', TRUE, '2024-12-20 09:00:00');

-- ============================================
-- 2. ĐỊA ĐIỂM (Destinations)
-- ============================================
INSERT INTO destinations (name, country, city, description, image_url, is_popular, created_by) VALUES
('Vịnh Hạ Long', 'Việt Nam', 'Quảng Ninh', 'Di sản thiên nhiên thế giới với hàng nghìn đảo đá vôi và hang động kỳ vĩ', 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b', TRUE, 1),
('Phố Cổ Hội An', 'Việt Nam', 'Quảng Nam', 'Thành phố cổ với kiến trúc độc đáo, đèn lồng rực rỡ và văn hóa đa dạng', 'https://images.unsplash.com/photo-1583417319070-4a69db38a482', TRUE, 1),
('Vịnh Nha Trang', 'Việt Nam', 'Khánh Hòa', 'Bãi biển đẹp nhất Việt Nam với làn nước trong xanh và nhiều hoạt động thể thao', 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b', TRUE, 1),
('Đà Lạt', 'Việt Nam', 'Lâm Đồng', 'Thành phố ngàn hoa với khí hậu mát mẻ quanh năm', 'https://images.unsplash.com/photo-1583417319070-4a69db38a482', TRUE, 1),
('Phú Quốc', 'Việt Nam', 'Kiên Giang', 'Đảo Ngọc với bãi biển hoang sơ, rừng nhiệt đới và hải sản tươi ngon', 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b', TRUE, 1),
('Sapa', 'Việt Nam', 'Lào Cai', 'Cao nguyên mờ sương với ruộng bậc thang và văn hóa dân tộc thiểu số', 'https://images.unsplash.com/photo-1583417319070-4a69db38a482', TRUE, 1),
('Bangkok', 'Thái Lan', 'Bangkok', 'Thủ đô sôi động với chùa chiền lộng lẫy và ẩm thực đường phố hấp dẫn', 'https://images.unsplash.com/photo-1508009603885-50cf7c579365', TRUE, 1),
('Phuket', 'Thái Lan', 'Phuket', 'Hòn đảo nhiệt đới nổi tiếng với bãi biển tuyệt đẹp và cuộc sống về đêm sôi động', 'https://images.unsplash.com/photo-1589394815804-964ed0be2eb5', TRUE, 1),
('Singapore', 'Singapore', 'Singapore', 'Đảo quốc hiện đại với kiến trúc ấn tượng và ẩm thực đa văn hóa', 'https://images.unsplash.com/photo-1525625293386-3f8f99389edd', TRUE, 1),
('Bali', 'Indonesia', 'Bali', 'Hòn đảo thiên đường với bãi biển tuyệt đẹp, đền thờ cổ và văn hóa độc đáo', 'https://images.unsplash.com/photo-1537996194471-e657df975ab4', TRUE, 1),
('Tokyo', 'Nhật Bản', 'Tokyo', 'Thủ đô hiện đại kết hợp truyền thống với công nghệ tiên tiến', 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf', TRUE, 1),
('Seoul', 'Hàn Quốc', 'Seoul', 'Thành phố năng động với văn hóa K-pop, ẩm thực đặc sắc và lịch sử lâu đời', 'https://images.unsplash.com/photo-1517154421773-0529f29ea451', TRUE, 1);

-- ============================================
-- 3. DANH MỤC TOUR (Tour Categories)
-- ============================================
INSERT INTO tour_categories (category_name, description, icon_url) VALUES
('Du lịch biển đảo', 'Các tour du lịch khám phá biển, đảo và các hoạt động thể thao dưới nước', 'https://cdn-icons-png.flaticon.com/512/2990/2990507.png'),
('Du lịch văn hóa', 'Tìm hiểu văn hóa, lịch sử và di sản của các vùng đất', 'https://cdn-icons-png.flaticon.com/512/3524/3524335.png'),
('Du lịch mạo hiểm', 'Các hoạt động thể thao mạo hiểm và khám phá thiên nhiên', 'https://cdn-icons-png.flaticon.com/512/2927/2927347.png'),
('Du lịch sinh thái', 'Khám phá thiên nhiên, động thực vật và bảo vệ môi trường', 'https://cdn-icons-png.flaticon.com/512/2917/2917995.png'),
('Du lịch thành phố', 'Khám phá các thành phố lớn, mua sắm và giải trí', 'https://cdn-icons-png.flaticon.com/512/3076/3076404.png'),
('Du lịch ẩm thực', 'Trải nghiệm ẩm thực đặc sản và văn hóa ăn uống', 'https://cdn-icons-png.flaticon.com/512/3480/3480822.png'),
('Du lịch nghỉ dưỡng', 'Thư giãn và nghỉ dưỡng tại resort cao cấp', 'https://cdn-icons-png.flaticon.com/512/2933/2933245.png'),
('Du lịch tâm linh', 'Tham quan các địa điểm tâm linh, chùa chiền, đền đài', 'https://cdn-icons-png.flaticon.com/512/3124/3124492.png');

-- ============================================
-- 4. TOUR
-- ============================================
INSERT INTO tours (tour_code, title, category_id, destination_id, description, duration_days, duration_nights, max_participants, min_participants, price_adult, price_child, price_infant, discount_percentage, featured_image, status, created_by) VALUES
-- Tours Việt Nam
('VN-HL-001', 'Khám phá Vịnh Hạ Long - Bái Đính - Tràng An 3N2Đ', 1, 1, 'Trải nghiệm vẻ đẹp thiên nhiên tuyệt vời của Vịnh Hạ Long, khám phá chùa Bái Đính lớn nhất Việt Nam và quần thể danh thắng Tràng An. Du thuyền qua đêm trên vịnh, thưởng thức hải sản tươi ngon và tham gia các hoạt động thể thao nước.', 3, 2, 25, 10, 4500000.00, 3500000.00, 500000.00, 10.00, 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b', 'published', 3),

('VN-HAN-001', 'Tour Hội An - Bà Nà - Huế 4N3Đ', 2, 2, 'Khám phá phố cổ Hội An với hàng trăm ngôi nhà cổ, đền thờ và hội quán. Trải nghiệm cảm giác như ở châu Âu tại Bà Nà Hills với cây cầu Vàng nổi tiếng. Tham quan Cố đô Huế với các di tích lịch sử, lăng tẩm và chùa chiền.', 4, 3, 30, 12, 6500000.00, 5000000.00, 800000.00, 15.00, 'https://images.unsplash.com/photo-1583417319070-4a69db38a482', 'published', 3),

('VN-NT-001', 'Nha Trang - Vịnh Ninh Vân 3N2Đ', 1, 3, 'Tận hưởng kỳ nghỉ tại thành phố biển Nha Trang với các bãi biển đẹp nhất Việt Nam. Tham gia lặn ngắm san hô, câu cá, và các hoạt động thể thao nước. Khám phá Vinpearl Land và tắm bùn khoáng nóng.', 3, 2, 20, 8, 3800000.00, 2800000.00, 400000.00, 5.00, 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b', 'published', 3),

('VN-DL-001', 'Đà Lạt Lãng Mạn 3N2Đ', 4, 4, 'Khám phá thành phố ngàn hoa với khí hậu mát mẻ quanh năm. Tham quan Thung lũng Tình Yêu, hồ Xuân Hương, thác Datanla. Thưởng thức cà phê đặc sản và dâu tây tươi. Check-in các điểm sống ảo nổi tiếng.', 3, 2, 25, 10, 3500000.00, 2700000.00, 300000.00, 0.00, 'https://images.unsplash.com/photo-1583417319070-4a69db38a482', 'published', 3),

('VN-PQ-001', 'Phú Quốc - Đảo Ngọc 4N3Đ', 1, 5, 'Nghỉ dưỡng tại đảo Ngọc Phú Quốc với các resort 5 sao. Tham quan VinWonders, Safari, tắm biển Bãi Sao. Trải nghiệm cáp treo Hòn Thơm dài nhất thế giới. Thưởng thức hải sản tươi sống và đặc sản địa phương.', 4, 3, 20, 8, 7500000.00, 6000000.00, 1000000.00, 20.00, 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b', 'published', 3),

('VN-SP-001', 'Sapa - Fansipan - Bản Cát Cát 3N2Đ', 3, 6, 'Chinh phục nóc nhà Đông Dương Fansipan bằng cáp treo hiện đại. Trekking qua các bản làng dân tộc thiểu số, ngắm ruộng bậc thang tuyệt đẹp. Trải nghiệm văn hóa và ẩm thực độc đáo của vùng cao.', 3, 2, 18, 8, 4200000.00, 3200000.00, 500000.00, 0.00, 'https://images.unsplash.com/photo-1583417319070-4a69db38a482', 'published', 3),

-- Tours Thái Lan
('TH-BK-001', 'Bangkok - Pattaya 5N4Đ', 5, 7, 'Khám phá thủ đô Bangkok với Cung điện Hoàng gia, chùa Vàng, chợ nổi Damnoen Saduak. Tham quan Pattaya với bãi biển đẹp, Coral Island, và show Alcazar nổi tiếng. Mua sắm tại các trung tâm thương mại lớn.', 5, 4, 30, 15, 8500000.00, 7000000.00, 1500000.00, 10.00, 'https://images.unsplash.com/photo-1508009603885-50cf7c579365', 'published', 3),

('TH-PK-001', 'Phuket - Krabi - Đảo Phi Phi 6N5Đ', 1, 8, 'Tour khám phá các hòn đảo đẹp nhất Thái Lan. Phuket với Patong Beach, Krabi với bãi biển Railay, đảo Phi Phi với Maya Bay. Lặn ngắm san hô, kayaking, và thưởng thức hải sản tươi ngon.', 6, 5, 25, 12, 12000000.00, 9500000.00, 2000000.00, 15.00, 'https://images.unsplash.com/photo-1589394815804-964ed0be2eb5', 'published', 4),

-- Tours Singapore
('SG-001', 'Singapore Hiện Đại 4N3Đ', 5, 9, 'Khám phá đảo quốc sư tử với Gardens by the Bay, Marina Bay Sands, Universal Studios. Shopping tại Orchard Road. Trải nghiệm ẩm thực đa văn hóa tại Hawker Centers. Tham quan Sentosa Island.', 4, 3, 25, 10, 15000000.00, 12000000.00, 2500000.00, 0.00, 'https://images.unsplash.com/photo-1525625293386-3f8f99389edd', 'published', 4),

-- Tours Bali
('ID-BL-001', 'Bali - Thiên Đường Nhiệt Đới 5N4Đ', 7, 10, 'Nghỉ dưỡng tại hòn đảo thiên đường Bali. Tham quan đền Tanah Lot, Uluwatu, rừng khỉ Ubud. Thưởng thức massage truyền thống Bali. Tắm biển tại Kuta, Seminyak. Check-in cánh đồng lúa và xích đu Bali.', 5, 4, 20, 10, 11000000.00, 9000000.00, 1800000.00, 10.00, 'https://images.unsplash.com/photo-1537996194471-e657df975ab4', 'published', 4),

-- Tours Nhật Bản
('JP-TK-001', 'Tokyo - Phú Sĩ - Osaka 7N6Đ', 5, 11, 'Tour Nhật Bản khám phá Tokyo với Shibuya, Shinjuku, đền Sensoji. Ngắm núi Phú Sĩ và tắm onsen. Tham quan Osaka với lâu đài Osaka, phố Dotonbori. Trải nghiệm văn hóa Nhật Bản và ẩm thực đặc sắc.', 7, 6, 20, 12, 28000000.00, 24000000.00, 5000000.00, 5.00, 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf', 'published', 4),

-- Tours Hàn Quốc
('KR-SE-001', 'Seoul - Nami - Everland 5N4Đ', 5, 12, 'Khám phá thủ đô Seoul với cung điện Gyeongbokgung, làng Bukchon Hanok, tháp N Seoul. Tham quan đảo Nami lãng mạn, công viên Everland. Shopping tại Myeongdong, Dongdaemun. Thưởng thức BBQ Hàn Quốc.', 5, 4, 25, 12, 16000000.00, 13000000.00, 3000000.00, 10.00, 'https://images.unsplash.com/photo-1517154421773-0529f29ea451', 'published', 4);

-- ============================================
-- 5. HÌNH ẢNH TOUR
-- ============================================
INSERT INTO tour_images (tour_id, image_url, caption, display_order, uploaded_by) VALUES
-- Tour Hạ Long
(1, 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b', 'Vịnh Hạ Long - Di sản thiên nhiên thế giới', 1, 3),
(1, 'https://images.unsplash.com/photo-1583417319070-4a69db38a482', 'Du thuyền sang trọng trên vịnh', 2, 3),
(1, 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b', 'Hang Sửng Sốt - Kỳ quan thiên nhiên', 3, 3),

-- Tour Hội An
(2, 'https://images.unsplash.com/photo-1583417319070-4a69db38a482', 'Phố cổ Hội An về đêm', 1, 3),
(2, 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b', 'Cầu Vàng Bà Nà Hills', 2, 3),
(2, 'https://images.unsplash.com/photo-1583417319070-4a69db38a482', 'Đại Nội Huế', 3, 3),

-- Tour Nha Trang
(3, 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b', 'Bãi biển Nha Trang', 1, 3),
(3, 'https://images.unsplash.com/photo-1583417319070-4a69db38a482', 'Lặn ngắm san hô', 2, 3),

-- Tour Bangkok
(7, 'https://images.unsplash.com/photo-1508009603885-50cf7c579365', 'Chùa Vàng Bangkok', 1, 3),
(7, 'https://images.unsplash.com/photo-1589394815804-964ed0be2eb5', 'Chợ nổi Damnoen Saduak', 2, 3);

-- ============================================
-- 6. LỊCH TRÌNH TOUR
-- ============================================
INSERT INTO tour_schedules (tour_id, departure_date, return_date, available_slots, booked_slots, status, guide_id) VALUES
-- Tour Hạ Long (Tour 1)
(1, '2025-01-05', '2025-01-07', 25, 18, 'available', 8),
(1, '2025-01-12', '2025-01-14', 25, 23, 'available', 9),
(1, '2025-01-19', '2025-01-21', 25, 25, 'full', 8),
(1, '2025-01-26', '2025-01-28', 25, 12, 'available', 10),
(1, '2025-02-02', '2025-02-04', 25, 0, 'available', 8),

-- Tour Hội An (Tour 2)
(2, '2025-01-08', '2025-01-11', 30, 22, 'available', 9),
(2, '2025-01-15', '2025-01-18', 30, 28, 'available', 10),
(2, '2025-01-22', '2025-01-25', 30, 15, 'available', 9),
(2, '2025-02-05', '2025-02-08', 30, 0, 'available', 8),

-- Tour Nha Trang (Tour 3)
(3, '2025-01-10', '2025-01-12', 20, 16, 'available', 8),
(3, '2025-01-17', '2025-01-19', 20, 20, 'full', 9),
(3, '2025-01-24', '2025-01-26', 20, 8, 'available', 10),

-- Tour Đà Lạt (Tour 4)
(4, '2025-01-06', '2025-01-08', 25, 20, 'available', 9),
(4, '2025-01-13', '2025-01-15', 25, 18, 'available', 8),
(4, '2025-01-20', '2025-01-22', 25, 10, 'available', 10),

-- Tour Phú Quốc (Tour 5)
(5, '2025-01-09', '2025-01-12', 20, 15, 'available', 8),
(5, '2025-01-16', '2025-01-19', 20, 19, 'available', 9),
(5, '2025-02-06', '2025-02-09', 20, 0, 'available', 10),

-- Tour Sapa (Tour 6)
(6, '2025-01-11', '2025-01-13', 18, 14, 'available', 9),
(6, '2025-01-18', '2025-01-20', 18, 12, 'available', 10),

-- Tour Bangkok (Tour 7)
(7, '2025-01-07', '2025-01-11', 30, 25, 'available', 8),
(7, '2025-01-14', '2025-01-18', 30, 28, 'available', 9),
(7, '2025-02-04', '2025-02-08', 30, 0, 'available', 10),

-- Tour Phuket (Tour 8)
(8, '2025-01-12', '2025-01-17', 25, 20, 'available', 9),
(8, '2025-02-09', '2025-02-14', 25, 0, 'available', 8),

-- Tour Singapore (Tour 9)
(9, '2025-01-15', '2025-01-18', 25, 18, 'available', 10),
(9, '2025-02-12', '2025-02-15', 25, 0, 'available', 9),

-- Tour Bali (Tour 10)
(10, '2025-01-20', '2025-01-24', 20, 16, 'available', 8),
(10, '2025-02-17', '2025-02-21', 20, 0, 'available', 9);

-- ============================================
-- 7. ĐẶT TOUR (Bookings)
-- ============================================
INSERT INTO bookings (booking_code, schedule_id, user_id, customer_name, customer_email, customer_phone, num_adults, num_children, num_infants, total_amount, paid_amount, payment_status, booking_status, special_requests, confirmed_by, confirmed_at) VALUES
-- Bookings đã hoàn thành
('BK2024120001', 1, 11, 'Trương Văn Anh', 'customer1@gmail.com', '0911234567', 2, 1, 0, 11700000.00, 11700000.00, 'completed', 'completed', 'Cần phòng giường đôi', 6, '2024-12-15 10:00:00'),
('BK2024120002', 1, 12, 'Lý Thị Bích', 'customer2@gmail.com', '0912345678', 2, 0, 0, 8100000.00, 8100000.00, 'completed', 'completed', NULL, 6, '2024-12-16 14:30:00'),
('BK2024120003', 2, 13, 'Phan Văn Cường', 'customer3@gmail.com', '0913456789', 4, 2, 1, 28300000.00, 28300000.00, 'completed', 'confirmed', 'Nhóm gia đình có người già', 7, '2024-12-17 09:15:00'),
('BK2024120004', 3, 14, 'Võ Thị Diễm', 'customer4@gmail.com', '0914567890', 2, 1, 0, 8930000.00, 8930000.00, 'completed', 'confirmed', NULL, 6, '2024-12-18 16:45:00'),

-- Bookings đã xác nhận
('BK2024120005', 4, 15, 'Cao Văn Em', 'customer5@gmail.com', '0915678901', 3, 1, 0, 13650000.00, 6825000.00, 'partial', 'confirmed', 'Cần xe đưa đón sân bay', 7, '2024-12-19 11:20:00'),
('BK2024120006', 5, 11, 'Trương Văn Anh', 'customer1@gmail.com', '0911234567', 2, 2, 1, 19600000.00, 19600000.00, 'completed', 'confirmed', NULL, 6, '2024-12-20 13:00:00'),
('BK2024120007', 7, 12, 'Lý Thị Bích', 'customer2@gmail.com', '0912345678', 2, 0, 0, 5950000.00, 5950000.00, 'completed', 'confirmed', 'Muốn phòng tầng cao', 7, '2024-12-21 10:30:00'),

-- Bookings chờ xác nhận
('BK2024120008', 8, 13, 'Phan Văn Cường', 'customer3@gmail.com', '0913456789', 2, 1, 0, 15750000.00, 0.00, 'pending', 'pending', NULL, NULL, NULL),
('BK2024120009', 10, 14, 'Võ Thị Diễm', 'customer4@gmail.com', '0914567890', 3, 0, 0, 10830000.00, 0.00, 'pending', 'pending', 'Ăn chay', NULL, NULL),
('BK2024120010', 11, 15, 'Cao Văn Em', 'customer5@gmail.com', '0915678901', 4, 2, 1, 26980000.00, 0.00, 'pending', 'pending', 'Nhóm bạn thân', NULL, NULL),

-- Bookings đã hủy
('BK2024120011', 1, 12, 'Lý Thị Bích', 'customer2@gmail.com', '0912345678', 2, 0, 0, 8100000.00, 8100000.00, 'refunded', 'cancelled', 'Có việc đột xuất', 6, '2024-12-10 09:00:00');

-- ============================================
-- 8. THÔNG TIN KHÁCH HÀNG TRONG BOOKING
-- ============================================
INSERT INTO booking_participants (booking_id, full_name, date_of_birth, passport_number, participant_type) VALUES
-- Booking 1
(1, 'Trương Văn Anh', '1985-05-15', 'B1234567', 'adult'),
(1, 'Nguyễn Thị Lan', '1987-08-20', 'B7654321', 'adult'),
(1, 'Trương Minh Khang', '2015-03-10', 'B9876543', 'child'),

-- Booking 2
(2, 'Lý Thị Bích', '1990-12-25', 'B2468135', 'adult'),
(2, 'Phan Văn Nam', '1988-07-14', 'B1357924', 'adult'),

-- Booking 3
(3, 'Phan Văn Cường', '1982-04-18', 'B3691472', 'adult'),
(3, 'Trần Thị Hoa', '1984-11-22', 'B7539514', 'adult'),
(3, 'Phan Thị Mai', '1980-02-08', 'B9517536', 'adult'),
(3, 'Nguyễn Văn Tùng', '1979-09-30', 'B1593574', 'adult'),
(3, 'Phan Minh Tuấn', '2012-06-15', 'B3571598', 'child'),
(3, 'Phan Thảo Nguyên', '2014-01-20', 'B7531592', 'child'),
(3, 'Phan Bảo Ngọc', '2023-05-10', NULL, 'infant');

-- ============================================
-- 9. THANH TOÁN
-- ============================================
INSERT INTO payments (booking_id, payment_method, amount, transaction_id, payment_status, payment_date, processed_by, notes) VALUES
(1, 'bank_transfer', 11700000.00, 'TXN20241215001', 'completed', '2024-12-15 11:00:00', 6, 'Chuyển khoản qua VCB'),
(2, 'credit_card', 8100000.00, 'TXN20241216001', 'completed', '2024-12-16 15:00:00', 6, 'Thanh toán online'),
(3, 'bank_transfer', 28300000.00, 'TXN20241217001', 'completed', '2024-12-17 10:00:00', 7, 'Chuyển khoản qua ACB'),
(4, 'e_wallet', 8930000.00, 'TXN20241218001', 'completed', '2024-12-18 17:00:00', 6, 'Thanh toán qua Momo'),
(5, 'bank_transfer', 6825000.00, 'TXN20241219001', 'completed', '2024-12-19 12:00:00', 7, 'Đặt cọc 50%'),
(6, 'credit_card', 19600000.00, 'TXN20241220001', 'completed', '2024-12-20 14:00:00', 6, 'Thanh toán online'),
(7, 'bank_transfer', 5950000.00, 'TXN20241221001', 'completed', '2024-12-21 11:00:00', 7, 'Chuyển khoản qua VCB'),
(11, 'bank_transfer', 8100000.00, 'TXN20241210001', 'refunded', '2024-12-22 10:00:00', 6, 'Hoàn tiền do hủy tour');

-- ============================================
-- 10. ĐÁNH GIÁ TOUR
-- ============================================
INSERT INTO reviews (tour_id, booking_id, user_id, rating, title, comment, status, reviewed_by, reviewed_at) VALUES
(1, 1, 11, 5, 'Tour tuyệt vời, hướng dẫn viên nhiệt tình', 'Chuyến đi rất tuyệt vời, hướng dẫn viên nhiệt tình, khách sạn sạch sẽ. Cảnh đẹp như mơ. Sẽ giới thiệu cho bạn bè.', 'approved', 5, '2024-12-23 09:00:00'),
(1, 2, 12, 4, 'Đáng giá tiền', 'Tour tổ chức tốt, lịch trình hợp lý. Tuy nhiên thức ăn chưa đa dạng lắm. Nhìn chung vẫn hài lòng.', 'approved', 5, '2024-12-23 10:00:00'),
(2, 3, 13, 5, 'Gia đình rất thích chuyến đi này', 'Hội An đẹp lắm, các em nhỏ rất thích Bà Nà. Hướng dẫn viên dễ thương, chăm sóc chu đáo. Chắc chắn sẽ quay lại.', 'approved', 5, '2024-12-23 14:00:00'),
(3, 4, 14, 5, 'Biển Nha Trang đẹp tuyệt vời', 'Biển trong xanh, hoạt động lặn ngắm san hô rất thú vị. Khách sạn view biển đẹp. Đoàn đông vui nhộn.', 'approved', 5, '2024-12-23 16:00:00'),
(4, 7, 12, 4, 'Đà Lạt lãng mạn', 'Thời tiết mát mẻ, cảnh đẹp. Tuy nhiên di chuyển khá xa. Nhìn chung ổn, phù hợp với cặp đôi.', 'pending', NULL, NULL);

-- ============================================
-- 11. BÀI VIẾT BLOG
-- ============================================
INSERT INTO blog_posts (title, slug, content, excerpt, featured_image, author_id, status, published_at) VALUES
('10 Điểm Đến Không Thể Bỏ Qua Khi Du Lịch Việt Nam', '10-diem-den-khong-the-bo-qua-khi-du-lich-viet-nam', 'Việt Nam là một đất nước với vẻ đẹp thiên nhiên đa dạng và văn hóa phong phú. Từ vịnh biển tuyệt đẹp đến những thành phố cổ kính, từ núi non hùng vĩ đến đồng bằng bát ngát...', 'Khám phá 10 địa điểm du lịch đẹp nhất Việt Nam mà bạn không nên bỏ lỡ trong chuyến hành trình khám phá đất nước hình chữ S.', 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b', 5, 'published', '2024-12-01 10:00:00'),

('Kinh Nghiệm Du Lịch Thái Lan Tự Túc Chi Tiết Nhất', 'kinh-nghiem-du-lich-thai-lan-tu-tuc-chi-tiet-nhat', 'Thái Lan là điểm đến yêu thích của nhiều du khách Việt Nam. Với chi phí hợp lý, văn hóa độc đáo và ẩm thực phong phú, Thái Lan luôn là lựa chọn hàng đầu...', 'Hướng dẫn chi tiết về visa, vé máy bay, khách sạn, phương tiện di chuyển và các điểm tham quan khi du lịch Thái Lan tự túc.', 'https://images.unsplash.com/photo-1508009603885-50cf7c579365', 5, 'published', '2024-12-05 14:00:00'),

('Top 5 Resort Cao Cấp Tại Phú Quốc Đáng Trải Nghiệm', 'top-5-resort-cao-cap-tai-phu-quoc-dang-trai-nghiem', 'Phú Quốc không chỉ nổi tiếng với biển đẹp mà còn có nhiều resort sang trọng. Dưới đây là top 5 resort cao cấp nhất đảo Ngọc...', 'Khám phá 5 resort 5 sao đẳng cấp nhất tại Phú Quốc với dịch vụ hoàn hảo, view biển tuyệt đẹp và không gian nghỉ dưỡng sang trọng.', 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b', 5, 'published', '2024-12-10 09:00:00'),

('Ẩm Thực Đường Phố Bangkok - Những Món Ăn Phải Thử', 'am-thuc-duong-pho-bangkok-nhung-mon-an-phai-thu', 'Bangkok được mệnh danh là thiên đường ẩm thực đường phố của châu Á. Với vô số món ăn đặc sắc và giá cả phải chăng...', 'Điểm danh những món ăn đường phố Bangkok nhất định phải thử: Pad Thai, Tom Yum Goong, Mango Sticky Rice và nhiều món khác.', 'https://images.unsplash.com/photo-1508009603885-50cf7c579365', 5, 'published', '2024-12-15 16:00:00'),

('Hướng Dẫn Xin Visa Nhật Bản Tự Túc 2024', 'huong-dan-xin-visa-nhat-ban-tu-tuc-2024', 'Xin visa Nhật Bản không khó như bạn nghĩ. Bài viết này sẽ hướng dẫn chi tiết từng bước để xin visa du lịch Nhật Bản...', 'Hướng dẫn chi tiết thủ tục, hồ sơ và kinh nghiệm xin visa du lịch Nhật Bản tự túc với tỷ lệ đỗ cao năm 2024.', 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf', 5, 'draft', NULL);

-- ============================================
-- 12. KHUYẾN MÃI
-- ============================================
INSERT INTO promotions (code, description, discount_type, discount_value, max_discount_amount, min_purchase_amount, usage_limit, used_count, valid_from, valid_to, status, created_by) VALUES
('SUMMER2025', 'Khuyến mãi mùa hè - Giảm 15% cho tour trong nước', 'percentage', 15.00, 2000000.00, 5000000.00, 100, 25, '2025-01-01', '2025-03-31', 'active', 1),
('NEWYEAR25', 'Chúc mừng năm mới - Giảm 500K cho mọi đơn hàng', 'fixed_amount', 500000.00, NULL, 3000000.00, 200, 68, '2024-12-20', '2025-01-10', 'active', 1),
('BANGKOK50', 'Ưu đãi đặc biệt tour Bangkok', 'percentage', 10.00, 1000000.00, 7000000.00, 50, 32, '2025-01-01', '2025-02-28', 'active', 3),
('FIRSTBOOK', 'Giảm giá cho khách hàng đặt tour lần đầu', 'percentage', 20.00, 1500000.00, 4000000.00, 150, 45, '2024-12-01', '2025-12-31', 'active', 1),
('FAMILY2025', 'Ưu đãi gia đình - Giảm 1 triệu cho tour từ 4 người', 'fixed_amount', 1000000.00, NULL, 10000000.00, 80, 28, '2025-01-01', '2025-06-30', 'active', 3),
('SINGAPORE15', 'Giảm 15% tour Singapore', 'percentage', 15.00, 2500000.00, 12000000.00, 30, 12, '2025-01-15', '2025-03-15', 'active', 4),
('FLASH300', 'Flash sale - Giảm 300K', 'fixed_amount', 300000.00, NULL, 2000000.00, 100, 89, '2024-12-15', '2024-12-31', 'expired', 1);

-- ============================================
-- 13. SỬ DỤNG KHUYẾN MÃI
-- ============================================
INSERT INTO promotion_usage (promotion_id, booking_id, user_id, discount_amount, used_at) VALUES
(1, 1, 11, 1000000.00, '2024-12-15 10:30:00'),
(2, 2, 12, 500000.00, '2024-12-16 14:45:00'),
(3, 3, 13, 1500000.00, '2024-12-17 09:30:00'),
(4, 5, 15, 1000000.00, '2024-12-19 11:45:00'),
(2, 6, 11, 500000.00, '2024-12-20 13:15:00');

-- ============================================
-- 14. THÔNG BÁO
-- ============================================
INSERT INTO notifications (user_id, title, message, notification_type, is_read, created_at) VALUES
-- Thông báo cho customer1
(11, 'Đặt tour thành công', 'Bạn đã đặt tour "Khám phá Vịnh Hạ Long" thành công. Mã booking: BK2024120001', 'booking', TRUE, '2024-12-15 10:00:00'),
(11, 'Thanh toán thành công', 'Thanh toán 11,700,000 VNĐ cho booking BK2024120001 đã được xác nhận', 'payment', TRUE, '2024-12-15 11:00:00'),
(11, 'Xác nhận booking', 'Booking BK2024120001 của bạn đã được xác nhận. Chúc bạn có chuyến đi vui vẻ!', 'booking', TRUE, '2024-12-15 11:30:00'),
(11, 'Khuyến mãi hot đang chờ bạn!', 'Giảm 15% cho tour mùa hè 2025. Sử dụng mã SUMMER2025', 'promotion', FALSE, '2024-12-23 09:00:00'),

-- Thông báo cho customer2
(12, 'Đặt tour thành công', 'Bạn đã đặt tour "Khám phá Vịnh Hạ Long" thành công. Mã booking: BK2024120002', 'booking', TRUE, '2024-12-16 14:30:00'),
(12, 'Thanh toán thành công', 'Thanh toán 8,100,000 VNĐ cho booking BK2024120002 đã được xác nhận', 'payment', TRUE, '2024-12-16 15:00:00'),
(12, 'Tour khởi hành sau 3 ngày', 'Tour Đà Lạt Lãng Mạn của bạn sẽ khởi hành vào ngày 06/01/2025', 'booking', FALSE, '2024-12-24 08:00:00'),

-- Thông báo cho customer3
(13, 'Đặt tour thành công', 'Bạn đã đặt tour "Tour Hội An - Bà Nà - Huế" thành công. Mã booking: BK2024120003', 'booking', TRUE, '2024-12-17 09:15:00'),
(13, 'Xác nhận booking', 'Booking BK2024120003 của bạn đã được xác nhận', 'booking', TRUE, '2024-12-17 10:30:00'),
(13, 'Booking chờ xác nhận', 'Booking BK2024120008 của bạn đang chờ xác nhận. Vui lòng thanh toán để giữ chỗ.', 'booking', FALSE, '2024-12-22 10:00:00'),

-- Thông báo cho customer4
(14, 'Đặt tour thành công', 'Bạn đã đặt tour "Nha Trang - Vịnh Ninh Vân" thành công. Mã booking: BK2024120004', 'booking', TRUE, '2024-12-18 16:45:00'),
(14, 'Flash Sale đặc biệt!', 'Giảm giá sốc 20% cho khách đặt tour lần đầu. Mã: FIRSTBOOK', 'promotion', FALSE, '2024-12-23 10:00:00'),

-- Thông báo cho customer5
(15, 'Thanh toán một phần thành công', 'Đã nhận thanh toán 50% (6,825,000 VNĐ) cho booking BK2024120005', 'payment', TRUE, '2024-12-19 12:00:00'),
(15, 'Nhắc nhở thanh toán', 'Vui lòng thanh toán số tiền còn lại cho booking BK2024120005 trước ngày 02/01/2025', 'payment', FALSE, '2024-12-24 09:00:00'),

-- Thông báo hệ thống
(11, 'Cập nhật điều khoản dịch vụ', 'Điều khoản sử dụng dịch vụ đã được cập nhật. Vui lòng xem chi tiết.', 'system', FALSE, '2024-12-20 08:00:00'),
(12, 'Cập nhật điều khoản dịch vụ', 'Điều khoản sử dụng dịch vụ đã được cập nhật. Vui lòng xem chi tiết.', 'system', FALSE, '2024-12-20 08:00:00'),
(13, 'Cập nhật điều khoản dịch vụ', 'Điều khoản sử dụng dịch vụ đã được cập nhật. Vui lòng xem chi tiết.', 'system', FALSE, '2024-12-20 08:00:00');

-- ============================================
-- 15. CẤU HÌNH HỆ THỐNG
-- ============================================
INSERT INTO system_settings (setting_key, setting_value, description, updated_by) VALUES
('site_name', 'VietTravel - Du lịch Việt Nam', 'Tên website', 1),
('site_email', 'info@viettravel.com', 'Email liên hệ chính', 1),
('site_phone', '1900-xxxx', 'Số điện thoại hotline', 1),
('site_address', '123 Nguyễn Huệ, Quận 1, TP.HCM', 'Địa chỉ công ty', 1),
('booking_deposit_percentage', '50', 'Phần trăm đặt cọc khi booking (%)', 1),
('booking_cancel_hours', '48', 'Số giờ tối thiểu trước khi hủy booking không mất phí', 1),
('currency', 'VND', 'Đơn vị tiền tệ', 1),
('timezone', 'Asia/Ho_Chi_Minh', 'Múi giờ', 1),
('items_per_page', '20', 'Số item hiển thị mỗi trang', 1),
('max_upload_size', '5242880', 'Kích thước file upload tối đa (bytes) - 5MB', 1),
('enable_reviews', 'true', 'Bật/tắt chức năng đánh giá', 1),
('auto_approve_reviews', 'false', 'Tự động duyệt đánh giá', 1),
('facebook_url', 'https://facebook.com/viettravel', 'Link Facebook fanpage', 5),
('instagram_url', 'https://instagram.com/viettravel', 'Link Instagram', 5),
('youtube_url', 'https://youtube.com/viettravel', 'Link Youtube channel', 5),
('payment_methods', 'credit_card,debit_card,bank_transfer,e_wallet', 'Các phương thức thanh toán được hỗ trợ', 1),
('email_notification', 'true', 'Bật/tắt thông báo qua email', 1),
('sms_notification', 'false', 'Bật/tắt thông báo qua SMS', 1),
('maintenance_mode', 'false', 'Chế độ bảo trì website', 1),
('google_analytics_id', 'UA-XXXXXXXXX-X', 'Google Analytics ID', 1);

-- ============================================
-- 16. LOG HOẠT ĐỘNG
-- ============================================
INSERT INTO activity_logs (user_id, action, module, record_id, ip_address, user_agent, created_at) VALUES
-- Admin activities
(1, 'login', 'auth', NULL, '118.70.183.16', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2024-12-24 08:00:00'),
(1, 'create', 'tour', 1, '118.70.183.16', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2024-12-01 09:30:00'),
(1, 'update', 'system_settings', 1, '118.70.183.16', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2024-12-10 14:20:00'),

-- Tour Manager activities
(3, 'login', 'auth', NULL, '118.70.183.25', 'Mozilla/5.0 (Macintosh; Intel Mac OS X)', '2024-12-24 07:00:00'),
(3, 'create', 'tour', 7, '118.70.183.25', 'Mozilla/5.0 (Macintosh; Intel Mac OS X)', '2024-12-05 10:15:00'),
(3, 'update', 'tour', 5, '118.70.183.25', 'Mozilla/5.0 (Macintosh; Intel Mac OS X)', '2024-12-12 11:30:00'),
(3, 'create', 'tour_schedule', 1, '118.70.183.25', 'Mozilla/5.0 (Macintosh; Intel Mac OS X)', '2024-12-15 09:00:00'),

-- Customer Service activities
(6, 'login', 'auth', NULL, '118.70.183.45', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2024-12-24 08:30:00'),
(6, 'confirm', 'booking', 1, '118.70.183.45', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2024-12-15 10:00:00'),
(6, 'confirm', 'booking', 2, '118.70.183.45', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2024-12-16 14:30:00'),
(6, 'process', 'payment', 1, '118.70.183.45', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2024-12-15 11:00:00'),

-- Content Manager activities
(5, 'login', 'auth', NULL, '118.70.183.58', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2024-12-24 09:00:00'),
(5, 'create', 'blog_post', 1, '118.70.183.58', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2024-12-01 10:00:00'),
(5, 'publish', 'blog_post', 1, '118.70.183.58', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2024-12-01 14:00:00'),
(5, 'approve', 'review', 1, '118.70.183.58', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2024-12-23 09:00:00'),

-- Customer activities
(11, 'login', 'auth', NULL, '14.161.xx.xx', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0)', '2024-12-23 20:00:00'),
(11, 'create', 'booking', 1, '14.161.xx.xx', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0)', '2024-12-15 10:00:00'),
(11, 'create', 'review', 1, '14.161.xx.xx', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0)', '2024-12-23 09:00:00'),

(12, 'login', 'auth', NULL, '14.161.xx.xx', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2024-12-24 10:00:00'),
(12, 'create', 'booking', 2, '14.161.xx.xx', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2024-12-16 14:30:00'),
(12, 'cancel', 'booking', 11, '14.161.xx.xx', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2024-12-10 09:00:00'),

(13, 'login', 'auth', NULL, '14.161.xx.xx', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2024-12-22 15:00:00'),
(13, 'create', 'booking', 3, '14.161.xx.xx', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2024-12-17 09:15:00'),
(13, 'create', 'booking', 8, '14.161.xx.xx', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '2024-12-22 10:00:00'),

-- Tour Guide activities
(8, 'login', 'auth', NULL, '118.70.183.78', 'Mozilla/5.0 (Android 12; Mobile)', '2024-12-24 06:00:00'),
(8, 'view', 'tour_schedule', 1, '118.70.183.78', 'Mozilla/5.0 (Android 12; Mobile)', '2024-12-24 06:15:00'),
(9, 'login', 'auth', NULL, '118.70.183.89', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0)', '2024-12-23 18:00:00'),
(9, 'view', 'booking', 3, '118.70.183.89', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0)', '2024-12-23 18:30:00');

-- ============================================
-- KẾT THÚC DỮ LIỆU MẪU
-- ============================================

-- Query kiểm tra dữ liệu
-- SELECT COUNT(*) as total_users FROM users;
-- SELECT COUNT(*) as total_tours FROM tours;
-- SELECT COUNT(*) as total_bookings FROM bookings;
-- SELECT COUNT(*) as total_payments FROM payments;
-- SELECT COUNT(*) as total_reviews FROM reviews;

-- Phân quyền cho Super Admin (tất cả quyền)
INSERT INTO role_permissions (role_id, permission_id)
SELECT 1, permission_id FROM permissions;

-- Phân quyền cho Admin
INSERT INTO role_permissions (role_id, permission_id)
SELECT 2, permission_id FROM permissions 
WHERE permission_name NOT IN ('user.manage_roles', 'system.edit_settings');

-- Phân quyền cho Tour Manager
INSERT INTO role_permissions (role_id, permission_id)
SELECT 3, permission_id FROM permissions 
WHERE module IN ('tour', 'booking') OR permission_name IN ('report.view_bookings', 'report.export');

-- Phân quyền cho Content Manager
INSERT INTO role_permissions (role_id, permission_id)
SELECT 4, permission_id FROM permissions 
WHERE module = 'content' OR module = 'review';

-- Phân quyền cho Customer Service
INSERT INTO role_permissions (role_id, permission_id)
SELECT 5, permission_id FROM permissions 
WHERE module IN ('booking', 'payment') 
   OR permission_name IN ('tour.view', 'customer.view', 'promotion.view');

-- Phân quyền cho Tour Guide
INSERT INTO role_permissions (role_id, permission_id)
SELECT 6, permission_id FROM permissions 
WHERE permission_name IN ('tour.view', 'booking.view_all');

-- Phân quyền cho Customer
INSERT INTO role_permissions (role_id, permission_id)
SELECT 7, permission_id FROM permissions 
WHERE permission_name IN ('tour.view', 'booking.view_own', 'booking.create', 'booking.cancel', 'review.view', 'promotion.view');