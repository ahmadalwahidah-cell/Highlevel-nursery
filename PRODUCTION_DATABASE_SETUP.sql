-- =====================================
-- إعداد قاعدة البيانات الإنتاجية
-- النظام المالي الذكي
-- =====================================

-- 1. إنشاء جدول الإيرادات
CREATE TABLE IF NOT EXISTS revenues (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  revenue_type TEXT NOT NULL CHECK(revenue_type IN ('subscription', 'other')),
  amount REAL NOT NULL CHECK(amount >= 0),
  description TEXT,
  revenue_date TEXT NOT NULL,
  created_by TEXT DEFAULT 'manager',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. إنشاء فهارس جدول الإيرادات
CREATE INDEX IF NOT EXISTS idx_revenues_date ON revenues(revenue_date);
CREATE INDEX IF NOT EXISTS idx_revenues_type ON revenues(revenue_type);

-- 3. إنشاء جدول المصروفات
CREATE TABLE IF NOT EXISTS expenses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  expense_type TEXT NOT NULL CHECK(expense_type IN ('rent', 'salary', 'other')),
  amount REAL NOT NULL CHECK(amount >= 0),
  description TEXT,
  expense_date TEXT NOT NULL,
  created_by TEXT DEFAULT 'board_member',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 4. إنشاء فهارس جدول المصروفات
CREATE INDEX IF NOT EXISTS idx_expenses_date ON expenses(expense_date);
CREATE INDEX IF NOT EXISTS idx_expenses_type ON expenses(expense_type);

-- =====================================
-- بيانات تجريبية (اختياري - يمكن حذفها)
-- =====================================

-- إيرادات تجريبية
INSERT INTO revenues (revenue_type, amount, description, revenue_date, created_by) 
VALUES 
  ('subscription', 5000, 'اشتراكات شهر ديسمبر 2025', '2025-12-01', 'manager'),
  ('subscription', 3500, 'اشتراكات متأخرة', '2025-12-05', 'manager'),
  ('other', 1200, 'رسوم الأنشطة الإضافية', '2025-12-10', 'manager');

-- مصروفات تجريبية
INSERT INTO expenses (expense_type, amount, description, expense_date, created_by) 
VALUES 
  ('rent', 2000, 'إيجار المبنى - ديسمبر 2025', '2025-12-01', 'board_member'),
  ('salary', 4500, 'رواتب المعلمات - ديسمبر 2025', '2025-12-01', 'board_member'),
  ('other', 800, 'صيانة وإصلاحات', '2025-12-08', 'board_member');
