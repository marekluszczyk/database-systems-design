CREATE TABLE firma (
    id NUMBER(4) CONSTRAINT firma_pk PRIMARY KEY,
    nazwa VARCHAR2(20) NOT NULL,
    regon CHAR(9) NOT NULL
);

CREATE TABLE osoba_fizyczna (
    id NUMBER(4) CONSTRAINT osoba_fizyczna_pk PRIMARY KEY,
    imie VARCHAR2(10) NOT NULL,
    nazwisko VARCHAR2(20) NOT NULL,
    pesel CHAR(11) NOT NULL,
    CONSTRAINT pesel_u UNIQUE ( pesel )
);

CREATE TABLE projekty (
    id NUMBER(4) CONSTRAINT projekty_pk PRIMARY KEY,
    tytul VARCHAR2(50) NOT NULL,
    data_rozpoczecia DATE NOT NULL,
    data_zakonczenia DATE,
    id_firmy NUMBER(4),
    id_osoby_fizycznej NUMBER(4),
    CONSTRAINT id_firmy_fk FOREIGN KEY ( id_firmy ) REFERENCES firma ( id ),
    CONSTRAINT id_osoby_fizycznej_fk FOREIGN KEY ( id_osoby_fizycznej ) REFERENCES osoba_fizyczna ( id )
);

ALTER TABLE projekty
ADD CONSTRAINT projekty_mutually_exclusive_ch
CHECK (
    ( ( id_firmy IS NOT NULL ) AND ( id_osoby_fizycznej IS NULL ) )
    OR
    ( ( id_firmy IS NULL ) AND ( id_osoby_fizycznej IS NOT NULL ) )
);

ALTER TABLE projekty
MODIFY tytul VARCHAR2(80);