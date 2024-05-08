class AdminController {
    async hello(req, res){
        const {email, password} = req.body
        
        const db = require('../drivers/db.js')
        await db.test(1, 2)

        res.json(Math.random())
    }
}

module.exports = new AdminController()
