-- ============================================
-- CẬP NHẬT ĐƯỜNG DẪN ẢNH CHO CÁC TOUR
-- ============================================
-- Script này cập nhật featured_image từ URL Unsplash sang ảnh local trong uploads/tours

-- Tour 1: Vịnh Hạ Long - Bái Đính - Tràng An 3N2Đ
UPDATE tours SET featured_image = '/uploads/tours/ha-long-1.jpg' WHERE tour_code = 'VN-HL-001';

-- Tour 2: Tour Hội An - Bà Nà - Huế 4N3Đ  
UPDATE tours SET featured_image = '/uploads/tours/hoi-an-1.jpg' WHERE tour_code = 'VN-HAN-001';

-- Tour 3: Nha Trang - Vịnh Ninh Vân 3N2Đ
UPDATE tours SET featured_image = '/uploads/tours/nha-trang-1.jpg' WHERE tour_code = 'VN-NT-001';

-- Tour 4: Đà Lạt Lãng Mạn 3N2Đ
UPDATE tours SET featured_image = '/uploads/tours/da-lat-1.jpg' WHERE tour_code = 'VN-DL-001';

-- Tour 5: Phú Quốc - Đảo Ngọc 4N3Đ
UPDATE tours SET featured_image = '/uploads/tours/phu-quoc-1.jpg' WHERE tour_code = 'VN-PQ-001';

-- Tour 6: Sapa - Fansipan - Bản Cát Cát 3N2Đ
UPDATE tours SET featured_image = '/uploads/tours/sapa-1.jpg' WHERE tour_code = 'VN-SP-001';

-- Tour 7: Bangkok - Pattaya 5N4Đ
-- Giữ nguyên URL Unsplash vì chưa có ảnh Bangkok local
-- UPDATE tours SET featured_image = '/uploads/tours/bangkok-1.jpg' WHERE tour_code = 'TH-BK-001';

-- Tour 8: Phuket - Krabi - Đảo Phi Phi 6N5Đ
-- Giữ nguyên URL Unsplash vì chưa có ảnh Phuket local
-- UPDATE tours SET featured_image = '/uploads/tours/phuket-1.jpg' WHERE tour_code = 'TH-PK-001';

-- Tour 9: Singapore Hiện Đại 4N3Đ
-- Giữ nguyên URL Unsplash vì chưa có ảnh Singapore local
-- UPDATE tours SET featured_image = '/uploads/tours/singapore-1.jpg' WHERE tour_code = 'SG-001';

-- Tour 10: Bali - Thiên Đường Nhiệt Đới 5N4Đ
-- Giữ nguyên URL Unsplash vì chưa có ảnh Bali local
-- UPDATE tours SET featured_image = '/uploads/tours/bali-1.jpg' WHERE tour_code = 'ID-BL-001';

-- Tour 11: Tokyo - Phú Sĩ - Osaka 7N6Đ
-- Giữ nguyên URL Unsplash vì chưa có ảnh Tokyo local
-- UPDATE tours SET featured_image = '/uploads/tours/tokyo-1.jpg' WHERE tour_code = 'JP-TK-001';

-- Tour 12: Seoul - Nami - Everland 5N4Đ
-- Giữ nguyên URL Unsplash vì chưa có ảnh Seoul local
-- UPDATE tours SET featured_image = '/uploads/tours/seoul-1.jpg' WHERE tour_code = 'KR-SE-001';

-- ============================================
-- CẬP NHẬT HÌNH ẢNH PHỤ CHO TOUR (tour_images)
-- ============================================

-- Xóa ảnh cũ của các tour Việt Nam
DELETE FROM tour_images WHERE tour_id IN (1, 2, 3, 4, 5, 6);

-- Tour 1: Hạ Long (4 ảnh)
INSERT INTO tour_images (tour_id, image_url, caption, display_order, uploaded_by) VALUES
(1, '/uploads/tours/ha-long-1.jpg', 'Vịnh Hạ Long - Di sản thiên nhiên thế giới', 1, 3),
(1, '/uploads/tours/ha-long-2.jpg', 'Du thuyền sang trọng trên vịnh', 2, 3),
(1, '/uploads/tours/ha-long-3.jpg', 'Hang động kỳ vĩ', 3, 3),
(1, '/uploads/tours/ha-long-4.jpg', 'Hoàng hôn trên vịnh Hạ Long', 4, 3);

-- Tour 2: Hội An (4 ảnh)
INSERT INTO tour_images (tour_id, image_url, caption, display_order, uploaded_by) VALUES
(2, '/uploads/tours/hoi-an-1.jpg', 'Phố cổ Hội An về đêm', 1, 3),
(2, '/uploads/tours/hoi-an-2.jpg', 'Đèn lồng rực rỡ', 2, 3),
(2, '/uploads/tours/hoi-an-3.jpg', 'Cầu Vàng Bà Nà Hills', 3, 3),
(2, '/uploads/tours/hoi-an-4.png', 'Kiến trúc cổ kính', 4, 3);

-- Tour 3: Nha Trang (4 ảnh)
INSERT INTO tour_images (tour_id, image_url, caption, display_order, uploaded_by) VALUES
(3, '/uploads/tours/nha-trang-1.jpg', 'Bãi biển Nha Trang', 1, 3),
(3, '/uploads/tours/nha-trang-2.jpg', 'Làn nước trong xanh', 2, 3),
(3, '/uploads/tours/nha-trang-3.jpg', 'Lặn ngắm san hô', 3, 3),
(3, '/uploads/tours/nha-trang-4.jpg', 'Vinpearl Land', 4, 3);

-- Tour 4: Đà Lạt (4 ảnh)
INSERT INTO tour_images (tour_id, image_url, caption, display_order, uploaded_by) VALUES
(4, '/uploads/tours/da-lat-1.jpg', 'Thành phố ngàn hoa', 1, 3),
(4, '/uploads/tours/da-lat-2.jpg', 'Hồ Xuân Hương', 2, 3),
(4, '/uploads/tours/da-lat-3.jpg', 'Thung lũng Tình Yêu', 3, 3),
(4, '/uploads/tours/da-lat-4.jpg', 'Cà phê Đà Lạt', 4, 3);

-- Tour 5: Phú Quốc (4 ảnh)
INSERT INTO tour_images (tour_id, image_url, caption, display_order, uploaded_by) VALUES
(5, '/uploads/tours/phu-quoc-1.jpg', 'Đảo Ngọc Phú Quốc', 1, 3),
(5, '/uploads/tours/phu-quoc-2.jpg', 'Bãi Sao tuyệt đẹp', 2, 3),
(5, '/uploads/tours/phu-quoc-3.jpg', 'Cáp treo Hòn Thơm', 3, 3),
(5, '/uploads/tours/phu-quoc-4.jpg', 'VinWonders Phú Quốc', 4, 3);

-- Tour 6: Sapa (4 ảnh)
INSERT INTO tour_images (tour_id, image_url, caption, display_order, uploaded_by) VALUES
(6, '/uploads/tours/sapa-1.jpg', 'Ruộng bậc thang Sapa', 1, 3),
(6, '/uploads/tours/sapa-2.jpg', 'Fansipan - Nóc nhà Đông Dương', 2, 3),
(6, '/uploads/tours/sapa-3.jpg', 'Bản làng dân tộc', 3, 3),
(6, '/uploads/tours/sapa-4.jpg', 'Sapa mùa lúa chín', 4, 3);

-- ============================================
-- KIỂM TRA KẾT QUẢ
-- ============================================
SELECT tour_id, tour_code, title, featured_image 
FROM tours 
WHERE tour_code IN ('VN-HL-001', 'VN-HAN-001', 'VN-NT-001', 'VN-DL-001', 'VN-PQ-001', 'VN-SP-001')
ORDER BY tour_id;

SELECT COUNT(*) as total_images, tour_id 
FROM tour_images 
WHERE tour_id IN (1, 2, 3, 4, 5, 6)
GROUP BY tour_id
ORDER BY tour_id;
