-- =====================================================
-- SCRIPT RESET VÀ TẠO DỮ LIỆU MẪU CHO WEBSITE DU LỊCH
-- Ngôn ngữ: Tiếng Việt
-- =====================================================

-- =====================================================
-- BƯỚC 1: XÓA TẤT CẢ DỮ LIỆU CŨ (GIỮ CẤU TRÚC BẢNG)
-- =====================================================

-- Tắt foreign key constraints tạm thời
SET session_replication_role = 'replica';

-- Xóa dữ liệu từ các bảng (theo thứ tự ngược lại với foreign key)
TRUNCATE TABLE activity_logs CASCADE;
TRUNCATE TABLE promotion_usage CASCADE;
TRUNCATE TABLE promotions CASCADE;
TRUNCATE TABLE notifications CASCADE;
TRUNCATE TABLE system_settings CASCADE;
TRUNCATE TABLE reviews CASCADE;
TRUNCATE TABLE blog_posts CASCADE;
TRUNCATE TABLE payments CASCADE;
TRUNCATE TABLE booking_participants CASCADE;
TRUNCATE TABLE bookings CASCADE;
TRUNCATE TABLE tour_schedules CASCADE;
TRUNCATE TABLE tour_images CASCADE;
TRUNCATE TABLE tours CASCADE;
TRUNCATE TABLE tour_categories CASCADE;
TRUNCATE TABLE destinations CASCADE;
TRUNCATE TABLE role_permissions CASCADE;
TRUNCATE TABLE permissions CASCADE;
TRUNCATE TABLE users CASCADE;
TRUNCATE TABLE roles CASCADE;

-- Bật lại foreign key constraints
SET session_replication_role = 'origin';

-- Reset sequences
ALTER SEQUENCE roles_role_id_seq RESTART WITH 1;
ALTER SEQUENCE users_user_id_seq RESTART WITH 1;
ALTER SEQUENCE permissions_permission_id_seq RESTART WITH 1;
ALTER SEQUENCE destinations_destination_id_seq RESTART WITH 1;
ALTER SEQUENCE tour_categories_category_id_seq RESTART WITH 1;
ALTER SEQUENCE tours_tour_id_seq RESTART WITH 1;
ALTER SEQUENCE tour_images_image_id_seq RESTART WITH 1;
ALTER SEQUENCE tour_schedules_schedule_id_seq RESTART WITH 1;
ALTER SEQUENCE bookings_booking_id_seq RESTART WITH 1;
ALTER SEQUENCE booking_participants_participant_id_seq RESTART WITH 1;
ALTER SEQUENCE payments_payment_id_seq RESTART WITH 1;
ALTER SEQUENCE reviews_review_id_seq RESTART WITH 1;
ALTER SEQUENCE blog_posts_post_id_seq RESTART WITH 1;
ALTER SEQUENCE promotions_promotion_id_seq RESTART WITH 1;
ALTER SEQUENCE promotion_usage_usage_id_seq RESTART WITH 1;
ALTER SEQUENCE notifications_notification_id_seq RESTART WITH 1;
ALTER SEQUENCE system_settings_setting_id_seq RESTART WITH 1;
ALTER SEQUENCE activity_logs_log_id_seq RESTART WITH 1;

-- =====================================================
-- BƯỚC 2: TẠO DỮ LIỆU MẪU
-- =====================================================

-- =====================================================
-- 1. VAI TRÒ (ROLES)
-- =====================================================
INSERT INTO roles (role_name, role_description) VALUES
('Super Admin', 'Quản trị viên cấp cao nhất, có toàn quyền truy cập hệ thống'),
('Admin', 'Quản trị viên, quản lý toàn bộ hệ thống'),
('Tour Manager', 'Quản lý tour, lịch trình và điểm đến'),
('Content Manager', 'Quản lý nội dung blog và đánh giá'),
('Customer Support', 'Hỗ trợ khách hàng, xử lý booking'),
('Accountant', 'Kế toán, quản lý thanh toán và doanh thu'),
('Customer', 'Khách hàng, đặt tour và đánh giá');

-- =====================================================
-- 2. QUYỀN HẠN (PERMISSIONS)
-- =====================================================
INSERT INTO permissions (permission_name, permission_description, module) VALUES
-- User module
('user.view', 'Xem danh sách người dùng', 'user'),
('user.create', 'Tạo người dùng mới', 'user'),
('user.edit', 'Chỉnh sửa thông tin người dùng', 'user'),
('user.delete', 'Xóa người dùng', 'user'),
('user.manage_roles', 'Quản lý vai trò người dùng', 'user'),

-- System module
('system.view_settings', 'Xem cài đặt hệ thống', 'system'),
('system.edit_settings', 'Chỉnh sửa cài đặt hệ thống', 'system'),
('system.view_logs', 'Xem nhật ký hoạt động', 'system'),

-- Tour module
('tour.view', 'Xem danh sách tour', 'tour'),
('tour.create', 'Tạo tour mới', 'tour'),
('tour.edit', 'Chỉnh sửa tour', 'tour'),
('tour.delete', 'Xóa tour', 'tour'),
('tour.publish', 'Xuất bản tour', 'tour'),

-- Booking module
('booking.view', 'Xem tất cả đơn đặt tour', 'booking'),
('booking.view_own', 'Xem đơn đặt tour của mình', 'booking'),
('booking.create', 'Tạo đơn đặt tour', 'booking'),
('booking.edit', 'Chỉnh sửa đơn đặt tour', 'booking'),
('booking.cancel', 'Hủy đơn đặt tour', 'booking'),
('booking.confirm', 'Xác nhận đơn đặt tour', 'booking'),

-- Payment module
('payment.view', 'Xem danh sách thanh toán', 'payment'),
('payment.create', 'Tạo giao dịch thanh toán', 'payment'),
('payment.process', 'Xử lý thanh toán', 'payment'),
('payment.refund', 'Hoàn tiền', 'payment'),

-- Review module
('review.view', 'Xem đánh giá', 'review'),
('review.create', 'Tạo đánh giá', 'review'),
('review.approve', 'Duyệt đánh giá', 'review'),
('review.delete', 'Xóa đánh giá', 'review'),

-- Content module
('content.view', 'Xem nội dung blog', 'content'),
('content.create', 'Tạo bài viết blog', 'content'),
('content.edit', 'Chỉnh sửa bài viết', 'content'),
('content.delete', 'Xóa bài viết', 'content'),
('content.publish', 'Xuất bản bài viết', 'content'),

-- Promotion module
('promotion.view', 'Xem khuyến mãi', 'promotion'),
('promotion.create', 'Tạo mã khuyến mãi', 'promotion'),
('promotion.edit', 'Chỉnh sửa khuyến mãi', 'promotion'),
('promotion.delete', 'Xóa khuyến mãi', 'promotion'),

-- Report module
('report.view_revenue', 'Xem báo cáo doanh thu', 'report'),
('report.view_statistics', 'Xem thống kê hệ thống', 'report'),

-- Customer module
('customer.view', 'Xem thông tin khách hàng', 'customer'),
('customer.manage', 'Quản lý khách hàng', 'customer');

-- =====================================================
-- 3. GÁN QUYỀN CHO VAI TRÒ (ROLE_PERMISSIONS)
-- =====================================================

-- Super Admin: Tất cả quyền
INSERT INTO role_permissions (role_id, permission_id)
SELECT 1, permission_id FROM permissions;

-- Admin: Hầu hết các quyền trừ manage_roles
INSERT INTO role_permissions (role_id, permission_id)
SELECT 2, permission_id FROM permissions WHERE permission_name != 'user.manage_roles';

-- Tour Manager: Quyền quản lý tour, booking, schedule
INSERT INTO role_permissions (role_id, permission_id)
SELECT 3, permission_id FROM permissions 
WHERE module IN ('tour', 'booking') OR permission_name IN ('customer.view', 'report.view_statistics');

-- Content Manager: Quyền quản lý nội dung
INSERT INTO role_permissions (role_id, permission_id)
SELECT 4, permission_id FROM permissions 
WHERE module IN ('content', 'review');

-- Customer Support: Quyền hỗ trợ khách hàng
INSERT INTO role_permissions (role_id, permission_id)
SELECT 5, permission_id FROM permissions 
WHERE module IN ('booking', 'customer') OR permission_name IN ('tour.view', 'payment.view');

-- Accountant: Quyền quản lý thanh toán
INSERT INTO role_permissions (role_id, permission_id)
SELECT 6, permission_id FROM permissions 
WHERE module IN ('payment', 'report') OR permission_name IN ('booking.view');

-- Customer: Quyền cơ bản của khách hàng
INSERT INTO role_permissions (role_id, permission_id)
SELECT 7, permission_id FROM permissions 
WHERE permission_name IN ('tour.view', 'booking.view_own', 'booking.create', 'booking.cancel', 'review.create', 'content.view');

-- =====================================================
-- 4. NGƯỜI DÙNG (USERS)
-- Mật khẩu mặc định: "password123" (đã hash với bcrypt)
-- =====================================================
INSERT INTO users (username, email, password_hash, full_name, phone, role_id, status, email_verified) VALUES
-- Super Admin
('superadmin', 'superadmin@travelweb.vn', '$2a$10$YourHashedPasswordHere', 'Nguyễn Văn Admin', '0901234567', 1, 'active', true),

-- Admin
('admin', 'admin@travelweb.vn', '$2a$10$YourHashedPasswordHere', 'Trần Thị Quản Lý', '0902345678', 2, 'active', true),

-- Tour Manager
('tourmanager', 'tourmanager@travelweb.vn', '$2a$10$YourHashedPasswordHere', 'Lê Văn Tour', '0903456789', 3, 'active', true),

-- Content Manager
('contentmanager', 'content@travelweb.vn', '$2a$10$YourHashedPasswordHere', 'Phạm Thị Nội Dung', '0904567890', 4, 'active', true),

-- Customer Support
('support', 'support@travelweb.vn', '$2a$10$YourHashedPasswordHere', 'Hoàng Văn Hỗ Trợ', '0905678901', 5, 'active', true),

-- Accountant
('accountant', 'accountant@travelweb.vn', '$2a$10$YourHashedPasswordHere', 'Đặng Thị Kế Toán', '0906789012', 6, 'active', true),

-- Customers
('customer1', 'customer1@gmail.com', '$2a$10$YourHashedPasswordHere', 'Nguyễn Minh Anh', '0907890123', 7, 'active', true),
('customer2', 'customer2@gmail.com', '$2a$10$YourHashedPasswordHere', 'Trần Hoàng Bảo', '0908901234', 7, 'active', true),
('customer3', 'customer3@gmail.com', '$2a$10$YourHashedPasswordHere', 'Lê Thị Cẩm', '0909012345', 7, 'active', true),
('customer4', 'customer4@gmail.com', '$2a$10$YourHashedPasswordHere', 'Phạm Văn Dũng', '0910123456', 7, 'active', true);

-- =====================================================
-- 5. ĐIỂM ĐẾN (DESTINATIONS)
-- =====================================================
INSERT INTO destinations (name, country, city, description, image_url, is_popular, created_by) VALUES
('Vịnh Hạ Long', 'Việt Nam', 'Quảng Ninh', 'Di sản thiên nhiên thế giới với hàng nghìn hòn đảo đá vôi kỳ vĩ, hang động tuyệt đẹp và làn nước xanh ngọc bích.', '/uploads/destinations/ha-long-bay.jpg', true, 3),
('Phố Cổ Hội An', 'Việt Nam', 'Quảng Nam', 'Thành phố cổ được UNESCO công nhận, nổi tiếng với kiến trúc cổ kính, đèn lồng rực rỡ và ẩm thực đặc sắc.', '/uploads/destinations/hoi-an.jpg', true, 3),
('Đà Lạt', 'Việt Nam', 'Lâm Đồng', 'Thành phố ngàn hoa với khí hậu mát mẻ quanh năm, thác nước, hồ, đồi chè và kiến trúc Pháp cổ điển.', '/uploads/destinations/da-lat.jpg', true, 3),
('Phú Quốc', 'Việt Nam', 'Kiên Giang', 'Đảo ngọc với bãi biển cát trắng, nước biển trong xanh, rừng nguyên sinh và hải sản tươi ngon.', '/uploads/destinations/phu-quoc.jpg', true, 3),
('Sapa', 'Việt Nam', 'Lào Cai', 'Vùng núi non hùng vĩ với ruộng bậc thang, văn hóa dân tộc thiểu số đa dạng và khí hậu se lạnh.', '/uploads/destinations/sapa.jpg', true, 3),
('Nha Trang', 'Việt Nam', 'Khánh Hòa', 'Thành phố biển nổi tiếng với bãi tắm đẹp, đảo Hon Mun, Vinpearl Land và các hoạt động thể thao biển.', '/uploads/destinations/nha-trang.jpg', true, 3),
('Huế', 'Việt Nam', 'Thừa Thiên Huế', 'Cố đô với di sản văn hóa phong phú, Đại Nội, lăng tẩm các vua triều Nguyễn và ẩm thực cung đình.', '/uploads/destinations/hue.jpg', true, 3),
('Đà Nẵng', 'Việt Nam', 'Đà Nẵng', 'Thành phố đáng sống với bãi biển Mỹ Khê, Bà Nà Hills, cầu Rồng và ẩm thực đường phố phong phú.', '/uploads/destinations/da-nang.jpg', true, 3),
('Mũi Né', 'Việt Nam', 'Bình Thuận', 'Thiên đường nghỉ dưỡng với đồi cát bay, suối tiên, làng chài và các resort cao cấp.', '/uploads/destinations/mui-ne.jpg', false, 3),
('Ninh Bình', 'Việt Nam', 'Ninh Bình', 'Vịnh Hạ Long trên cạn với Tràng An, Tam Cốc, Bích Động và cố đô Hoa Lư.', '/uploads/destinations/ninh-binh.jpg', false, 3);

-- =====================================================
-- 6. DANH MỤC TOUR (TOUR_CATEGORIES)
-- =====================================================
INSERT INTO tour_categories (category_name, description, icon_url) VALUES
('Tour Biển Đảo', 'Khám phá các bãi biển đẹp, đảo ngọc và hoạt động thể thao biển', '/icons/beach.svg'),
('Tour Núi Rừng', 'Chinh phục núi non, trekking, khám phá thiên nhiên hoang dã', '/icons/mountain.svg'),
('Tour Văn Hóa', 'Tìm hiểu lịch sử, văn hóa, di sản và kiến trúc cổ', '/icons/culture.svg'),
('Tour Ẩm Thực', 'Trải nghiệm ẩm thực đặc sản vùng miền', '/icons/food.svg'),
('Tour Mạo Hiểm', 'Các hoạt động mạo hiểm như leo núi, lặn biển, dù lượn', '/icons/adventure.svg'),
('Tour Nghỉ Dưỡng', 'Thư giãn tại resort, spa, massage và chăm sóc sức khỏe', '/icons/relax.svg'),
('Tour Khám Phá', 'Khám phá địa điểm mới, trải nghiệm độc đáo', '/icons/explore.svg'),
('Tour Gia Đình', 'Phù hợp cho cả gia đình, có trẻ em', '/icons/family.svg');

-- =====================================================
-- 7. TOUR DU LỊCH (TOURS)
-- =====================================================
INSERT INTO tours (tour_code, title, category_id, destination_id, description, duration_days, duration_nights, max_participants, min_participants, price_adult, price_child, price_infant, discount_percentage, featured_image, status, created_by) VALUES
-- Tour Vịnh Hạ Long
('HL001', 'Du Thuyền Vịnh Hạ Long 2N1Đ - Trải Nghiệm Sang Trọng', 1, 1, 
'Khám phá kỳ quan thiên nhiên thế giới Vịnh Hạ Long trên du thuyền 5 sao. Tham quan hang Sửng Sốt, làng chài Cửa Vạn, chèo kayak, tắm biển và thưởng thức hải sản tươi ngon. Ngắm hoàng hôn và bình minh trên vịnh, tham gia các hoạt động giải trí trên du thuyền.', 
2, 1, 30, 10, 3500000, 2500000, 500000, 15, '/uploads/tours/ha-long-cruise.jpg', 'published', 3),

-- Tour Hội An
('HA001', 'Hội An - Đà Nẵng 3N2Đ - Phố Cổ & Biển Xanh', 3, 2,
'Khám phá phố cổ Hội An với đèn lồng lung linh, chùa Cầu, nhà cổ Tấn Ký. Tham quan Đà Nẵng với Bà Nà Hills, cầu Vàng, bãi biển Mỹ Khê. Trải nghiệm ẩm thực đặc sản: cao lầu, mì Quảng, bánh bèo. Thả đèn hoa đăng trên sông Hoài.', 
3, 2, 25, 8, 4200000, 3000000, 600000, 10, '/uploads/tours/hoi-an-da-nang.jpg', 'published', 3),

-- Tour Đà Lạt
('DL001', 'Đà Lạt Lãng Mạn 3N2Đ - Thành Phố Ngàn Hoa', 2, 3,
'Khám phá thành phố ngàn hoa với thung lũng Tình Yêu, hồ Xuân Hương, đồi chè Cầu Đất. Tham quan làng hoa Vạn Thành, đồi Mộng Mơ, thác Datanla. Thưởng thức đặc sản: lẩu gà lá é, bánh tráng nướng, sữa đậu nành. Chụp ảnh tại các điểm check-in nổi tiếng.', 
3, 2, 20, 6, 3800000, 2700000, 550000, 20, '/uploads/tours/da-lat-romantic.jpg', 'published', 3),

-- Tour Phú Quốc
('PQ001', 'Phú Quốc 4N3Đ - Đảo Ngọc Thiên Đường', 1, 4,
'Nghỉ dưỡng tại đảo ngọc Phú Quốc với bãi Sao, bãi Dài tuyệt đẹp. Lặn ngắm san hô, câu cá, tham quan làng chài Hàm Ninh. Khám phá VinWonders, Safari, Grand World. Thưởng thức hải sản tươi sống và ghẹ Hàm Ninh nổi tiếng.', 
4, 3, 35, 12, 6500000, 4500000, 800000, 15, '/uploads/tours/phu-quoc-paradise.jpg', 'published', 3),

-- Tour Sapa
('SP001', 'Sapa 3N2Đ - Chinh Phục Fansipan', 2, 5,
'Chinh phục nóc nhà Đông Dương Fansipan bằng cáp treo. Trekking qua ruộng bậc thang Mường Hoa, thăm bản Cát Cát, Tả Van. Trải nghiệm văn hóa dân tộc H Mông, Dao. Thưởng thức đặc sản: thịt trâu gác bếp, cá tầm, rau rừng.', 
3, 2, 25, 10, 4500000, 3200000, 650000, 10, '/uploads/tours/sapa-fansipan.jpg', 'published', 3),

-- Tour Nha Trang
('NT001', 'Nha Trang 3N2Đ - Biển Xanh & Đảo Xinh', 1, 6,
'Tour 4 đảo Nha Trang: Hòn Mun lặn ngắm san hô, Hòn Tằm tắm biển, Hòn Miễu thăm thủy cung, Hòn Một chơi thể thao biển. Tham quan Vinpearl Land, tháp Bà Ponagar, nhà thờ Đá. Tắm bùn khoáng I-Resort, thưởng thức hải sản tươi ngon.', 
3, 2, 30, 10, 3900000, 2800000, 580000, 12, '/uploads/tours/nha-trang-islands.jpg', 'published', 3),

-- Tour Huế
('HU001', 'Huế - Động Phong Nha 3N2Đ - Di Sản Văn Hóa', 3, 7,
'Khám phá cố đô Huế: Đại Nội, lăng Khải Định, lăng Tự Đức, chùa Thiên Mụ. Du thuyền sông Hương nghe ca Huế. Tham quan động Phong Nha - Kẻ Bàng, di sản thiên nhiên thế giới. Thưởng thức ẩm thực cung đình: bún bò Huế, cơm hến, bánh bèo.', 
3, 2, 25, 8, 4300000, 3100000, 620000, 8, '/uploads/tours/hue-heritage.jpg', 'published', 3),

-- Tour Mũi Né
('MN001', 'Mũi Né 2N1Đ - Đồi Cát Bay & Suối Tiên', 6, 9,
'Nghỉ dưỡng tại Mũi Né với resort view biển. Tham quan đồi cát bay, đồi cát vàng, suối tiên, làng chài. Chơi golf, lướt ván buồm, tắm biển. Thưởng thức hải sản nướng, bánh căn, bánh xèo Phan Thiết. Ngắm bình minh tại mũi Kê Gà.', 
2, 1, 20, 6, 2800000, 2000000, 400000, 15, '/uploads/tours/mui-ne-resort.jpg', 'published', 3),

-- Tour Ninh Bình
('NB001', 'Ninh Bình 2N1Đ - Vịnh Hạ Long Trên Cạn', 7, 10,
'Khám phá Tràng An, Tam Cốc - Bích Động bằng thuyền. Tham quan cố đô Hoa Lư, chùa Bái Đính, Hang Múa. Leo núi Ngọa Long ngắm toàn cảnh Ninh Bình. Thưởng thức đặc sản: cơm cháy, dê núi, thịt dê.', 
2, 1, 25, 8, 2500000, 1800000, 350000, 10, '/uploads/tours/ninh-binh-trang-an.jpg', 'published', 3),

-- Tour Đà Nẵng
('DN001', 'Đà Nẵng - Bà Nà Hills 2N1Đ - Cầu Vàng Huyền Thoại', 7, 8,
'Khám phá Bà Nà Hills với cầu Vàng nổi tiếng, làng Pháp, vườn hoa Le Jardin. Tham quan chùa Linh Ứng, bán đảo Sơn Trà. Tắm biển Mỹ Khê, ngắm cầu Rồng phun lửa. Thưởng thức hải sản, mì Quảng, bánh tráng cuốn thịt heo.', 
2, 1, 30, 10, 3200000, 2300000, 460000, 12, '/uploads/tours/da-nang-ba-na.jpg', 'published', 3);

-- =====================================================
-- 8. HÌNH ẢNH TOUR (TOUR_IMAGES)
-- =====================================================
INSERT INTO tour_images (tour_id, image_url, caption, display_order, uploaded_by) VALUES
-- Hạ Long
(1, '/uploads/tours/ha-long-1.jpg', 'Du thuyền sang trọng trên Vịnh Hạ Long', 1, 3),
(1, '/uploads/tours/ha-long-2.jpg', 'Hang Sửng Sốt kỳ vĩ', 2, 3),
(1, '/uploads/tours/ha-long-3.jpg', 'Chèo kayak khám phá vịnh', 3, 3),

-- Hội An
(2, '/uploads/tours/hoi-an-1.jpg', 'Phố cổ Hội An về đêm', 1, 3),
(2, '/uploads/tours/hoi-an-2.jpg', 'Cầu Vàng Bà Nà Hills', 2, 3),
(2, '/uploads/tours/hoi-an-3.jpg', 'Bãi biển Mỹ Khê', 3, 3),

-- Đà Lạt
(3, '/uploads/tours/da-lat-1.jpg', 'Đồi chè Cầu Đất', 1, 3),
(3, '/uploads/tours/da-lat-2.jpg', 'Hồ Xuân Hương lãng mạn', 2, 3),
(3, '/uploads/tours/da-lat-3.jpg', 'Làng hoa Vạn Thành', 3, 3),

-- Phú Quốc
(4, '/uploads/tours/phu-quoc-1.jpg', 'Bãi Sao tuyệt đẹp', 1, 3),
(4, '/uploads/tours/phu-quoc-2.jpg', 'Lặn ngắm san hô', 2, 3),
(4, '/uploads/tours/phu-quoc-3.jpg', 'VinWonders Phú Quốc', 3, 3);

-- =====================================================
-- 9. LỊCH TRÌNH TOUR (TOUR_SCHEDULES)
-- =====================================================
INSERT INTO tour_schedules (tour_id, departure_date, return_date, available_slots, booked_slots, status, guide_id) VALUES
-- Hạ Long - Tháng 1/2026
(1, '2026-01-10', '2026-01-12', 30, 15, 'available', 3),
(1, '2026-01-17', '2026-01-19', 30, 22, 'available', 3),
(1, '2026-01-24', '2026-01-26', 30, 8, 'available', 3),

-- Hội An - Tháng 1/2026
(2, '2026-01-12', '2026-01-15', 25, 18, 'available', 3),
(2, '2026-01-19', '2026-01-22', 25, 12, 'available', 3),
(2, '2026-01-26', '2026-01-29', 25, 5, 'available', 3),

-- Đà Lạt - Tháng 1/2026
(3, '2026-01-08', '2026-01-11', 20, 16, 'available', 3),
(3, '2026-01-15', '2026-01-18', 20, 20, 'full', 3),
(3, '2026-01-22', '2026-01-25', 20, 7, 'available', 3),

-- Phú Quốc - Tháng 1-2/2026
(4, '2026-01-15', '2026-01-19', 35, 28, 'available', 3),
(4, '2026-01-25', '2026-01-29', 35, 14, 'available', 3),
(4, '2026-02-05', '2026-02-09', 35, 0, 'available', 3),

-- Sapa - Tháng 1/2026
(5, '2026-01-11', '2026-01-14', 25, 19, 'available', 3),
(5, '2026-01-18', '2026-01-21', 25, 11, 'available', 3),

-- Nha Trang - Tháng 1/2026
(6, '2026-01-13', '2026-01-16', 30, 24, 'available', 3),
(6, '2026-01-20', '2026-01-23', 30, 9, 'available', 3);

-- =====================================================
-- 10. ĐƠN ĐẶT TOUR (BOOKINGS)
-- =====================================================
INSERT INTO bookings (booking_code, schedule_id, user_id, customer_name, customer_email, customer_phone, num_adults, num_children, num_infants, total_amount, paid_amount, payment_status, booking_status, special_requests, confirmed_by, confirmed_at) VALUES
('BK20260101001', 1, 7, 'Nguyễn Minh Anh', 'customer1@gmail.com', '0907890123', 2, 1, 0, 9500000, 9500000, 'completed', 'confirmed', 'Muốn phòng view biển', 5, '2025-12-20 10:30:00'),
('BK20260101002', 1, 8, 'Trần Hoàng Bảo', 'customer2@gmail.com', '0908901234', 2, 0, 0, 7000000, 3500000, 'partial', 'confirmed', NULL, 5, '2025-12-21 14:20:00'),
('BK20260101003', 2, 9, 'Lê Thị Cẩm', 'customer3@gmail.com', '0909012345', 4, 2, 1, 19400000, 19400000, 'completed', 'confirmed', 'Gia đình có người già, cần hỗ trợ di chuyển', 5, '2025-12-22 09:15:00'),
('BK20260101004', 4, 10, 'Phạm Văn Dũng', 'customer4@gmail.com', '0910123456', 2, 0, 0, 8400000, 0, 'pending', 'pending', NULL, NULL, NULL),
('BK20260101005', 7, 7, 'Nguyễn Minh Anh', 'customer1@gmail.com', '0907890123', 3, 1, 0, 14100000, 14100000, 'completed', 'confirmed', 'Muốn phòng gần nhau', 5, '2025-12-23 16:45:00');

-- =====================================================
-- 11. NGƯỜI THAM GIA (BOOKING_PARTICIPANTS)
-- =====================================================
INSERT INTO booking_participants (booking_id, full_name, date_of_birth, passport_number, participant_type) VALUES
-- Booking 1
(1, 'Nguyễn Minh Anh', '1990-05-15', 'B1234567', 'adult'),
(1, 'Trần Văn Bình', '1988-08-20', 'B2345678', 'adult'),
(1, 'Nguyễn Minh Châu', '2015-03-10', NULL, 'child'),

-- Booking 2
(2, 'Trần Hoàng Bảo', '1992-11-25', 'B3456789', 'adult'),
(2, 'Lê Thị Diệu', '1994-02-14', 'B4567890', 'adult'),

-- Booking 3
(3, 'Lê Thị Cẩm', '1985-07-08', 'B5678901', 'adult'),
(3, 'Phạm Văn Em', '1983-12-30', 'B6789012', 'adult'),
(3, 'Nguyễn Thị Phượng', '1980-04-18', 'B7890123', 'adult'),
(3, 'Trần Văn Giang', '1978-09-22', 'B8901234', 'adult'),
(3, 'Lê Minh Hiếu', '2016-06-05', NULL, 'child'),
(3, 'Lê Thu Hà', '2018-01-12', NULL, 'child'),
(3, 'Phạm Bảo Khánh', '2024-11-20', NULL, 'infant');

-- =====================================================
-- 12. THANH TOÁN (PAYMENTS)
-- =====================================================
INSERT INTO payments (booking_id, payment_method, amount, transaction_id, payment_status, processed_by, notes) VALUES
(1, 'bank_transfer', 9500000, 'TXN20260101001', 'completed', 6, 'Chuyển khoản qua Vietcombank'),
(2, 'bank_transfer', 3500000, 'TXN20260101002', 'completed', 6, 'Đặt cọc 50%'),
(3, 'credit_card', 19400000, 'TXN20260101003', 'completed', 6, 'Thanh toán qua thẻ Visa'),
(5, 'e_wallet', 14100000, 'TXN20260101005', 'completed', 6, 'Thanh toán qua MoMo');

-- =====================================================
-- 13. ĐÁNH GIÁ (REVIEWS)
-- =====================================================
INSERT INTO reviews (tour_id, booking_id, user_id, rating, title, comment, status, reviewed_by, reviewed_at) VALUES
(1, 1, 7, 5, 'Trải nghiệm tuyệt vời!', 'Du thuyền rất sang trọng, phục vụ chu đáo. Cảnh đẹp mê hồn, ăn uống ngon. Hướng dẫn viên nhiệt tình. Sẽ quay lại lần sau!', 'approved', 4, '2026-01-03 10:00:00'),
(2, 3, 9, 5, 'Phố cổ Hội An thật đẹp', 'Phố cổ rất đẹp về đêm với đèn lồng. Bà Nà Hills cũng tuyệt vời. Gia đình rất hài lòng. Cảm ơn hướng dẫn viên đã hỗ trợ người già trong đoàn.', 'approved', 4, '2026-01-03 11:30:00'),
(3, 5, 7, 4, 'Đà Lạt lãng mạn', 'Thời tiết mát mẻ, cảnh đẹp. Tuy nhiên lịch trình hơi dày đặc. Nhìn chung vẫn rất tốt, đáng để đi.', 'approved', 4, '2026-01-03 14:20:00');

-- =====================================================
-- 14. BÀI VIẾT BLOG (BLOG_POSTS)
-- =====================================================
INSERT INTO blog_posts (title, slug, content, excerpt, featured_image, author_id, status, published_at) VALUES
('10 Điểm Đến Không Thể Bỏ Qua Khi Du Lịch Việt Nam', '10-diem-den-khong-the-bo-qua-khi-du-lich-viet-nam',
'Việt Nam là một đất nước tuyệt đẹp với nhiều điểm đến hấp dẫn từ Bắc chí Nam. Trong bài viết này, chúng tôi sẽ giới thiệu 10 điểm đến không thể bỏ qua...

## 1. Vịnh Hạ Long - Kỳ Quan Thiên Nhiên
Vịnh Hạ Long với hàng nghìn hòn đảo đá vôi kỳ vĩ...

## 2. Phố Cổ Hội An - Thành Phố Đèn Lồng
Hội An là một trong những điểm đến được yêu thích nhất...

## 3. Đà Lạt - Thành Phố Ngàn Hoa
Với khí hậu mát mẻ quanh năm, Đà Lạt là điểm đến lý tưởng...', 
'Khám phá 10 điểm đến tuyệt đẹp nhất Việt Nam, từ Vịnh Hạ Long kỳ vĩ đến phố cổ Hội An lãng mạn.', 
'/uploads/blog/top-10-destinations.jpg', 4, 'published', '2025-12-15 08:00:00'),

('Kinh Nghiệm Du Lịch Phú Quốc Tự Túc', 'kinh-nghiem-du-lich-phu-quoc-tu-tuc',
'Phú Quốc là đảo ngọc của Việt Nam với nhiều bãi biển đẹp. Dưới đây là kinh nghiệm du lịch Phú Quốc tự túc...

## Thời Điểm Đi
Tháng 11 đến tháng 3 là thời điểm lý tưởng nhất...

## Phương Tiện Di Chuyển
Bạn có thể thuê xe máy hoặc ô tô tự lái...

## Địa Điểm Tham Quan
- Bãi Sao
- Bãi Dài
- VinWonders
- Safari Phú Quốc', 
'Hướng dẫn chi tiết kinh nghiệm du lịch Phú Quốc tự túc, tiết kiệm chi phí nhưng vẫn trọn vẹn.', 
'/uploads/blog/phu-quoc-guide.jpg', 4, 'published', '2025-12-20 10:00:00'),

('Ẩm Thực Đường Phố Sài Gòn Phải Thử', 'am-thuc-duong-pho-sai-gon-phai-thu',
'Sài Gòn nổi tiếng với ẩm thực đường phố phong phú và đa dạng...

## Phở
Món ăn sáng truyền thống của người Việt...

## Bánh Mì
Bánh mì Sài Gòn với nhân đa dạng...

## Cơm Tấm
Món ăn dân dã nhưng đầy hấp dẫn...', 
'Khám phá những món ăn đường phố Sài Gòn không thể bỏ qua khi đến thành phố này.', 
'/uploads/blog/saigon-street-food.jpg', 4, 'published', '2025-12-25 15:30:00');

-- =====================================================
-- 15. KHUYẾN MÃI (PROMOTIONS)
-- =====================================================
INSERT INTO promotions (code, description, discount_type, discount_value, max_discount_amount, min_purchase_amount, usage_limit, used_count, valid_from, valid_to, status, created_by) VALUES
('TETDUONG2026', 'Khuyến mãi Tết Dương lịch 2026 - Giảm 15% tất cả tour', 'percentage', 15, 2000000, 5000000, 100, 5, '2026-01-01', '2026-01-31', 'active', 2),
('SUMMER2026', 'Khuyến mãi hè 2026 - Giảm 500K cho tour biển', 'fixed_amount', 500000, NULL, 3000000, 200, 0, '2026-05-01', '2026-08-31', 'active', 2),
('NEWCUSTOMER', 'Ưu đãi khách hàng mới - Giảm 10%', 'percentage', 10, 1000000, 2000000, NULL, 12, '2026-01-01', '2026-12-31', 'active', 2),
('FAMILY50', 'Ưu đãi gia đình - Giảm 50K/người từ 4 người trở lên', 'fixed_amount', 200000, NULL, 10000000, 50, 3, '2026-01-01', '2026-06-30', 'active', 2);

-- =====================================================
-- 16. LỊCH SỬ SỬ DỤNG KHUYẾN MÃI (PROMOTION_USAGE)
-- =====================================================
INSERT INTO promotion_usage (promotion_id, booking_id, user_id, discount_amount) VALUES
(1, 1, 7, 1425000),
(1, 2, 8, 1050000),
(3, 3, 9, 1000000),
(4, 5, 7, 200000);

-- =====================================================
-- 17. THÔNG BÁO (NOTIFICATIONS)
-- =====================================================
INSERT INTO notifications (user_id, title, message, notification_type, is_read) VALUES
(7, 'Đặt tour thành công', 'Bạn đã đặt tour "Du Thuyền Vịnh Hạ Long 2N1Đ" thành công. Mã booking: BK20260101001', 'booking', true),
(7, 'Thanh toán thành công', 'Thanh toán cho booking BK20260101001 đã được xác nhận. Số tiền: 9.500.000đ', 'payment', true),
(8, 'Đặt tour thành công', 'Bạn đã đặt tour "Du Thuyền Vịnh Hạ Long 2N1Đ" thành công. Mã booking: BK20260101002', 'booking', true),
(9, 'Booking được xác nhận', 'Booking BK20260101003 của bạn đã được xác nhận. Chúc bạn có chuyến đi vui vẻ!', 'booking', true),
(10, 'Đặt tour thành công', 'Bạn đã đặt tour "Hội An - Đà Nẵng 3N2Đ" thành công. Vui lòng thanh toán trong 24h.', 'booking', false),
(7, 'Khuyến mãi mới', 'Mã giảm giá TETDUONG2026 - Giảm 15% cho tất cả tour. Áp dụng đến 31/01/2026', 'promotion', false),
(8, 'Khuyến mãi mới', 'Mã giảm giá TETDUONG2026 - Giảm 15% cho tất cả tour. Áp dụng đến 31/01/2026', 'promotion', false),
(9, 'Khuyến mãi mới', 'Mã giảm giá TETDUONG2026 - Giảm 15% cho tất cả tour. Áp dụng đến 31/01/2026', 'promotion', false);

-- =====================================================
-- 18. CÀI ĐẶT HỆ THỐNG (SYSTEM_SETTINGS)
-- =====================================================
INSERT INTO system_settings (setting_key, setting_value, description, updated_by) VALUES
('site_name', 'VietTravel - Du Lịch Việt Nam', 'Tên website', 1),
('site_email', 'contact@viettravel.vn', 'Email liên hệ chính', 1),
('site_phone', '1900 1234', 'Hotline hỗ trợ', 1),
('currency', 'VND', 'Đơn vị tiền tệ', 1),
('timezone', 'Asia/Ho_Chi_Minh', 'Múi giờ', 1),
('booking_expiry_hours', '24', 'Thời gian hết hạn booking chưa thanh toán (giờ)', 1),
('min_booking_days', '3', 'Số ngày tối thiểu phải đặt trước khi khởi hành', 1),
('cancellation_fee_percentage', '20', 'Phí hủy tour (% tổng tiền)', 1),
('max_upload_size_mb', '10', 'Kích thước file upload tối đa (MB)', 1),
('reviews_require_approval', 'true', 'Đánh giá cần được duyệt trước khi hiển thị', 1);

-- =====================================================
-- 19. NHẬT KÝ HOẠT ĐỘNG (ACTIVITY_LOGS)
-- =====================================================
INSERT INTO activity_logs (user_id, action, module, record_id, ip_address, user_agent) VALUES
(7, 'create', 'booking', 1, '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'),
(7, 'create', 'payment', 1, '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'),
(8, 'create', 'booking', 2, '192.168.1.101', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)'),
(9, 'create', 'booking', 3, '192.168.1.102', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_6 like Mac OS X)'),
(5, 'update', 'booking', 1, '192.168.1.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'),
(5, 'update', 'booking', 2, '192.168.1.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'),
(5, 'update', 'booking', 3, '192.168.1.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'),
(4, 'create', 'blog', 1, '192.168.1.60', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'),
(4, 'create', 'blog', 2, '192.168.1.60', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'),
(4, 'approve', 'review', 1, '192.168.1.60', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)');

-- =====================================================
-- HOÀN TẤT
-- =====================================================

-- Cập nhật lại sequences để đảm bảo ID tiếp theo đúng
SELECT setval('roles_role_id_seq', (SELECT MAX(role_id) FROM roles));
SELECT setval('users_user_id_seq', (SELECT MAX(user_id) FROM users));
SELECT setval('permissions_permission_id_seq', (SELECT MAX(permission_id) FROM permissions));
SELECT setval('destinations_destination_id_seq', (SELECT MAX(destination_id) FROM destinations));
SELECT setval('tour_categories_category_id_seq', (SELECT MAX(category_id) FROM tour_categories));
SELECT setval('tours_tour_id_seq', (SELECT MAX(tour_id) FROM tours));
SELECT setval('tour_images_image_id_seq', (SELECT MAX(image_id) FROM tour_images));
SELECT setval('tour_schedules_schedule_id_seq', (SELECT MAX(schedule_id) FROM tour_schedules));
SELECT setval('bookings_booking_id_seq', (SELECT MAX(booking_id) FROM bookings));
SELECT setval('booking_participants_participant_id_seq', (SELECT MAX(participant_id) FROM booking_participants));
SELECT setval('payments_payment_id_seq', (SELECT MAX(payment_id) FROM payments));
SELECT setval('reviews_review_id_seq', (SELECT MAX(review_id) FROM reviews));
SELECT setval('blog_posts_post_id_seq', (SELECT MAX(post_id) FROM blog_posts));
SELECT setval('promotions_promotion_id_seq', (SELECT MAX(promotion_id) FROM promotions));
SELECT setval('promotion_usage_usage_id_seq', (SELECT MAX(usage_id) FROM promotion_usage));
SELECT setval('notifications_notification_id_seq', (SELECT MAX(notification_id) FROM notifications));
SELECT setval('system_settings_setting_id_seq', (SELECT MAX(setting_id) FROM system_settings));
SELECT setval('activity_logs_log_id_seq', (SELECT MAX(log_id) FROM activity_logs));

-- =====================================================
-- THỐNG KÊ DỮ LIỆU ĐÃ TẠO
-- =====================================================
SELECT 'Roles' as table_name, COUNT(*) as record_count FROM roles
UNION ALL
SELECT 'Users', COUNT(*) FROM users
UNION ALL
SELECT 'Permissions', COUNT(*) FROM permissions
UNION ALL
SELECT 'Role Permissions', COUNT(*) FROM role_permissions
UNION ALL
SELECT 'Destinations', COUNT(*) FROM destinations
UNION ALL
SELECT 'Tour Categories', COUNT(*) FROM tour_categories
UNION ALL
SELECT 'Tours', COUNT(*) FROM tours
UNION ALL
SELECT 'Tour Images', COUNT(*) FROM tour_images
UNION ALL
SELECT 'Tour Schedules', COUNT(*) FROM tour_schedules
UNION ALL
SELECT 'Bookings', COUNT(*) FROM bookings
UNION ALL
SELECT 'Booking Participants', COUNT(*) FROM booking_participants
UNION ALL
SELECT 'Payments', COUNT(*) FROM payments
UNION ALL
SELECT 'Reviews', COUNT(*) FROM reviews
UNION ALL
SELECT 'Blog Posts', COUNT(*) FROM blog_posts
UNION ALL
SELECT 'Promotions', COUNT(*) FROM promotions
UNION ALL
SELECT 'Promotion Usage', COUNT(*) FROM promotion_usage
UNION ALL
SELECT 'Notifications', COUNT(*) FROM notifications
UNION ALL
SELECT 'System Settings', COUNT(*) FROM system_settings
UNION ALL
SELECT 'Activity Logs', COUNT(*) FROM activity_logs;

-- =====================================================
-- LƯU Ý QUAN TRỌNG
-- =====================================================
-- 1. Mật khẩu mặc định cho tất cả user là "password123"
--    Cần hash lại bằng bcrypt trước khi sử dụng thực tế
-- 2. Các URL hình ảnh là placeholder, cần thay thế bằng URL thật
-- 3. Dữ liệu này chỉ để demo/development, không dùng cho production
-- 4. Nên thay đổi thông tin nhạy cảm như email, số điện thoại
-- =====================================================

