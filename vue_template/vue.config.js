const { defineConfig } = require("@vue/cli-service");
module.exports = defineConfig({
  transpileDependencies: true,
  lintOnSave: false,
  devServer: {
    host: '127.0.0.1',
    port: 8081,
    open: false,
    client: {
      overlay: false
    },
    proxy: {
      '/api': {
        target: 'http://127.0.0.1:1234',
        changeOrigin: true,
        secure: false
      }
    }
  },
});