/*
Format ogólny (standard PostgreSQL, bez żadnej biblioteki)
postgresql://user:password@host:port/database
*/

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    is_superuser BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO users (username, email, hashed_password, is_active, is_superuser) VALUES
('admin', 'admin@firma.pl', '$2b$12$xomaLbOB1HClgYTQsYcwB.Vl6KCoYbXo6G03lOMX7bwO/yilVG7C.', TRUE, TRUE),
('jan.kowalski', 'jan.kowalski@firma.pl', '$2b$12$wKmM3aCjY28X8nAaMt8gLeOoD7D02qtrFTAKjjBdyZzYxDdDIfjLe', TRUE, FALSE),
('anna.nowak', 'anna.nowak@firma.pl', '$2b$12$wKmM3aCjY28X8nAaMt8gLeOoD7D02qtrFTAKjjBdyZzYxDdDIfjLe', TRUE, FALSE),
('piotr.wisniewski', 'piotr.wisniewski@firma.pl', '$2b$12$wKmM3aCjY28X8nAaMt8gLeOoD7D02qtrFTAKjjBdyZzYxDdDIfjLe', TRUE, FALSE),
('katarzyna.wojcik', 'katarzyna.wojcik@firma.pl', '$2b$12$wKmM3aCjY28X8nAaMt8gLeOoD7D02qtrFTAKjjBdyZzYxDdDIfjLe', TRUE, FALSE),
('marek.kaminski', 'marek.kaminski@firma.pl', '$2b$12$wKmM3aCjY28X8nAaMt8gLeOoD7D02qtrFTAKjjBdyZzYxDdDIfjLe', FALSE, FALSE),
('agnieszka.lewandowska', 'agnieszka.lewandowska@firma.pl', '$2b$12$wKmM3aCjY28X8nAaMt8gLeOoD7D02qtrFTAKjjBdyZzYxDdDIfjLe', TRUE, FALSE),
('tomasz.zielinski', 'tomasz.zielinski@firma.pl', '$2b$12$wKmM3aCjY28X8nAaMt8gLeOoD7D02qtrFTAKjjBdyZzYxDdDIfjLe', TRUE, FALSE),
('magdalena.szymanska', 'magdalena.szymanska@firma.pl', '$2b$12$wKmM3aCjY28X8nAaMt8gLeOoD7D02qtrFTAKjjBdyZzYxDdDIfjLe', FALSE, FALSE),
('robert.wozniak', 'robert.wozniak@firma.pl', '$2b$12$wKmM3aCjY28X8nAaMt8gLeOoD7D02qtrFTAKjjBdyZzYxDdDIfjLe', TRUE, FALSE),
('monika.kozlowska', 'monika.kozlowska@firma.pl', '$2b$12$wKmM3aCjY28X8nAaMt8gLeOoD7D02qtrFTAKjjBdyZzYxDdDIfjLe', TRUE, FALSE),
('krzysztof.jankowski', 'krzysztof.jankowski@firma.pl', '$2b$12$wKmM3aCjY28X8nAaMt8gLeOoD7D02qtrFTAKjjBdyZzYxDdDIfjLe', TRUE, FALSE),
('barbara.wojciechowska', 'barbara.wojciechowska@firma.pl', '$2b$12$wKmM3aCjY28X8nAaMt8gLeOoD7D02qtrFTAKjjBdyZzYxDdDIfjLe', TRUE, FALSE),
('lukasz.kwiatkowski', 'lukasz.kwiatkowski@firma.pl', '$2b$12$wKmM3aCjY28X8nAaMt8gLeOoD7D02qtrFTAKjjBdyZzYxDdDIfjLe', FALSE, FALSE),
('ewa.wojtyla', 'ewa.wojtyla@firma.pl', '$2b$12$wKmM3aCjY28X8nAaMt8gLeOoD7D02qtrFTAKjjBdyZzYxDdDIfjLe', TRUE, FALSE);