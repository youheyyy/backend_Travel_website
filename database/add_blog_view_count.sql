-- Add view_count column to blog_posts table if it doesn't exist
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'blog_posts' 
        AND column_name = 'view_count'
    ) THEN
        ALTER TABLE blog_posts ADD COLUMN view_count INTEGER DEFAULT 0;
    END IF;
END $$;
