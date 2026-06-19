/*
1. Wyświetl wszystkich użytkowników, którzy nie są aktywni (is_active = FALSE), pokazując tylko username i email.
*/
SELECT u.username, u.email
FROM users u
WHERE u.is_active = FALSE;

SELECT u.username, u.email
FROM users u
WHERE NOT u.is_active;

/*
2. Wyświetl nazwę streamu i liczbę kategorii przypisanych do 
każdego streamu (podpowiedź: JOIN + GROUP BY + COUNT).
*/

SELECT s.id, s.name, COUNT(*) AS count
FROM streams s
JOIN stream_categories sc ON s.id = sc.stream_id
GROUP BY s.id, s.name
ORDER BY s.name ASC;

/*
3. Znajdź wszystkich userów, którzy mają dostęp do streamu film1, 
ale pokaż tylko ich username i email — 
wynik powinien wymagać złączenia trzech tabel 
(users, stream_access, streams).
*/
SELECT u.username, u.email
FROM users u
JOIN stream_access sa ON u.id = sa.user_id
JOIN streams s ON s.id = sa.stream_id
WHERE s.name = 'film1'
ORDER BY u.username ASC;

/*
4. Wyświetl średnią ocenę (reaction) dla każdego streamu z tabeli 
reactions, posortowaną od najwyższej do najniższej 
(podpowiedź: AVG(), GROUP BY, ORDER BY).
*/

SELECT s.name, AVG(r.reaction) AS avg_reaction
FROM streams s
JOIN reactions r ON r.stream_id = s.id
GROUP BY s.id, s.name
ORDER BY avg_reaction DESC;

/*
5. Znajdź userów, którzy mają rolę moderator, ale nie mają roli admin 
— pokaż ich username (podpowiedź: to wymaga 
albo dwóch podzapytań z IN/NOT IN, albo JOIN na user_roles 
z odpowiednim filtrowaniem; zastanów się też nad EXCEPT).
*/

SELECT u.id, u.username
FROM users u
WHERE u.id IN ( 
    SELECT ur.user_id 
    FROM user_roles ur 
    JOIN roles r ON r.id = ur.role_id 
    WHERE r.role = 'moderator'
)
AND u.id NOT IN (
    SELECT ur.user_id
    FROM user_roles ur
    JOIN roles r ON r.id = ur.role_id
    WHERE r.role = 'admin'
);


SELECT u.id, u.username
FROM users u
WHERE u.id IN ( 
    SELECT ur.user_id 
    FROM user_roles ur 
    JOIN roles r ON r.id = ur.role_id 
    WHERE r.role = 'moderator'
) EXCEPT (
    SELECT ur.user_id
    FROM user_roles ur
    JOIN roles r ON r.id = ur.role_id
    WHERE r.role = 'admin'
);
