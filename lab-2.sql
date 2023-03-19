--1
SELECT nazwisko, LEVEL
FROM pracownicy
START WITH id_szefa IS NULL
CONNECT BY id_szefa = PRIOR id_pracownika
ORDER BY LEVEL;

--2
SELECT nazwisko, LEVEL
FROM pracownicy
START WITH id_szefa IS NULL
CONNECT BY id_szefa = PRIOR id_pracownika
ORDER SIBLINGS BY nazwisko;

--3
SELECT nazwisko, LEVEL
FROM pracownicy
START WITH id_szefa IS NULL
CONNECT BY id_szefa = PRIOR id_pracownika
ORDER BY LEVEL, nazwisko;

--4
SELECT nazwisko, LEVEL
FROM pracownicy
START WITH nazwisko='RACZKOWSKA' AND plec='K'
CONNECT BY id_szefa = PRIOR id_pracownika
ORDER SIBLINGS BY nazwisko;

--5
SELECT nazwisko, LEVEL
FROM pracownicy
START WITH nazwisko='ZATORSKI'
CONNECT BY id_pracownika = PRIOR id_szefa;

--6
SELECT LPAD(nazwisko, LENGTH(nazwisko) + LEVEL), LEVEL
FROM pracownicy
START WITH id_szefa IS NULL
CONNECT BY id_szefa = PRIOR id_pracownika
ORDER BY LEVEL;

--7
SELECT p.imie, p.nazwisko, p.pensja, pl.nazwa, w.poziom
FROM pracownicy p JOIN placowki pl ON p.id_placowki = pl.id_placowki
JOIN wyksztalcenie w ON p.id_wyksztalcenia = w.id_wyksztalcenia
ORDER BY pl.nazwa, p.nazwisko;

--8
SELECT DISTINCT k.nazwa
FROM 
    uczestnictwo u JOIN pracownicy p ON p.id_pracownika = u.id_pracownika
    JOIN kursy k ON k.id_kursu = u.id_kursu
WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, p.data_urodzenia) / 12) > 50;


--9
SELECT pl.nazwa, COUNT(p.id_pracownika)
FROM placowki pl LEFT JOIN pracownicy p ON pl.id_placowki = p.id_placowki
GROUP BY pl.nazwa; 

--10
SELECT p.nazwisko "NAZWISKO PRACOWNIKA", s.nazwisko "NAWISKO SZEFA"
FROM pracownicy p JOIN pracownicy s ON p.id_szefa=s.id_pracownika
ORDER BY 2, 1;

--11
SELECT p.nazwisko "NAZWISKO PRACOWNIKA", s.nazwisko "NAWISKO SZEFA"
FROM pracownicy p LEFT JOIN pracownicy s ON p.id_szefa=s.id_pracownika
ORDER BY 2, 1;

--12
SELECT nazwisko
FROM pracownicy
WHERE id_szefa = (SELECT id_pracownika FROM pracownicy WHERE nazwisko = 'KONECKI');

--13
SELECT p.imie, p.nazwisko
FROM pracownicy p JOIN pracownicy s ON p.id_szefa = s.id_pracownika
WHERE p.data_zatrudnienia < s.data_zatrudnienia
ORDER BY 2, 1;

--14
SELECT imie, numer_pracowniczy
FROM pracownicy
WHERE id_pracownika IN (SELECT DISTINCT id_szefa FROM pracownicy);

--15
SELECT imie, nazwisko, plec
FROM pracownicy
WHERE id_pracownika NOT IN (SELECT DISTINCT id_pracownika FROM pracownicy WHERE id_szefa IS NOT NULL);

--16
SELECT imie, nazwisko
FROM pracownicy p
WHERE EXISTS (SELECT 1 FROM pracownicy WHERE id_szefa = p.id_pracownika)
ORDER BY 2, 1;

--17
SELECT nazwisko
FROM pracownicy
WHERE id_pracownika IN (SELECT DISTINCT id_szefa FROM pracownicy) AND plec = 'K';

--18
SELECT nazwisko
FROM pracownicy
WHERE id_szefa IN (SELECT DISTINCT id_szefa FROM pracownicy WHERE plec = 'K' AND zawod = 'SPRZEDAWCA');


--19
SELECT p.imie, p.nazwisko, 
    (SELECT COUNT(id_pracownika) FROM pracownicy WHERE zawod=p.zawod) "liczba osób w zawodzie", 
	(SELECT ROUND(AVG(pensja), 2) FROM pracownicy WHERE zawod=p.zawod) "średnia pensja w zawodzie"
FROM pracownicy p;

--20
SELECT nazwisko,
    (SELECT nazwisko FROM pracownicy WHERE id_pracownika = p.id_szefa)
FROM pracownicy p;

--21
SELECT nazwisko, LEVEL
FROM pracownicy
WHERE id_pracownika NOT BETWEEN 30 AND 40
START WITH id_szefa IS NULL
CONNECT BY id_szefa = PRIOR id_pracownika;

--22
SELECT nazwisko, LEVEL
FROM pracownicy
START WITH id_szefa IS NULL
CONNECT BY id_szefa = PRIOR id_pracownika AND id_pracownika <> 18;

--23
SELECT nazwisko, LEVEL
FROM pracownicy
WHERE plec = 'M'
START WITH id_szefa IS NULL
CONNECT BY id_szefa = PRIOR id_pracownika;

--24
SELECT k.nazwa, COUNT(p.id_pracownika) 
FROM 
    kursy k JOIN uczestnictwo u ON k.id_kursu = u.id_kursu
    JOIN pracownicy p ON u.id_pracownika = p.id_pracownika
GROUP BY k.nazwa;

--25
SELECT k.nazwa
FROM 
    kursy k JOIN uczestnictwo u ON k.id_kursu = u.id_kursu
    JOIN pracownicy p ON u.id_pracownika = p.id_pracownika
	GROUP BY k.nazwa
	HAVING COUNT(p.id_pracownika) = (SELECT MAX(COUNT(pp.id_pracownika)) 
    FROM 
    kursy kk JOIN uczestnictwo uu ON kk.id_kursu = uu.id_kursu
    JOIN pracownicy pp ON uu.id_pracownika = pp.id_pracownika
    GROUP BY kk.nazwa);

--26
SELECT p.nazwisko, p.imie
FROM pracownicy p JOIN pracownicy s ON p.id_szefa = s.id_pracownika
WHERE p.pensja > s.pensja;

--27
SELECT p.nazwisko, p.imie
FROM pracownicy p JOIN pracownicy s ON p.id_szefa = s.id_pracownika
WHERE s.zawod IN ('KASJER', 'SPRZEDAWCA');

--28
SELECT DISTINCT zawod
FROM pracownicy 
WHERE id_pracownika IN (SELECT id_szefa FROM pracownicy);

--29
SELECT COUNT(DISTINCT zawod)
FROM pracownicy
WHERE id_pracownika IN (SELECT id_szefa FROM pracownicy);

--30
SELECT nazwisko
FROM pracownicy
WHERE id_pracownika IN (SELECT id_szefa FROM pracownicy) AND zawod <> 'SPRZEDAWCA';

--31
SELECT AVG(pensja)
FROM pracownicy
WHERE id_pracownika IN (SELECT id_szefa FROM pracownicy) AND zawod <> 'SPRZEDAWCA';

--32
SELECT p.imie, p.nazwisko, TO_CHAR(p.data_zatrudnienia, 'DD fmMON YYYY')
FROM pracownicy p JOIN pracownicy s ON p.id_szefa = s.id_pracownika
WHERE s.nazwisko = 'RADOMSKA';


--33
SELECT imie, nazwisko, numer_pracowniczy
FROM pracownicy
WHERE id_szefa = 11;

--34
SELECT imie, nazwisko, numer_pracowniczy, SYS_CONNECT_BY_PATH(nazwisko, '/') AS "ŚCIEŻKA"
FROM pracownicy
WHERE id_szefa = 11
START WITH id_pracownika = 11
CONNECT BY id_szefa = PRIOR id_pracownika;






