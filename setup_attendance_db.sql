-- ========================================
-- SQL Commands for Attendance System
-- Execute these commands in Cloudflare Dashboard
-- ========================================

-- 1. Create teacher_attendance_logs table
CREATE TABLE IF NOT EXISTS teacher_attendance_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  teacher_id INTEGER NOT NULL,
  log_type TEXT NOT NULL CHECK(log_type IN ('check_in', 'check_out')),
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
  latitude REAL,
  longitude REAL,
  distance_from_nursery REAL,
  device_info TEXT,
  biometric_verified INTEGER DEFAULT 0,
  FOREIGN KEY (teacher_id) REFERENCES teachers(id)
);

-- 2. Create nursery_settings table
CREATE TABLE IF NOT EXISTS nursery_settings (
  id INTEGER PRIMARY KEY CHECK(id = 1),
  latitude REAL,
  longitude REAL,
  radius_meters INTEGER DEFAULT 100
);

-- 3. Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_teacher_attendance_teacher_id ON teacher_attendance_logs(teacher_id);
CREATE INDEX IF NOT EXISTS idx_teacher_attendance_date ON teacher_attendance_logs(DATE(timestamp));
CREATE INDEX IF NOT EXISTS idx_teacher_attendance_type ON teacher_attendance_logs(log_type);
