const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'catchme_db',
  password: 'twoje_haslo',
  port: 5432,
});

pool.connect((err) => {
    if (err) {
        console.error('Błąd połączenia z bazą PostgreSQL:', err.stack);
    } else {
        console.log('Sukces: Połączono z bazą PostgreSQL - Persistent Storage aktywne.');
    }
});

module.exports = pool;
