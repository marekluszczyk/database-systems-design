CREATE TABLE uniwersytety (
    id NUMBER(3) CONSTRAINT uniwersytety_pk PRIMARY KEY,
    nazwa VARCHAR2(40) NOT NULL,
    CONSTRAINT nazwa_u UNIQUE ( nazwa ),
    miejscowosc VARCHAR2(20) NOT NULL
);

CREATE TABLE naukowcy (
    id NUMBER(4) CONSTRAINT naukowcy_pk PRIMARY KEY,
    imie VARCHAR2(10) NOT NULL,
    nazwisko VARCHAR2(20) NOT NULL,
    plec CHAR(1) NOT NULL,
    data_urodzenia DATE NOT NULL,
    data_zapisania_do_bazy DATE NOT NULL,
    CONSTRAINT data_ch CHECK ( data_zapisania_do_bazy > data_urodzenia ),
    id_wspolpracownika NUMBER(4),
    CONSTRAINT wspolpracownik_fk FOREIGN KEY ( id_wspolpracownika ) REFERENCES naukowcy ( id )
)

CREATE TABLE wspolpracownicy (
    id NUMBER(4) NOT NULL,
    id_naukowca NUMBER(4) NOT NULL,
    CONSTRAINT wspolpracownicy_pk PRIMARY KEY ( id, id_naukowca ),
    CONSTRAINT id_fk FOREIGN KEY ( id ) REFERENCES naukowcy ( id ),
    CONSTRAINT id_naukowca_fk FOREIGN KEY ( id_naukowca ) REFERENCES naukowcy ( id )
)

ALTER TABLE naukowcy MODIFY data_zapisania_do_bazy DEFAULT SYSDATE;