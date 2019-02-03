SELECT 'ФИО: Непочатых Александр Анатольевич';

DROP TABLE IF EXISTS films;
CREATE TABLE
films (
    name VARCHAR (100),
    id INT PRIMARY KEY,
    country VARCHAR (355),
    fees_dollars INT,
    year INT
);

INSERT INTO films VALUES ('Gladiator', 1, 'USA', 457640427, 2000);
INSERT INTO films VALUES ('Forrest Gump', 2, 'USA', 677386686, 1994);
INSERT INTO films VALUES ('Inception', 3, 'USA', 825532764, 2010);
INSERT INTO films VALUES ('Fight Club', 4, 'USA', 100853753, 1999);
INSERT INTO films VALUES ('The Matrix', 5, 'USA', 463517383, 1999);

DROP TABLE IF EXISTS persons;
CREATE TABLE
persons (
    id INT PRIMARY KEY, 
    name VARCHAR (355)
);

INSERT INTO persons VALUES (1, 'Rassel Croy');
INSERT INTO persons VALUES (2, 'Tom Hanks');
INSERT INTO persons VALUES (3, 'Robert Zemekis');
INSERT INTO persons VALUES (4, 'Leonardo DiKaprio');
INSERT INTO persons VALUES (5, 'Cristopher Nolan');
INSERT INTO persons VALUES (6, 'Edvard Norton');
INSERT INTO persons VALUES (7, 'Bred Pitt');
INSERT INTO persons VALUES (8, 'David Fintcher');
INSERT INTO persons VALUES (9, 'Keany Rivz');
INSERT INTO persons VALUES (10, 'Lana Vachovski');

DROP TABLE IF EXISTS person2content;
CREATE TABLE
person2content (
    id_person INT,
    id_content INT,
    person_type VARCHAR (400)
);

INSERT INTO person2content VALUES (1, 1, 'Actor');
INSERT INTO person2content VALUES (2, 2, 'Actor');
INSERT INTO person2content VALUES (3, 2, 'Director');
INSERT INTO person2content VALUES (4, 3, 'Actor');
INSERT INTO person2content VALUES (5, 3, 'Director');
INSERT INTO person2content VALUES (6, 4, 'Actor');
INSERT INTO person2content VALUES (7, 4, 'Actor');
INSERT INTO person2content VALUES (8, 4, 'Director');
INSERT INTO person2content VALUES (9, 4, 'Actor');
INSERT INTO person2content VALUES (10, 5, 'Director');
