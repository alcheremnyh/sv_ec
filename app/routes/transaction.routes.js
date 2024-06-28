const Router = require('express')
const router = new Router()
const controller = require('../controllers/transaction.controller.js')

router.post('/balance', controller.balance)
router.post('/game-balance', controller.game_balance)

router.post('/set', controller.set)
router.post('/generate-wd', controller.generate_wd)
router.post('/moderate-wd', controller.moderate_wd)
router.post('/request-wd', controller.request_wd)
router.post('/list-wd', controller.list_wd)
router.post('/withdrawal', controller.withdrawal)
router.get('/get', controller.get)
router.post('/get-custom', controller.get_custom)
router.post('/get-transaction', controller.get_transaction)
router.post('/cancel', controller.cancel)

module.exports = router