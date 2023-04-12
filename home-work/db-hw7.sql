CREATE TABLE oddzialy_firmy (
    id NUMBER(2) CONSTRAINT oddzial_firmy_pk PRIMARY KEY,
    nazwa VARCHAR2(50) NOT NULL CONSTRAINT nazwa_ic CHECK(nazwa = INITCAP(nazwa)),
    id_kierownika NUMBER(4) --kolumna klucza obcego do kolumny ID w tabeli PRACOWNICY o wartościach unikalnych.
)

CREATE TABLE pracownicy (
    id NUMBER(4) CONSTRAINT pracownicy_pk PRIMARY KEY,
    pierwsze_imie VARCHAR2(15) NOT NULL CONSTRAINT pierwsze_imie_ic CHECK(pierwsze_imie = INITCAP(pierwsze_imie)),
    drugie_imie VARCHAR2(15) CONSTRAINT drugie_imie_ic CHECK(drugie_imie = INITCAP(drugie_imie)),
    nazwisko VARCHAR2(30) NOT NULL,
    pesel VARCHAR2(11) NOT NULL CONSTRAINT pesel_u UNIQUE CONSTRAINT pesel_check CHECK(LENGTH(pesel) = 11), --kolumna o wartościach unikalnych
    plec CHAR(1) NOT NULL CONSTRAINT check_plec CHECK (plec IN ('K', 'M')),
    data_urodzenia DATE NOT NULL,
    data_zatrudnienia DATE DEFAULT SYSDATE NOT NULL CONSTRAINT data_zatrudnienia_check CHECK (data_zatrudnienia > data_urodzenia),
    id_oddzialu NUMBER(2) NOT NULL, --kolumna klucza obcego do kolumny ID w tabeli ODDZIALY_FIRMY
    id_przelozonego NUMBER(4) NOT NULL --kolumna klucza obcego do kolumny ID w tabeli PRACOWNICY
)

CREATE TABLE czlonkowie_rodzin (
    pierwsze_imie VARCHAR2(15) CONSTRAINT czlonkowie_firmy_pk PRIMARY KEY CONSTRAINT pierwsze_imie_ic CHECK(pierwsze_imie = INITCAP(pierwsze_imie)),
    plec CHAR(1) NOT NULL CONSTRAINT check_plec CHECK(plec IN ('K', 'M')),
    data_urodzenia DATE NOT NULL,
	stopien_pokrewienstwa VARCHAR2(30) NOT NULL,
    id_pracownika NUMBER(4) CONSTRAINT pracownicy_fk REFERENCES pracownicy(id) --kolumna klucza obcego do kolumny ID w tabeli PRACOWNICY 
)

ALTER TABLE oddzialy_firmy
ADD CONSTRAINT id_kierownika_fk
FOREIGN KEY (id_kierownika) REFERENCES pracownicy(id);