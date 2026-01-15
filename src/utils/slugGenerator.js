/**
 * Generate URL-friendly slug from text
 * Supports Vietnamese characters
 */
const generateSlug = (text) => {
    if (!text) return '';

    // Convert to lowercase
    let slug = text.toLowerCase();

    // Vietnamese character mapping
    const vietnameseMap = {
        'à': 'a', 'á': 'a', 'ạ': 'a', 'ả': 'a', 'ã': 'a',
        'â': 'a', 'ầ': 'a', 'ấ': 'a', 'ậ': 'a', 'ẩ': 'a', 'ẫ': 'a',
        'ă': 'a', 'ằ': 'a', 'ắ': 'a', 'ặ': 'a', 'ẳ': 'a', 'ẵ': 'a',
        'è': 'e', 'é': 'e', 'ẹ': 'e', 'ẻ': 'e', 'ẽ': 'e',
        'ê': 'e', 'ề': 'e', 'ế': 'e', 'ệ': 'e', 'ể': 'e', 'ễ': 'e',
        'ì': 'i', 'í': 'i', 'ị': 'i', 'ỉ': 'i', 'ĩ': 'i',
        'ò': 'o', 'ó': 'o', 'ọ': 'o', 'ỏ': 'o', 'õ': 'o',
        'ô': 'o', 'ồ': 'o', 'ố': 'o', 'ộ': 'o', 'ổ': 'o', 'ỗ': 'o',
        'ơ': 'o', 'ờ': 'o', 'ớ': 'o', 'ợ': 'o', 'ở': 'o', 'ỡ': 'o',
        'ù': 'u', 'ú': 'u', 'ụ': 'u', 'ủ': 'u', 'ũ': 'u',
        'ư': 'u', 'ừ': 'u', 'ứ': 'u', 'ự': 'u', 'ử': 'u', 'ữ': 'u',
        'ỳ': 'y', 'ý': 'y', 'ỵ': 'y', 'ỷ': 'y', 'ỹ': 'y',
        'đ': 'd'
    };

    // Replace Vietnamese characters
    Object.keys(vietnameseMap).forEach(key => {
        slug = slug.replace(new RegExp(key, 'g'), vietnameseMap[key]);
    });

    // Remove special characters
    slug = slug.replace(/[^a-z0-9\s-]/g, '');

    // Replace spaces with hyphens
    slug = slug.replace(/\s+/g, '-');

    // Remove multiple hyphens
    slug = slug.replace(/-+/g, '-');

    // Trim hyphens from start and end
    slug = slug.replace(/^-+|-+$/g, '');

    return slug;
};

/**
 * Generate unique slug with timestamp if needed
 */
const generateUniqueSlug = (text) => {
    const baseSlug = generateSlug(text);
    const timestamp = Date.now().toString(36);
    return `${baseSlug}-${timestamp}`;
};

module.exports = {
    generateSlug,
    generateUniqueSlug
};
