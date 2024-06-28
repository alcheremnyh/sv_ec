const Router = require('express')
const router = new Router()
const controller = require('../controllers/user.controller.js')

router.post('/login', controller.login)
router.post('/register', controller.register)
router.get('/rules', controller.rules_get)
router.post('/rules-set', controller.rules_set)
router.get('/gen-password', controller.gen_password)
router.post('/list', controller.list_get)
router.post('/status-set', controller.status_set)
router.get('/info', controller.info_get)
router.post('/update-name', controller.update_name)
router.post('/update-password', controller.update_password)


router.post('/shift-start', controller.shift_start)
router.post('/shift-end', controller.shift_end)

module.exports = router