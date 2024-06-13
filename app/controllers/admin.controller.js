class AdminController {
    async login(req, res){
        const {login, password} = req.body
        const db = require('../drivers/db.js')
        var result = await db.admin_login(login, password)

        res.json(result)
    }

    async register(req, res){
        if(typeof req.headers.authorization !== "undefined"){
            const token = req.headers.authorization.replace('Bearer ','')
            const {login, password} = req.body
            const db = require('../drivers/db.js')
            var result = await db.admin_register(login, password, token)

            res.json(result)
        }else{
            res.json(0)
        }
    }

    async rules_get(req, res){
        if(typeof req.headers.authorization !== "undefined"){
            const token = req.headers.authorization.replace('Bearer ','')
            const {game_id} = req.query
            
            const db = require('../drivers/db.js')
            var result = await db.rules_get(game_id, token)

            res.json(result)
        }else{
            res.json(0)
        }
    }

    async rules_set(req, res){
        if(typeof req.headers.authorization !== "undefined"){
            const token = req.headers.authorization.replace('Bearer ','')
            const {game_id, rtp, jackpot_limit, jackpot_percentage, min_win, max_win, name} = req.body
            
            const db = require('../drivers/db.js')
            var result = await db.rules_set(game_id, token, rtp, jackpot_limit, jackpot_percentage, min_win, max_win, name)

            res.json(result)
        }else{
            res.json(0)
        }
    }

    async gen_password(req, res) {
        const {length} = req.query
        let result = '';
        const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_-+=';
        const charactersLength = characters.length;
        let counter = 0;
        while (counter < length) {
          result += characters.charAt(Math.floor(Math.random() * charactersLength));
          counter += 1;
        }
        res.json({password:result})
    }

    async list_get(req, res){
        if(typeof req.headers.authorization !== "undefined"){
            const token = req.headers.authorization.replace('Bearer ','')
            
            const db = require('../drivers/db.js')
            var result = await db.admin_list_get(token)

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
            var result = await db.admin_status_set(id, status, token)

            res.json(result)
        }else{
            res.json(0)
        }
    }
}

module.exports = new AdminController()
