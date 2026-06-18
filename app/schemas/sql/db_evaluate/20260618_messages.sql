CREATE TABLE messages(
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    stream_id INTEGER NOT NULL REFERENCES streams(id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    message_time TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO messages (user_id, stream_id, message) VALUES
(2, 1, 'Super jakość obrazu, działa płynnie!'),
(7, 2, 'Czy będzie powtórka tego streamu?'),
(13, 3, 'Dźwięk trochę się rozjeżdża z obrazem'),
(10, 1, 'Dzięki za udostępnienie, czekałem na to');