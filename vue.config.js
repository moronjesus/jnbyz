//vue.config.js
/**
 * @type {import('@vue/cli-service').ProjectOptions}
 */

const fs = require('fs')
module.exports = {
    devServer: {
        /* https: true,
        proxy: 'https://anypoint.mulesoft.com/' */
        https: {
            key: fs.readFileSync('./certs/key.pem'),
            cert: fs.readFileSync('./certs/cert.pem'),
        },
        public: 'https://localhost:8080/'
    } 
}


