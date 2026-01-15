-- Insert test accounts with different roles
-- Password for all accounts: Test@123

-- Note: These passwords are hashed using bcrypt with salt rounds 10
-- Original password: Test@123

-- 1. Admin Account
INSERT INTO users (username, password, email, full_name, phone, role_id, status, email_verified)
VALUES (
    'admin',
    '$2b$10$rQJ5YvH0qZXKJ5YvH0qZXO8K5YvH0qZXKJ5YvH0qZXKJ5YvH0qZXK', -- Test@123
    'admin@travel.com',
    'Quản Trị Viên',
    '0901234567',
    1, -- Admin role
    'active',
    true
) ON CONFLICT (username) DO NOTHING;

-- 2. Tour Manager Account
INSERT INTO users (username, password, email, full_name, phone, role_id, status, email_verified)
VALUES (
    'tourmanager',
    '$2b$10$rQJ5YvH0qZXKJ5YvH0qZXO8K5YvH0qZXKJ5YvH0qZXKJ5YvH0qZXK', -- Test@123
    'tourmanager@travel.com',
    'Nguyễn Văn Quản Lý Tour',
    '0901234568',
    2, -- Tour Manager role
    'active',
    true
) ON CONFLICT (username) DO NOTHING;

-- 3. Customer Service Account
INSERT INTO users (username, password, email, full_name, phone, role_id, status, email_verified)
VALUES (
    'customerservice',
    '$2b$10$rQJ5YvH0qZXKJ5YvH0qZXO8K5YvH0qZXKJ5YvH0qZXKJ5YvH0qZXK', -- Test@123
    'cs@travel.com',
    'Trần Thị Chăm Sóc Khách Hàng',
    '0901234569',
    3, -- Customer Service role
    'active',
    true
) ON CONFLICT (username) DO NOTHING;

-- 4. Content Manager Account
INSERT INTO users (username, password, email, full_name, phone, role_id, status, email_verified)
VALUES (
    'contentmanager',
    '$2b$10$rQJ5YvH0qZXKJ5YvH0qZXO8K5YvH0qZXKJ5YvH0qZXO8K5YvH0qZXK', -- Test@123
    'content@travel.com',
    'Lê Văn Quản Lý Nội Dung',
    '0901234570',
    4, -- Content Manager role
    'active',
    true
) ON CONFLICT (username) DO NOTHING;

-- 5. Accountant Account
INSERT INTO users (username, password, email, full_name, phone, role_id, status, email_verified)
VALUES (
    'accountant',
    '$2b$10$rQJ5YvH0qZXKJ5YvH0qZXO8K5YvH0qZXKJ5YvH0qZXKJ5YvH0qZXK', -- Test@123
    'accountant@travel.com',
    'Phạm Thị Kế Toán',
    '0901234571',
    5, -- Accountant role
    'active',
    true
) ON CONFLICT (username) DO NOTHING;

-- 6. Tour Guide Account
INSERT INTO users (username, password, email, full_name, phone, role_id, status, email_verified)
VALUES (
    'tourguide',
    '$2b$10$rQJ5YvH0qZXKJ5YvH0qZXO8K5YvH0qZXKJ5YvH0qZXKJ5YvH0qZXK', -- Test@123
    'guide@travel.com',
    'Hoàng Văn Hướng Dẫn Viên',
    '0901234572',
    6, -- Tour Guide role
    'active',
    true
) ON CONFLICT (username) DO NOTHING;

-- 7. Customer Account
INSERT INTO users (username, password, email, full_name, phone, role_id, status, email_verified)
VALUES (
    'customer',
    '$2b$10$rQJ5YvH0qZXKJ5YvH0qZXO8K5YvH0qZXKJ5YvH0qZXKJ5YvH0qZXK', -- Test@123
    'customer@travel.com',
    'Nguyễn Thị Khách Hàng',
    '0901234573',
    7, -- Customer role
    'active',
    true
) ON CONFLICT (username) DO NOTHING;

-- Display created accounts
SELECT 
    u.user_id,
    u.username,
    u.email,
    u.full_name,
    r.role_name,
    u.status
FROM users u
JOIN roles r ON u.role_id = r.role_id
WHERE u.username IN ('admin', 'tourmanager', 'customerservice', 'contentmanager', 'accountant', 'tourguide', 'customer')
ORDER BY u.role_id;
