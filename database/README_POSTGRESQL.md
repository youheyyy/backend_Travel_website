# Hướng dẫn Import Database PostgreSQL

## Vấn đề Encoding

Database PostgreSQL của bạn hiện đang dùng encoding **WIN1252** thay vì **UTF-8**, nên không thể import dữ liệu tiếng Việt có dấu.

## Giải pháp

### Cách 1: Tạo lại database với encoding UTF-8 (KHUYẾN NGHỊ)

```powershell
# 1. Kết nối vào PostgreSQL
psql -U postgres

# 2. Xóa database cũ (nếu có)
DROP DATABASE IF EXISTS travel_website;

# 3. Tạo database mới với encoding UTF-8
CREATE DATABASE travel_website
    WITH 
    ENCODING = 'UTF8'
    LC_COLLATE = 'Vietnamese_Vietnam.1258'
    LC_CTYPE = 'Vietnamese_Vietnam.1258'
    TEMPLATE = template0;

# 4. Thoát psql
\q

# 5. Import schema
psql -U postgres -d travel_website -f "d:\Project\travel website\database\travel_postgresql.sql"

# 6. Import dữ liệu
psql -U postgres -d travel_website -f "d:\Project\travel website\database\travel_data_full.sql"
```

### Cách 2: Nếu không thể tạo lại database

Sử dụng file dữ liệu không dấu đã tạo trước đó:

```powershell
psql -U postgres -d travel_website -f "d:\Project\travel website\database\travel_data.sql"
```

## Kiểm tra encoding hiện tại

```sql
SELECT 
    datname, 
    pg_encoding_to_char(encoding) as encoding,
    datcollate,
    datctype
FROM pg_database 
WHERE datname = 'travel_website';
```

## Cấu trúc Files

1. **travel_postgresql.sql** - Schema database (bảng, constraints, triggers)
2. **travel_data_full.sql** - Dữ liệu đầy đủ với tiếng Việt có dấu (cần UTF-8)
3. **travel_data.sql** - Dữ liệu không dấu (dùng khi database là WIN1252)

## Lưu ý

- Nên dùng encoding UTF-8 cho database để hỗ trợ đầy đủ tiếng Việt
- File SQL phải được lưu với encoding UTF-8 (không BOM)
- Khi import, đảm bảo terminal/console cũng dùng UTF-8
