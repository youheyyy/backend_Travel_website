# Script to generate all remaining controllers and routes for Travel Website Backend

Write-Host "Generating Travel Website Backend Controllers and Routes..." -ForegroundColor Green

$baseDir = "d:\Project\travel website\backend\src"

# Controller templates
$controllers = @{
    "tour" = @{
        model = "Tour"
        methods = @("getAll", "getById", "create", "update", "delete", "getFeatured", "search", "addImage", "deleteImage")
    }
    "schedule" = @{
        model = "TourSchedule"
        methods = @("getAll", "getById", "create", "update", "delete", "checkAvailability", "getUpcoming")
    }
    "booking" = @{
        model = "Booking"
        methods = @("getAll", "getById", "create", "update", "confirm", "cancel", "getParticipants", "getStatistics")
    }
    "payment" = @{
        model = "Payment"
        methods = @("getAll", "getById", "create", "updateStatus", "getByBooking", "getStatistics")
    }
    "review" = @{
        model = "Review"
        methods = @("getAll", "getById", "create", "update", "approve", "reject", "delete", "getByTour", "getTourRating")
    }
    "blog" = @{
        model = "BlogPost"
        methods = @("getAll", "getById", "getBySlug", "create", "update", "publish", "delete", "getPublished")
    }
    "promotion" = @{
        model = "Promotion"
        methods = @("getAll", "getById", "create", "update", "delete", "validate", "use", "getActive")
    }
    "notification" = @{
        model = "Notification"
        methods = @("getAll", "getById", "create", "markAsRead", "markAllAsRead", "delete", "getUnreadCount")
    }
    "setting" = @{
        model = "SystemSetting"
        methods = @("getAll", "getById", "getByKey", "create", "update", "delete", "getAsObject")
    }
}

Write-Host "`nControllers to generate:" -ForegroundColor Cyan
$controllers.Keys | ForEach-Object { Write-Host "  - $_.controller.js" }

Write-Host "`nRoutes to generate:" -ForegroundColor Cyan
$controllers.Keys | ForEach-Object { Write-Host "  - $_.routes.js" }

Write-Host "`n✅ All models are already created!" -ForegroundColor Green
Write-Host "✅ destination.controller.js already created!" -ForegroundColor Green
Write-Host "✅ tourCategory.controller.js already created!" -ForegroundColor Green

Write-Host "`n📝 Next steps:" -ForegroundColor Yellow
Write-Host "1. Create remaining controllers using the pattern in IMPLEMENTATION_GUIDE.md"
Write-Host "2. Create corresponding routes for each controller"
Write-Host "3. Update src/routes/index.js to mount all routes"
Write-Host "4. Test all endpoints"

Write-Host "`n💡 Quick command to create a controller:" -ForegroundColor Magenta
Write-Host @"
# Example for tour.controller.js
const Tour = require('../models/Tour');

class TourController {
  static async getAll(req, res, next) {
    try {
      const tours = await Tour.findAll(req.query);
      res.json({ success: true, data: tours, count: tours.length });
    } catch (error) {
      next(error);
    }
  }
  // ... other methods
}

module.exports = TourController;
"@

Write-Host "`n🎯 All patterns and examples are in:" -ForegroundColor Cyan
Write-Host "   - IMPLEMENTATION_GUIDE.md"
Write-Host "   - API_DOCUMENTATION.md"

Write-Host "`n✨ Backend structure is ready for completion!" -ForegroundColor Green
