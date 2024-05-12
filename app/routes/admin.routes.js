const Router = require('express')
const router = new Router()
const controller = require('../controllers/admin.controller.js')

router.post('/login', controller.login)
router.post('/register', controller.register)
router.get('/rules', controller.rules_get)
router.post('/rules-set', controller.rules_set)
router.get('/gen-password', controller.gen_password)

module.exports = router