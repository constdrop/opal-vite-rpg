import { defineConfig } from 'vite'
import opal from 'vite-plugin-opal'

export default defineConfig({
  plugins: [
    opal({
      loadPaths: ['./app'],
      sourceMap: true,
      useBundler: false
    })
  ]
})
