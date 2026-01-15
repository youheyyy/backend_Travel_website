/**
 * Calculate tour price for participants
 */
const calculateTourPrice = (priceAdult, priceChild, priceInfant, numAdults, numChildren, numInfants) => {
    const adultTotal = (priceAdult || 0) * (numAdults || 0);
    const childTotal = (priceChild || 0) * (numChildren || 0);
    const infantTotal = (priceInfant || 0) * (numInfants || 0);

    return adultTotal + childTotal + infantTotal;
};

/**
 * Apply discount to price
 */
const applyDiscount = (price, discountPercentage) => {
    if (!discountPercentage || discountPercentage <= 0) return price;

    const discountAmount = (price * discountPercentage) / 100;
    return price - discountAmount;
};

/**
 * Calculate promotion discount
 */
const calculatePromotionDiscount = (promotion, totalAmount) => {
    if (!promotion) return 0;

    let discountAmount = 0;

    if (promotion.discount_type === 'percentage') {
        discountAmount = (totalAmount * promotion.discount_value) / 100;

        // Apply max discount limit
        if (promotion.max_discount_amount && discountAmount > promotion.max_discount_amount) {
            discountAmount = promotion.max_discount_amount;
        }
    } else if (promotion.discount_type === 'fixed_amount') {
        discountAmount = promotion.discount_value;
    }

    // Discount cannot exceed total amount
    return Math.min(discountAmount, totalAmount);
};

/**
 * Calculate final booking price
 */
const calculateBookingPrice = (tour, numAdults, numChildren, numInfants, promotion = null) => {
    // Base price
    let totalPrice = calculateTourPrice(
        tour.price_adult,
        tour.price_child,
        tour.price_infant,
        numAdults,
        numChildren,
        numInfants
    );

    // Apply tour discount
    if (tour.discount_percentage) {
        totalPrice = applyDiscount(totalPrice, tour.discount_percentage);
    }

    // Apply promotion
    let promotionDiscount = 0;
    if (promotion) {
        promotionDiscount = calculatePromotionDiscount(promotion, totalPrice);
    }

    const finalPrice = totalPrice - promotionDiscount;

    return {
        basePrice: totalPrice + promotionDiscount,
        tourDiscount: tour.discount_percentage || 0,
        promotionDiscount: promotionDiscount,
        finalPrice: Math.max(finalPrice, 0)
    };
};

/**
 * Format price to Vietnamese currency
 */
const formatPrice = (price) => {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(price);
};

/**
 * Calculate deposit amount (typically 30%)
 */
const calculateDeposit = (totalAmount, depositPercentage = 30) => {
    return (totalAmount * depositPercentage) / 100;
};

module.exports = {
    calculateTourPrice,
    applyDiscount,
    calculatePromotionDiscount,
    calculateBookingPrice,
    formatPrice,
    calculateDeposit
};
