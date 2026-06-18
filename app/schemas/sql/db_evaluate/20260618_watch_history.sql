CREATE TABLE watch_history (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at timestamptz NOT NULL DEFAULT NOW(),
    stream_id INTEGER NOT NULL REFERENCES streams(id) ON DELETE CASCADE, 
    start_time TIMESTAMPTZ,
    stop_time TIMESTAMPTZ,
    view_ratio INTEGER NOT NULL DEFAULT 0 CHECK (view_ratio >= 0 AND view_ratio <= 100)
);

INSERT INTO watch_history (user_id, stream_id, start_time, stop_time) VALUES
(2, 1, '2026-06-15 18:05:00+02', '2026-06-15 19:58:00+02'),
(10, 3, '2026-06-16 20:00:00+02', '2026-06-16 20:45:00+02'),
(7, 2, '2026-06-17 19:00:00+02', '2026-06-17 19:30:00+02'),
(13, 1, '2026-06-17 18:10:00+02', '2026-06-17 20:00:00+02');
