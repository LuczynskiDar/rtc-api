
CREATE TABLE stream_access (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    stream_id INTEGER NOT NULL REFERENCES streams(id) ON DELETE CASCADE,
    granted_at TIMESTAMP DEFAULT NOW(),
    UNIQUE (user_id, stream_id)
);

INSERT INTO stream_access (user_id, stream_id) VALUES
(1, 1), (1, 2), (1, 3),
(2, 1), (2, 2), (2, 3),
(3, 1),
(4, 3),
(5, 3),
(6, 1), (6, 2), (6, 3),
(7, 1),
(8, 1),
(9, 3),
(10, 1), (10, 2), (10, 3),
(11, 2),
(12, 1), (12, 2), (12, 3),
(13, 1), (13, 2), (13, 3),
(14, 1),
(15, 1), (15, 3);