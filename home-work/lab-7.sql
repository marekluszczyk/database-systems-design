-- lab-7-hw

CREATE TABLE oddzialy_firmy (
    id NUMBER(2)
    	CONSTRAINT oddzialy_firmy_pk PRIMARY KEY,
    nazwa VARCHAR2(50) NOT NULL
    	CONSTRAINT nazwa_ic CHECK(nazwa = INITCAP(nazwa)),
    id_kierownika NUMBER(4) -- kolumna klucza obcego do kolumny ID w tabeli PRACOWNICY o wartościach unikalnych
    	CONSTRAINT id_kierownika_u UNIQUE
);


CREATE TABLE pracownicy (
    id NUMBER(4)
    	CONSTRAINT pracownicy_pk PRIMARY KEY,
    pierwsze_imie VARCHAR2(15) NOT NULL
    	CONSTRAINT pierwsze_imie_ic CHECK(pierwsze_imie = INITCAP(pierwsze_imie)),
    drugie_imie VARCHAR2(30),
    nazwisko VARCHAR2(30) NOT NULL
    	CONSTRAINT nazwisko_ic CHECK(nazwisko = INITCAP(nazwisko)),
    pesel VARCHAR2(11) NOT NULL -- kolumna o wartościach unikalnych
    	CONSTRAINT pesel_u UNIQUE  
    	CONSTRAINT pesel_11 CHECK(LENGTH(pesel) = 11), 
    plec CHAR(1) NOT NULL
    	CONSTRAINT plec_km CHECK(plec IN ('K', 'M')),
    data_urodzenia DATE NOT NULL,
    data_zatrudnienia DATE DEFAULT SYSDATE,
    id_oddzialu NUMBER(2) NOT NULL
    	CONSTRAINT oddzial_fk REFERENCES oddzialy_firmy(id),
    id_przelozonego NUMBER(4)
    	CONSTRAINT przelozony_fk REFERENCES pracownicy(id),
    
    CONSTRAINT data_zatrudnienia_ch CHECK(data_zatrudnienia > data_urodzenia) -- ??? zapytac czemu nie moge dodac constrainta w linicje z data urodzenia 
);


CREATE TABLE czlonkowie_rodzin (
    pierwsze_imie VARCHAR2(15)
    	CONSTRAINT pierwsze_imie_ic2 CHECK(pierwsze_imie = INITCAP(pierwsze_imie)),
    plec CHAR(1) CONSTRAINT plec_km2 CHECK(plec IN ('K', 'M')),
    data_urodzenia DATE NOT NULL,
    stopien_pokrewienstwa VARCHAR2(30) NOT NULL,
    id_pracownika NUMBER(4) -- kolumna klucza obcego do kolumny ID w tabeli PRACOWNICY
    	CONSTRAINT pracownik_fk REFERENCES pracownicy(id),
    	CONSTRAINT pk_czlonkowie_rodzin PRIMARY KEY (pierwsze_imie, id_pracownika)
);


ALTER TABLE oddzialy_firmy
ADD CONSTRAINT id_kierownika_fk
FOREIGN KEY (id_kierownika) REFERENCES pracownicy(id);


-- lab-7

-- b)
CREATE INDEX pracownicy_npi_ind
ON pracownicy(nazwisko,pierwsze_imie);


-- c)
CREATE SEQUENCE pracownicy_sekw
INCREMENT BY 1 START WITH 1;


-- d)
INSERT INTO oddzialy_firmy VALUES(1, 'Oddział Łódź', NULL);
INSERT INTO oddzialy_firmy VALUES(2, 'Oddział Kraków', NULL);
INSERT INTO oddzialy_firmy VALUES(3, 'Oddział Gdańsk', NULL);

INSERT INTO pracownicy VALUES(pracownicy_sekw.NEXTVAL,'Jan','Piotr', 'Nowak', '67110512816', 'M', TO_DATE('05/11/1967', 'DD/MM/YYYY'), TO_DATE('01/01/2021', 'DD/MM/YYYY'), 1, NULL);
INSERT INTO pracownicy VALUES(pracownicy_sekw.NEXTVAL,'Alicja', NULL, 'Tracz', '76071509449', 'K', TO_DATE('15/07/1976', 'DD/MM/YYYY'), TO_DATE('01/01/2021','DD/MM/YYYY'), 1, (SELECT id FROM pracownicy WHERE pesel = '67110512816'));
INSERT INTO pracownicy VALUES(pracownicy_sekw.NEXTVAL,'Wojciech','Jakub','Sosnowski','58122478773','M',TO_DATE('24/12/1958','DD/MM/YYYY'),TO_DATE('01/01/2021','DD/MM/YYYY'), 2, (SELECT id FROM pracownicy WHERE pesel = '67110512816'));
INSERT INTO pracownicy VALUES(pracownicy_sekw.NEXTVAL,'Jakub', NULL, 'Kot', '78101908736', 'M', TO_DATE('19/10/1978','DD/MM/YYYY'), DEFAULT, 2, (SELECT id FROM pracownicy WHERE pesel = '58122478773'));
INSERT INTO pracownicy VALUES(pracownicy_sekw.NEXTVAL,'Anna', 'Maria', 'Wójcik', '68032723801', 'K', TO_DATE('27/03/1968','DD/MM/YYYY'), TO_DATE('01/02/2021','DD/MM/YYYY'), 1, (SELECT id FROM pracownicy WHERE pesel = '67110512816'));
INSERT INTO pracownicy VALUES(pracownicy_sekw.NEXTVAL,'Mariola', 'Ewa', 'Zimnicka', '74071335781', 'K', TO_DATE('13/07/1974','DD/MM/YYYY'), TO_DATE('01/02/2021', 'DD/MM/YYYY'), 1,(SELECT id FROM pracownicy WHERE pesel='68032723801'));


-- e)
INSERT INTO czlonkowie_rodzin VALUES('Zofia', 'K', TO_DATE('05/11/2009', 'DD/MM/YYYY'), 'córka', (SELECT id FROM pracownicy WHERE pesel = '74071335781'));
INSERT INTO czlonkowie_rodzin VALUES('Maciej', 'M',TO_DATE('12/04/2011', 'DD/MM/YYYY'), 'syn',(SELECT id FROM pracownicy WHERE pesel = '74071335781'));
INSERT INTO czlonkowie_rodzin VALUES('Michalina', 'K',TO_DATE('22/05/2012', 'DD/MM/YYYY'), 'córka',(SELECT id FROM pracownicy WHERE pesel = '68032723801'));

COMMIT;

-- g)
SELECT * FROM V$NLS_PARAMETERS;

ALTER SESSION SET NLS_DATE_FORMAT = 'DD MON YYYY';

SELECT * FROM oddzialy_Firmy;
SELECT * FROM pracownicy;
SELECT * FROM czlonkowie_rodzin;


-- h)
UPDATE oddzialy_firmy 
SET id_kierownika = (SELECT id FROM pracownicy WHERE pesel = '67110512816')
WHERE id = 1;
UPDATE oddzialy_firmy 
SET id_kierownika = (SELECT id FROM pracownicy WHERE pesel = '58122478773')
WHERE id = 2;
UPDATE oddzialy_firmy 
SET id_kierownika = (SELECT id FROM pracownicy WHERE pesel = '68032723801')
WHERE id = 3;

COMMIT;


-- i)
ALTER TABLE oddzialy_firmy MODIFY (id_kierownika NOT NULL);


-- j)
ALTER TABLE czlonkowie_rodzin
ADD CONSTRAINT plec_ck CHECK (
    (stopien_pokrewienstwa = 'córka' AND plec = 'K') OR 
    (stopien_pokrewienstwa = 'syn' AND plec = 'M') OR 
    (stopien_pokrewienstwa NOT IN ('córka', 'syn'))
);

insert into czlonkowie_rodzin values('Marysia', 'M', TO_DATE('05/11/2004','DD/MM/YYYY'),
'córka',(select id from pracownicy where pesel='68032723801'));
insert into czlonkowie_rodzin values('Marysia', 'K', TO_DATE('05/11/1969','DD/MM/YYYY'),
'żona',(select id from pracownicy where pesel='68032723801'));

DELETE FROM czlonkowie_rodzin 
WHERE id_pracownika = (SELECT id FROM pracownicy WHERE pesel = '68032723801');

ALTER TABLE czlonkowie_rodzin DROP CONSTRAINT plec_ck;


-- k)
ALTER TABLE pracownicy
MODIFY(nazwisko VARCHAR2(40));