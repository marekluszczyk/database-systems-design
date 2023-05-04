CREATE TABLE osoba (
    id NUMBER(4) CONSTRAINT osoba_pk PRIMARY KEY,
    imie VARCHAR2(15) NOT NULL,
    nazwisko VARCHAR2(25) NOT NULL,
    pesel CHAR(11) NOT NULL CONSTRAINT pesel_u UNIQUE,
    plec CHAR(1) NOT NULL,
    id_ojca NUMBER(4),
    id_matki NUMBER(4),
    CONSTRAINT id_ojca_fk FOREIGN KEY ( id_ojca ) REFERENCES osoba ( id ),
    CONSTRAINT id_matki_fk FOREIGN KEY ( id_matki ) REFERENCES osoba ( id )
);

ALTER TABLE osoba ADD CONSTRAINT pesel_ch CHECK (
    (plec = 'K' AND MOD(TO_NUMBER(SUBSTR(pesel, 10, 1)), 2) = 0) OR
    (plec = 'M' AND MOD(TO_NUMBER(SUBSTR(pesel, 10, 1)), 2) <> 0)
);

CREATE TABLE historia_zamieszkania (
    data_od DATE NOT NULL,
    miejscowosc VARCHAR2(30) NOT NULL,
    id_osoby NUMBER(4) NOT NULL,
    CONSTRAINT osoba_fk FOREIGN KEY ( id_osoby ) REFERENCES osoba ( id ),
    CONSTRAINT h_z_pk PRIMARY KEY ( data_od, id_osoby )
);