# CTINASSL Activity — MERN + TypeScript Monorepo

> Information Assurance and Security | MERN Stack Activity

This repository contains a full-stack **MERN** application initialized with complete **TypeScript** support across both frontend and backend services.

---

## System Architecture & Current State

The project is structured as a monorepo consisting of:

```
CTINASSL_Activity/
├── backend/                  # Express.js REST API
│   ├── src/
│   │   ├── config/          # Database configuration (MongoDB / Mongoose)
│   │   ├── controllers/     # Request handlers (ready for implementation)
│   │   ├── middleware/      # Custom middleware (auth, validation, etc.)
│   │   ├── models/          # Mongoose schema models
│   │   ├── routes/          # API route definitions
│   │   ├── services/        # Business logic services
│   │   ├── app.ts           # Express application configuration & CORS
│   │   └── server.ts        # Server entry point & DB connection lifecycle
│   ├── .env.example         # Backend environment variable template
│   ├── package.json         # Backend dependencies & scripts
│   └── tsconfig.json        # TypeScript configuration (NodeNext)
├── frontend/                 # React SPA (Vite + TypeScript)
│   ├── src/
│   │   ├── assets/          # Static assets (images, icons)
│   │   ├── components/      # Reusable UI components
│   │   ├── context/         # React Context providers (auth, state)
│   │   ├── hooks/           # Custom React hooks
│   │   ├── pages/           # Application views/pages
│   │   ├── services/        # API client services (Axios instance configured)
│   │   ├── App.tsx          # Main React root component
│   │   └── main.tsx         # React DOM entry point
│   ├── .env.example         # Frontend environment variable template
│   ├── package.json         # Frontend dependencies & scripts
│   └── vite.config.ts       # Vite bundler configuration
├── mernsetup.sh              # Monorepo scaffolding and setup automation script
└── README.md                 # Project documentation
```

### What is currently implemented:
- **Backend**:
  - Express 5 application setup with CORS configured for frontend interaction.
  - TypeScript runtime execution via `tsx` with hot-reloading for development.
  - MongoDB connection handler via Mongoose (`backend/src/config/database.ts`).
  - Active Health Check endpoint: `GET /api/health` returning `{"status": "ok"}`.
  - Modular directory structure for controllers, services, routes, models, and middleware.
- **Frontend**:
  - React 19 bundled with Vite 8 and TypeScript.
  - Pre-configured Axios HTTP client instance in `frontend/src/services/api.ts` with base URL and cookie credentials enabled.
  - Clean modular directory layout ready for page views, UI components, and state management.

---

## Prerequisites

Ensure you have the following installed on your machine:
- **Node.js**: `v18.0.0` or higher (v20+ recommended)
- **npm**: `v9.0.0` or higher
- **MongoDB**: A running local MongoDB instance (`mongodb://127.0.0.1:27017`) or a [MongoDB Atlas](https://www.mongodb.com/atlas) cluster connection string.

---

## Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/Teeey/CTINASSL_Activity.git
cd CTINASSL_Activity
```

### 2. Configure Environment Variables

#### Backend Environment
Create a `.env` file in the `backend/` directory:
```bash
cp backend/.env.example backend/.env
```
Default configuration (`backend/.env`):
```env
PORT=8000
FRONTEND_ORIGIN=http://localhost:5173
MONGODB_URI=mongodb://127.0.0.1:27017/ctinassl_activity
```
*(If using MongoDB Atlas, replace `MONGODB_URI` with your connection URI).*

#### Frontend Environment
Create a `.env` file in the `frontend/` directory:
```bash
cp frontend/.env.example frontend/.env
```
Default configuration (`frontend/.env`):
```env
VITE_API_URL=http://localhost:8000/api
```

---

### 3. Install Dependencies

You must install dependencies for both the `backend` and `frontend`:

#### Install Backend Dependencies
```bash
cd backend
npm install
cd ..
```

#### Install Frontend Dependencies
```bash
cd frontend
npm install
cd ..
```

---

## Running the Application

For development, run the backend and frontend in separate terminal windows:

### Terminal 1: Backend
```bash
cd backend
npm run dev
```
- API will start on: `http://localhost:8000`
- MongoDB will automatically connect using `MONGODB_URI`.
- Test the health endpoint:
  ```bash
  curl http://localhost:8000/api/health
  # Response: {"status":"ok"}
  ```

### Terminal 2: Frontend
```bash
cd frontend
npm run dev
```
- Frontend dev server will start on: `http://localhost:5173`
- Open [http://localhost:5173](http://localhost:5173) in your browser.

---

## Available Scripts

### Backend (`cd backend`)
| Command | Description |
| :--- | :--- |
| `npm run dev` | Starts server with live reload via `tsx watch` |
| `npm run build` | Compiles TypeScript to `dist/` |
| `npm run start` | Runs compiled code from `dist/server.js` |
| `npm run typecheck` | Checks TypeScript types without emitting files |

### Frontend (`cd frontend`)
| Command | Description |
| :--- | :--- |
| `npm run dev` | Starts the Vite development server with HMR |
| `npm run build` | Typechecks and compiles production bundle to `dist/` |
| `npm run preview` | Previews the production build locally |
| `npm run lint` | Lints code using Oxlint |
