const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

const db_config = {
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'track_app'
};

function connectToMySQL() {
  return mysql.createConnection(db_config);
}

app.get('/', (req, res) => {
  res.sendFile('index.html', { root: __dirname });
});

app.get('/register', (req, res) => {
  res.sendFile('register.html', { root: __dirname });
});

app.post('/get_data', (req, res) => {
  let data = 'No records';
  const { time, stop } = req.body;

  const conn = connectToMySQL();
  const query = 'SELECT bus FROM bus_data WHERE time = ? AND stops LIKE ?';

  conn.query(query, [time,stop], (err, result) => {
    if (err) throw err;
    data = result;
    conn.end();
    console.log(data[0]['bus']);
    res.send(data[0]['bus']);
  });
});

app.post('/insert_data', (req, res) => {
  const { date, time, stop, bus } = req.body;
  const user_data = { date, time, stop, bus };

  const conn = connectToMySQL();
  const query = 'INSERT INTO bus_data (date, time, stop, bus) VALUES (?, ?, ?, ?)';
  conn.query(query, [date, time, stop, bus], (err, result) => {
    if (err) throw err;
    conn.end();
    res.send(result);
  });
});

app.listen(5000,"192.168.69.149", () => {
  console.log('Server running on port 5000');
});
