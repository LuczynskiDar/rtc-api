CREATE TABLE streams (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO streams (name, file_path) VALUES
('film1', '/content/film1.mp4'),
('film2', '/content/film2.mp4'),
('film3', '/content/film3.mp4');