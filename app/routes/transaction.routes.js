const Router = require('express')
const router = new Router()
const controller = require('../controllers/transaction.controller.js')

router.post('/balance', controller.balance)
router.post('/game-balance', controller.game_balance)

module.exports = router