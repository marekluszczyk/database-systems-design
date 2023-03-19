--1
SELECT p.nazwisko 
FROM pracownicy p JOIN placowki pl ON p.id_placowki = pl.id_placowki
WHERE p.id_placowki = 1
INTERSECT
SELECT p.nazwisko 
FROM pracownicy p JOIN placowki pl ON p.id_placowki = pl.id_placowki
WHERE p.id_placowki = 6;

--2
SELECT p.nazwisko 
FROM pracownicy p JOIN placowki pl ON p.id_placowki = pl.id_placowki
WHERE pl.nazwa = 'BIURO'
MINUS
SELECT p.nazwisko 
FROM pracownicy p JOIN placowki pl ON p.id_placowki = pl.id_placowki
WHERE pl.nazwa = 'SKLEP I';

--3
(
SELECT nazwisko||'*'
FROM pracownicy
WHERE id_placowki=1
UNION ALL
SELECT nazwisko
FROM pracownicy
WHERE NOT id_placowki=1
)
ORDER BY 1;


SELECT nazwisko||CASE id_placowki WHEN 1 THEN '*' END nazwisko
FROM pracownicy
ORDER BY 1;

--4
SELECT imie, nazwisko, ADD_MONTHS(data_zatrudnienia, 3)
FROM pracownicy
WHERE MOD(id_pracownika, 2) = 0
UNION
SELECT imie, nazwisko, ADD_MONTHS(data_zatrudnienia, 6)
FROM pracownicy
WHERE MOD(id_pracownika, 2) = 1;

--5
SELECT pl.nazwa, TRUNC(AVG(p.pensja), 5)
FROM pracownicy p JOIN placowki pl ON p.id_placowki=pl.id_placowki
GROUP BY ROLLUP(pl.nazwa)
ORDER BY 1;

--6
SELECT TO_CHAR(data_urodzenia, 'MONTH') AS "MIESIĄC", COUNT(id_pracownika) AS "LICZBA OSÓB"
FROM pracownicy
GROUP BY ROLLUP(TO_CHAR(data_urodzenia, 'MONTH'));

--7
SELECT zawod, plec, ROUND(AVG(pensja), 5) "srednia pensja"
FROM pracownicy
GROUP BY zawod, plec
ORDER BY 1, 2;

SELECT zawod, plec, ROUND(AVG(pensja), 5) "srednia pensja"
FROM pracownicy
GROUP BY ROLLUP(zawod, plec)
ORDER BY 1, 2;

--7
SELECT zawod, plec, AVG(pensja)
FROM pracownicy
GROUP BY (zawod, plec)
ORDER BY 1, 2;

SELECT zawod, plec, AVG(pensja)
FROM pracownicy
GROUP BY ROLLUP(zawod, plec)
ORDER BY 1, 2;

SELECT zawod, plec, AVG(pensja)
FROM pracownicy
GROUP BY CUBE(zawod, plec)
ORDER BY 1, 2;

--8
SELECT w.poziom, pl.nazwa, COUNT(p.id_pracownika) AS "liczba osób"
FROM wyksztalcenie w JOIN pracownicy p ON w.id_wyksztalcenia = p.id_wyksztalcenia
JOIN placowki pl ON pl.id_placowki = p.id_placowki
GROUP BY (pl.nazwa, w.poziom)
ORDER BY 1 DESC, 2;

SELECT w.poziom, pl.nazwa, COUNT(id_pracownika) "licba osób"
FROM pracownicy p JOIN placowki pl ON p.id_placowki=pl.id_placowki
    JOIN wyksztalcenie w ON w.id_wyksztalcenia=p.id_wyksztalcenia
GROUP BY GROUPING SETS((poziom, nazwa), poziom, ())
ORDER BY 1, 2;


--9
SELECT w.poziom, pl.nazwa, COUNT(id_pracownika) "licba osób", GROUPING(poziom), GROUPING(nazwa)
FROM pracownicy p JOIN placowki pl ON p.id_placowki=pl.id_placowki
    JOIN wyksztalcenie w ON w.id_wyksztalcenia=p.id_wyksztalcenia
GROUP BY GROUPING SETS((poziom, nazwa), poziom, ())
ORDER BY 1, 2;


--10
SELECT pl.nazwa, p.zawod, MIN(p.pensja)
FROM placowki pl JOIN pracownicy p ON pl.id_placowki=p.id_placowki
GROUP BY GROUPING SETS(pl.nazwa, p.zawod);

--11
SELECT k.nazwa, p.plec, COUNT(p.id_pracownika) "liczba osób"
FROM pracownicy p JOIN uczestnictwo u ON p.id_pracownika=u.id_pracownika
JOIN kursy k ON u.id_kursu=k.id_kursu
WHERE data_zatrudnienia>TO_DATE('15/01/2010', 'DD/MM/YYYY')
GROUP BY GROUPING SETS((nazwa, plec), plec, nazwa, ())
ORDER BY 1, 2;

--12
SELECT pl.nazwa, TRUNC(AVG(p.pensja), 5)
FROM pracownicy p JOIN placowki pl ON p.id_placowki=pl.id_placowki
GROUP BY ROLLUP(pl.nazwa)
ORDER BY 1;