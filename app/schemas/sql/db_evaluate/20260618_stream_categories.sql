CREATE TABLE stream_categories(
    id SERIAL PRIMARY KEY,
    stream_id INTEGER NOT NULL REFERENCES streams(id) ON DELETE CASCADE,
    category_id INTEGER NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    UNIQUE(stream_id, category_id)
);

INSERT INTO stream_categories (stream_id, category_id) VALUES
(1, 1),
(1, 5),
(2, 2),
(2, 4),
(3, 3),
(3, 1);