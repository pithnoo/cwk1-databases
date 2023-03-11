/*
@author Oliver Cheung

This is an sql file to put your queries for SQL coursework. 
You can write your comment in sqlite with -- or /* * /

To read the sql and execute it in the sqlite, simply
type .read sqlcwk.sql on the terminal after sqlite3 chinook.db.
*/

/* =====================================================
   WARNNIG: DO NOT REMOVE THE DROP VIEW
   Dropping existing views if exists
   =====================================================
*/

DROP VIEW IF EXISTS vCustomerPerEmployee;
DROP VIEW IF EXISTS v10WorstSellingGenres;
DROP VIEW IF EXISTS vBestSellingGenreAlbum;
DROP VIEW IF EXISTS v10BestSellingArtists;
DROP VIEW IF EXISTS vTopCustomerEachGenre;

/*
============================================================================
Question 1: Complete the query for vCustomerPerEmployee.
WARNING: DO NOT REMOVE THE STATEMENT "CREATE VIEW vCustomerPerEmployee AS"
============================================================================
*/

CREATE VIEW vCustomerPerEmployee  AS

SELECT e.LastName, e.FirstName, e.EmployeeID, COUNT(c.SupportRepId) AS TotalCustomers
FROM employees e
LEFT JOIN customers c
on e.EmployeeID = c.SupportRepiD
GROUP BY EmployeeID;

/*
============================================================================
Question 2: Complete the query for v10WorstSellingGenres.
WARNING: DO NOT REMOVE THE STATEMENT "CREATE VIEW v10WorstSellingGenres AS"
============================================================================
*/

CREATE VIEW v10WorstSellingGenres  AS

SELECT g.Name AS Genre, COUNT(c.CustomerId) AS Sales

FROM genres g
JOIN tracks t
ON g.GenreId = t.GenreId

LEFT JOIN invoice_items ii
ON ii.TrackId = t.TrackId

LEFT JOIN invoices i
ON i.InvoiceId = ii.InvoiceId

LEFT JOIN customers c
ON c.CustomerId = i.CustomerId

GROUP BY g.Name 
ORDER BY Sales ASC LIMIT 10;

/*
============================================================================
Question 3:
Complete the query for vBestSellingGenreAlbum
WARNING: DO NOT REMOVE THE STATEMENT "CREATE VIEW vBestSellingGenreAlbum AS"
============================================================================
*/

CREATE VIEW vBestSellingGenreAlbum  AS
SELECT Genre, Album, Artist, Sales
FROM(
    SELECT g.Name AS Genre,
    al.Title AS Album,
    ar.Name AS Artist,
    COUNT(c.CustomerId) AS Sales,
    ROW_NUMBER() OVER (PARTITION BY g.Name ORDER BY COUNT(c.CustomerId) DESC) AS Rank

    FROM genres g
    JOIN tracks t
    ON g.GenreId = t.GenreId

    JOIN invoice_items ii
    ON ii.TrackId = t.TrackId

    JOIN invoices i
    ON i.InvoiceId = ii.InvoiceId

    JOIN customers c
    ON c.CustomerId = i.CustomerId

    JOIN albums al
    on al.AlbumId = t.AlbumId

    JOIN artists ar
    on al.ArtistId = ar.ArtistId

    GROUP BY Album, Genre
)
WHERE Rank = 1;


/*
============================================================================
Question 4:
Complete the query for v10BestSellingArtists
WARNING: DO NOT REMOVE THE STATEMENT "CREATE VIEW v10BestSellingArtists AS"
============================================================================
*/
CREATE VIEW v10BestSellingArtists AS
SELECT Artist, TotalAlbum, TotalTrackSales
FROM(
    SELECT *
    FROM(
        SELECT ar.Name AS Artist,
        COUNT(al.AlbumId) AS TotalTrackSales

        FROM genres g
        JOIN tracks t
        ON t.GenreId = g.GenreId

        JOIN invoice_items ii
        ON ii.TrackId = t.TrackId

        JOIN albums al
        on al.AlbumId = t.AlbumId

        JOIN artists ar
        on al.ArtistId = ar.ArtistId

        GROUP BY Artist 
        ORDER BY TotalTrackSales DESC LIMIT 10
    ) t1 

    JOIN(
        SELECT art.Name AS Artist,
        COUNT(alb.albumId) AS TotalAlbum

        FROM albums alb
        JOIN artists art
        ON alb.ArtistId = art.ArtistId
        
        GROUP BY Artist
    ) t2

    ON t1.Artist = t2.Artist
);

/*
============================================================================
Question 5:
Complete the query for vTopCustomerEachGenre
WARNING: DO NOT REMOVE THE STATEMENT "CREATE VIEW vTopCustomerEachGenre AS" 
============================================================================
*/
--CREATE VIEW vTopCustomerEachGenre AS


/*
To view the created views, use SELECT * FROM views;
You can uncomment the following to look at invididual views created
*/
--SELECT * FROM vCustomerPerEmployee;
--SELECT * FROM v10WorstSellingGenres;
--SELECT * FROM vBestSellingGenreAlbum;
SELECT * FROM v10BestSellingArtists;
--SELECT * FROM vTopCustomerEachGenre;
