# API Documentation - Travel Website Backend

## Tổng quan

API này cung cấp hệ thống phân quyền dựa trên vai trò (RBAC - Role-Based Access Control) cho website du lịch. Hệ thống bao gồm quản lý người dùng, vai trò, và quyền hạn.

**Base URL:** `http://localhost:5000/api`

**Authentication:** Bearer Token (JWT)

---

## Mục lục

1. [Authentication](#authentication)
2. [Roles](#roles)
3. [Permissions](#permissions)
4. [Users](#users)
5. [Error Codes](#error-codes)
6. [Testing Examples](#testing-examples)

---

## Authentication

### 1. Đăng ký người dùng mới

**Endpoint:** `POST /api/auth/register`

**Description:** Tạo tài khoản người dùng mới (mặc định là vai trò Customer)

**Request Body:**
```json
{
  "username": "johndoe",
  "email": "john@example.com",
  "password": "password123",
  "full_name": "John Doe",
  "phone": "0123456789",
  "role_id": 7
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": {
      "user_id": 1,
      "username": "johndoe",
      "email": "john@example.com",
      "full_name": "John Doe",
      "phone": "0123456789",
      "role_id": 7
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

---

### 2. Đăng nhập

**Endpoint:** `POST /api/auth/login`

**Description:** Đăng nhập và nhận JWT token

**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "user_id": 1,
      "username": "johndoe",
      "email": "john@example.com",
      "full_name": "John Doe",
      "phone": "0123456789",
      "avatar_url": null,
      "status": "active",
      "email_verified": false,
      "role_id": 7,
      "role_name": "Customer",
      "role_description": "Khách hàng"
    },
    "permissions": [
      "tour.view",
      "booking.view_own",
      "booking.create",
      "booking.cancel"
    ],
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

---

### 3. Lấy thông tin profile

**Endpoint:** `GET /api/auth/profile`

**Description:** Lấy thông tin người dùng hiện tại

**Headers:**
```
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "user": {
      "user_id": 1,
      "username": "johndoe",
      "email": "john@example.com",
      "full_name": "John Doe",
      "phone": "0123456789",
      "avatar_url": null,
      "status": "active",
      "role_id": 7,
      "role_name": "Customer"
    },
    "permissions": [
      "tour.view",
      "booking.view_own",
      "booking.create"
    ]
  }
}
```

---

### 4. Cập nhật profile

**Endpoint:** `PUT /api/auth/profile`

**Description:** Cập nhật thông tin cá nhân

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "full_name": "John Doe Updated",
  "phone": "0987654321",
  "avatar_url": "https://example.com/avatar.jpg"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Profile updated successfully",
  "data": {
    "user_id": 1,
    "username": "johndoe",
    "email": "john@example.com",
    "full_name": "John Doe Updated",
    "phone": "0987654321",
    "avatar_url": "https://example.com/avatar.jpg"
  }
}
```

---

### 5. Đổi mật khẩu

**Endpoint:** `PUT /api/auth/change-password`

**Description:** Thay đổi mật khẩu

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "current_password": "password123",
  "new_password": "newpassword456"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Password changed successfully"
}
```

---

## Roles

### 1. Lấy danh sách tất cả vai trò

**Endpoint:** `GET /api/roles`

**Description:** Lấy danh sách tất cả vai trò trong hệ thống

**Headers:**
```
Authorization: Bearer <token>
```

**Required Permission:** `user.manage_roles`

**Response (200 OK):**
```json
{
  "success": true,
  "data": [
    {
      "role_id": 1,
      "role_name": "Super Admin",
      "role_description": "Quản trị viên cấp cao nhất",
      "created_at": "2024-01-01T00:00:00.000Z"
    },
    {
      "role_id": 2,
      "role_name": "Admin",
      "role_description": "Quản trị viên",
      "created_at": "2024-01-01T00:00:00.000Z"
    }
  ],
  "count": 2
}
```

---

### 2. Lấy thông tin vai trò theo ID

**Endpoint:** `GET /api/roles/:id`

**Description:** Lấy thông tin chi tiết của một vai trò kèm danh sách quyền

**Headers:**
```
Authorization: Bearer <token>
```

**Required Permission:** `user.manage_roles`

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "role_id": 1,
    "role_name": "Super Admin",
    "role_description": "Quản trị viên cấp cao nhất",
    "created_at": "2024-01-01T00:00:00.000Z",
    "permissions": [
      {
        "permission_id": 1,
        "permission_name": "user.manage_roles",
        "permission_description": "Quản lý vai trò người dùng",
        "module": "user"
      },
      {
        "permission_id": 2,
        "permission_name": "system.edit_settings",
        "permission_description": "Chỉnh sửa cài đặt hệ thống",
        "module": "system"
      }
    ]
  }
}
```

---

### 3. Tạo vai trò mới

**Endpoint:** `POST /api/roles`

**Description:** Tạo vai trò mới

**Headers:**
```
Authorization: Bearer <token>
```

**Required Permission:** `user.manage_roles`

**Request Body:**
```json
{
  "role_name": "Marketing Manager",
  "role_description": "Quản lý marketing"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Role created successfully",
  "data": {
    "role_id": 8,
    "role_name": "Marketing Manager",
    "role_description": "Quản lý marketing",
    "created_at": "2024-01-15T10:30:00.000Z"
  }
}
```

---

### 4. Cập nhật vai trò

**Endpoint:** `PUT /api/roles/:id`

**Description:** Cập nhật thông tin vai trò

**Headers:**
```
Authorization: Bearer <token>
```

**Required Permission:** `user.manage_roles`

**Request Body:**
```json
{
  "role_name": "Marketing Director",
  "role_description": "Giám đốc marketing"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Role updated successfully",
  "data": {
    "role_id": 8,
    "role_name": "Marketing Director",
    "role_description": "Giám đốc marketing",
    "created_at": "2024-01-15T10:30:00.000Z"
  }
}
```

---

### 5. Xóa vai trò

**Endpoint:** `DELETE /api/roles/:id`

**Description:** Xóa vai trò

**Headers:**
```
Authorization: Bearer <token>
```

**Required Permission:** `user.manage_roles`

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Role deleted successfully"
}
```

---

### 6. Lấy danh sách quyền của vai trò

**Endpoint:** `GET /api/roles/:id/permissions`

**Description:** Lấy tất cả quyền được gán cho vai trò

**Headers:**
```
Authorization: Bearer <token>
```

**Required Permission:** `user.manage_roles`

**Response (200 OK):**
```json
{
  "success": true,
  "data": [
    {
      "permission_id": 3,
      "permission_name": "tour.view",
      "permission_description": "Xem tour",
      "module": "tour"
    },
    {
      "permission_id": 4,
      "permission_name": "tour.create",
      "permission_description": "Tạo tour mới",
      "module": "tour"
    }
  ],
  "count": 2
}
```

---

### 7. Gán quyền cho vai trò

**Endpoint:** `POST /api/roles/:id/permissions`

**Description:** Gán nhiều quyền cho vai trò (thay thế tất cả quyền hiện tại)

**Headers:**
```
Authorization: Bearer <token>
```

**Required Permission:** `user.manage_roles`

**Request Body:**
```json
{
  "permission_ids": [3, 4, 5, 6, 7]
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Permissions assigned successfully",
  "data": [
    {
      "permission_id": 3,
      "permission_name": "tour.view",
      "permission_description": "Xem tour",
      "module": "tour"
    },
    {
      "permission_id": 4,
      "permission_name": "tour.create",
      "permission_description": "Tạo tour mới",
      "module": "tour"
    }
  ],
  "count": 5
}
```

---

## Permissions

### 1. Lấy danh sách tất cả quyền

**Endpoint:** `GET /api/permissions`

**Description:** Lấy danh sách tất cả quyền trong hệ thống

**Headers:**
```
Authorization: Bearer <token>
```

**Required Permission:** `user.manage_roles`

**Response (200 OK):**
```json
{
  "success": true,
  "data": [
    {
      "permission_id": 1,
      "permission_name": "user.manage_roles",
      "permission_description": "Quản lý vai trò người dùng",
      "module": "user",
      "created_at": "2024-01-01T00:00:00.000Z"
    },
    {
      "permission_id": 2,
      "permission_name": "system.edit_settings",
      "permission_description": "Chỉnh sửa cài đặt hệ thống",
      "module": "system",
      "created_at": "2024-01-01T00:00:00.000Z"
    }
  ],
  "count": 2
}
```

---

### 2. Lấy danh sách modules

**Endpoint:** `GET /api/permissions/modules`

**Description:** Lấy danh sách tất cả các module có quyền

**Headers:**
```
Authorization: Bearer <token>
```

**Required Permission:** `user.manage_roles`

**Response (200 OK):**
```json
{
  "success": true,
  "data": [
    "user",
    "system",
    "tour",
    "booking",
    "payment",
    "review",
    "content",
    "promotion",
    "report",
    "customer"
  ],
  "count": 10
}
```

---

### 3. Lấy quyền theo module

**Endpoint:** `GET /api/permissions/module/:module`

**Description:** Lấy tất cả quyền thuộc một module cụ thể

**Headers:**
```
Authorization: Bearer <token>
```

**Required Permission:** `user.manage_roles`

**Example:** `GET /api/permissions/module/tour`

**Response (200 OK):**
```json
{
  "success": true,
  "data": [
    {
      "permission_id": 3,
      "permission_name": "tour.view",
      "permission_description": "Xem tour",
      "module": "tour",
      "created_at": "2024-01-01T00:00:00.000Z"
    },
    {
      "permission_id": 4,
      "permission_name": "tour.create",
      "permission_description": "Tạo tour mới",
      "module": "tour",
      "created_at": "2024-01-01T00:00:00.000Z"
    },
    {
      "permission_id": 5,
      "permission_name": "tour.edit",
      "permission_description": "Chỉnh sửa tour",
      "module": "tour",
      "created_at": "2024-01-01T00:00:00.000Z"
    }
  ],
  "count": 3
}
```

---

### 4. Lấy quyền theo ID

**Endpoint:** `GET /api/permissions/:id`

**Description:** Lấy thông tin chi tiết của một quyền

**Headers:**
```
Authorization: Bearer <token>
```

**Required Permission:** `user.manage_roles`

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "permission_id": 3,
    "permission_name": "tour.view",
    "permission_description": "Xem tour",
    "module": "tour",
    "created_at": "2024-01-01T00:00:00.000Z"
  }
}
```

---

### 5. Tạo quyền mới

**Endpoint:** `POST /api/permissions`

**Description:** Tạo quyền mới

**Headers:**
```
Authorization: Bearer <token>
```

**Required Permission:** `user.manage_roles`

**Request Body:**
```json
{
  "permission_name": "tour.publish",
  "permission_description": "Xuất bản tour",
  "module": "tour"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Permission created successfully",
  "data": {
    "permission_id": 21,
    "permission_name": "tour.publish",
    "permission_description": "Xuất bản tour",
    "module": "tour",
    "created_at": "2024-01-15T10:30:00.000Z"
  }
}
```

---

### 6. Cập nhật quyền

**Endpoint:** `PUT /api/permissions/:id`

**Description:** Cập nhật thông tin quyền

**Headers:**
```
Authorization: Bearer <token>
```

**Required Permission:** `user.manage_roles`

**Request Body:**
```json
{
  "permission_name": "tour.publish_approve",
  "permission_description": "Duyệt và xuất bản tour",
  "module": "tour"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Permission updated successfully",
  "data": {
    "permission_id": 21,
    "permission_name": "tour.publish_approve",
    "permission_description": "Duyệt và xuất bản tour",
    "module": "tour",
    "created_at": "2024-01-15T10:30:00.000Z"
  }
}
```

---

### 7. Xóa quyền

**Endpoint:** `DELETE /api/permissions/:id`

**Description:** Xóa quyền

**Headers:**
```
Authorization: Bearer <token>
```

**Required Permission:** `user.manage_roles`

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Permission deleted successfully"
}
```

---

## Users

### 1. Lấy danh sách tất cả người dùng

**Endpoint:** `GET /api/users`

**Description:** Lấy danh sách tất cả người dùng

**Headers:**
```
Authorization: Bearer <token>
```

**Required Permission:** `customer.view`

**Response (200 OK):**
```json
{
  "success": true,
  "data": [
    {
      "user_id": 1,
      "username": "johndoe",
      "email": "john@example.com",
      "full_name": "John Doe",
      "phone": "0123456789",
      "avatar_url": null,
      "status": "active",
      "email_verified": false,
      "created_at": "2024-01-01T00:00:00.000Z",
      "updated_at": "2024-01-01T00:00:00.000Z",
      "last_login": "2024-01-15T10:00:00.000Z",
      "role_id": 7,
      "role_name": "Customer",
      "role_description": "Khách hàng"
    }
  ],
  "count": 1
}
```

---

### 2. Lấy người dùng theo vai trò

**Endpoint:** `GET /api/users/role/:roleId`

**Description:** Lấy danh sách người dùng theo vai trò

**Headers:**
```
Authorization: Bearer <token>
```

**Required Permission:** `customer.view`

**Example:** `GET /api/users/role/7`

**Response (200 OK):**
```json
{
  "success": true,
  "data": [
    {
      "user_id": 1,
      "username": "johndoe",
      "email": "john@example.com",
      "full_name": "John Doe",
      "role_id": 7,
      "role_name": "Customer"
    }
  ],
  "count": 1
}
```

---

### 3. Lấy thông tin người dùng theo ID

**Endpoint:** `GET /api/users/:id`

**Description:** Lấy thông tin chi tiết người dùng kèm quyền

**Headers:**
```
Authorization: Bearer <token>
```

**Required Permission:** `customer.view` hoặc `booking.view_own`

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "user_id": 1,
    "username": "johndoe",
    "email": "john@example.com",
    "full_name": "John Doe",
    "phone": "0123456789",
    "avatar_url": null,
    "status": "active",
    "email_verified": false,
    "role_id": 7,
    "role_name": "Customer",
    "permissions": [
      {
        "permission_id": 3,
        "permission_name": "tour.view",
        "permission_description": "Xem tour",
        "module": "tour"
      },
      {
        "permission_id": 8,
        "permission_name": "booking.view_own",
        "permission_description": "Xem booking của mình",
        "module": "booking"
      }
    ]
  }
}
```

---

### 4. Tạo người dùng mới

**Endpoint:** `POST /api/users`

**Description:** Tạo người dùng mới (chỉ admin)

**Headers:**
```
Authorization: Bearer <token>
```

**Required Permission:** `user.manage_roles`

**Request Body:**
```json
{
  "username": "janedoe",
  "email": "jane@example.com",
  "password": "password123",
  "full_name": "Jane Doe",
  "phone": "0987654321",
  "role_id": 3
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "User created successfully",
  "data": {
    "user_id": 2,
    "username": "janedoe",
    "email": "jane@example.com",
    "full_name": "Jane Doe",
    "phone": "0987654321",
    "role_id": 3,
    "status": "active",
    "email_verified": false
  }
}
```

---

### 5. Cập nhật người dùng

**Endpoint:** `PUT /api/users/:id`

**Description:** Cập nhật thông tin người dùng

**Headers:**
```
Authorization: Bearer <token>
```

**Required Permission:** `user.manage_roles`

**Request Body:**
```json
{
  "full_name": "Jane Doe Updated",
  "phone": "0111222333",
  "status": "active",
  "role_id": 4
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "User updated successfully",
  "data": {
    "user_id": 2,
    "username": "janedoe",
    "email": "jane@example.com",
    "full_name": "Jane Doe Updated",
    "phone": "0111222333",
    "status": "active",
    "role_id": 4
  }
}
```

---

### 6. Xóa người dùng

**Endpoint:** `DELETE /api/users/:id`

**Description:** Xóa người dùng

**Headers:**
```
Authorization: Bearer <token>
```

**Required Permission:** `user.manage_roles`

**Response (200 OK):**
```json
{
  "success": true,
  "message": "User deleted successfully"
}
```

---

### 7. Gán vai trò cho người dùng

**Endpoint:** `POST /api/users/:id/assign-role`

**Description:** Gán vai trò mới cho người dùng

**Headers:**
```
Authorization: Bearer <token>
```

**Required Permission:** `user.manage_roles`

**Request Body:**
```json
{
  "role_id": 3
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Role assigned successfully",
  "data": {
    "user_id": 2,
    "username": "janedoe",
    "email": "jane@example.com",
    "role_id": 3
  }
}
```

---

### 8. Lấy quyền của người dùng

**Endpoint:** `GET /api/users/:id/permissions`

**Description:** Lấy tất cả quyền của người dùng thông qua vai trò

**Headers:**
```
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": [
    {
      "permission_id": 3,
      "permission_name": "tour.view",
      "permission_description": "Xem tour",
      "module": "tour"
    },
    {
      "permission_id": 4,
      "permission_name": "tour.create",
      "permission_description": "Tạo tour mới",
      "module": "tour"
    }
  ],
  "count": 2
}
```

---

## Error Codes

### HTTP Status Codes

| Code | Meaning | Description |
|------|---------|-------------|
| 200 | OK | Request thành công |
| 201 | Created | Tạo resource thành công |
| 400 | Bad Request | Dữ liệu không hợp lệ |
| 401 | Unauthorized | Chưa đăng nhập hoặc token không hợp lệ |
| 403 | Forbidden | Không có quyền truy cập |
| 404 | Not Found | Không tìm thấy resource |
| 409 | Conflict | Dữ liệu bị trùng lặp |
| 500 | Internal Server Error | Lỗi server |

### Error Response Format

```json
{
  "success": false,
  "message": "Error message here",
  "errors": [
    {
      "field": "email",
      "message": "Email is required",
      "value": ""
    }
  ]
}
```

---

## Testing Examples

### Sử dụng cURL

#### 1. Đăng ký người dùng

```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "password123",
    "full_name": "Test User",
    "phone": "0123456789"
  }'
```

#### 2. Đăng nhập

```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

#### 3. Lấy danh sách vai trò (cần token)

```bash
curl -X GET http://localhost:5000/api/roles \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

#### 4. Tạo vai trò mới

```bash
curl -X POST http://localhost:5000/api/roles \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "role_name": "Test Role",
    "role_description": "Test role description"
  }'
```

#### 5. Gán quyền cho vai trò

```bash
curl -X POST http://localhost:5000/api/roles/1/permissions \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "permission_ids": [1, 2, 3, 4, 5]
  }'
```

#### 6. Lấy quyền theo module

```bash
curl -X GET http://localhost:5000/api/permissions/module/tour \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

#### 7. Tạo người dùng mới

```bash
curl -X POST http://localhost:5000/api/users \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "newuser",
    "email": "newuser@example.com",
    "password": "password123",
    "full_name": "New User",
    "phone": "0987654321",
    "role_id": 7
  }'
```

#### 8. Gán vai trò cho người dùng

```bash
curl -X POST http://localhost:5000/api/users/2/assign-role \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "role_id": 3
  }'
```

---

### Sử dụng Postman

#### Thiết lập Environment

1. Tạo environment mới trong Postman
2. Thêm biến:
   - `base_url`: `http://localhost:5000/api`
   - `token`: (để trống, sẽ tự động cập nhật sau khi login)

#### Collection Setup

1. **Login Request:**
   - Method: POST
   - URL: `{{base_url}}/auth/login`
   - Body (JSON):
     ```json
     {
       "email": "test@example.com",
       "password": "password123"
     }
     ```
   - Tests (để tự động lưu token):
     ```javascript
     var jsonData = pm.response.json();
     if (jsonData.success && jsonData.data.token) {
       pm.environment.set("token", jsonData.data.token);
     }
     ```

2. **Các request khác:**
   - Thêm header:
     - Key: `Authorization`
     - Value: `Bearer {{token}}`

---

### Test Flow Hoàn Chỉnh

#### Scenario 1: Quản lý vai trò và quyền

1. **Đăng nhập với tài khoản Super Admin**
   ```
   POST /api/auth/login
   {
     "email": "admin@example.com",
     "password": "admin123"
   }
   ```

2. **Lấy danh sách tất cả quyền**
   ```
   GET /api/permissions
   ```

3. **Lấy quyền theo module "tour"**
   ```
   GET /api/permissions/module/tour
   ```

4. **Tạo vai trò mới "Tour Operator"**
   ```
   POST /api/roles
   {
     "role_name": "Tour Operator",
     "role_description": "Nhà điều hành tour"
   }
   ```

5. **Gán quyền cho vai trò vừa tạo**
   ```
   POST /api/roles/8/permissions
   {
     "permission_ids": [3, 4, 5, 6, 7, 8, 9]
   }
   ```

6. **Kiểm tra quyền đã gán**
   ```
   GET /api/roles/8/permissions
   ```

#### Scenario 2: Quản lý người dùng

1. **Tạo người dùng mới với vai trò Tour Manager**
   ```
   POST /api/users
   {
     "username": "tourmanager1",
     "email": "tourmanager@example.com",
     "password": "password123",
     "full_name": "Tour Manager One",
     "phone": "0123456789",
     "role_id": 3
   }
   ```

2. **Lấy thông tin người dùng và quyền**
   ```
   GET /api/users/2
   ```

3. **Lấy danh sách quyền của người dùng**
   ```
   GET /api/users/2/permissions
   ```

4. **Thay đổi vai trò người dùng**
   ```
   POST /api/users/2/assign-role
   {
     "role_id": 8
   }
   ```

5. **Cập nhật thông tin người dùng**
   ```
   PUT /api/users/2
   {
     "full_name": "Tour Manager Updated",
     "status": "active"
   }
   ```

#### Scenario 3: Test phân quyền

1. **Đăng nhập với tài khoản Customer**
   ```
   POST /api/auth/login
   {
     "email": "customer@example.com",
     "password": "password123"
   }
   ```

2. **Thử truy cập endpoint yêu cầu quyền admin (sẽ bị từ chối)**
   ```
   GET /api/roles
   ```
   Expected: 403 Forbidden

3. **Lấy profile của chính mình (được phép)**
   ```
   GET /api/auth/profile
   ```
   Expected: 200 OK

---

## Danh sách Vai trò Mặc định

| ID | Role Name | Description |
|----|-----------|-------------|
| 1 | Super Admin | Quản trị viên cấp cao nhất |
| 2 | Admin | Quản trị viên |
| 3 | Tour Manager | Quản lý tour |
| 4 | Content Manager | Quản lý nội dung |
| 5 | Customer Service | Nhân viên chăm sóc khách hàng |
| 6 | Tour Guide | Hướng dẫn viên |
| 7 | Customer | Khách hàng |

---

## Danh sách Quyền Mặc định

### User Module
- `user.manage_roles` - Quản lý vai trò người dùng

### System Module
- `system.edit_settings` - Chỉnh sửa cài đặt hệ thống

### Tour Module
- `tour.view` - Xem tour
- `tour.create` - Tạo tour mới
- `tour.edit` - Chỉnh sửa tour
- `tour.delete` - Xóa tour

### Booking Module
- `booking.view_all` - Xem tất cả booking
- `booking.view_own` - Xem booking của mình
- `booking.create` - Tạo booking
- `booking.cancel` - Hủy booking
- `booking.confirm` - Xác nhận booking

### Payment Module
- `payment.process` - Xử lý thanh toán

### Review Module
- `review.view` - Xem đánh giá
- `review.approve` - Duyệt đánh giá

### Content Module
- `content.manage` - Quản lý nội dung

### Promotion Module
- `promotion.view` - Xem khuyến mãi
- `promotion.create` - Tạo khuyến mãi

### Report Module
- `report.view_bookings` - Xem báo cáo booking
- `report.export` - Xuất báo cáo

### Customer Module
- `customer.view` - Xem thông tin khách hàng

---

## Notes

1. **Token Expiration:** JWT token có thời hạn 7 ngày. Sau đó cần đăng nhập lại.

2. **Password Security:** Mật khẩu được hash bằng bcrypt với salt rounds = 10.

3. **Permission Naming Convention:** Quyền được đặt tên theo format `module.action` (ví dụ: `tour.create`, `booking.view_all`).

4. **Role Assignment:** Khi gán quyền cho vai trò bằng endpoint `/roles/:id/permissions`, tất cả quyền cũ sẽ bị thay thế bằng danh sách quyền mới.

5. **Cascading Delete:** Khi xóa vai trò, tất cả quyền được gán cho vai trò đó cũng sẽ bị xóa (do CASCADE trong database).

6. **User Status:** Người dùng có 3 trạng thái: `active`, `inactive`, `suspended`. Chỉ người dùng `active` mới có thể đăng nhập.

---

## Support

Nếu có vấn đề hoặc câu hỏi, vui lòng liên hệ team phát triển.
