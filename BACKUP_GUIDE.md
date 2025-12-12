# 💾 دليل النسخ الاحتياطي والاستعادة
# Backup & Restore Guide

## 📋 **نظرة عامة**

نظام النسخ الاحتياطي التلقائي يضمن حماية بياناتك بشكل كامل:
- ✅ نسخ قاعدة البيانات (محلي + إنتاج)
- ✅ نسخ ملفات الكود
- ✅ حفظ معلومات Git
- ✅ الاحتفاظ بآخر 10 نسخ تلقائياً

---

## 🚀 **كيفية عمل نسخة احتياطية**

### **الطريقة 1: نسخة احتياطية كاملة (موصى بها)**

```bash
cd /home/user/highlevel-nursery

# مع Cloudflare API Token
export CLOUDFLARE_API_TOKEN="your-token-here"
npm run backup
```

### **الطريقة 2: نسخة محلية فقط**

```bash
cd /home/user/highlevel-nursery
npm run backup
# (سينسخ المحلي فقط إذا لم يكن Token موجوداً)
```

### **الطريقة 3: تشغيل مباشر**

```bash
cd /home/user/highlevel-nursery
bash scripts/backup-database.sh
```

---

## 📅 **جدول النسخ الاحتياطي الموصى به**

| التكرار | التوقيت | الأمر |
|---------|---------|-------|
| **يومي** | 3 صباحاً | `npm run backup` |
| **أسبوعي** | الجمعة 12 ظهراً | `npm run backup` |
| **شهري** | أول كل شهر | `npm run backup` + حفظ على USB |
| **قبل التحديثات** | قبل أي `npm run deploy` | `npm run backup` |

---

## 📂 **محتويات النسخة الاحتياطية**

كل نسخة احتياطية تحتوي على:

### **1. ملفات الكود** (`code_backup_YYYYMMDD_HHMMSS.tar.gz`)
- ✅ جميع ملفات `src/`
- ✅ ملفات `migrations/`
- ✅ ملفات `public/`
- ✅ ملفات التكوين (`package.json`, `wrangler.jsonc`, etc.)
- ❌ مستثنى: `node_modules/`, `.wrangler/`, `dist/`

### **2. قاعدة البيانات** (`db_backup_YYYYMMDD_HHMMSS.sql.*`)
- ✅ Schema الجداول
- ✅ البيانات بصيغة JSON لكل جدول:
  - `students.json` - بيانات الطلاب
  - `teachers.json` - بيانات المعلمات
  - `attendance.json` - سجلات الحضور
  - `device_bindings.json` - ربط الأجهزة
  - `suspicious_activity_logs.json` - الأنشطة المشبوهة
  - وجميع الجداول الأخرى...

### **3. قاعدة البيانات المحلية** (`local_YYYYMMDD_HHMMSS/`)
- ✅ نسخة كاملة من `.wrangler/state/v3/d1/`
- ✅ ملفات SQLite الأصلية

### **4. معلومات Git** (`git_info_YYYYMMDD_HHMMSS.txt`)
- ✅ Commit Hash الحالي
- ✅ آخر 10 commits
- ✅ معلومات المطور

---

## 🔄 **استعادة النسخة الاحتياطية**

### **سيناريو 1: استعادة ملفات الكود**

```bash
cd /home/user/highlevel-nursery

# عرض النسخ المتاحة
npm run restore:list

# استعادة آخر نسخة
tar -xzf backups/code_backup_YYYYMMDD_HHMMSS.tar.gz

# إعادة تثبيت dependencies
npm install --legacy-peer-deps

# إعادة البناء
npm run build
```

### **سيناريو 2: استعادة قاعدة البيانات المحلية**

```bash
cd /home/user/highlevel-nursery

# حذف قاعدة البيانات المحلية الحالية
rm -rf .wrangler/state/v3/d1

# نسخ النسخة الاحتياطية
cp -r backups/local_YYYYMMDD_HHMMSS .wrangler/state/v3/d1

# إعادة تشغيل السيرفر
pm2 restart highlevel-nursery
```

### **سيناريو 3: استعادة قاعدة بيانات الإنتاج**

⚠️ **تحذير: هذا سيستبدل البيانات الحالية في الإنتاج!**

```bash
cd /home/user/highlevel-nursery

# 1. إنشاء جداول جديدة (إذا لزم الأمر)
npx wrangler d1 migrations apply highlevel-nursery-production --remote

# 2. استعادة البيانات من JSON
# مثال: استعادة جدول teachers
cat backups/db_backup_YYYYMMDD_HHMMSS.sql.teachers.json

# 3. استيراد البيانات يدوياً أو باستخدام script مخصص
```

---

## 📊 **عرض النسخ الاحتياطية**

### **قائمة جميع النسخ:**

```bash
npm run restore:list
```

أو:

```bash
ls -lht backups/
```

### **معلومات نسخة معينة:**

```bash
# عرض معلومات Git
cat backups/git_info_YYYYMMDD_HHMMSS.txt

# عرض محتويات الكود
tar -tzf backups/code_backup_YYYYMMDD_HHMMSS.tar.gz

# عرض بيانات جدول معين
cat backups/db_backup_YYYYMMDD_HHMMSS.sql.teachers.json | head -20
```

---

## 🗑️ **إدارة النسخ القديمة**

النظام **تلقائياً** يحتفظ بآخر **10 نسخ** فقط.

### **حذف يدوي للنسخ القديمة:**

```bash
cd /home/user/highlevel-nursery/backups

# حذف نسخ أقدم من 30 يوم
find . -name "code_backup_*.tar.gz" -mtime +30 -delete
```

### **حذف جميع النسخ (تحذير!):**

```bash
cd /home/user/highlevel-nursery
rm -rf backups/*
```

---

## 💾 **نسخ إلى مكان آمن خارجي**

### **نسخ إلى USB Drive:**

```bash
# تحديد USB drive
USB_PATH="/media/usb_drive"

# نسخ آخر نسخة
cp backups/code_backup_*.tar.gz "$USB_PATH/"
```

### **نسخ إلى Google Drive (باستخدام rclone):**

```bash
# تثبيت rclone
curl https://rclone.org/install.sh | sudo bash

# إعداد Google Drive
rclone config

# نسخ
rclone copy backups/ gdrive:highlevel-nursery-backups/
```

### **نسخ إلى Email:**

```bash
# استخدام mutt أو mail
echo "نسخة احتياطية تلقائية" | \
  mutt -s "Backup $(date +%Y-%m-%d)" \
  -a backups/code_backup_*.tar.gz -- \
  your-email@example.com
```

---

## 🔐 **تشفير النسخ الاحتياطية**

### **تشفير بكلمة سر:**

```bash
cd /home/user/highlevel-nursery/backups

# تشفير
gpg -c code_backup_YYYYMMDD_HHMMSS.tar.gz
# سيطلب كلمة سر

# فك التشفير
gpg code_backup_YYYYMMDD_HHMMSS.tar.gz.gpg
```

---

## ⚡ **نسخ احتياطي سريع (قبل التحديثات)**

```bash
cd /home/user/highlevel-nursery

# نسخة سريعة قبل Deploy
npm run backup && npm run deploy
```

---

## 🆘 **حالات الطوارئ**

### **الموقع معطل تماماً:**

1. استعادة آخر نسخة احتياطية:
```bash
cd /home/user/highlevel-nursery
tar -xzf backups/code_backup_*.tar.gz
npm install --legacy-peer-deps
npm run build
npm run deploy
```

2. إذا فشل، استعادة من Git:
```bash
git reset --hard HEAD
npm install --legacy-peer-deps
npm run build
npm run deploy
```

### **فقدان البيانات:**

1. استعادة قاعدة البيانات المحلية من النسخة الاحتياطية
2. إعادة تطبيق Migrations
3. استعادة بيانات الإنتاج من JSON files

---

## 📞 **الدعم**

إذا واجهت مشكلة في الاستعادة:
1. تحقق من ملف `git_info_*.txt` لمعرفة آخر commit
2. راجع logs في `backups/`
3. اتصل بالدعم الفني مع رقم النسخة الاحتياطية

---

## ✅ **Checklist للنسخ الاحتياطي الشهري**

- [ ] تشغيل `npm run backup`
- [ ] التحقق من نجاح النسخ (عرض logs)
- [ ] نسخ الملف إلى USB Drive
- [ ] التحقق من حجم الملف (يجب أن يكون > 500KB)
- [ ] حفظ الملف في مكان آمن
- [ ] تسجيل تاريخ النسخ في دفتر

---

**آخر تحديث:** 2025-12-05  
**الإصدار:** 1.0  
**المطور:** High Level Nursery System
