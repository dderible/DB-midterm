const { Pool } = require('pg');

// PostgreSQL connection
const pool = new Pool({
  user: 'postgres', //This _should_ be your username, as it's the default one Postgres uses
  host: 'localhost',
  database: 'Sprint', //This should be changed to reflect your actual database
  password: 'Dog43656', //This should be changed to reflect the password you used when setting up Postgres
  port: 5432,
});

/**
 * Creates the database tables, if they do not already exist.
 */
async function createTable() {
  const tables = `

    CREATE TABLE IF NOT EXISTS movies (
      title TEXT,
      year INT,
      genre TEXT,
      director TEXT,
      id SERIAL PRIMARY KEY
    );

    CREATE TABLE IF NOT EXISTS customers (
      first_name TEXT,
      last_name TEXT,
      email TEXT,
      phone_number TEXT,
      id SERIAL PRIMARY KEY
    );

    CREATE TABLE IF NOT EXISTS rentals (
      customer_id INT REFERENCES customers(id),
      movie_id INT REFERENCES movies(id),
      rent_date DATE,
      return_date DATE
    );
  `
};

/**
 * Inserts a new movie into the Movies table.
 * 
 * @param {string} title Title of the movie
 * @param {number} year Year the movie was released
 * @param {string} genre Genre of the movie
 * @param {string} director Director of the movie
 */
async function insertMovie(title, year, genre, director) {
  const movieadd = {
    text: 'INSERT INTO movies (title, year, genre, director) VALUES ($1, $2, $3, $4)',
    values: [title, year, genre, director],
  };
};

/**
 * Prints all movies in the database to the console
 */
async function displayMovies() {
  const movieList = 'SELECT * FROM movies'
  try {

    const result = await pool.query(movieList);

    if (result.rows.length > 0) {
      result.rows.forEach((row) => {
        console.log(
          `${row.id}: MOVIE: ${row.movie_title} YEAR: ${row.movie_year} GENRE: ${row.movie_genre} DIRECTOR: ${row.movie_director}`
        );
      });
    } else {
      console.log("ERROR: No Movies In Database!");
    }} catch (error) {
      console.error("ERROR: Cannot Load Movie Contents!");
    };
};

/**
 * Updates a customer's email address.
 * 
 * @param {number} customerId ID of the customer
 * @param {string} newEmail New email address of the customer
 */
async function updateCustomerEmail(customerId, newEmail) {
  const email = {
    text: 'UPDATE customers SET id = $1 WHERE email = $2',
    values: [customerId, newEmail],
  };
};

/**
 * Removes a customer from the database along with their rental history.
 * 
 * @param {number} customerId ID of the customer to remove
 */
async function removeCustomer(customerId) {
  const customer = {
    text: 'DELETE FROM rentals WHERE customer_id = $1',
    values: [customerId],
  };

  const rentals = {
    text: 'DELETE FROM customers WHERE id = $1',
    values: [customerId],
  }
};

/**
 * Prints a help message to the console
 */
function printHelp() {
  console.log('Usage:');
  console.log('  insert <title> <year> <genre> <director> - Insert a movie');
  console.log('  show - Show all movies');
  console.log('  update <customer_id> <new_email> - Update a customer\'s email');
  console.log('  remove <customer_id> - Remove a customer from the database');
}

/**
 * Runs our CLI app to manage the movie rentals database
 */
async function runCLI() {
  await createTable();

  const args = process.argv.slice(2);
  switch (args[0]) {
    case 'insert':
      if (args.length !== 5) {
        printHelp();
        return;
      }
      await insertMovie(args[1], parseInt(args[2]), args[3], args[4]);
      break;
    case 'show':
      await displayMovies();
      break;
    case 'update':
      if (args.length !== 3) {
        printHelp();
        return;
      }
      await updateCustomerEmail(parseInt(args[1]), args[2]);
      break;
    case 'remove':
      if (args.length !== 2) {
        printHelp();
        return;
      }
      await removeCustomer(parseInt(args[1]));
      break;
    default:
      printHelp();
      break;
  }
};

runCLI();
