# 🔧 دليل ربط Cloudflare KV بالمشروع

## ⚠️ خطوة مهمة: ربط KV بـ Pages

لكي تعمل ميزة الحفظ الفوري، يجب ربط KV namespace مع Cloudflare Pages:

### الطريقة الأولى: عبر Cloudflare Dashboard (سهلة جداً)

1. **افتح Cloudflare Dashboard**
   - اذهب إلى: https://dash.cloudflare.com
   - اختر حسابك

2. **افتح صفحة المشروع**
   - من القائمة الجانبية، اختر **Workers & Pages**
   - اختر مشروع **highlevel-nursery**

3. **اذهب لإعدادات المشروع**
   - اضغط تبويب **Settings**
   - اذهب لقسم **Functions**
   - انزل لأسفل حتى **KV namespace bindings**

4. **أضف الربط (Binding)**
   - اضغط **Add binding**
   - **Variable name**: `FINGERPRINT_SETTINGS`
   - **KV namespace**: اختر `FINGERPRINT_SETTINGS` من القائمة
   - اضغط **Save**

5. **أعد نشر المشروع**
   ```bash
   cd /home/user/highlevel-nursery
   npx wrangler pages deploy dist --project-name highlevel-nursery
   ```

### الطريقة الثانية: عبر wrangler CLI

```bash
cd /home/user/highlevel-nursery

# ربط KV namespace
npx wrangler pages secret bulk ./wrangler.toml --project-name highlevel-nursery
```

---

## ✅ التحقق من نجاح الربط

بعد إعادة النشر، اختبر API:

```bash
# اختبار القراءة
curl https://highlevel-nursery.pages.dev/fingerprint-config.json

# اختبار الحفظ
curl -X POST -H "Content-Type: application/json" \
  -d '{"fingerprint_window_start":"05:30","fingerprint_window_end":"07:00"}' \
  https://highlevel-nursery.pages.dev/admin/nursery/api/update-fingerprint-times
```

إذا نجح، ستظهر رسالة: `"success": true`

---

## 📋 KV Namespace Details

- **Namespace ID**: `eec9a07397aa47adada8cc9a08a8ba33`
- **Binding Name**: `FINGERPRINT_SETTINGS`
- **Keys المستخدمة**:
  - `fingerprint_window_start` - وقت فتح البصمة
  - `fingerprint_window_end` - وقت بداية احتساب التأخير
  - `last_updated` - تاريخ آخر تحديث

---

## 🎯 بعد الربط

بمجرد ربط KV بنجاح:

1. افتح: https://highlevel-nursery.pages.dev/admin/settings/fingerprint
2. غيّر الأوقات
3. اضغط **"حفظ الأوقات الجديدة"**
4. التحديث فوري - لا حاجة لانتظار!

---

**آخر تحديث**: 2025-12-06
