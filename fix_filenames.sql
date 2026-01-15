-- =====================================================
-- FIX FILENAME MISMATCH - Update database to use actual filenames
-- =====================================================

-- Update tours table to use actual filenames that exist in uploads/tours/
UPDATE tours SET featured_image = '/uploads/tours/ha-long-1.jpg' WHERE tour_id = 1;
UPDATE tours SET featured_image = '/uploads/tours/hoi-an-1.jpg' WHERE tour_id = 2;
UPDATE tours SET featured_image = '/uploads/tours/da-lat-1.jpg' WHERE tour_id = 3;
UPDATE tours SET featured_image = '/uploads/tours/phu-quoc-1.jpg' WHERE tour_id = 4;
UPDATE tours SET featured_image = '/uploads/tours/sapa-1.jpg' WHERE tour_id = 5;
UPDATE tours SET featured_image = '/uploads/tours/nha-trang-1.jpg' WHERE tour_id = 6;
UPDATE tours SET featured_image = '/uploads/tours/hue-1.jpg' WHERE tour_id = 7;
UPDATE tours SET featured_image = '/uploads/tours/mui-ne-1.jpg' WHERE tour_id = 8;
UPDATE tours SET featured_image = '/uploads/tours/ninh-binh-1.jpg' WHERE tour_id = 9;
UPDATE tours SET featured_image = '/uploads/tours/da-nang-1.jpg' WHERE tour_id = 10;

-- Verify the updates
SELECT tour_id, title, featured_image FROM tours ORDER BY tour_id;

SELECT 'Filename mismatch fixed!' as status;
