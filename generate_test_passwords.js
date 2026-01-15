const bcrypt = require('bcryptjs');

const password = 'Test@123';
const saltRounds = 10;

console.log('Generating password hash for:', password);
console.log('Salt rounds:', saltRounds);
console.log('');

bcrypt.hash(password, saltRounds, (err, hash) => {
    if (err) {
        console.error('Error generating hash:', err);
        return;
    }
    
    console.log('Generated hash:', hash);
    console.log('');
    console.log('SQL to insert test accounts:');
    console.log('');
    
    const accounts = [
        { username: 'admin', email: 'admin@travel.com', full_name: 'Quản Trị Viên', phone: '0901234567', role_id: 1 },
        { username: 'tourmanager', email: 'tourmanager@travel.com', full_name: 'Nguyễn Văn Quản Lý Tour', phone: '0901234568', role_id: 2 },
        { username: 'customerservice', email: 'cs@travel.com', full_name: 'Trần Thị Chăm Sóc Khách Hàng', phone: '0901234569', role_id: 3 },
        { username: 'contentmanager', email: 'content@travel.com', full_name: 'Lê Văn Quản Lý Nội Dung', phone: '0901234570', role_id: 4 },
        { username: 'accountant', email: 'accountant@travel.com', full_name: 'Phạm Thị Kế Toán', phone: '0901234571', role_id: 5 },
        { username: 'tourguide', email: 'guide@travel.com', full_name: 'Hoàng Văn Hướng Dẫn Viên', phone: '0901234572', role_id: 6 },
        { username: 'customer', email: 'customer@travel.com', full_name: 'Nguyễn Thị Khách Hàng', phone: '0901234573', role_id: 7 }
    ];
    
    accounts.forEach(account => {
        console.log(`-- ${account.full_name} (${account.username})`);
        console.log(`INSERT INTO users (username, password, email, full_name, phone, role_id, status, email_verified)`);
        console.log(`VALUES ('${account.username}', '${hash}', '${account.email}', '${account.full_name}', '${account.phone}', ${account.role_id}, 'active', true)`);
        console.log(`ON CONFLICT (username) DO UPDATE SET password = EXCLUDED.password, email = EXCLUDED.email;`);
        console.log('');
    });
    
    console.log('');
    console.log('='.repeat(80));
    console.log('TEST ACCOUNTS CREDENTIALS:');
    console.log('='.repeat(80));
    console.log('');
    accounts.forEach(account => {
        console.log(`${account.full_name}:`);
        console.log(`  Email: ${account.email}`);
        console.log(`  Password: ${password}`);
        console.log(`  Role ID: ${account.role_id}`);
        console.log('');
    });
});
