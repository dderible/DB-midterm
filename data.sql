-- Author: Declan Derible

-- TABLES:
CREATE TABLE movies (
    title TEXT,
    year INT,
    genre TEXT,
    director TEXT,
    id SERIAL PRIMARY KEY
);

CREATE TABLE customers (
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    phone_number TEXT,
    id SERIAL PRIMARY KEY
);

CREATE TABLE rentals (
    movie_id INT REFERENCES movies(id),
    customer_id INT REFERENCES customers(id),
    rent_date DATE,
    return_date DATE
);

-- INSERTED INFORMATION:
INSERT INTO movies (title, year, genre, director, id) VALUES
    ('Avengers: Infinity War', 2018, 'Sci-Fi', 'Russo Brothers', 1),
    ('Spongebob Squarepants Movie', 2004, 'Family', 'Stephen Hillenburg', 2),
    ('Five Nights at Freddys', 2023, 'Horror', 'Emma Tammi', 3),
    ('Super Mario Bros. Movie', 2023, 'Comedy', 'Aaron Horvath', 4),
    ('Bullet Train', 2022, 'Action', 'David Leitch', 5);

INSERT INTO customers (first_name, last_name, email, phone_number, id) VALUES
    ('Declan', 'Derible', 'declan.derible@keyin.com', '111-1111', 1),
    ('Evan', 'Morris', 'evan.morris@keyin.com', '222-2222', 2),
    ('Connor', 'Andrews', 'connor.andrews@keyin.com', '333-3333', 3),
    ('Tristan', 'Greening', 'tristan.greening@keyin.com', '444-4444', 4),
    ('Chris', 'Stoyles', 'chris.stoyles@keyin.com', '555-5555', 5);

INSERT INTO rentals (movie_id, customer_id, rent_date, return_date) VALUES
    (1, 1, '2024-10-29', '2024-11-01'),
    (2, 2, '2024-01-06', '2024-01-12'),
    (3, 3, '2024-05-14', '2024-05-16'),
    (4, 4, '2024-08-12', '2024-08-16'),
    (5, 5, '2024-04-20', '2024-04-23'),
    (1, 4, '2024-09-01', '2024-09-08'),
    (2, 3, '2024-11-03', '2024-11-10'),
    (3, 1, '2024-03-16', '2024-03-18'),
    (4, 5, '2024-08-17', '2024-08-22'),
    (5, 2, '2024-02-29', '2024-03-03');

-- SQL QUERIES:
-- SEARCH VIA EMAIL:
SELECT movies.title
FROM customers
JOIN rentals ON customers.id = rentals.customer_id
JOIN movies ON movies.id = rentals.movie_id
WHERE customers.email = 'declan.derible@keyin.com';

-- SEARCH VIA MOVIE RENTAL LIST:
SELECT customers.first_name || ' ' || customers.last_name || ', ID= ' || customers.id as movie5_rentals
FROM customers
JOIN rentals ON customers.id = rentals.customer_id
JOIN movies ON movies.id = rentals.movie_id
WHERE movie_id = 5;

-- MOVIE RENTAL HISTORY:
SELECT customers.first_name || ' ' || customers.last_name || ', ID= ' || customers.id as rental_history_name
SELECT rentals.rent_date || ' to ' || rentals.return_date as rental_history_dates
FROM movies
JOIN rentals ON movies.id = rentals.customer_id
JOIN customers ON customers.id = rentals.movie_id
where movies.title = 'Avengers: Infinity War';

-- SEARCH VIA DIRECTOR:
SELECT customers.first_name || ' - Rented Movie(s): ' || movies.title as director_search
FROM movies
JOIN rentals ON movies.id = rentals.customer_id
JOIN customers ON customers.id = rentals.movie_id
WHERE movies.director = 'Emma Tammi';

-- UNRETURNED MOVIES:
SELECT customers.first_name || ' ' || customers.last_name || ', ID= ' || customers.id as customer_name
SELECT rentals.rent_date || ' to ' || rentals.return_date as customer_rental_dates
JOIN rentals ON movies.id = rentals.customer_id
JOIN customers ON customers.id = rentals.movie_id
WHERE rentals.return_date > CURRENT_DATE;