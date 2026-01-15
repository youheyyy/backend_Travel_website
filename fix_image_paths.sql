-- =====================================================
-- FIX IMAGE PATHS - Migration Script
-- Cập nhật đường dẫn ảnh từ /images/ sang /uploads/
-- =====================================================

-- Hiển thị số lượng bản ghi sẽ được cập nhật
SELECT 'Tours with /images/ paths:' as info, COUNT(*) as count 
FROM tours 
WHERE featured_image LIKE '/images/%';

SELECT 'Tour images with /images/ paths:' as info, COUNT(*) as count 
FROM tour_images 
WHERE image_url LIKE '/images/%';

SELECT 'Destinations with /images/ paths:' as info, COUNT(*) as count 
FROM destinations 
WHERE image_url LIKE '/images/%';

SELECT 'Blog posts with /images/ paths:' as info, COUNT(*) as count 
FROM blog_posts 
WHERE featured_image LIKE '/images/%';

-- Cập nhật tours featured_image paths
UPDATE tours 
SET featured_image = REPLACE(featured_image, '/images/', '/uploads/')
WHERE featured_image LIKE '/images/%';

-- Cập nhật tour_images paths
UPDATE tour_images 
SET image_url = REPLACE(image_url, '/images/', '/uploads/')
WHERE image_url LIKE '/images/%';

-- Cập nhật destinations paths
UPDATE destinations 
SET image_url = REPLACE(image_url, '/images/', '/uploads/')
WHERE image_url LIKE '/images/%';

-- Cập nhật blog_posts paths
UPDATE blog_posts 
SET featured_image = REPLACE(featured_image, '/images/', '/uploads/')
WHERE featured_image LIKE '/images/%';

-- Hiển thị kết quả sau khi cập nhật
SELECT 'Tours updated - Sample:' as info;
SELECT tour_id, title, featured_image FROM tours LIMIT 5;

SELECT 'Tour images updated - Sample:' as info;
SELECT image_id, tour_id, image_url FROM tour_images LIMIT 5;

SELECT 'Migration completed successfully!' as status;
