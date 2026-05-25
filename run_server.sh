#!/bin/bash

cleanup() {
    echo "Stopping servers..."
    kill "$BACKEND_PID" "$FRONTEND_PID" 2>/dev/null
    exit
}

trap cleanup SIGINT SIGTERM EXIT

echo "1. Starting Django backend server on http://localhost:3000..."
cd api

bash run_server.sh &
BACKEND_PID=$!

echo "2. Starting Vite React frontend server..."
cd ../frontend

npm run dev &
FRONTEND_PID=$!

wait
