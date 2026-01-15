# HƯỚNG DẪN SỬ DỤNG SCRIPT RESET DATABASE

## 📋 Tổng Quan

File `reset_and_seed_data.sql` chứa script để:
1. **Xóa tất cả dữ liệu cũ** trong database (giữ nguyên cấu trúc bảng)
2. **Tạo dữ liệu mẫu mới** hoàn chỉnh bằng tiếng Việt

## ⚠️ CẢNH BÁO QUAN TRỌNG

**Script này sẽ XÓA TẤT CẢ dữ liệu hiện có trong database!**
- Chỉ sử dụng cho môi trường **development/testing**
- **KHÔNG BAO GIỜ** chạy trên môi trường **production**
- Nên backup database trước khi chạy

## 🚀 Cách Sử Dụng

### Cách 1: Sử Dụng psql Command Line

```bash
# Di chuyển đến thư mục chứa file SQL
cd "d:\Project\travel website\backend"

# Chạy script (thay YOUR_DATABASE_NAME bằng tên database của bạn)
psql -U postgres -d YOUR_DATABASE_NAME -f reset_and_seed_data.sql
```

### Cách 2: Sử Dụng pgAdmin

1. Mở **pgAdmin**
2. Kết nối đến database của bạn
3. Click chuột phải vào database → **Query Tool**
4. Mở file `reset_and_seed_data.sql` (File → Open)
5. Click nút **Execute** (F5)

### Cách 3: Sử Dụng DBeaver/DataGrip

1. Mở **DBeaver** hoặc **DataGrip**
2. Kết nối đến database
3. Tạo **New SQL Script**
4. Copy nội dung file `reset_and_seed_data.sql` vào
5. Click **Execute** (Ctrl+Enter)

## 📊 Dữ Liệu Được Tạo

### 1. Vai Trò & Người Dùng
- **7 vai trò**: Super Admin, Admin, Tour Manager, Content Manager, Customer Support, Accountant, Customer
- **10 người dùng**: 6 nhân viên + 4 khách hàng
- **40+ quyền hạn** được phân bổ cho các vai trò

### 2. Tour & Điểm Đến
- **10 điểm đến** nổi tiếng Việt Nam
- **8 danh mục tour**
- **10 tour** với thông tin đầy đủ
- **12+ hình ảnh tour**
- **16 lịch trình** khởi hành

### 3. Booking & Thanh Toán
- **5 đơn đặt tour** với các trạng thái khác nhau
- **13 người tham gia** tour
- **4 giao dịch thanh toán**

### 4. Nội Dung
- **3 đánh giá** tour (đã duyệt)
- **3 bài viết blog** (đã xuất bản)

### 5. Khuyến Mãi & Thông Báo
- **4 mã khuyến mãi** đang hoạt động
- **4 lịch sử sử dụng** khuyến mãi
- **8 thông báo** cho người dùng

### 6. Hệ Thống
- **10 cài đặt** hệ thống
- **10 nhật ký** hoạt động

## 👥 Tài Khoản Mặc Định

### Tài Khoản Quản Trị

| Username | Email | Password | Vai Trò |
|----------|-------|----------|---------|
| superadmin | superadmin@travelweb.vn | password123 | Super Admin |
| admin | admin@travelweb.vn | password123 | Admin |
| tourmanager | tourmanager@travelweb.vn | password123 | Tour Manager |
| contentmanager | content@travelweb.vn | password123 | Content Manager |
| support | support@travelweb.vn | password123 | Customer Support |
| accountant | accountant@travelweb.vn | password123 | Accountant |

### Tài Khoản Khách Hàng

| Username | Email | Password | Họ Tên |
|----------|-------|----------|--------|
| customer1 | customer1@gmail.com | password123 | Nguyễn Minh Anh |
| customer2 | customer2@gmail.com | password123 | Trần Hoàng Bảo |
| customer3 | customer3@gmail.com | password123 | Lê Thị Cẩm |
| customer4 | customer4@gmail.com | password123 | Phạm Văn Dũng |

**Lưu ý**: Mật khẩu trong script đã được hash bằng bcrypt. Mật khẩu gốc là `password123`.

## 🔧 Sau Khi Chạy Script

### 1. Kiểm Tra Dữ Liệu

Script sẽ tự động hiển thị thống kê dữ liệu đã tạo:

```sql
-- Xem thống kê
SELECT 'Roles' as table_name, COUNT(*) as record_count FROM roles
UNION ALL
SELECT 'Users', COUNT(*) FROM users
-- ... (tất cả các bảng)
```

### 2. Hash Mật Khẩu (Nếu Cần)

Nếu bạn muốn thay đổi mật khẩu, sử dụng bcrypt để hash:

**Node.js:**
```javascript
const bcrypt = require('bcryptjs');
const password = 'your_new_password';
const hash = bcrypt.hashSync(password, 10);
console.log(hash);
```

Sau đó cập nhật trong database:
```sql
UPDATE users SET password_hash = '$2a$10$...' WHERE username = 'admin';
```

### 3. Cập Nhật URL Hình Ảnh

Các URL hình ảnh trong script là placeholder. Bạn cần:
1. Upload hình ảnh thật vào thư mục `uploads/images/`
2. Cập nhật URL trong database hoặc sử dụng hình ảnh có sẵn

## 📝 Lưu Ý Quan Trọng

### 1. Mật Khẩu
- Mật khẩu mặc định: `password123`
- **Phải thay đổi** trước khi deploy production
- Sử dụng mật khẩu mạnh cho tài khoản admin

### 2. Hình Ảnh
- Tất cả URL hình ảnh là placeholder
- Cần thay thế bằng hình ảnh thật
- Hoặc sử dụng dịch vụ như Unsplash, Pexels

### 3. Thông Tin Cá Nhân
- Email và số điện thoại là dữ liệu giả
- Nên thay đổi trước khi sử dụng thực tế

### 4. Ngày Tháng
- Lịch trình tour được set cho tháng 1-2/2026
- Cần cập nhật theo thời gian thực tế

## 🔄 Reset Lại Database

Nếu muốn reset lại từ đầu, chỉ cần chạy lại script:

```bash
psql -U postgres -d YOUR_DATABASE_NAME -f reset_and_seed_data.sql
```

Script sẽ:
1. Xóa tất cả dữ liệu cũ
2. Reset sequences về 1
3. Tạo lại dữ liệu mẫu mới

## 🐛 Xử Lý Lỗi

### Lỗi: "permission denied"
```bash
# Chạy với quyền admin
sudo psql -U postgres -d YOUR_DATABASE_NAME -f reset_and_seed_data.sql
```

### Lỗi: "relation does not exist"
- Đảm bảo đã chạy migration tạo bảng trước
- Kiểm tra tên database đúng chưa

### Lỗi: "duplicate key value"
- Script đã tự động xóa dữ liệu cũ
- Nếu vẫn lỗi, kiểm tra foreign key constraints

## 📞 Hỗ Trợ

Nếu gặp vấn đề, kiểm tra:
1. Database đã được tạo chưa
2. Migration đã chạy chưa
3. Quyền truy cập database
4. Version PostgreSQL (khuyến nghị >= 12)

## ✅ Checklist Sau Khi Chạy

- [ ] Kiểm tra số lượng bản ghi trong mỗi bảng
- [ ] Đăng nhập thử với tài khoản admin
- [ ] Kiểm tra phân quyền hoạt động
- [ ] Test API endpoints
- [ ] Kiểm tra dữ liệu hiển thị đúng
- [ ] Thay đổi mật khẩu mặc định
- [ ] Cập nhật URL hình ảnh (nếu cần)
