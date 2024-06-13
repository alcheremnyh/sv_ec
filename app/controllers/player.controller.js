class PlayerController {
    async login(req, res){
        const {login, password} = req.body
        const db = require('../drivers/db.js')
        var result = await db.player_login(login, password)

        res.json(result)
    }

    async register(req, res){
        if(typeof req.headers.authorization !== "undefined"){
            const token = req.headers.authorization.replace('Bearer ','')
            const {login, password} = req.body
            const db = require('../drivers/db.js')
            var result = await db.player_register(login, password, token)

            res.json(result)
        }else{
            res.json(0)
        }
    }

    async list_get(req, res){
        if(typeof req.headers.authorization !== "undefined"){
            const token = req.headers.authorization.replace('Bearer ','')
            
            const db = require('../drivers/db.js')
            var result = await db.player_list_get(token)

            res.json(result)
        }else{
            res.json(0)
        }
    }

    async status_set(req, res){
        if(typeof req.headers.authorization !== "undefined"){
            const token = req.headers.authorization.replace('Bearer ','')
            const {id, status} = req.body

            const db = require('../drivers/db.js')
            var result = await db.player_status_set(id, status, token)

            res.json(result)
        }else{
            res.json(0)
        }
    }
}
module.exports = new PlayerController()