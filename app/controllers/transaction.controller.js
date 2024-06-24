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

    async set(req, res){
        if(typeof req.headers.authorization !== "undefined"){
            const token = req.headers.authorization.replace('Bearer ','')
            const {user_id, operation_id, cash} = req.body
            const db = require('../drivers/db.js')
            var result = await db.transaction_set(user_id, operation_id, cash, token)
            res.json(result)
        }else{
            res.json(0)
        }
    }

    async get(req, res){
        if(typeof req.headers.authorization !== "undefined"){
            const token = req.headers.authorization.replace('Bearer ','')
            const db = require('../drivers/db.js')
            var result = await db.transaction_get(token)
            res.json(result)
        }else{
            res.json(0)
        }
    }

    async generate_wd(req, res){
        if(typeof req.headers.authorization !== "undefined"){
            const token = req.headers.authorization.replace('Bearer ','')
            const {withdrawal_id} = req.body
            const db = require('../drivers/db.js')
            var result = await db.generate_wd(withdrawal_id, token)
            res.json(result)
        }else{
            res.json(0)
        }
    }

    async moderate_wd(req, res){
        if(typeof req.headers.authorization !== "undefined"){
            const token = req.headers.authorization.replace('Bearer ','')
            const {withdrawal_id, is_approve, description} = req.body
            const db = require('../drivers/db.js')
            var result = await db.moderate_wd(withdrawal_id, is_approve, description, token)
            res.json(result)
        }else{
            res.json(0)
        }
    }
    
    async request_wd(req, res){
        if(typeof req.headers.authorization !== "undefined"){
            const token = req.headers.authorization.replace('Bearer ','')
            const {cashier_id, cash} = req.body
            const db = require('../drivers/db.js')
            var result = await db.request_wd(cashier_id, cash, token)
            res.json(result)
        }else{
            res.json(0)
        }
    }

    async withdrawal(req, res){
        if(typeof req.headers.authorization !== "undefined"){
            const token = req.headers.authorization.replace('Bearer ','')
            const {code} = req.body
            const db = require('../drivers/db.js')
            var result = await db.withdrawal(code, token)
            res.json(result)
        }else{
            res.json(0)
        }
    }

    async list_wd(req, res){
        if(typeof req.headers.authorization !== "undefined"){
            const token = req.headers.authorization.replace('Bearer ','')
            const db = require('../drivers/db.js')
            var result = await db.list_wd(token)
            res.json(result)
        }else{
            res.json(0)
        }
    }

}

module.exports = new TransactionController()