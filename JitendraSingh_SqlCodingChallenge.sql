--NAME : JITENDRA SINGH

--Coding Challenge SQL
--Virtual Art Gallery Shema DDL and DML

CREATE TABLE Artists (
 ArtistID INT PRIMARY KEY,
 Name VARCHAR(255) NOT NULL,
 Biography TEXT,
 Nationality VARCHAR(100));


CREATE TABLE Categories (
 CategoryID INT PRIMARY KEY,
 Name VARCHAR(100) NOT NULL);


 CREATE TABLE Artworks (
 ArtworkID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 ArtistID INT,
 CategoryID INT,
 Year INT,
 Description TEXT,
 ImageURL VARCHAR(255),
 FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
 FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID));


 CREATE TABLE Exhibitions (
 ExhibitionID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 StartDate DATE,
 EndDate DATE,
 Description TEXT);


 CREATE TABLE ExhibitionArtworks (
 ExhibitionID INT,
 ArtworkID INT,
 PRIMARY KEY (ExhibitionID, ArtworkID),
 FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
 FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID));


 -- Insert sample data into the Artists table
INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES
 (1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
 (2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
 (3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');

-- Insert sample data into the Categories table
INSERT INTO Categories (CategoryID, Name) VALUES
 (1, 'Painting'),
 (2, 'Sculpture'),
 (3, 'Photography');

-- Insert sample data into the Artworks table
INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
 (1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
 (2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
 (3, 'Guernica', 1, 1, 1937, 'Pablo Picasso\''s powerful anti-war mural.', 'guernica.jpg');

-- Insert sample data into the Exhibitions table
INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES
 (1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
 (2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');

-- Insert artworks into exhibitions
INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
 (1, 1),
 (1, 2),
 (1, 3),
 (2, 2);

 SELECT * From Artists;
 SELECT * From Artworks;
 SELECT * From Categories;
 SELECT * From Exhibitions;
 SELECT * From ExhibitionArtworks;


--1. Retrieve the names of all artists along with the number of artworks they have in the gallery, and
--list them in descending order of the number of artworks.

SELECT A.Name AS ArtistName, COUNT(*) AS NumberOfArtworks
FROM Artists A
JOIN Artworks AW ON A.ArtistID = AW.ArtistID
GROUP BY A.ArtistID, A.Name
ORDER BY NumberOfArtworks DESC;

--2. List the titles of artworks created by artists from 'Spanish' and 'Dutch' nationalities, and order
--them by the year in ascending order.

SELECT aw.Title, aw.Year 
FROM Artworks aw
JOIN Artists a ON aw.ArtistID = a.ArtistID
WHERE a.Nationality IN ('Spanish','Dutch')
ORDER BY aw.Year;


--3. Find the names of all artists who have artworks in the 'Painting' category, and the number of
--artworks they have in this category.

SELECT A.ArtistID, A.Name AS ArtistName, COUNT(*) AS NumberOfArtworks
FROM Artists A
JOIN Artworks AW ON A.ArtistID = AW.ArtistID
JOIN Categories C ON AW.CategoryID = C.CategoryID
WHERE C.Name = 'Painting'
GROUP BY A.ArtistID, A.Name;

--4. List the names of artworks from the 'Modern Art Masterpieces' exhibition, along with their
--artists and categories.

SELECT A.Name AS ArtistName, AW.Title, C.Name AS Category
FROM Artists A
JOIN Artworks AW ON A.ArtistID = AW.ArtistID
JOIN ExhibitionArtworks EA ON AW.ArtworkID = EA.ArtworkID
JOIN Exhibitions E ON EA.ExhibitionID = E.ExhibitionID
JOIN Categories C ON AW.CategoryID = C.CategoryID
WHERE E.Title = 'Modern Art Masterpieces';


--5. Find the artists who have more than two artworks in the gallery.

SELECT a.ArtistID, a.Name AS ArtistName, COUNT(aw.ArtistID) AS NumberOfArtWorks
FROM Artists a
JOIN Artworks aw ON a.ArtistID = aw.ArtistID
GROUP BY a.ArtistID, a.Name
HAVING COUNT(aw.ArtistID) > 2;

--6. Find the titles of artworks that were exhibited in both 'Modern Art Masterpieces' and
--'Renaissance Art' exhibitions

SELECT aw.Title FROM Artworks aw
JOIN ExhibitionArtworks ew ON aw.ArtworkID = ew.ArtworkID
JOIN Exhibitions e ON ew.ExhibitionID = e.ExhibitionID
WHERE e.Title IN ('Modern Art Masterpieces', 'Renaissance Art')
GROUP BY aw.Title
HAVING COUNT(DISTINCT e.Title) = 2


--7. Find the total number of artworks in each category
 
SELECT c.CategoryID,c.Name, COUNT(aw.ArtworkID) AS NumberOfArtworks
FROM Categories c
LEFT JOIN Artworks aw ON c.CategoryID = aw.CategoryID
GROUP BY c.CategoryID,c.Name

--8. List artists who have more than 3 artworks in the gallery.
 
SELECT a.ArtistID,a.Name
FROM Artists a
JOIN Artworks aw ON a.ArtistID = aw.ArtistID
GROUP BY a.ArtistID,a.Name
HAVING COUNT(a.ArtistID) > 3;

--9. Find the artworks created by artists from a specific nationality (e.g., Spanish).

SELECT aw.Title,a.Name 
FROM Artworks aw
JOIN Artists a ON aw.ArtistID = a.ArtistID
WHERE a.Nationality = 'Spanish'

--10. List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci
 
SELECT E.Title
FROM Exhibitions E
JOIN ExhibitionArtworks EA ON E.ExhibitionID = EA.ExhibitionID
JOIN Artworks AW ON EA.ArtworkID = AW.ArtworkID
JOIN Artists A ON AW.ArtistID = A.ArtistID
WHERE A.Name IN ('Vincent van Gogh', 'Leonardo da Vinci')
GROUP BY E.ExhibitionID, E.Title
HAVING COUNT(DISTINCT A.Name) = 2;

--11. Find all the artworks that have not been included in any exhibition.

SELECT aw.ArtworkID,aw.Title
FROM Artworks aw
LEFT JOIN ExhibitionArtworks ea ON aw.ArtworkID = ea.ArtworkID
WHERE aw.ArtworkID is NULL;

--12. List artists who have created artworks in all available categories.

SELECT A.Name AS ArtistName
FROM Artists A
JOIN Artworks AW ON A.ArtistID = AW.ArtistID
JOIN Categories C ON AW.CategoryID = C.CategoryID
GROUP BY A.ArtistID, A.Name
HAVING COUNT(DISTINCT C.CategoryID) = (SELECT COUNT(*) FROM Categories);

--13. List the total number of artworks in each category.

SELECT c.CategoryID,c.Name,COUNT(aw.CategoryID) AS TotalNumberOfArtworks
FROM Categories c
LEFT JOIN Artworks aw ON c.CategoryID = aw.CategoryID
GROUP BY c.CategoryID,c.Name


--14. Find the artists who have more than 2 artworks in the gallery.
 
SELECT a.ArtistID,a.Name FROM Artists a
JOIN Artworks aw ON a.ArtistID =aw.ArtistID
GROUP BY a.ArtistID,a.Name
HAVING COUNT(a.ArtistID) > 2


--15.List the categories with the average year of artworks they contain, only for categories with more
--than 1 artwork.
 
SELECT c.CategoryID, c.Name AS CategoryName, AVG(aw.Year) AS AverageYear
FROM Categories c
JOIN Artworks aw ON c.CategoryID = aw.CategoryID
GROUP BY c.CategoryID, c.Name
HAVING COUNT(aw.ArtworkID) > 1;

--16. Find the artworks that were exhibited in the 'Modern Art Masterpieces' exhibition.

SELECT aw.ArtworkID,aw.Title  
FROM Artworks aw
JOIN ExhibitionArtworks ea ON aw.ArtworkID =ea.ArtworkID
JOIN Exhibitions e ON ea.ExhibitionID =e.ExhibitionID
WHERE e.Title = 'Modern Art Masterpieces' 

--17. Find the categories where the average year of artworks is greater than the average year of all
--artworks.
 
SELECT c.CategoryID, c.Name AS CategoryName, AVG(aw.Year) AS CategoryAverageYear, AVG(aw.Year) AS OverallAverageYear
FROM Categories c
JOIN Artworks aw ON c.CategoryID = aw.CategoryID
GROUP BY c.CategoryID, c.Name
HAVING AVG(aw.Year) > (SELECT AVG(Year) FROM Artworks);

--18. List the artworks that were not exhibited in any exhibition.

SELECT aw.ArtworkID,aw.Title
FROM Artworks aw
WHERE aw.ArtworkID NOT IN
(SELECT ArtworkID FROM ExhibitionArtworks);


--19. Show artists who have artworks in the same category as "Mona Lisa."

SELECT DISTINCT a.ArtistID,a.Name
FROM Artists a
JOIN Artworks aw ON a.ArtistID = aw.ArtistID
JOIN Categories c ON aw.CategoryID = c.CategoryID
WHERE c.CategoryID =
(SELECT aw.CategoryID 
FROM Artworks aw 
WHERE aw.Title='Mona Lisa')

--20. List the names of artists and the number of artworks they have in the gallery.
 
 SELECT a.ArtistID,a.Name,COUNT(aw.ArtworkID) AS NumberOfArtWorks
 FROM Artists a
 LEFT JOIN Artworks aw ON a.ArtistID = aw.ArtistID
 GROUP BY a.ArtistID, a.Name

 
 
