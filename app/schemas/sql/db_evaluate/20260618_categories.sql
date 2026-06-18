CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    category VARCHAR(255) NOT NULL UNIQUE
);

INSERT INTO categories (category) VALUES
('akcja'),
('komedia'),
('dokumentalny'),
('sport'),
('sci-fi');