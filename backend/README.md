SmartWatt backend (minimal)

This is a tiny Express server used for demoing login/register for the SmartWatt app.
It uses SQLite and issues JWT tokens for authentication.

Setup

1. Copy `.env.example` to `.env` and set `JWT_SECRET` to a strong value.
2. Install dependencies:

```pwsh
cd backend
npm install
```

3. Run the server:

```pwsh
npm start
```

Endpoints

- POST /register { email, password } -> 201 { id, email, token }
- POST /login { email, password } -> 200 { id, email, token }
- GET /me Authorization: Bearer <token> -> 200 { id, email, createdAt }

Note: For production, use a managed DB, stronger key storage, refresh tokens, HTTPS, rate limiting, input validation, and other security hardening.
