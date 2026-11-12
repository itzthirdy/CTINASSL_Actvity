#!/usr/bin/env bash
set -e

# Name of your root monorepo directory
PROJECT_NAME="CTINASSL_Activity"

echo "Initializing MERN + TypeScript monorepo directory: $PROJECT_NAME..."

# 1. Initialize root Git repository
git init -b main

# 2. Setup Frontend (React + Vite + TypeScript with npm)
echo "Scaffolding React + TypeScript frontend..."
npm create vite@latest frontend -- --template react-ts --no-interactive
rm -rf frontend/.git

cd frontend
npm install
npm install axios
mkdir -p src/{components,pages,services,hooks,context}

cat << 'EOF' > src/services/api.ts
import axios from "axios";

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL ?? "http://localhost:8000/api",
  withCredentials: true,
});

export default api;
EOF

cat << 'EOF' > .env
VITE_API_URL=http://localhost:8000/api
EOF

cp .env .env.example
cd ..

# 3. Setup Backend (Node.js + Express + Mongoose + TypeScript with npm)
echo "Scaffolding Express + TypeScript backend..."
mkdir -p backend/src/{config,routes,controllers,services,models,middleware}
cd backend

# Initialize backend package.json
npm init -y

# Install backend dependencies and TypeScript tooling
npm install express mongoose cors dotenv
npm install -D typescript tsx @types/node @types/express @types/cors

# Configure package.json
cat << 'EOF' > package.json
{
  "name": "backend",
  "version": "1.0.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "tsx watch src/server.ts",
    "build": "tsc",
    "start": "node dist/server.js",
    "typecheck": "tsc --noEmit"
  },
  "dependencies": {
    "cors": "^2.8.6",
    "dotenv": "^18.0.10",
    "express": "^5.3.0",
    "mongoose": "^9.12.1"
  },
  "devDependencies": {
    "@types/cors": "^2.8.19",
    "@types/express": "^5.0.6",
    "@types/node": "^26.6.6",
    "tsx": "^4.23.15",
    "typescript": "^7.0.2"
  }
}
EOF

# Create tsconfig.json
cat << 'EOF' > tsconfig.json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "rootDir": "./src",
    "outDir": "./dist",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src/**/*"]
}
EOF

# Create src/app.ts
cat << 'EOF' > src/app.ts
import express, { Request, Response } from "express";
import cors from "cors";

const app = express();

app.use(cors({
  origin: process.env.FRONTEND_ORIGIN ?? "http://localhost:5173",
  credentials: true,
}));

app.use(express.json());

app.get("/api/health", (_req: Request, res: Response) => {
  res.json({ status: "ok" });
});

export default app;
EOF

# Create src/config/database.ts
cat << 'EOF' > src/config/database.ts
import mongoose from "mongoose";

export async function connectDatabase(): Promise<void> {
  const uri = process.env.MONGODB_URI;

  if (!uri) {
    throw new Error("MONGODB_URI is required");
  }

  await mongoose.connect(uri);
  console.log("MongoDB connected");
}
EOF

# Create src/server.ts
cat << 'EOF' > src/server.ts
import "dotenv/config";
import app from "./app.js";
import { connectDatabase } from "./config/database.js";

const port = Number(process.env.PORT ?? 8000);

async function startServer(): Promise<void> {
  try {
    await connectDatabase();

    app.listen(port, () => {
      console.log(`API running on http://localhost:${port}`);
    });
  } catch (error) {
    console.error("Failed to start backend:", error);
    process.exit(1);
  }
}

startServer();
EOF

# Create backend .env and .env.example
cat << 'EOF' > .env
PORT=8000
FRONTEND_ORIGIN=http://localhost:5173
MONGODB_URI=mongodb://127.0.0.1:27017/ctinassl_activity
EOF

cp .env .env.example

# Create backend .gitignore
cat << 'EOF' > .gitignore
node_modules/
.env
dist/
EOF

cd ..

# 4. Root Repository Configuration
cat << 'EOF' > .gitignore
node_modules/
.env
.env.local
.DS_Store
dist/
EOF

cat << 'EOF' > README.md
# MERN + TypeScript Monorepo

## Structure
- \`frontend/\`: React (Vite, TypeScript, Axios)
- \`backend/\`: Express.js, TypeScript, Mongoose, Node.js runtime

## Development

### Frontend
\`\`\`bash
cd frontend
npm run dev
\`\`\`

### Backend
\`\`\`bash
cd backend
npm run dev
\`\`\`
EOF

echo "MERN setup complete!"

