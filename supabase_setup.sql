-- ══════════════════════════════════════════
-- Math Block Blast — Supabase Database Setup
-- Supabase Dashboard → SQL Editor → Run
-- ══════════════════════════════════════════

-- 1. ROOMS
create table if not exists rooms (
  code       text primary key,
  teacher    text not null,
  grade      int  not null default 0,
  created_at bigint default extract(epoch from now())*1000
);

-- 2. SCORES
create table if not exists scores (
  room_code   text not null,
  player_name text not null,
  score       int  default 0,
  lines       int  default 0,
  correct     int  default 0,
  wrong       int  default 0,
  total       int  default 0,
  pct         int  default 0,
  max_combo   int  default 0,
  ts          bigint default extract(epoch from now())*1000,
  primary key (room_code, player_name),
  foreign key (room_code) references rooms(code) on delete cascade
);

-- 3. RLS (누구나 읽기/쓰기)
alter table rooms  enable row level security;
alter table scores enable row level security;

create policy "allow all rooms"  on rooms  for all using (true) with check (true);
create policy "allow all scores" on scores for all using (true) with check (true);

-- 4. INDEXES
create index if not exists idx_scores_room on scores(room_code);
create index if not exists idx_scores_pct  on scores(room_code, pct desc);
