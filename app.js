const express = require('express')
const path = require('path')
const https = require("https")

const userRouter = require('./app/routes/user.routes.js')
const transactionRouter = require('./app/routes/transaction.routes.js')

const cors = require('cors');

const PORT = process.env.PORT || 8434;
const HTTPS = process.env.HTTPS || 0;
const app = express()

app.use(cors({
    origin: '*'
}));

app.use(express.json())
app.use('/user', userRouter)
app.use('/transaction', transactionRouter)

app.use(express.static(__dirname+"/app/public"))

if(HTTPS == 1) {
    https
        .createServer(
            {
                //key: fs.readFileSync('/opt/nginx/nginx_secrets/live/api.dev.jadebuddha.io/privkey.pem'),
                //cert: fs.readFileSync('/opt/nginx/nginx_secrets/live/api.dev.jadebuddha.io/fullchain.pem'),
                //key: fs.readFileSync('/etc/letsencrypt/live/game.jadebuddha.io/privkey.pem'),
                //cert: fs.readFileSync('/etc/letsencrypt/live/game.jadebuddha.io/fullchain.pem'),
                key: fs.readFileSync('/etc/letsencrypt/live/ec.gamesinc.ru/privkey.pem'),
                cert: fs.readFileSync('/etc/letsencrypt/live/ec.gamesinc.ru/fullchain.pem'),
            },
            app)
        .listen(PORT, () => {
            console.log(`Server started. Port ${PORT}`)
        })
}else{
    app.listen(PORT, () => {
        console.log(`Server started in local. Port ${PORT}`)
    })
}
