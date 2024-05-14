class PGP {
    constructor() {
        this.pgp = require('pg-promise')()
        this.db = this.pgp('postgres://ecus:ecpwd@127.0.0.1:5432/ecdb')
    }

    async admin_login(login, password){
        let data = await this.db.one('select * from admins.login($1,$2);', [login, password])
            .then((data) => {
                console.log('DATA:', data.token)
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return 0; 
            })

        console.log(data)
        return data
    }

    async admin_register(login, password, token){
        let data = await this.db.one('select * from admins.register($1,$2,$3);', [login, password, token])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return 0; 
            })

        return data
    }

    async admin_list_get(token){
        let data = await this.db.any('select * from admins.list_get($1);', [token])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return 0; 
            })

        return data
    }

    async admin_status_set(id, status, token){
        let data = await this.db.one('select * from admins.status_set($1, $2, $3);', [id, status, token])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return 0; 
            })

        return data
    }

    async rules_get(game_id, token){
        let data = await this.db.one('select * from admins.rules_get($1,$2);', [game_id,token])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return 0; 
            })

        return data
    }

    async rules_set(game_id, token, rtp, j_limit, j_p, min, max, name){
        let data = await this.db.one('select * from admins.rules_set($1,$2,$3,$4,$5,$6,$7,$8);', [game_id,token,rtp,j_limit,j_p,min,max,name])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return 0; 
            })

        return data
    }

    async cashier_login(login, password){
        let data = await this.db.one('select * from cashiers.login($1,$2);', [login, password])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return 0; 
            })

        console.log(data)
        return data
    }

    async cashier_register(login, password, token){
        let data = await this.db.one('select * from cashiers.register($1,$2,$3);', [login, password, token])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return 0; 
            })

        return data
    }
}
module.exports = new PGP()
