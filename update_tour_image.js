const { Pool } = require('pg');

const pool = new Pool({
    user: 'postgres',
    password: '123',
    host: 'localhost',
    database: 'travel_website',
    port: 5432
});

async function updateAllTourImages() {
    try {
        console.log('🔄 Updating all tour images to use existing files...\n');

        // Update all tours to use ha-long-1.jpg temporarily
        // This ensures all tours display an image instead of blue placeholders
        const updates = [
            { id: 1, image: '/uploads/tours/ha-long-1.jpg', name: 'Ha Long' },
            { id: 2, image: '/uploads/tours/ha-long-2.jpg', name: 'Hoi An' },
            { id: 3, image: '/uploads/tours/ha-long-3.jpg', name: 'Da Lat' },
            { id: 4, image: '/uploads/tours/ha-long-1.jpg', name: 'Phu Quoc' },
            { id: 5, image: '/uploads/tours/ha-long-2.jpg', name: 'Sapa' },
            { id: 6, image: '/uploads/tours/ha-long-3.jpg', name: 'Nha Trang' },
            { id: 7, image: '/uploads/tours/ha-long-1.jpg', name: 'Hue' },
            { id: 8, image: '/uploads/tours/ha-long-2.jpg', name: 'Mui Ne' },
            { id: 9, image: '/uploads/tours/ha-long-3.jpg', name: 'Ninh Binh' },
            { id: 10, image: '/uploads/tours/ha-long-1.jpg', name: 'Da Nang' }
        ];

        for (const update of updates) {
            const result = await pool.query(
                'UPDATE tours SET featured_image = $1 WHERE tour_id = $2 RETURNING tour_id, title, featured_image',
                [update.image, update.id]
            );

            if (result.rows.length > 0) {
                console.log(`✅ Updated Tour ${update.id} (${update.name}): ${update.image}`);
            }
        }

        console.log('\n📊 Verification - All tours:');
        const verify = await pool.query('SELECT tour_id, title, featured_image FROM tours ORDER BY tour_id');
        verify.rows.forEach(row => {
            console.log(`  ${row.tour_id}. ${row.title.substring(0, 40)}... -> ${row.featured_image}`);
        });

        console.log('\n✅ All tours updated successfully!');
        console.log('ℹ️  Note: Tours are using Ha Long images temporarily.');
        console.log('   Add proper images to uploads/tours/ and update database later.');

    } catch (error) {
        console.error('❌ Error:', error);
    } finally {
        await pool.end();
    }
}

updateAllTourImages();
