class CashierController {
    async login(req, res){
        const {login, password} = req.body
        const db = require('../drivers/db.js')
        var result = await db.cashier_login(login, password)

        res.json(result)
    }

    async register(req, res){
        const token = req.headers.authorization.replace('Bearer ','')
        const {login, password} = req.body
        const db = require('../drivers/db.js')
        var result = await db.cashier_register(login, password, token)

        res.json(result)
    }

    async list_get(req, res){
        const token = req.headers.authorization.replace('Bearer ','')
        
        const db = require('../drivers/db.js')
        var result = await db.cashier_list_get(token)

        res.json(result)
    }

    async status_set(req, res){
        const token = req.headers.authorization.replace('Bearer ','')
        const {id, status} = req.body

        const db = require('../drivers/db.js')
        var result = await db.cashier_status_set(id, status, token)

        res.json(result)
    }

    async info_get(req, res){
        const token = req.headers.authorization.replace('Bearer ','')
        
        const db = require('../drivers/db.js')
        var result = await db.cashier_info_get(token)

        res.json(result)
    }
}
module.exports = new CashierController()