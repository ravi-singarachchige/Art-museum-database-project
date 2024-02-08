DROP DATABASE IF EXISTS ARTMUSEUM;
CREATE DATABASE ARTMUSEUM; 
USE ARTMUSEUM;

DROP TABLE IF EXISTS EXHIBITION;
CREATE TABLE EXHIBITION (
	name			varchar(100)	not null,
	startDate		varchar(20),
	endDate			varchar(20),
	primary key (name, startDate)
);

INSERT INTO EXHIBITION(name, startDate, endDate)
VALUES
('The Tudors: Art and Majesty in Renaissance England','November 10, 2023','December 25, 2023'),
('Cubism and the Trompe l''Oeil Tradition','December 1, 2023','December 22, 2023');


DROP TABLE IF EXISTS ARTIST;
CREATE TABLE ARTIST (
	name			    varchar(50)		not null,
	dateBorn		    varchar(20),
	dateDied			varchar(20),
	countryOrigin		varchar(20),
	epoch				varchar(20),
	mainStyle			varchar(20),
	description			mediumtext,
	primary key (name)
);


INSERT INTO ARTIST(name, dateBorn, dateDied, countryOrigin, epoch, mainStyle, description)
VALUES
('Hans Holbein the Younger','1497','1543','Germany','Renaissance','Realistic', 'Considered one of the greatest portratists of the 16th century'),
('Benedetto da Rovezzano','1474','1554','Italy','Renaissance', 'Abstract', 'Italian architect and sculptor'),
('John Shute',null,'1563','England', 'Renaissance', 'Written', 'English artist and architect'),
('Pablo Picasso','October 25, 1881','April 8, 1973', 'Spain', 'Modern', 'Abstract', 'One of the most influential artists of the 20th century'),
('Theaster Gates','1973',null, 'American', 'Modern', 'Abstract', 'American social practice artist'),
('Woody de Othello','1991',null, 'American', 'Modern', 'Abstract', 'American ceramicist and painter');

DROP TABLE IF EXISTS ART_OBJECT;
CREATE TABLE ART_OBJECT 
(
	uniqueID			varchar(30)		not null,
	year			    varchar(10),
    title			    varchar(100),
	description         mediumtext,
	countryOrigin       varchar(20),
	epoch            	varchar(20),
    style				varchar(20),
	primary key (uniqueID)
);

INSERT INTO ART_OBJECT (uniqueID, year, title, description, countryOrigin, epoch, style)
VALUES
('0001','1537','Henry VIII', 'Portrait of Henry VIII', 'England', 'Renaissance', 'Realistic'),
('0002','1912','Still Life with Chair Caning', 'Work of art by Picasso that is considered to be the first collage in modern art', 'Spain', 'Modern', 'Abstract'),
('0003','2021','Applying Pressure', 'Vase on Table', 'America', 'Modern', 'Abstract'),
('0004','2020','Signature Study', 'Stoneware', 'American', 'Modern','Abstract'),
('0005','1563','The First and Chief Groundes of Architecture Used in All the Auncient and Famous Monymentes...','Written Text', 'England', 'Renaissance', 'Written'),
('0006','1500','Candelabrum', 'A candelabrum', 'Italy', 'Renaissance', 'Abstract'),
('0007','1533-36','Anne Boleyn', 'Portrait of Anne Boleyn', 'England', 'Renaissance', 'Realistic');


DROP TABLE IF EXISTS PAINTING;
CREATE TABLE PAINTING (
	uniqueID			varchar(30) 	not null,
	paintType			varchar(20),
	drawnOn				varchar(20),
	primary key (uniqueID),
	foreign key (uniqueID) references ART_OBJECT(uniqueID) ON DELETE CASCADE    
);

INSERT INTO PAINTING (uniqueID, paintType, drawnOn)
VALUES
('0001','Oil','Panel'),
('0002','Oil','Oilcloth');

DROP TABLE IF EXISTS SCULPTURE_OBJECT;
CREATE TABLE SCULPTURE_OBJECT (
	uniqueID		varchar(30) 	not null,
	material		varchar(20),
	height			varchar(20),
	weight			varchar(20),
	sculptureFlag	varchar(1),
	statueFlag		varchar(1),
	primary key (uniqueID),
	foreign key (uniqueID) references ART_OBJECT(uniqueID) ON DELETE CASCADE
);

INSERT INTO SCULPTURE_OBJECT (uniqueID, material, height, weight, sculptureFlag, statueFlag)
VALUES
('0003','Ceramic/Oak Wood','96.5cm','20.8kg', 1, 0),
('0004','Stoneware','54.9cm','40.8kg', 1, 0),
('0006','Bronze','340cm','622kg', 0, 1);

DROP TABLE IF EXISTS OTHER;
CREATE TABLE OTHER (
	uniqueID		varchar(30)		not null,
	type			varchar(20),
	primary key (uniqueID),
	foreign key (uniqueID) references ART_OBJECT(uniqueID) ON DELETE CASCADE
);

INSERT INTO Other (uniqueID, type)
VALUES
('0007','Sketch'),
('0005','Text');

DROP TABLE IF EXISTS PERMANENT_COLLECTION;
CREATE TABLE PERMANENT_COLLECTION (
	uniqueID			varchar(30) 	not null,
	dateAcquired		varchar(20),
	status				varchar(10),
	cost				varchar(15),
	primary key (uniqueID),
	foreign key (uniqueID) references ART_OBJECT(uniqueID) ON DELETE CASCADE
    );

INSERT INTO PERMANENT_COLLECTION (uniqueID, dateAcquired, status, cost)
VALUES
('0001','2022-1-21','On Display','$150000'),
('0002','2023-12-12','Stored','$100000'),
('0005','2022-4-29','On Display','$1200'),
('0006','2022-5-12','On Display','$1200'),
('0007','2022-7-11','On Display','$10000');


DROP TABLE IF EXISTS OTHER_COLLECTIONS;
CREATE TABLE OTHER_COLLECTIONS (
	name				varchar(100)	not null,
	type		   		varchar(20),
	description			mediumtext,
	address				varchar(75),
	phone				varchar(25),
	contactPerson		varchar(50),
	primary key (name)
);

INSERT INTO OTHER_COLLECTIONS(Name, type, description, address, phone, contactPerson)
VALUES
("Metropolitan Modern Art Collection",
"Modern Art",
"The Metropolitan Modern Art Collection features a diverse range of contemporary artworks from the late 20th century to the present day.",
"129 Gallery Street, Cityville",
"(555) 123-4567",
"Emily Smith"),
("Serene Landscapes Gallery",
"Landscape Paintings",
"The collection primarily focuses on breathtaking landscapes from different regions and periods, capturing the beauty of nature through various artistic styles.",
"56 Nature Avenue, Townsville, State, ZIP",
"(555) 987-6543",
"Alexander Norman");


DROP TABLE IF EXISTS BORROWED;
CREATE TABLE BORROWED (
	uniqueID			varchar(15)		not null,
	dateBorrowed		varchar(20),
	dateReturned		varchar(20),
	OCName				varchar(100),
	primary key (uniqueID),
	foreign key (uniqueID) references ART_OBJECT(uniqueID) ON DELETE CASCADE,
	foreign key (OCName) references OTHER_COLLECTIONS(name) ON DELETE CASCADE
);


INSERT INTO BORROWED (uniqueID, dateBorrowed, dateReturned, OCName)
VALUES
('0003','1950', null,'Metropolitan Modern Art Collection'),
('0004','1951', null,'Metropolitan Modern Art Collection');

DROP TABLE IF EXISTS DISPLAYED_IN;
CREATE TABLE DISPLAYED_IN (
    eName				varchar(200)	not null,
    eStartDate			varchar(20),
    objectID			varchar(10),
    primary key (eName, eStartDate, objectID),
    foreign key (eName, eStartDate) references EXHIBITION(name, startDate) ON DELETE CASCADE,
    foreign key (objectID) references ART_OBJECT(uniqueID) ON DELETE CASCADE
);

INSERT INTO DISPLAYED_IN (eName, eStartDate, objectID)
VALUES
('The Tudors: Art and Majesty in Renaissance England','November 10, 2023','0001'),
('Cubism and the Trompe l''Oeil Tradition','December 1, 2023','0005'),
('The Tudors: Art and Majesty in Renaissance England','November 10, 2023','0006'),
('Cubism and the Trompe l''Oeil Tradition','December 1, 2023','0007');


DROP TABLE IF EXISTS MADE_BY;
CREATE TABLE MADE_BY (
    UID					varchar(30)		not null,
    artistName			varchar(50),
    primary key (UID, artistName),
    foreign key (UID) references ART_OBJECT(uniqueID) ON DELETE CASCADE,
    foreign key (artistName) references ARTIST(name) ON DELETE CASCADE
);

INSERT INTO MADE_BY (UID, artistName)
VALUES
('0001','Hans Holbein the Younger'),
('0002','Pablo Picasso'),
('0003','Woody de Othello'),
('0004','Theaster Gates'),
('0005','John Shute'),
('0006','Benedetto da Rovezzano'),
('0007','Hans Holbein the Younger');



DROP ROLE IF EXISTS db_admin@localhost, employee@localhost, guest_role@localhost;
CREATE ROLE db_admin@localhost, employee@localhost, guest_role@localhost;

GRANT ALL PRIVILEGES ON ARTMUSEUM.* TO 'db_admin'@'localhost';
GRANT CREATE USER, ROLE_ADMIN ON *.* TO 'db_admin'@'localhost' WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON ARTMUSEUM.* TO 'employee'@'localhost';
GRANT SELECT ON ARTMUSEUM.* TO 'guest_role'@'localhost';
FLUSH PRIVILEGES;

DROP USER IF EXISTS admin@localhost;
DROP USER IF EXISTS employee1@localhost;
DROP USER IF EXISTS guest@localhost;

CREATE USER admin@localhost IDENTIFIED WITH mysql_native_password BY 'admin123';
CREATE USER employee1@localhost IDENTIFIED WITH mysql_native_password BY '123';
CREATE USER guest@localhost;

GRANT db_admin@localhost TO admin@localhost;
GRANT SELECT, INSERT, UPDATE, DELETE ON ARTMUSEUM.* TO employee1@localhost;
GRANT guest_role@localhost TO guest@localhost;

SET DEFAULT ROLE ALL TO admin@localhost, employee1@localhost, guest@localhost;