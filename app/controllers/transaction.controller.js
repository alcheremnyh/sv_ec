class TransactionController {

    async balance(req, res){
        if(typeof req.headers.authorization !== "undefined"){
            const token = req.headers.authorization.replace('Bearer ','')
            const {user_id} = req.body
            const db = require('../drivers/db.js')
            var result = await db.balance(user_id, token)

            res.json(result)
        }else{
            res.json(0)
        }
    }

    async game_balance(req, res){
        if(typeof req.headers.authorization !== "undefined"){
            const token = req.headers.authorization.replace('Bearer ','')
            const {user_id} = req.body
            const db = require('../drivers/db.js')
            var result = await db.game_balance(user_id, token)

            res.json(result)
        }else{
            res.json(0)
        }
    }


}

module.exports = new UserController()