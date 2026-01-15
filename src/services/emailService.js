const nodemailer = require('nodemailer');

// Create transporter
const transporter = nodemailer.createTransport({
    host: process.env.SMTP_HOST || 'smtp.gmail.com',
    port: process.env.SMTP_PORT || 587,
    secure: false,
    auth: {
        user: process.env.SMTP_USER,
        pass: process.env.SMTP_PASS
    }
});

/**
 * Send email
 */
const sendEmail = async (to, subject, html, attachments = []) => {
    try {
        const mailOptions = {
            from: `"${process.env.APP_NAME || 'Travel Website'}" <${process.env.SMTP_USER}>`,
            to,
            subject,
            html,
            attachments
        };

        const info = await transporter.sendMail(mailOptions);
        console.log('Email sent:', info.messageId);
        return { success: true, messageId: info.messageId };
    } catch (error) {
        console.error('Email error:', error);
        return { success: false, error: error.message };
    }
};

/**
 * Send booking confirmation email
 */
const sendBookingConfirmation = async (booking, tour) => {
    const html = `
    <h2>Xác nhận đặt tour</h2>
    <p>Xin chào ${booking.customer_name},</p>
    <p>Cảm ơn bạn đã đặt tour tại ${process.env.APP_NAME}!</p>
    
    <h3>Thông tin đặt tour:</h3>
    <ul>
      <li><strong>Mã đặt tour:</strong> ${booking.booking_code}</li>
      <li><strong>Tour:</strong> ${tour.title}</li>
      <li><strong>Ngày khởi hành:</strong> ${booking.departure_date}</li>
      <li><strong>Số người:</strong> ${booking.num_adults} người lớn, ${booking.num_children} trẻ em, ${booking.num_infants} em bé</li>
      <li><strong>Tổng tiền:</strong> ${booking.total_amount.toLocaleString('vi-VN')} VNĐ</li>
    </ul>
    
    <p>Chúng tôi sẽ liên hệ với bạn sớm nhất để xác nhận thông tin.</p>
    
    <p>Trân trọng,<br>${process.env.APP_NAME}</p>
  `;

    return sendEmail(booking.customer_email, 'Xác nhận đặt tour', html);
};

/**
 * Send payment confirmation email
 */
const sendPaymentConfirmation = async (payment, booking) => {
    const html = `
    <h2>Xác nhận thanh toán</h2>
    <p>Xin chào ${booking.customer_name},</p>
    <p>Chúng tôi đã nhận được thanh toán của bạn.</p>
    
    <h3>Thông tin thanh toán:</h3>
    <ul>
      <li><strong>Mã đặt tour:</strong> ${booking.booking_code}</li>
      <li><strong>Số tiền:</strong> ${payment.amount.toLocaleString('vi-VN')} VNĐ</li>
      <li><strong>Phương thức:</strong> ${payment.payment_method}</li>
      <li><strong>Trạng thái:</strong> ${payment.payment_status}</li>
    </ul>
    
    <p>Trân trọng,<br>${process.env.APP_NAME}</p>
  `;

    return sendEmail(booking.customer_email, 'Xác nhận thanh toán', html);
};

/**
 * Send password reset email
 */
const sendPasswordReset = async (email, resetToken) => {
    const resetUrl = `${process.env.FRONTEND_URL}/reset-password?token=${resetToken}`;

    const html = `
    <h2>Đặt lại mật khẩu</h2>
    <p>Bạn đã yêu cầu đặt lại mật khẩu.</p>
    <p>Vui lòng click vào link sau để đặt lại mật khẩu:</p>
    <p><a href="${resetUrl}">${resetUrl}</a></p>
    <p>Link này sẽ hết hạn sau 1 giờ.</p>
    <p>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.</p>
  `;

    return sendEmail(email, 'Đặt lại mật khẩu', html);
};

/**
 * Send welcome email
 */
const sendWelcomeEmail = async (user) => {
    const html = `
    <h2>Chào mừng đến với ${process.env.APP_NAME}!</h2>
    <p>Xin chào ${user.full_name || user.username},</p>
    <p>Cảm ơn bạn đã đăng ký tài khoản tại ${process.env.APP_NAME}.</p>
    <p>Bạn có thể bắt đầu khám phá các tour du lịch tuyệt vời của chúng tôi!</p>
    <p>Trân trọng,<br>${process.env.APP_NAME}</p>
  `;

    return sendEmail(user.email, `Chào mừng đến với ${process.env.APP_NAME}`, html);
};

module.exports = {
    sendEmail,
    sendBookingConfirmation,
    sendPaymentConfirmation,
    sendPasswordReset,
    sendWelcomeEmail
};
