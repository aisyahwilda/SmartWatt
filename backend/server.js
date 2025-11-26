require("dotenv").config();
const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const sqlite3 = require("sqlite3").verbose();
const path = require("path");
const bodyParser = require("body-parser");
const cors = require("cors");

const DB_PATH = path.resolve(__dirname, "data.sqlite");
const db = new sqlite3.Database(DB_PATH);

const JWT_SECRET = process.env.JWT_SECRET || "dev_secret_change_me";
const PORT = process.env.PORT || 8080;

// Initialize tables
db.serialize(() => {
  db.run(`
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      email TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  `);
});

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Register
app.post("/register", (req, res) => {
  const { email, password } = req.body || {};
  if (!email || !password)
    return res.status(400).json({ error: "email and password required" });

  const hashed = bcrypt.hashSync(password, 10);
  const stmt = db.prepare("INSERT INTO users (email, password) VALUES (?, ?)");
  stmt.run(email, hashed, function (err) {
    if (err) {
      if (err.code === "SQLITE_CONSTRAINT_UNIQUE") {
        return res.status(409).json({ error: "Email already registered" });
      }
      console.error(err);
      return res.status(500).json({ error: "Database error" });
    }

    const id = this.lastID;
    const token = jwt.sign({ sub: id, email }, JWT_SECRET, { expiresIn: "7d" });
    res.status(201).json({ id, email, token });
  });
  stmt.finalize();
});

// Login
app.post("/login", (req, res) => {
  const { email, password } = req.body || {};
  if (!email || !password)
    return res.status(400).json({ error: "email and password required" });

  db.get(
    "SELECT id, email, password FROM users WHERE email = ?",
    [email],
    (err, row) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: "Database error" });
      }
      if (!row) return res.status(401).json({ error: "Invalid credentials" });

      const match = bcrypt.compareSync(password, row.password);
      if (!match) return res.status(401).json({ error: "Invalid credentials" });

      const token = jwt.sign({ sub: row.id, email: row.email }, JWT_SECRET, {
        expiresIn: "7d",
      });
      res.json({ id: row.id, email: row.email, token });
    }
  );
});

// Protected: get current user (token in Authorization: Bearer <token>)
app.get("/me", (req, res) => {
  const auth = req.headers.authorization || "";
  const m = auth.match(/^Bearer (.+)$/);
  if (!m) return res.status(401).json({ error: "Missing token" });
  const token = m[1];
  try {
    const payload = jwt.verify(token, JWT_SECRET);
    const userId = payload.sub;
    db.get(
      "SELECT id, email, created_at FROM users WHERE id = ?",
      [userId],
      (err, row) => {
        if (err) return res.status(500).json({ error: "Database error" });
        if (!row) return res.status(404).json({ error: "User not found" });
        res.json({ id: row.id, email: row.email, createdAt: row.created_at });
      }
    );
  } catch (e) {
    return res.status(401).json({ error: "Invalid token" });
  }
});

app.listen(PORT, () => {
  console.log(`SmartWatt backend listening on http://localhost:${PORT}`);
});
