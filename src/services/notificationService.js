const Notification = require('../models/Notification');

/**
 * Create notification for user
 */
const createNotification = async (userId, title, message, type = 'info') => {
    try {
        const notification = await Notification.create({
            user_id: userId,
            title,
            message,
            notification_type: type
        });
        return notification;
    } catch (error) {
        console.error('Notification error:', error);
        return null;
    }
};

/**
 * Notify user about booking confirmation
 */
const notifyBookingConfirmed = async (userId, bookingCode) => {
    return createNotification(
        userId,
        'Đặt tour thành công',
        `Đặt tour ${bookingCode} của bạn đã được xác nhận. Chúng tôi sẽ liên hệ với bạn sớm nhất.`,
        'booking'
    );
};

/**
 * Notify user about payment received
 */
const notifyPaymentReceived = async (userId, amount, bookingCode) => {
    return createNotification(
        userId,
        'Thanh toán thành công',
        `Chúng tôi đã nhận được thanh toán ${amount.toLocaleString('vi-VN')} VNĐ cho booking ${bookingCode}.`,
        'payment'
    );
};

/**
 * Notify user about booking cancellation
 */
const notifyBookingCancelled = async (userId, bookingCode) => {
    return createNotification(
        userId,
        'Đặt tour đã hủy',
        `Booking ${bookingCode} của bạn đã được hủy thành công.`,
        'booking'
    );
};

/**
 * Notify user about upcoming tour
 */
const notifyUpcomingTour = async (userId, tourTitle, departureDate) => {
    return createNotification(
        userId,
        'Tour sắp khởi hành',
        `Tour "${tourTitle}" của bạn sẽ khởi hành vào ${departureDate}. Vui lòng chuẩn bị hành lý!`,
        'reminder'
    );
};

/**
 * Notify user about promotion
 */
const notifyPromotion = async (userId, promotionCode, description) => {
    return createNotification(
        userId,
        'Khuyến mãi mới',
        `Sử dụng mã ${promotionCode} để nhận ưu đãi: ${description}`,
        'promotion'
    );
};

/**
 * Send bulk notifications to multiple users
 */
const sendBulkNotifications = async (userIds, title, message, type = 'info') => {
    try {
        const notifications = await Notification.createBulk(userIds, title, message, type);
        return notifications;
    } catch (error) {
        console.error('Bulk notification error:', error);
        return [];
    }
};

module.exports = {
    createNotification,
    notifyBookingConfirmed,
    notifyPaymentReceived,
    notifyBookingCancelled,
    notifyUpcomingTour,
    notifyPromotion,
    sendBulkNotifications
};
