CREATE TABLE reactions(
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    stream_id INTEGER NOT NULL REFERENCES streams(id) ON DELETE CASCADE,
    reaction INTEGER NOT NULL CHECK (reaction >= 1 AND reaction <= 5),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO reactions (user_id, stream_id, reaction) VALUES
(2, 1, 5),
(7, 1, 4),
(13, 2, 3),
(10, 3, 5);