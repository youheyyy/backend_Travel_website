-- ============================================================================
-- INSERT TEST ACCOUNTS FOR TRAVEL WEBSITE
-- ============================================================================
-- All accounts use the same password: Test@123
-- Password hash: $2a$10$mzzfBATfJiiCOR2onw6cVOC15S.nhwqppxmbCm/5TjNBINMe8aDEW
-- ============================================================================

-- 1. Admin Account
INSERT INTO users (username, password_hash, email, full_name, phone, role_id, status, email_verified)
VALUES ('admin', '$2a$10$mzzfBATfJiiCOR2onw6cVOC15S.nhwqppxmbCm/5TjNBINMe8aDEW', 'admin@travel.com', 'Quan Tri Vien', '0901234567', 1, 'active', true)
ON CONFLICT (username) DO UPDATE SET password_hash = EXCLUDED.password_hash, email = EXCLUDED.email;

-- 2. Tour Manager Account
INSERT INTO users (username, password_hash, email, full_name, phone, role_id, status, email_verified)
VALUES ('tourmanager', '$2a$10$mzzfBATfJiiCOR2onw6cVOC15S.nhwqppxmbCm/5TjNBINMe8aDEW', 'tourmanager@travel.com', 'Nguyen Van Quan Ly Tour', '0901234568', 2, 'active', true)
ON CONFLICT (username) DO UPDATE SET password_hash = EXCLUDED.password_hash, email = EXCLUDED.email;

-- 3. Customer Service Account
INSERT INTO users (username, password_hash, email, full_name, phone, role_id, status, email_verified)
VALUES ('customerservice', '$2a$10$mzzfBATfJiiCOR2onw6cVOC15S.nhwqppxmbCm/5TjNBINMe8aDEW', 'cs@travel.com', 'Tran Thi Cham Soc Khach Hang', '0901234569', 3, 'active', true)
ON CONFLICT (username) DO UPDATE SET password_hash = EXCLUDED.password_hash, email = EXCLUDED.email;

-- 4. Content Manager Account
INSERT INTO users (username, password_hash, email, full_name, phone, role_id, status, email_verified)
VALUES ('contentmanager', '$2a$10$mzzfBATfJiiCOR2onw6cVOC15S.nhwqppxmbCm/5TjNBINMe8aDEW', 'content@travel.com', 'Le Van Quan Ly Noi Dung', '0901234570', 4, 'active', true)
ON CONFLICT (username) DO UPDATE SET password_hash = EXCLUDED.password_hash, email = EXCLUDED.email;

-- 5. Accountant Account
INSERT INTO users (username, password_hash, email, full_name, phone, role_id, status, email_verified)
VALUES ('accountant', '$2a$10$mzzfBATfJiiCOR2onw6cVOC15S.nhwqppxmbCm/5TjNBINMe8aDEW', 'accountant@travel.com', 'Pham Thi Ke Toan', '0901234571', 5, 'active', true)
ON CONFLICT (username) DO UPDATE SET password_hash = EXCLUDED.password_hash, email = EXCLUDED.email;

-- 6. Tour Guide Account
INSERT INTO users (username, password_hash, email, full_name, phone, role_id, status, email_verified)
VALUES ('tourguide', '$2a$10$mzzfBATfJiiCOR2onw6cVOC15S.nhwqppxmbCm/5TjNBINMe8aDEW', 'guide@travel.com', 'Hoang Van Huong Dan Vien', '0901234572', 6, 'active', true)
ON CONFLICT (username) DO UPDATE SET password_hash = EXCLUDED.password_hash, email = EXCLUDED.email;

-- 7. Customer Account
INSERT INTO users (username, password_hash, email, full_name, phone, role_id, status, email_verified)
VALUES ('customer', '$2a$10$mzzfBATfJiiCOR2onw6cVOC15S.nhwqppxmbCm/5TjNBINMe8aDEW', 'customer@travel.com', 'Nguyen Thi Khach Hang', '0901234573', 7, 'active', true)
ON CONFLICT (username) DO UPDATE SET password_hash = EXCLUDED.password_hash, email = EXCLUDED.email;

-- Display created accounts
SELECT 
    u.user_id,
    u.username,
    u.email,
    u.full_name,
    r.role_name,
    u.status,
    u.email_verified
FROM users u
JOIN roles r ON u.role_id = r.role_id
WHERE u.username IN ('admin', 'tourmanager', 'customerservice', 'contentmanager', 'accountant', 'tourguide', 'customer')
ORDER BY u.role_id;
