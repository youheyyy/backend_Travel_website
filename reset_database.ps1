# =====================================================
# SCRIPT POWERSHELL ĐỂ RESET VÀ TẠO DỮ LIỆU MẪU
# =====================================================

param(
    [Parameter(Mandatory=$false)]
    [string]$DatabaseName = "travel_website",
    
    [Parameter(Mandatory=$false)]
    [string]$Username = "postgres",
    
    [Parameter(Mandatory=$false)]
    [string]$Host = "localhost",
    
    [Parameter(Mandatory=$false)]
    [int]$Port = 5432
)

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  RESET VÀ TẠO DỮ LIỆU MẪU - WEBSITE DU LỊCH" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Kiểm tra file SQL tồn tại
$sqlFile = Join-Path $PSScriptRoot "reset_and_seed_data.sql"
if (-not (Test-Path $sqlFile)) {
    Write-Host "❌ Không tìm thấy file: $sqlFile" -ForegroundColor Red
    exit 1
}

Write-Host "📁 File SQL: $sqlFile" -ForegroundColor Green
Write-Host "🗄️  Database: $DatabaseName" -ForegroundColor Yellow
Write-Host "👤 User: $Username" -ForegroundColor Yellow
Write-Host "🖥️  Host: $Host" -ForegroundColor Yellow
Write-Host "🔌 Port: $Port" -ForegroundColor Yellow
Write-Host ""

# Cảnh báo
Write-Host "⚠️  CẢNH BÁO: Script này sẽ XÓA TẤT CẢ dữ liệu trong database!" -ForegroundColor Red
Write-Host "⚠️  Chỉ sử dụng cho môi trường development/testing!" -ForegroundColor Red
Write-Host ""

# Xác nhận
$confirmation = Read-Host "Bạn có chắc chắn muốn tiếp tục? (yes/no)"
if ($confirmation -ne "yes") {
    Write-Host "❌ Đã hủy thao tác." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "🚀 Đang chạy script SQL..." -ForegroundColor Cyan

# Thiết lập biến môi trường để tránh nhập password nhiều lần
$env:PGPASSWORD = Read-Host "Nhập password cho user $Username" -AsSecureString | ConvertFrom-SecureString

try {
    # Chạy script SQL
    $result = psql -h $Host -p $Port -U $Username -d $DatabaseName -f $sqlFile 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✅ Hoàn thành! Dữ liệu đã được reset và tạo mới thành công." -ForegroundColor Green
        Write-Host ""
        Write-Host "📊 Thống kê dữ liệu:" -ForegroundColor Cyan
        Write-Host $result | Select-String -Pattern "table_name|record_count"
        Write-Host ""
        Write-Host "👥 Tài khoản mặc định:" -ForegroundColor Cyan
        Write-Host "   - Super Admin: superadmin@travelweb.vn / password123" -ForegroundColor White
        Write-Host "   - Admin: admin@travelweb.vn / password123" -ForegroundColor White
        Write-Host "   - Customer: customer1@gmail.com / password123" -ForegroundColor White
        Write-Host ""
        Write-Host "📖 Xem file RESET_DATABASE_GUIDE.md để biết thêm chi tiết." -ForegroundColor Yellow
    } else {
        Write-Host ""
        Write-Host "❌ Có lỗi xảy ra khi chạy script!" -ForegroundColor Red
        Write-Host $result -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host ""
    Write-Host "❌ Lỗi: $_" -ForegroundColor Red
    exit 1
} finally {
    # Xóa password khỏi biến môi trường
    Remove-Item Env:\PGPASSWORD -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  HOÀN TẤT" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
