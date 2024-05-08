const Router = require('express')
const router = new Router()
const controller = require('../controllers/admin.controller.js')

router.get('/', controller.hello)

module.exports = router