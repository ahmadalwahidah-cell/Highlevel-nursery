import { defineConfig } from 'vite'
import pages from '@hono/vite-cloudflare-pages'

export default defineConfig({
  plugins: [
    pages({
      // استثناء ملفات PWA والصفحات الثابتة من routes.json
      exclude: [
        '/manifest.json', 
        '/sw.js', 
        '/favicon.ico', 
        '/install-help.html',
        '/test-security.html',
        '/test-attendance.html',
        '/security-test.html',
        '/fingerprint-update-guide.html'
      ]
    })
  ],
  build: {
    outDir: 'dist',
    minify: 'terser',
    terserOptions: {
      compress: {
        drop_console: true,
        drop_debugger: true,
        pure_funcs: ['console.log', 'console.info']
      }
    },
    rollupOptions: {
      output: {
        manualChunks: undefined
      }
    }
  }
})
