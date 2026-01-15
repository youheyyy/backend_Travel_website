/**
 * Generate unique booking code
 * Format: BK-YYYYMMDD-XXXX
 */
const generateBookingCode = () => {
    const date = new Date();
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const random = Math.random().toString(36).substring(2, 6).toUpperCase();

    return `BK-${year}${month}${day}-${random}`;
};

/**
 * Generate unique tour code
 * Format: TR-XXXX
 */
const generateTourCode = () => {
    const timestamp = Date.now().toString(36).toUpperCase();
    const random = Math.random().toString(36).substring(2, 4).toUpperCase();

    return `TR-${timestamp}${random}`;
};

/**
 * Generate promotion code
 * Format: PROMO-XXXX
 */
const generatePromoCode = (prefix = 'PROMO') => {
    const random = Math.random().toString(36).substring(2, 8).toUpperCase();
    return `${prefix}-${random}`;
};

/**
 * Generate transaction ID
 * Format: TXN-timestamp-random
 */
const generateTransactionId = () => {
    const timestamp = Date.now();
    const random = Math.random().toString(36).substring(2, 8).toUpperCase();

    return `TXN-${timestamp}-${random}`;
};

/**
 * Generate random alphanumeric code
 */
const generateRandomCode = (length = 8) => {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    let result = '';
    for (let i = 0; i < length; i++) {
        result += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return result;
};

module.exports = {
    generateBookingCode,
    generateTourCode,
    generatePromoCode,
    generateTransactionId,
    generateRandomCode
};
