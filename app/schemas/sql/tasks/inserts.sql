/*
1. Dodaj nowego użytkownika o nazwie michal.dabrowski, 
mailu michal.dabrowski@firma.pl, z dowolnym hashem hasła, aktywnego, nie-superusera.
*/

INSERT INTO users (username, email, hashed_password, is_active, is_superuser) VALUES
('michal.dabrowski', 'email', '$2b$12$wKmM3aCjY28X8nAaMt8gLeOoD7D02qtrFTAKjjBdyZzYxDdDIfjLe', TRUE, FALSE);

/*
2. Dodaj nowy stream o nazwie film4 ze ścieżką /video/film4.mp4, 
a następnie przypisz mu dwie kategorie z istniejącej tabeli categories 
(musisz wstawić wiersze do dwóch tabel — najpierw do streams, 
potem do stream_categories, korzystając z id nowo dodanego streamu).
*/
INSERT INTO streams (name, file_path) VALUES
('film4.mp4','/content/film4.mp4');

INSERT INTO stream_categories (stream_id, category_id)
SELECT stream.id, category.id
FROM streams stream, categories category
WHERE stream.name = 'film4.mp4'
AND category.category IN ('sport', 'sci-fi');

/* 3. Daj userowi o id=5 dostęp do streamu id=2 poprzez stream_access 
— ale zrób to tak, żeby zapytanie nie wywaliło błędu, 
jeśli ten dostęp już istnieje (podpowiedź: poszukaj klauzuli ON CONFLICT).
*/

INSERT INTO stream_access (user_id, stream_id) VALUES
(5, 2)
ON CONFLICT(user_id, stream_id) DO NOTHING;

/*
4. Wstaw 3 nowe wiersze do watch_history dla jednego konkretnego użytkownika, 
każdy dla innego streamu, z różnymi view_ratio (np. 20, 60, 95).
*/
INSERT INTO watch_history (user_id, stream_id, start_time, stop_time, view_ratio) VALUES
((SELECT id FROM users WHERE username = 'robert.wozniak'), 1, NOW(), NOW(), 20),
((SELECT id FROM users WHERE username = 'robert.wozniak'), 2, NOW(), NOW(), 60 ),
((SELECT id FROM users WHERE username = 'robert.wozniak'), 1, NOW(), NOW(), 95 );

/*
FROM tabela_A a
JOIN tabela_B b ON a.kolumna_wspolna = b.kolumna_wspolna
*/

/*
5. Dodaj nową kategorię horror do categories, a następnie w jednym kroku (jednym zapytaniem INSERT ... SELECT, 
bez podawania id na sztywno) przypisz tę nową kategorię do streamu film1 — podpowiedź: będziesz musiał użyć podzapytania, 
żeby znaleźć id kategorii horror i id streamu film1 po nazwie, a nie po numerze.
*/

INSERT INTO categories (category) VALUES
('horror');

INSERT INTO stream_categories (stream_id, category_id)
SELECT s.id, c.id
FROM streams s, categories c
WHERE s.name = 'film1'
AND c.category = 'horror';