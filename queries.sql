#01:
SELECT
  TABLE_NAME, COLUMN_NAME, DATA_TYPE, COLUMN_KEY
FROM
  INFORMATION_SCHEMA.COLUMNS
WHERE
  TABLE_SCHEMA IN ('ARTMUSEUM');

#02:
SELECT * FROM ART_OBJECT
WHERE uniqueID='0007';

#03:
SELECT * FROM PERMANENT_COLLECTION
ORDER BY dateAcquired ASC;

#04:
SELECT *
FROM ART_OBJECT
WHERE uniqueID IN (
SELECT uniqueID
FROM PAINTING) ;

#05:
SELECT distinct art_object.uniqueID, year, art_object.countryOrigin, art_object.epoch, title, art_object.description, style 
FROM art_object 
JOIN made_by ON art_object.uniqueID = made_by.UID 
JOIN artist ON made_by.artistName = artistName 
WHERE artistName = 'Pablo Picasso';

#06:
UPDATE PERMANENT_COLLECTION
SET Status="On Display"
WHERE uniqueID='0002';

#07: - here the referential trigger from the foreign key gets rid of the object in all other tables
DELETE FROM art_object where uniqueID='0003';
