-- ============================================
-- 有給休暇管理システム データベーススキーマ
-- Supabase の SQL Editor で実行してください
-- ============================================

-- 従業員テーブル
CREATE TABLE employees (
  id         SERIAL PRIMARY KEY,
  name       TEXT NOT NULL,
  pin        TEXT NOT NULL,
  total_days NUMERIC NOT NULL DEFAULT 20,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 申請テーブル
CREATE TABLE requests (
  id         SERIAL PRIMARY KEY,
  emp_id     INTEGER REFERENCES employees(id) ON DELETE CASCADE,
  date       DATE NOT NULL,
  date_end   DATE,
  hours      NUMERIC NOT NULL,
  days       INTEGER,
  half_type  TEXT,
  reason     TEXT,
  status     TEXT NOT NULL DEFAULT 'pending',
  type       TEXT NOT NULL DEFAULT 'daily',
  is_initial BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 設定テーブル（aprilModeなど）
CREATE TABLE config (
  key        TEXT PRIMARY KEY,
  value      TEXT NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 初期設定
INSERT INTO config (key, value) VALUES ('aprilMode', 'true');

-- リアルタイム有効化
ALTER PUBLICATION supabase_realtime ADD TABLE employees;
ALTER PUBLICATION supabase_realtime ADD TABLE requests;
ALTER PUBLICATION supabase_realtime ADD TABLE config;

-- RLS（行レベルセキュリティ）を無効化（PINで認証するため）
ALTER TABLE employees DISABLE ROW LEVEL SECURITY;
ALTER TABLE requests  DISABLE ROW LEVEL SECURITY;
ALTER TABLE config    DISABLE ROW LEVEL SECURITY;

-- ============================================
-- 初期従業員データ（実行後に追加）
-- ============================================
INSERT INTO employees (id, name, pin, total_days) VALUES
  (1,  '元山貴士',  '0427', 40),
  (2,  '元山実希',  '0930', 40),
  (3,  'シン',      '0111', 25),
  (4,  '松尾和幸',  '0816', 37),
  (5,  '大庭康平',  '0925', 40),
  (6,  '勝本高悠',  '0822', 21),
  (7,  '大蔵敏',    '0720', 20),
  (8,  '田渕朋宏',  '0830', 40),
  (9,  '田中裕治',  '0403', 38),
  (10, 'アサンカ',  '0914', 20),
  (11, '辻和秀',    '0806', 37.5),
  (16, '元山通',    '1021', 40),
  (12, '平野太朗',  '0901', 28.5),
  (13, 'パダン',    '0610', 18),
  (14, '古賀翼',    '0803', 25),
  (17, 'アハマド',  '0821', 11),
  (15, 'ナン',      '0427', 20);

-- idのシーケンスを初期データの最大値に合わせる
SELECT setval('employees_id_seq', 20);

-- 2月以前の実績データ
INSERT INTO requests (emp_id, date, hours, reason, status, is_initial, type) VALUES
  (1,  '2026-02-28', 64,  '2026年2月以前の取得実績', 'approved', TRUE, 'daily'),
  (3,  '2026-02-28', 20,  '2026年2月以前の取得実績', 'approved', TRUE, 'daily'),
  (4,  '2026-02-28', 12,  '2026年2月以前の取得実績', 'approved', TRUE, 'daily'),
  (7,  '2026-02-28', 48,  '2026年2月以前の取得実績', 'approved', TRUE, 'daily'),
  (8,  '2026-02-28', 16,  '2026年2月以前の取得実績', 'approved', TRUE, 'daily'),
  (10, '2026-02-28', 24,  '2026年2月以前の取得実績', 'approved', TRUE, 'daily'),
  (11, '2026-02-28', 12,  '2026年2月以前の取得実績', 'approved', TRUE, 'daily'),
  (13, '2026-02-28', 4,   '2026年2月以前の取得実績', 'approved', TRUE, 'daily');
