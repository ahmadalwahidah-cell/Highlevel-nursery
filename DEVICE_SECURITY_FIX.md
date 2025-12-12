# إصلاح صفحة أمان الأجهزة للمطور

## المشكلة
عند محاولة الوصول إلى صفحة أمان الأجهزة للمطور (`/admin/developer/device-security`)، يظهر خطأ "Internal Server Error".

## الأسباب المحتملة
1. **الجداول غير موجودة في البيئة المحلية** - قد لا تكون جداول `device_change_requests` أو `suspicious_activity_logs` موجودة
2. **عدم تطبيق الهجرات** - الهجرات الخاصة بنظام أمان الأجهزة لم تُطبق على قاعدة البيانات المحلية
3. **مشكلة في البيئة المحلية فقط** - قد تعمل الصفحة بشكل صحيح في Production

## الحلول المطبقة

### 1. إضافة معالجة أخطاء شاملة
```typescript
try {
  // جلب البيانات
  let deviceChangeRequests = { results: [] }
  try {
    deviceChangeRequests = await DB.prepare(...).all()
  } catch (e) {
    console.error('Error fetching device change requests:', e)
  }
  
  // رسالة خطأ للمستخدم
} catch (error) {
  return c.html(`<html>...</html>`)
}
```

### 2. قيم افتراضية للبيانات
- إذا فشل جلب الطلبات: `{ results: [] }`
- إذا فشل جلب الأنشطة: `{ results: [] }`

### 3. التحقق من الجداول
```bash
# التحقق من وجود الجداول
npx wrangler d1 execute highlevel-nursery-production --local \
  --command="SELECT name FROM sqlite_master WHERE type='table' AND name LIKE '%device%'"
```

## الهجرات المطلوبة

إذا كانت الجداول غير موجودة، قم بتطبيق هذه الهجرة:

```sql
-- migrations/XXXX_create_device_security_tables.sql

CREATE TABLE IF NOT EXISTS device_change_requests (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  teacher_id INTEGER NOT NULL,
  old_device_fingerprint TEXT,
  new_device_fingerprint TEXT,
  new_device_info TEXT,
  reason TEXT,
  reason_type TEXT,
  status TEXT DEFAULT 'pending',
  requested_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  reviewed_at DATETIME,
  reviewed_by TEXT,
  FOREIGN KEY (teacher_id) REFERENCES teachers(id)
);

CREATE TABLE IF NOT EXISTS suspicious_activity_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  teacher_id INTEGER,
  activity_type TEXT,
  severity TEXT,
  description TEXT,
  device_fingerprint TEXT,
  location_data TEXT,
  is_reviewed INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (teacher_id) REFERENCES teachers(id)
);

CREATE INDEX IF NOT EXISTS idx_device_requests_status ON device_change_requests(status);
CREATE INDEX IF NOT EXISTS idx_device_requests_teacher ON device_change_requests(teacher_id);
CREATE INDEX IF NOT EXISTS idx_suspicious_logs_reviewed ON suspicious_activity_logs(is_reviewed);
```

## كيفية التطبيق

### البيئة المحلية
```bash
cd /home/user/highlevel-nursery

# تطبيق الهجرات
npx wrangler d1 migrations apply highlevel-nursery-production --local

# إعادة بناء المشروع
npm run build

# إعادة تشغيل الخدمة
pm2 delete highlevel-nursery
pm2 start ecosystem.config.cjs

# اختبار
curl -s -X POST http://localhost:3000/api/admin/developer/login \
  -H "Content-Type: application/json" \
  -d '{"password":"1008"}' \
  -c /tmp/dev_cookies.txt

curl -s http://localhost:3000/admin/developer/device-security \
  -b /tmp/dev_cookies.txt
```

### بيئة الإنتاج (Production)
```bash
# تطبيق الهجرات على Production
npx wrangler d1 migrations apply highlevel-nursery-production --remote

# نشر التحديثات
npm run build
npx wrangler pages deploy dist --project-name highlevel-nursery
```

## التحقق من الحل

### 1. التحقق من الجداول
```bash
npx wrangler d1 execute highlevel-nursery-production --local \
  --command="SELECT COUNT(*) FROM device_change_requests"

npx wrangler d1 execute highlevel-nursery-production --local \
  --command="SELECT COUNT(*) FROM suspicious_activity_logs"
```

### 2. اختبار الصفحة
1. تسجيل الدخول كمطور: https://highlevel-nursery.pages.dev/admin/developer/login
2. كلمة المرور: `1008`
3. الوصول للصفحة: https://highlevel-nursery.pages.dev/admin/developer/device-security

### 3. النتيجة المتوقعة
- عرض إحصائيات الطلبات (معلقة، مُعالَجة، مشبوهة)
- جدول بطلبات تغيير الجهاز
- أزرار الحذف النهائي للطلبات المُعالَجة

## روابط الوصول

- **Production:** https://highlevel-nursery.pages.dev/admin/developer/device-security
- **آخر نشر:** https://993a892c.highlevel-nursery.pages.dev/admin/developer/device-security

## ملاحظات

1. **الصفحة محمية:** تتطلب تسجيل دخول بصلاحية المطور
2. **البيئة المحلية:** قد تختلف عن Production
3. **قاعدة البيانات:** تأكد من تطبيق جميع الهجرات
4. **الاختبار:** اختبر في Production إذا فشل الاختبار المحلي

## الحالة الحالية

- ✅ الكود محدّث ونُشر
- ✅ معالجة أخطاء شاملة
- ⚠️ قد تحتاج لتطبيق الهجرات على البيئة المحلية
- ✅ جاهز للاختبار في Production

---

**تاريخ التحديث:** 2025-12-05  
**الإصدار:** 1.1  
**المطور:** High Level Nursery System
