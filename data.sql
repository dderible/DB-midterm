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
    id SERIAL PRIMARY KEY,
    movie_id INT REFERENCES movies(id),
    customer_id INT REFERENCES customers(id),
    rent_date DATE,
    return_date DATE
);