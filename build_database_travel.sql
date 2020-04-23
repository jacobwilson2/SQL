--CREATE DATABASE

--Drop existing tables

DROP TABLE BOOKING;
DROP TABLE TRAVELER;
DROP TABLE TOUR;

--Create new table schemas

CREATE TABLE TRAVELER (

    TrID             NUMBER(5, 0),
    TrName           VARCHAR2(20),
    TrPhone          NUMBER(10, 0),

    CONSTRAINT PK_TRAVELER
            PRIMARY KEY (TrID)
);

CREATE TABLE TOUR (

    TID             NUMBER(4, 0),
    DestinationName VARCHAR(20),
    TLength         NUMBER(3, 0)
                    CHECK (0 < TLength AND TLength <= 999),
    TCost           DECIMAL(6, 2)
                    CHECK (0 <= TCost AND TCost <= 9999.99),

    CONSTRAINT PK_TOUR
            PRIMARY KEY (TID)
);

CREATE TABLE BOOKING (

    TourID          NUMBER(4, 0),
    TravelerID      NUMBER(5, 0),
    TourDate        DATE,

    CONSTRAINT FK_BOOKING_TOUR
            FOREIGN KEY (TourID)
            REFERENCES Tour(TID),
    CONSTRAINT FK_BOOKING_TRAVELER
            FOREIGN KEY (TravelerID)
            REFERENCES TRAVELER(TrID)
);

--Part 2:

--Populate TOUR table

INSERT INTO TOUR VALUES ('1111', 'Los Angeles', '14', '1200');
INSERT INTO TOUR VALUES ('2222', 'Tokyo', '90', '3300');
INSERT INTO TOUR VALUES ('3333', 'Barcelona', '60', '2500');
INSERT INTO TOUR VALUES ('4444', 'Montreal', '10', '800');

--Populate TRAVELER table

INSERT INTO TRAVELER VALUES ('11234', 'Jacob', '8888888888');
INSERT INTO TRAVELER VALUES ('56789', 'Jake', '7777777777');
INSERT INTO TRAVELER VALUES ('13579', 'Jakob', '9999999999');

--Part 3:

--Populate BOOKING table

INSERT INTO BOOKING VALUES ('2222', '11234', DATE '2020-04-14');
INSERT INTO BOOKING VALUES ('1111', '56789', DATE '2020-08-10');
INSERT INTO BOOKING VALUES ('4444', '13579', DATE '2020-06-20');
INSERT INTO BOOKING VALUES ('3333', '11234', DATE '2021-09-28');
INSERT INTO BOOKING VALUES ('3333', '56789', DATE '2021-09-28');

--Part 4:

--Display the table

SELECT * FROM TOUR;
SELECT * FROM TRAVELER;
SELECT * FROM BOOKING;
