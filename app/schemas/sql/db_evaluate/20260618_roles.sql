CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    role VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO roles (role) VALUES
('admin'),
('moderator'),
('viewer');