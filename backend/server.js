require('dotenv').config();
const express = require('express');
const mysql = require('mysql2');
const helmet = require('helmet');
const morgan = require('morgan');
const promClient = require('prom-client');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const app = express();

app.use(helmet());
app.use(morgan('combined'));
app.use(express.json());

// Prometheus metrics
const collectDefaultMetrics = promClient.collectDefaultMetrics;
collectDefaultMetrics();

app.get('/metrics', async (req, res) => {
  try {
    res.set('Content-Type', promClient.register.contentType);
    res.end(await promClient.register.metrics());
  } catch (ex) {
    res.status(500).end(ex);
  }
});

const db = mysql.createConnection({
  host: process.env.MYSQL_HOST || 'mysql-db',
  user: process.env.MYSQL_USER || 'root',
  password: process.env.MYSQL_ROOT_PASSWORD,
  database: process.env.MYSQL_DATABASE || 'lab_db'
});

db.connect(err => {
  if (err) {
    console.error('Error connecting to MySQL:', err);
    process.exit(1);
  }
  console.log('Connected to MySQL');
  // Create users table if not exists
  db.query(`CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
  )`, (err) => {
    if (err) {
      console.error('Error creating users table:', err);
      process.exit(1);
    }
    console.log('Users table ready');
  });
});

app.get('/', (req, res) => {
  res.send('Node.js & MySQL Lab Running on Azure');
});

app.get('/health', (req, res) => {
  res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});

// Show safe environment info (no secrets)
app.get('/env', (req, res) => {
  res.json({
    NODE_ENV: process.env.NODE_ENV,
    MYSQL_HOST: process.env.MYSQL_HOST,
    MYSQL_USER: process.env.MYSQL_USER,
    MYSQL_DATABASE: process.env.MYSQL_DATABASE,
    PORT: process.env.PORT
  });
});

// User registration
app.post('/register', async (req, res) => {
  const { username, password } = req.body;
  if (!username || !password) {
    return res.status(400).json({ error: 'Username and password required' });
  }
  const hashedPassword = await bcrypt.hash(password, 10);
  db.query('INSERT INTO users (username, password) VALUES (?, ?)', [username, hashedPassword], (err, result) => {
    if (err) {
      if (err.code === 'ER_DUP_ENTRY') {
        return res.status(409).json({ error: 'Username already exists' });
      }
      return res.status(500).json({ error: 'Database error', details: err });
    }
    res.status(201).json({ message: 'User registered' });
  });
});

// User login
app.post('/login', (req, res) => {
  const { username, password } = req.body;
  if (!username || !password) {
    return res.status(400).json({ error: 'Username and password required' });
  }
  db.query('SELECT * FROM users WHERE username = ?', [username], async (err, results) => {
    if (err) return res.status(500).json({ error: 'Database error', details: err });
    if (results.length === 0) return res.status(401).json({ error: 'Invalid credentials' });
    const user = results[0];
    const valid = await bcrypt.compare(password, user.password);
    if (!valid) return res.status(401).json({ error: 'Invalid credentials' });
    const token = jwt.sign({ id: user.id, username: user.username }, process.env.JWT_SECRET || 'secret', { expiresIn: '1h' });
    res.json({ token });
  });
});

// Example protected endpoint
app.get('/profile', (req, res) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  if (!token) return res.status(401).json({ error: 'No token provided' });
  jwt.verify(token, process.env.JWT_SECRET || 'secret', (err, user) => {
    if (err) return res.status(403).json({ error: 'Invalid token' });
    res.json({ id: user.id, username: user.username });
  });
});

const port = process.env.PORT || 4000;
const server = app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});

// Graceful shutdown
process.on('SIGTERM', shutdown);
process.on('SIGINT', shutdown);

function shutdown() {
  console.log('Shutting down server...');
  server.close(() => {
    db.end(() => {
      console.log('MySQL connection closed.');
      process.exit(0);
    });
  });
}
