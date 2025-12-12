# 🔐 دليل دمج نظام الأمان المتقدم

## 📋 نظرة عامة

تم تطوير نظام أمان متقدم لمنع التحايل على نظام البصمة. النظام يتضمن:

1. **ربط الجهاز بالمعلمة** - كل معلمة تستخدم جهازها الشخصي فقط
2. **التحقق البيومتري** - بصمة الإصبع أو Face ID إجباري
3. **كشف الأنماط المشبوهة** - تنبيهات تلقائية للمديرة

---

## 🗄️ الجداول الجديدة (تم إنشاؤها)

### 1. `device_fingerprints`
```sql
- id: معرّف فريد
- teacher_id: معرّف المعلمة
- device_fingerprint: بصمة الجهاز (فريدة)
- device_name: اسم الجهاز
- device_info: معلومات تفصيلية (JSON)
- is_approved: هل تمت الموافقة؟
- is_blocked: هل محظور؟
- usage_count: عدد مرات الاستخدام
```

### 2. `suspicious_activity_logs`
```sql
- id: معرّف فريد
- teacher_id: معرّف المعلمة
- activity_type: نوع النشاط المشبوه
- severity: الخطورة (low, medium, high, critical)
- description: وصف النشاط
- device_fingerprint: بصمة الجهاز
- is_reviewed: هل تمت المراجعة؟
```

### 3. `login_attempts`
```sql
- id: معرّف فريد
- teacher_id: معرّف المعلمة
- device_fingerprint: بصمة الجهاز
- is_success: هل نجحت المحاولة؟
- biometric_used: هل استُخدم البيومتري؟
- created_at: وقت المحاولة
```

### 4. `device_approval_requests`
```sql
- id: معرّف فريد
- teacher_id: معرّف المعلمة
- device_fingerprint: بصمة الجهاز الجديد
- status: pending, approved, rejected
- requested_at: وقت الطلب
```

---

## 📁 الملفات الجديدة (تم إنشاؤها)

### 1. `/public/device-fingerprint.js`
مكتبة JavaScript لتوليد بصمة فريدة للجهاز

**الاستخدام:**
```javascript
// توليد بصمة الجهاز
const deviceData = await DeviceFingerprint.generate();
console.log(deviceData.fingerprint); // "a1b2c3d4e5f6..."
console.log(deviceData.deviceInfo); // {deviceName: "iOS - Safari (mobile)", ...}

// حفظ في LocalStorage
await DeviceFingerprint.saveToStorage();

// قراءة من LocalStorage
const stored = DeviceFingerprint.getFromStorage();
```

### 2. `/public/biometric-auth.js`
مكتبة JavaScript للتحقق البيومتري (WebAuthn)

**الاستخدام:**
```javascript
// فحص إذا كان البيومتري مدعوماً
const supported = await BiometricAuth.isPlatformAuthenticatorAvailable();

// التحقق السريع (بصمة إصبع أو Face ID)
const verified = await BiometricAuth.quickVerify();
if (verified) {
  // التحقق نجح ✅
}

// الحصول على نوع البيومتري
const type = await BiometricAuth.getSupportedType();
console.log(type); // "Touch ID / Face ID"
```

---

## 🔌 APIs الجديدة (تم إنشاؤها)

### 1. `POST /api/nursery/security/verify-device`
التحقق من الجهاز عند تسجيل الدخول

**Request:**
```json
{
  "teacher_id": 1,
  "device_fingerprint": "a1b2c3d4e5...",
  "device_info": {
    "deviceName": "iOS - Safari",
    "deviceType": "mobile",
    "os": "iOS",
    "browser": "Safari"
  }
}
```

**Responses:**
```json
// ✅ معتمد
{
  "status": "approved",
  "message": "تم التحقق من الجهاز بنجاح",
  "device_id": 123
}

// ⏳ في انتظار الموافقة
{
  "status": "pending_approval",
  "message": "الجهاز في انتظار موافقة المديرة"
}

// ❌ جهاز جديد يحتاج موافقة
{
  "status": "requires_approval",
  "message": "لديك جهاز مسجل مسبقاً. الجهاز الجديد يحتاج موافقة المديرة"
}

// 🚫 مرفوض (نفس الجهاز لمعلمة أخرى)
{
  "status": "rejected",
  "error": "هذا الجهاز مسجل لمعلمة أخرى",
  "severity": "critical"
}
```

### 2. `POST /api/nursery/security/detect-suspicious`
كشف الأنماط المشبوهة تلقائياً

**Request:**
```json
{
  "teacher_id": 1,
  "device_fingerprint": "a1b2c3...",
  "location": {"latitude": 29.3759, "longitude": 47.9774},
  "ip_address": "192.168.1.1"
}
```

**Response:**
```json
{
  "suspicious": true,
  "count": 2,
  "activities": [
    {
      "type": "same_device_multiple_teachers",
      "severity": "critical",
      "description": "نفس الجهاز سجل لـ 3 معلمات خلال 5 دقائق"
    },
    {
      "type": "unusual_time",
      "severity": "low",
      "description": "تسجيل في وقت غير معتاد (02:00)"
    }
  ]
}
```

### 3. `POST /api/nursery/security/log-login`
تسجيل محاولة تسجيل دخول

**Request:**
```json
{
  "teacher_id": 1,
  "phone": "22222222",
  "device_fingerprint": "a1b2c3...",
  "device_info": {...},
  "ip_address": "192.168.1.1",
  "is_success": true,
  "biometric_used": true
}
```

---

## 🔧 كيفية الدمج مع صفحة تسجيل الدخول

### الخطوات المطلوبة في `/nursery/teacher/login`:

1. **تحميل المكتبات:**
```html
<script src="/device-fingerprint.js"></script>
<script src="/biometric-auth.js"></script>
```

2. **عند تسجيل الدخول:**
```javascript
async function login() {
  const phone = document.getElementById('phone').value;
  
  // 1️⃣ توليد بصمة الجهاز
  const deviceData = await DeviceFingerprint.getOrGenerate();
  
  // 2️⃣ التحقق من صحة رقم الهاتف (API موجود)
  const authResponse = await axios.post('/teacher/login', { phone });
  const teacher_id = authResponse.data.teacher_id;
  
  // 3️⃣ التحقق من الجهاز
  const deviceCheck = await axios.post('/api/nursery/security/verify-device', {
    teacher_id: teacher_id,
    device_fingerprint: deviceData.fingerprint,
    device_info: deviceData.deviceInfo
  });
  
  if (deviceCheck.data.status === 'rejected') {
    alert('❌ ' + deviceCheck.data.error);
    return;
  }
  
  if (deviceCheck.data.status === 'requires_approval') {
    alert('⏳ ' + deviceCheck.data.message);
    return;
  }
  
  // 4️⃣ التحقق البيومتري (إذا كان مدعوماً)
  let biometric_verified = false;
  const biometricAvailable = await BiometricAuth.isPlatformAuthenticatorAvailable();
  
  if (biometricAvailable) {
    biometric_verified = await BiometricAuth.quickVerify();
    
    if (!biometric_verified) {
      alert('❌ فشل التحقق البيومتري. يرجى المحاولة مرة أخرى');
      return;
    }
  }
  
  // 5️⃣ تسجيل محاولة الدخول
  await axios.post('/api/nursery/security/log-login', {
    teacher_id: teacher_id,
    phone: phone,
    device_fingerprint: deviceData.fingerprint,
    device_info: deviceData.deviceInfo,
    is_success: true,
    biometric_used: biometric_verified
  });
  
  // 6️⃣ كشف الأنماط المشبوهة
  await axios.post('/api/nursery/security/detect-suspicious', {
    teacher_id: teacher_id,
    device_fingerprint: deviceData.fingerprint,
    location: getCurrentPosition(), // من GPS
    ip_address: null // يمكن الحصول عليه من الخادم
  });
  
  // ✅ نجح تسجيل الدخول
  window.location.href = '/nursery/teacher/attendance';
}
```

---

## 🔧 كيفية الدمج مع صفحة الحضور

### في `/nursery/teacher/attendance`:

```javascript
async function recordAttendance(type) {
  // ... الكود الموجود ...
  
  // ✅ إضافة التحقق البيومتري قبل تسجيل الحضور
  const biometricAvailable = await BiometricAuth.isPlatformAuthenticatorAvailable();
  let biometricVerified = false;
  
  if (biometricAvailable) {
    // طلب التحقق البيومتري
    try {
      biometricVerified = await BiometricAuth.quickVerify();
      
      if (!biometricVerified) {
        alert('❌ يجب التحقق من بصمة الإصبع أو Face ID لتسجيل الحضور');
        return;
      }
    } catch (e) {
      alert('❌ فشل التحقق البيومتري: ' + e.message);
      return;
    }
  }
  
  // تسجيل الحضور (الكود الموجود)
  const response = await axios.post('/api/nursery/attendance/record', {
    teacher_id: teacherId,
    log_type: type,
    latitude: currentPosition.coords.latitude,
    longitude: currentPosition.coords.longitude,
    biometric_verified: biometricVerified // ✅ إضافة هذا
  });
  
  // ... بقية الكود ...
}
```

---

## 📊 صفحات المديرة المطلوبة (للمرحلة التالية)

### 1. صفحة إدارة الأجهزة
`/admin/nursery/security/devices`

- عرض كل الأجهزة المسجلة
- الموافقة على الأجهزة الجديدة
- حظر/إلغاء حظر الأجهزة
- عرض معلومات الجهاز

### 2. صفحة النشاط المشبوه
`/admin/nursery/security/suspicious`

- عرض كل الأنشطة المشبوهة
- تصفية حسب الخطورة
- مراجعة النشاط
- إضافة ملاحظات

### 3. صفحة طلبات الموافقة
`/admin/nursery/security/approvals`

- عرض طلبات الأجهزة الجديدة
- الموافقة/الرفض
- عرض تفاصيل المعلمة والجهاز

---

## ✅ الحالة الحالية

### ✅ تم إنجازه:
- [x] إنشاء الجداول في قاعدة البيانات
- [x] تطوير مكتبة Device Fingerprinting
- [x] تطوير مكتبة Biometric Auth
- [x] إنشاء APIs الأمان
- [x] إنشاء API كشف الأنماط المشبوهة

### ⏳ قيد الإنجاز:
- [ ] دمج التحقق من الجهاز في صفحة تسجيل الدخول
- [ ] دمج التحقق البيومتري في صفحة الحضور
- [ ] إنشاء صفحات المديرة

### 📋 الخطوات التالية:
1. تطبيق Migration للجداول الجديدة
2. تحديث صفحة تسجيل دخول المعلمة
3. تحديث صفحة تسجيل الحضور
4. إنشاء صفحات المديرة
5. اختبار شامل

---

## 🧪 كيفية التطبيق والاختبار

### 1. تطبيق Migration:
```bash
npx wrangler d1 migrations apply highlevel-nursery-production --local
```

### 2. البناء والنشر:
```bash
npm run build
npx wrangler pages deploy dist --project-name highlevel-nursery
```

### 3. الاختبار:
1. افتح صفحة تسجيل دخول المعلمة
2. سجل دخول من جهاز جديد
3. حاول التسجيل من نفس الجهاز لمعلمة أخرى (يجب أن يُرفض)
4. افتح صفحة الحضور
5. جرب التحقق البيومتري

---

## 📞 الدعم

للأسئلة أو المساعدة، يرجى مراجعة:
- `migrations/0011_security_system.sql` - تعريف الجداول
- `public/device-fingerprint.js` - مكتبة البصمة
- `public/biometric-auth.js` - مكتبة البيومتري
- `src/routes/api.tsx` - APIs الأمان (آخر الملف)

---

## 🔒 ملاحظات الأمان

1. ✅ بصمة الجهاز فريدة ومشفرة (SHA-256)
2. ✅ التحقق البيومتري يستخدم WebAuthn المعتمد عالمياً
3. ✅ كل محاولة تسجيل دخول مسجلة
4. ✅ النشاط المشبوه يُكتشف تلقائياً
5. ✅ الجهاز الواحد لا يمكن استخدامه لأكثر من معلمة
6. ✅ الجهاز الجديد يحتاج موافقة المديرة

---

تم بواسطة: نظام الأمان المتقدم لحضانة High Level 🔐
