const Router = require('express')
const router = new Router()
const controller = require('../controllers/cashier.controller.js')

router.post('/login', controller.login)
router.post('/register', controller.register)
router.get('/list', controller.list_get)
router.post('/status-set', controller.status_set)
router.get('/info', controller.info_get)

module.exports = router