CREATE TYPE week_days AS ENUM ('monday', 'tuesday', 'wenedsday', 'thursday', 'friday', 'saturday', 'sunday');

CREATE TABLE days (
	id INTEGER PRIMARY KEY,
	day week_days,
	user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	stream_id INTEGER NOT NULL,
	FOREIGN KEY (stream_id) REFERENCES streams(id) ON DELETE CASCADE
);

DROP TABLE days CASCADE;

CREATE TABLE days(
	id SERIAL PRIMARY KEY,
	day week_days,
	user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	stream_id INTEGER NOT NULL,
	FOREIGN KEY (stream_id) REFERENCES streams(id) ON DELETE CASCADE
);

ALTER TYPE week_days RENAME VALUE 'wenedsday' TO 'wednesday';

INSERT INTO days (day, user_id, stream_id) VALUES
('monday', 1, 2),
('monday', 1, 3),
('monday', 1, 1),
('monday', 10, 1),
('wednesday', 8, 1),
('wednesday', 9, 3),
('thursday', 7, 1),
('friday', 12, 2),
('friday', 14, 1),
('saturday', 12, 1),
('saturday', 12, 3),
('sunday', 14, 1),
('sunday', 15, 1),
('sunday', 15, 3);