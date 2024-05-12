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
}
module.exports = new CashierController()