-- ============================================
-- DỮ LIỆU ĐẦY ĐỦ CHO DATABASE TRAVEL - POSTGRESQL
-- Encoding: UTF-8
-- ============================================

-- 1. NGƯỜI DÙNG (Users)
INSERT INTO users (username, email, password_hash, full_name, phone, avatar_url, role_id, status, email_verified, last_login) VALUES
('admin', 'admin@travelweb.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Nguyễn Văn Admin', '0901234567', 'https://i.pravatar.cc/150?img=1', 1, 'active', TRUE, '2024-12-24 08:00:00'),
('manager1', 'manager1@travelweb.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Trần Thị Lan', '0902345678', 'https://i.pravatar.cc/150?img=2', 2, 'active', TRUE, '2024-12-23 14:30:00'),
('tourmanager1', 'tourmanager1@travelweb.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Lê Văn Hùng', '0903456789', 'https://i.pravatar.cc/150?img=3', 3, 'active', TRUE, '2024-12-24 07:00:00'),
('tourmanager2', 'tourmanager2@travelweb.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Phạm Thị Mai', '0904567890', 'https://i.pravatar.cc/150?img=4', 3, 'active', TRUE, '2024-12-23 16:00:00'),
('content1', 'content1@travelweb.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Hoàng Minh Tuấn', '0905678901', 'https://i.pravatar.cc/150?img=5', 4, 'active', TRUE, '2024-12-24 09:00:00'),
('cs1', 'cs1@travelweb.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Vũ Thị Hương', '0906789012', 'https://i.pravatar.cc/150?img=6', 5, 'active', TRUE, '2024-12-24 08:30:00'),
('cs2', 'cs2@travelweb.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Đặng Văn Nam', '0907890123', 'https://i.pravatar.cc/150?img=7', 5, 'active', TRUE, '2024-12-23 17:00:00'),
('guide1', 'guide1@travelweb.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Bùi Minh Quân', '0908901234', 'https://i.pravatar.cc/150?img=8', 6, 'active', TRUE, '2024-12-24 06:00:00'),
('guide2', 'guide2@travelweb.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Đinh Thị Thảo', '0909012345', 'https://i.pravatar.cc/150?img=9', 6, 'active', TRUE, '2024-12-23 18:00:00'),
('guide3', 'guide3@travelweb.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Ngô Văn Đức', '0900123456', 'https://i.pravatar.cc/150?img=10', 6, 'active', TRUE, '2024-12-24 05:30:00'),
('customer1', 'customer1@gmail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Trương Văn Anh', '0911234567', 'https://i.pravatar.cc/150?img=11', 7, 'active', TRUE, '2024-12-23 20:00:00'),
('customer2', 'customer2@gmail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Lý Thị Bích', '0912345678', 'https://i.pravatar.cc/150?img=12', 7, 'active', TRUE, '2024-12-24 10:00:00'),
('customer3', 'customer3@gmail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Phan Văn Cường', '0913456789', 'https://i.pravatar.cc/150?img=13', 7, 'active', TRUE, '2024-12-22 15:00:00'),
('customer4', 'customer4@gmail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Võ Thị Diễm', '0914567890', 'https://i.pravatar.cc/150?img=14', 7, 'active', TRUE, '2024-12-21 11:00:00'),
('customer5', 'customer5@gmail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Cao Văn Em', '0915678901', 'https://i.pravatar.cc/150?img=15', 7, 'active', TRUE, '2024-12-20 09:00:00');

-- 2. ĐỊA ĐIỂM (Destinations)
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

-- 3. DANH MỤC TOUR (Tour Categories)
INSERT INTO tour_categories (category_name, description, icon_url) VALUES
('Du lịch biển đảo', 'Các tour du lịch khám phá biển, đảo và các hoạt động thể thao dưới nước', 'https://cdn-icons-png.flaticon.com/512/2990/2990507.png'),
('Du lịch văn hóa', 'Tìm hiểu văn hóa, lịch sử và di sản của các vùng đất', 'https://cdn-icons-png.flaticon.com/512/3524/3524335.png'),
('Du lịch mạo hiểm', 'Các hoạt động thể thao mạo hiểm và khám phá thiên nhiên', 'https://cdn-icons-png.flaticon.com/512/2927/2927347.png'),
('Du lịch sinh thái', 'Khám phá thiên nhiên, động thực vật và bảo vệ môi trường', 'https://cdn-icons-png.flaticon.com/512/2917/2917995.png'),
('Du lịch thành phố', 'Khám phá các thành phố lớn, mua sắm và giải trí', 'https://cdn-icons-png.flaticon.com/512/3076/3076404.png'),
('Du lịch ẩm thực', 'Trải nghiệm ẩm thực đặc sản và văn hóa ăn uống', 'https://cdn-icons-png.flaticon.com/512/3480/3480822.png'),
('Du lịch nghỉ dưỡng', 'Thư giãn và nghỉ dưỡng tại resort cao cấp', 'https://cdn-icons-png.flaticon.com/512/2933/2933245.png'),
('Du lịch tâm linh', 'Tham quan các địa điểm tâm linh, chùa chiền, đền đài', 'https://cdn-icons-png.flaticon.com/512/3124/3124492.png');

-- 4. TOUR
INSERT INTO tours (tour_code, title, category_id, destination_id, description, duration_days, duration_nights, max_participants, min_participants, price_adult, price_child, price_infant, discount_percentage, featured_image, status, created_by) VALUES
('VN-HL-001', 'Khám phá Vịnh Hạ Long - Bái Đính - Tràng An 3N2Đ', 1, 1, 'Trải nghiệm vẻ đẹp thiên nhiên tuyệt vời của Vịnh Hạ Long, khám phá chùa Bái Đính lớn nhất Việt Nam và quần thể danh thắng Tràng An. Du thuyền qua đêm trên vịnh, thưởng thức hải sản tươi ngon và tham gia các hoạt động thể thao nước.', 3, 2, 25, 10, 4500000.00, 3500000.00, 500000.00, 10.00, 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b', 'published', 3),
('VN-HAN-001', 'Tour Hội An - Bà Nà - Huế 4N3Đ', 2, 2, 'Khám phá phố cổ Hội An với hàng trăm ngôi nhà cổ, đền thờ và hội quán. Trải nghiệm cảm giác như ở châu Âu tại Bà Nà Hills với cây cầu Vàng nổi tiếng. Tham quan Cố đô Huế với các di tích lịch sử, lăng tẩm và chùa chiền.', 4, 3, 30, 12, 6500000.00, 5000000.00, 800000.00, 15.00, 'https://images.unsplash.com/photo-1583417319070-4a69db38a482', 'published', 3),
('VN-NT-001', 'Nha Trang - Vịnh Ninh Vân 3N2Đ', 1, 3, 'Tận hưởng kỳ nghỉ tại thành phố biển Nha Trang với các bãi biển đẹp nhất Việt Nam. Tham gia lặn ngắm san hô, câu cá, và các hoạt động thể thao nước. Khám phá Vinpearl Land và tắm bùn khoáng nóng.', 3, 2, 20, 8, 3800000.00, 2800000.00, 400000.00, 5.00, 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b', 'published', 3),
('VN-DL-001', 'Đà Lạt Lãng Mạn 3N2Đ', 4, 4, 'Khám phá thành phố ngàn hoa với khí hậu mát mẻ quanh năm. Tham quan Thung lũng Tình Yêu, hồ Xuân Hương, thác Datanla. Thưởng thức cà phê đặc sản và dâu tây tươi. Check-in các điểm sống ảo nổi tiếng.', 3, 2, 25, 10, 3500000.00, 2700000.00, 300000.00, 0.00, 'https://images.unsplash.com/photo-1583417319070-4a69db38a482', 'published', 3),
('VN-PQ-001', 'Phú Quốc - Đảo Ngọc 4N3Đ', 1, 5, 'Nghỉ dưỡng tại đảo Ngọc Phú Quốc với các resort 5 sao. Tham quan VinWonders, Safari, tắm biển Bãi Sao. Trải nghiệm cáp treo Hòn Thơm dài nhất thế giới. Thưởng thức hải sản tươi sống và đặc sản địa phương.', 4, 3, 20, 8, 7500000.00, 6000000.00, 1000000.00, 20.00, 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b', 'published', 3),
('VN-SP-001', 'Sapa - Fansipan - Bản Cát Cát 3N2Đ', 3, 6, 'Chinh phục nóc nhà Đông Dương Fansipan bằng cáp treo hiện đại. Trekking qua các bản làng dân tộc thiểu số, ngắm ruộng bậc thang tuyệt đẹp. Trải nghiệm văn hóa và ẩm thực độc đáo của vùng cao.', 3, 2, 18, 8, 4200000.00, 3200000.00, 500000.00, 0.00, 'https://images.unsplash.com/photo-1583417319070-4a69db38a482', 'published', 3),
('TH-BK-001', 'Bangkok - Pattaya 5N4Đ', 5, 7, 'Khám phá thủ đô Bangkok với Cung điện Hoàng gia, chùa Vàng, chợ nổi Damnoen Saduak. Tham quan Pattaya với bãi biển đẹp, Coral Island, và show Alcazar nổi tiếng. Mua sắm tại các trung tâm thương mại lớn.', 5, 4, 30, 15, 8500000.00, 7000000.00, 1500000.00, 10.00, 'https://images.unsplash.com/photo-1508009603885-50cf7c579365', 'published', 3),
('TH-PK-001', 'Phuket - Krabi - Đảo Phi Phi 6N5Đ', 1, 8, 'Tour khám phá các hòn đảo đẹp nhất Thái Lan. Phuket với Patong Beach, Krabi với bãi biển Railay, đảo Phi Phi với Maya Bay. Lặn ngắm san hô, kayaking, và thưởng thức hải sản tươi ngon.', 6, 5, 25, 12, 12000000.00, 9500000.00, 2000000.00, 15.00, 'https://images.unsplash.com/photo-1589394815804-964ed0be2eb5', 'published', 4),
('SG-001', 'Singapore Hiện Đại 4N3Đ', 5, 9, 'Khám phá đảo quốc sư tử với Gardens by the Bay, Marina Bay Sands, Universal Studios. Shopping tại Orchard Road. Trải nghiệm ẩm thực đa văn hóa tại Hawker Centers. Tham quan Sentosa Island.', 4, 3, 25, 10, 15000000.00, 12000000.00, 2500000.00, 0.00, 'https://images.unsplash.com/photo-1525625293386-3f8f99389edd', 'published', 4),
('ID-BL-001', 'Bali - Thiên Đường Nhiệt Đới 5N4Đ', 7, 10, 'Nghỉ dưỡng tại hòn đảo thiên đường Bali. Tham quan đền Tanah Lot, Uluwatu, rừng khỉ Ubud. Thưởng thức massage truyền thống Bali. Tắm biển tại Kuta, Seminyak. Check-in cánh đồng lúa và xích đu Bali.', 5, 4, 20, 10, 11000000.00, 9000000.00, 1800000.00, 10.00, 'https://images.unsplash.com/photo-1537996194471-e657df975ab4', 'published', 4),
('JP-TK-001', 'Tokyo - Phú Sĩ - Osaka 7N6Đ', 5, 11, 'Tour Nhật Bản khám phá Tokyo với Shibuya, Shinjuku, đền Sensoji. Ngắm núi Phú Sĩ và tắm onsen. Tham quan Osaka với lâu đài Osaka, phố Dotonbori. Trải nghiệm văn hóa Nhật Bản và ẩm thực đặc sắc.', 7, 6, 20, 12, 28000000.00, 24000000.00, 5000000.00, 5.00, 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf', 'published', 4),
('KR-SE-001', 'Seoul - Nami - Everland 5N4Đ', 5, 12, 'Khám phá thủ đô Seoul với cung điện Gyeongbokgung, làng Bukchon Hanok, tháp N Seoul. Tham quan đảo Nami lãng mạn, công viên Everland. Shopping tại Myeongdong, Dongdaemun. Thưởng thức BBQ Hàn Quốc.', 5, 4, 25, 12, 16000000.00, 13000000.00, 3000000.00, 10.00, 'https://images.unsplash.com/photo-1517154421773-0529f29ea451', 'published', 4);

-- 5. PHÂN QUYỀN
INSERT INTO role_permissions (role_id, permission_id)
SELECT 1, permission_id FROM permissions;

INSERT INTO role_permissions (role_id, permission_id)
SELECT 2, permission_id FROM permissions 
WHERE permission_name NOT IN ('user.manage_roles', 'system.edit_settings');

INSERT INTO role_permissions (role_id, permission_id)
SELECT 3, permission_id FROM permissions 
WHERE module IN ('tour', 'booking') OR permission_name IN ('report.view_bookings', 'report.export');

INSERT INTO role_permissions (role_id, permission_id)
SELECT 4, permission_id FROM permissions 
WHERE module = 'content' OR module = 'review';

INSERT INTO role_permissions (role_id, permission_id)
SELECT 5, permission_id FROM permissions 
WHERE module IN ('booking', 'payment') 
   OR permission_name IN ('tour.view', 'customer.view', 'promotion.view');

INSERT INTO role_permissions (role_id, permission_id)
SELECT 6, permission_id FROM permissions 
WHERE permission_name IN ('tour.view', 'booking.view_all');

INSERT INTO role_permissions (role_id, permission_id)
SELECT 7, permission_id FROM permissions 
WHERE permission_name IN ('tour.view', 'booking.view_own', 'booking.create', 'booking.cancel', 'review.view', 'promotion.view');
