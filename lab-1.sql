--15
SELECT TO_CHAR(LAST_DAY(TO_DATE('02/2024','MM/YYYY')),'DD FMmonth YYYY') result
FROM DUAL;

--16
SELECT imie, nazwisko
FROM pracownicy
WHERE plec = 'K' AND to_char(data_urodzenia, 'fmDAY') = 'SUNDAY';

--17
SELECT nazwisko, TRANSLATE(nazwisko, 'KA','?*') AS "nazwisko po zmianie"
FROM pracownicy;

--18
SELECT nazwisko, REPLACE(nazwisko, 'SZKA', 'SZKOWA') AS "nazwisko po zmianie"
FROM pracownicy;

--19
SELECT nazwisko
FROM pracownicy
WHERE INSTR(nazwisko, 'H', 1, 1) > 0;

--20 ?

--21
SELECT imie, nazwisko, pensja, WIDTH_BUCKET(pensja, 0, 10000, 10) AS kategoria
FROM pracownicy;

--22
SELECT id_pracownika, CASE
WHEN pensja >= 3500 THEN to_char(pensja)
ELSE 'zbyt niska pensja'
END AS informacja
FROM pracownicy;

SELECT id_pracownika, DECODE(SIGN(pensja-3500), 1, TO_CHAR(pensja), 0, TO_CHAR(pensja), -1, 'Zbyt niska pensja')
FROM pracownicy
ORDER BY 1;

--23
SELECT imie||' '||nazwisko||', '||zawod||', wiek: '||FLOOR(MONTHS_BETWEEN(SYSDATE, data_urodzenia)/12) as dane
FROM pracownicy
ORDER BY FLOOR(MONTHS_BETWEEN(SYSDATE, data_urodzenia)/12) DESC;

--24 ?
SELECT MIN(pensja), AVG(pensja), MAX(pensja), COUNT(*)
FROM pracownicy
WHERE imie LIKE '%H%' OR imie LIKE '%C%';


--25
SELECT imie, nazwisko
FROM pracownicy
WHERE MOD(id_pracownika, 2) = 0 AND plec = 'M';

--27
SELECT imie, nazwisko
FROM pracownicy
WHERE TO_CHAR(data_urodzenia, 'fmMONTH') = 'MAY' OR TO_CHAR(data_urodzenia, 'fmMONTH') = 'AUGUST';

--28
SELECT 
    id_pracownika AS identyfikator,
    imie||' '||nazwisko AS "imie i nazwisko",
	SUBSTR(imie, 1, 1)||'. '||SUBSTR(nazwisko, 1, 1)||'. ',
	TO_CHAR(data_urodzenia,'DD/fmMonth/YYYY'),
    TO_CHAR(data_urodzenia, 'Q')
FROM pracownicy;

--30
SELECT nazwa
FROM kursy
ORDER BY LENGTH(nazwa) DESC;

--31
SELECT EXTRACT(YEAR FROM data_zatrudnienia) ROK, COUNT(id_pracownika) "LICZBA OSÓB"
FROM pracownicy
GROUP BY EXTRACT(YEAR FROM data_zatrudnienia)
ORDER BY ROK ASC;

--32
SELECT nazwisko, data_urodzenia
FROM pracownicy
WHERE data_urodzenia = (SELECT MAX(data_urodzenia) FROM PRACOWNICY WHERE nazwisko LIKE 'K%');

--33 !!!
SELECT imie, nazwisko, SUBSTR(nazwisko, 1, 1) ||''|| SUBSTR(imie, 1, 2) ||''|| EXTRACT(year from data_zatrudnienia) AS "Kod pracowniczy"
FROM pracownicy;

--34
SELECT imie, nazwisko
FROM pracownicy
WHERE TO_CHAR(data_urodzenia, 'DD/MM') = '08/10';

--35
SELECT imie, nazwisko, numer_pracowniczy, TRUNC(SYSDATE - data_zatrudnienia), FLOOR(MONTHS_BETWEEN(SYSDATE, data_zatrudnienia)), FLOOR(MONTHS_BETWEEN(SYSDATE, data_zatrudnienia)/12)
FROM pracownicy;

--36
SELECT nazwisko, zawod, data_zatrudnienia
FROM pracownicy
WHERE data_zatrudnienia BETWEEN TO_DATE('15.08.2010', 'DD.MM.YYYY') AND TO_DATE('30.09.2011', 'DD.MM.YYYY');

--37
SELECT imie, nazwisko
FROM pracownicy
WHERE TO_CHAR(data_urodzenia, 'YYYY') BETWEEN '1987' AND '1999'; 

--38
SELECT nazwisko NAZWISKO, TO_CHAR(data_urodzenia,'YYYY/MM/DD') DATA_URODZENIA, ADD_MONTHS(data_urodzenia, 65*12) "65 URODZINY"
FROM pracownicy
WHERE plec='M'
ORDER BY nazwisko ASC;

--39
SELECT TO_CHAR(data_zatrudnienia,'day') AS "Dzień tygodnia"
FROM pracownicy
WHERE nazwisko = 'KONECKI';

--40
SELECT imie, nazwisko
FROM pracownicy
WHERE plec = 'K' AND TO_CHAR(data_urodzenia, 'Q') = 1;

--41
SELECT  SUBSTR(nazwisko, 1, 1) AS litera, COUNT(id_pracownika) AS liczba_osob
FROM pracownicy
GROUP BY SUBSTR(nazwisko, 1, 1)
ORDER BY 1;

--42
SELECT  SUBSTR(nazwisko, 1, 1) AS litera, COUNT(id_pracownika) AS liczba_osob
FROM pracownicy
GROUP BY SUBSTR(nazwisko, 1, 1)
HAVING COUNT(id_pracownika) > 2;
ORDER BY 1;

--43
SELECT NEXT_DAY(LAST_DAY(TO_DATE('2023/07','YYYY/MM/')), 'THURSDAY') data
FROM dual;

--44
SELECT nazwisko, data_zatrudnienia, ROUND(data_zatrudnienia,'month')
FROM pracownicy
ORDER BY nazwisko;

--45
SELECT nazwa, REPLACE(nazwa, 'SKLEP', 'BUTIK')
FROM placowki;

--46 !!!
SELECT LPAD(imie,LENGTH(imie)), RPAD(imie,LENGTH(nazwisko))
FROM pracownicy;

--47
SELECT nazwisko
FROM pracownicy
WHERE INSTR(nazwisko, 'E', 1) > 0 AND INSTR(nazwisko, 'E', 1, 2) = 0;
