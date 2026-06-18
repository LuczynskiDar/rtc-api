create TABLE schedule(
    id SERIAL PRIMARY KEY,
    start_stream TIME NOT NULL,
    stop_stream TIME NOT NULL,
    stream_id INTEGER NOT NULL REFERENCES streams(id) ON DELETE CASCADE,
    day_id INTEGER NOT NULL REFERENCES days(id) ON DELETE CASCADE
);


INSERT INTO schedule (start_stream, stop_stream, stream_id, day_id) VALUES
('18:00', '20:00', 1, 1),
('8:30', '21:00', 2, 3),
('9:30', '11:00', 3, 4),
('6:30', '23:00', 2, 5),
('19:30', '21:00', 1, 6),
('17:30', '23:00', 3, 7),
('5:30', '22:00', 1, 8);