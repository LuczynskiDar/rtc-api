CREATE TABLE user_roles(
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_id INTEGER NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    UNIQUE (user_id, role_id)
);

INSERT INTO user_roles (user_id, role_id) VALUES
(1, 1),
(7, 2),
(7, 3),
(13, 2),
(13, 3),
(2, 3);