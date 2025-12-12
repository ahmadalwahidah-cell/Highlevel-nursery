# 🔐 دليل إعداد Google Drive للنسخ الاحتياطي

## 📋 الخطوات المطلوبة

### **1️⃣ إنشاء Google Cloud Project**

1. اذهب إلى: https://console.cloud.google.com/
2. سجّل الدخول بـ: `high.level.mutlaa@gmail.com`
3. انقر **Create Project**
4. اسم المشروع: `highlevel-nursery-backups`
5. انقر **Create**

---

### **2️⃣ تفعيل Google Drive API**

1. في لوحة التحكم، اذهب إلى:
   **APIs & Services → Library**
2. ابحث عن: `Google Drive API`
3. انقر على **Google Drive API**
4. انقر **Enable**

---

### **3️⃣ إنشاء Service Account**

1. اذهب إلى: **APIs & Services → Credentials**
2. انقر **Create Credentials → Service Account**
3. ملء البيانات:
   - **Service account name**: `nursery-backup-service`
   - **Service account ID**: `nursery-backup-service`
   - **Description**: `Service account for automatic backups to Google Drive`
4. انقر **Create and Continue**
5. اختر **Role**: `Editor` (أو `Owner`)
6. انقر **Continue** ثم **Done**

---

### **4️⃣ إنشاء JSON Key**

1. في صفحة **Credentials**، ستجد **Service Accounts**
2. انقر على `nursery-backup-service@...`
3. اذهب إلى تبويب **Keys**
4. انقر **Add Key → Create new key**
5. اختر نوع: **JSON**
6. انقر **Create**
7. سيتم تنزيل ملف `.json` (احتفظ به جيداً!)

---

### **5️⃣ إنشاء مجلد Google Drive للنسخ الاحتياطية**

1. اذهب إلى: https://drive.google.com/
2. سجّل الدخول بـ: `high.level.mutlaa@gmail.com`
3. انقر **New → Folder**
4. اسم المجلد: `Nursery Backups`
5. انقر بزر الماوس الأيمن على المجلد → **Share**
6. شارك المجلد مع **Service Account Email**:
   - البريد سيكون بصيغة: `nursery-backup-service@highlevel-nursery-backups.iam.gserviceaccount.com`
   - امنحه صلاحية **Editor**
7. انسخ **Folder ID** من URL:
   ```
   https://drive.google.com/drive/folders/FOLDER_ID_HERE
   ```

---

## 🔑 **المعلومات المطلوبة:**

بعد إكمال الخطوات، ستحتاج:

1. ✅ **Service Account JSON File** (ملف .json المُحمّل)
2. ✅ **Google Drive Folder ID** (من URL المجلد)

---

## 📤 **كيفية رفع الملفات:**

### **الطريقة 1: نسخ محتوى JSON مباشرة** (الأسهل)
```bash
# افتح الملف المُحمّل واستخرج محتواه
cat ~/Downloads/highlevel-nursery-backups-*.json

# انسخ المحتوى كاملاً وزودني به
```

### **الطريقة 2: رفع الملف إلى السيرفر**
```bash
# إذا كنت على السيرفر مباشرة
scp ~/Downloads/highlevel-nursery-backups-*.json user@server:/home/user/highlevel-nursery/.google-credentials.json
```

---

## ⚠️ **مهم جداً:**

- **لا تشارك ملف JSON مع أحد**
- **لا ترفعه على GitHub** (سيتم إضافته إلى .gitignore)
- **احتفظ بنسخة آمنة** في مكان محمي

---

## 📧 **ملاحظة:**

بعد الحصول على:
1. ✅ Service Account JSON
2. ✅ Google Drive Folder ID

سأقوم تلقائياً بـ:
- ✅ إعداد النسخ الاحتياطي التلقائي
- ✅ جدولة نسخ أسبوعية (كل أحد 2 صباحاً)
- ✅ إرسال تنبيهات Email عند كل نسخ احتياطي
- ✅ إرسال تنبيهات عند الأخطاء

---

## 🎯 **الخطوة التالية:**

**زودني بـ:**
1. محتوى ملف JSON (أو ارفعه)
2. Google Drive Folder ID

وسأُكمل الإعداد تلقائياً! 🚀
