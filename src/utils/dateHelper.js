/**
 * Format date to Vietnamese format
 */
const formatDate = (date, format = 'DD/MM/YYYY') => {
    if (!date) return '';

    const d = new Date(date);
    const day = String(d.getDate()).padStart(2, '0');
    const month = String(d.getMonth() + 1).padStart(2, '0');
    const year = d.getFullYear();
    const hours = String(d.getHours()).padStart(2, '0');
    const minutes = String(d.getMinutes()).padStart(2, '0');

    switch (format) {
        case 'DD/MM/YYYY':
            return `${day}/${month}/${year}`;
        case 'YYYY-MM-DD':
            return `${year}-${month}-${day}`;
        case 'DD/MM/YYYY HH:mm':
            return `${day}/${month}/${year} ${hours}:${minutes}`;
        default:
            return d.toISOString();
    }
};

/**
 * Calculate days between two dates
 */
const daysBetween = (date1, date2) => {
    const d1 = new Date(date1);
    const d2 = new Date(date2);
    const diffTime = Math.abs(d2 - d1);
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    return diffDays;
};

/**
 * Add days to a date
 */
const addDays = (date, days) => {
    const result = new Date(date);
    result.setDate(result.getDate() + days);
    return result;
};

/**
 * Check if date is in the past
 */
const isPast = (date) => {
    return new Date(date) < new Date();
};

/**
 * Check if date is in the future
 */
const isFuture = (date) => {
    return new Date(date) > new Date();
};

/**
 * Get date range for a tour
 */
const getTourDateRange = (departureDate, durationDays) => {
    const departure = new Date(departureDate);
    const returnDate = addDays(departure, durationDays);

    return {
        departure: formatDate(departure),
        return: formatDate(returnDate),
        duration: durationDays
    };
};

/**
 * Check if booking is within cancellation period
 */
const isWithinCancellationPeriod = (departureDate, cancellationDays = 7) => {
    const daysUntilDeparture = daysBetween(new Date(), departureDate);
    return daysUntilDeparture >= cancellationDays;
};

module.exports = {
    formatDate,
    daysBetween,
    addDays,
    isPast,
    isFuture,
    getTourDateRange,
    isWithinCancellationPeriod
};
