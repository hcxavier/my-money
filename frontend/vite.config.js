import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [
    react(),
    tailwindcss(),
  ],
  server: {
    proxy: {
      '/auth': 'http://localhost:3000',
      '/users': 'http://localhost:3000',
      '/transactions': 'http://localhost:3000',
      '/metrics': 'http://localhost:3000',
      '/o': 'http://localhost:3000',
      '/media': 'http://localhost:3000',
    }
  }
})
