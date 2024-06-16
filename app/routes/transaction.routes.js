const Router = require('express')
const router = new Router()
const controller = require('../controllers/transaction.controller.js')

router.post('/balance', controller.balance)
router.post('/game-balance', controller.game_balance)

router.post('/set', controller.set)
router.post('/generate_wd', controller.generate_wd)
router.post('/moderate_wd', controller.moderate_wd)
router.post('/request_wd', controller.request_wd)
router.post('/withdrawal', controller.withdrawal)

module.exports = router