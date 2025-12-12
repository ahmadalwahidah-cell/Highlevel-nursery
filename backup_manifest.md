# نسخة احتياطية شاملة - نظام الحضانة المتقدم
## تاريخ النسخ: 2025-12-11

### محتويات النسخة الاحتياطية:

#### 1. **الكود المصدري الكامل** (Full Source Code)
- جميع ملفات TypeScript/JavaScript
- جميع ملفات التكوين (wrangler.jsonc, package.json, tsconfig.json)
- جميع المكتبات والاعتماديات (node_modules)
- سجل Git الكامل (.git)
- جميع ملفات الهجرة (migrations/)
- جميع الملفات الثابتة (public/)

#### 2. **قاعدة البيانات الكاملة** (Complete Database)
- تصدير كامل لقاعدة البيانات المحلية
- جميع الجداول والبيانات
- جميع الفهارس والعلاقات
- اسم الملف: database_backup_20251211_115014.sql

#### 3. **التكوينات والإعدادات** (Configurations)
- تكوينات Cloudflare (wrangler.jsonc)
- تكوينات PM2 (ecosystem.config.cjs)
- متغيرات البيئة (.dev.vars)
- إعدادات TypeScript (tsconfig.json)
- إعدادات Vite (vite.config.ts)

#### 4. **التقارير والتوثيق** (Reports & Documentation)
- README.md الرئيسي
- BACKUP_README.md (دليل الاستعادة)
- جميع التقارير المؤقتة
- سجلات التغييرات (Git commits)

#### 5. **ملفات البناء** (Build Artifacts)
- dist/ (الملفات المبنية)
- .wrangler/ (ملفات Wrangler المحلية)

### معلومات النظام:

#### حجم المشروع:
- الحجم الإجمالي: ~319 MB
- حجم قاعدة البيانات: ~19 KB
- عدد الملفات: ~15,000+ ملف

#### الجداول في قاعدة البيانات:
1. teachers (المعلمات)
2. teacher_attendance_logs (سجلات الحضور)
3. students (الطلاب)
4. parents (أولياء الأمور)
5. classes (الفصول)
6. system_settings (إعدادات النظام)
7. device_fingerprints (بصمات الأجهزة)
8. suspicious_activity_logs (سجلات النشاط المشبوه)
9. nursery_settings (إعدادات الحضانة)
10. custom_teacher_schedules (جداول المعلمات المخصصة)
11. admin_users (مستخدمي الإدارة)
12. وغيرها...

#### معلومات الدخول:
- **مجلس الإدارة**: https://highlevel-nursery.pages.dev/admin/board/login (PIN: 5050)
- **المديرة**: https://highlevel-nursery.pages.dev/admin/nursery/login (كلمة المرور: 1020)
- **المطور**: https://highlevel-nursery.pages.dev/admin/developer/login (كلمة المرور: 1008)
- **المعلمات**: https://highlevel-nursery.pages.dev/teacher/login

#### آخر التحديثات:
- إصلاح التوقيت (Kuwait UTC+3)
- إضافة التقرير التفصيلي لحضور المعلمات في صفحة مجلس الإدارة
- إزالة شرط deleted_at من الاستعلامات
- تحسين واجهة التقارير

### طريقة الاستعادة:

```bash
# 1. فك الضغط
tar -xzf highlevel-nursery-backup-20251211.tar.gz
cd highlevel-nursery

# 2. تثبيت الاعتماديات
npm install

# 3. استعادة قاعدة البيانات
npx wrangler d1 execute highlevel-nursery-production --local --file=database_backup_20251211_115014.sql

# 4. بناء المشروع
npm run build

# 5. تشغيل محليًا
npm run dev:sandbox
# أو
pm2 start ecosystem.config.cjs

# 6. النشر على Cloudflare Pages
npm run deploy
```

### ملاحظات مهمة:
- جميع الأوقات معروضة بتوقيت الكويت (UTC+3)
- النظام يستخدم D1 Database من Cloudflare
- البصمة والموقع الجغرافي مفعّلان للحضور
- جميع البيانات محفوظة ومشفرة

