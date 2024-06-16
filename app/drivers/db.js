class PGP {
    constructor() {
        this.pgp = require('pg-promise')()
        this.db = this.pgp('postgres://ecus:ecpwd@127.0.0.1:5432/ecdb')
    }

    async login(login, password){
        let data = await this.db.one('select * from users.login($1,$2);', [login, password])
            .then((data) => {
                console.log('DATA:', data.token, data.role)
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return {error: "wrong login or password"}; 
            })

        console.log(data)
        return data
    }

    async register(login, password, name, role, token){
        let data = await this.db.one('select * from users.register($1,$2,$3,$4,$5);', [login, password, name, role, token])
            .then((data) => {
                return data
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return {error: error}
                return 0; 
            })

        return data
    }

    async list_get(token,filter_role){
        let data = await this.db.any('select * from users.list_get($1,$2);', [token,filter_role])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return 0; 
            })

        return data
    }

    async status_set(id, status, token, description){
        let data = await this.db.one('select * from users.status_set($1, $2, $3, $4);', [id, status, token, description])
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
        let data = await this.db.one('select * from users.rules_get($1,$2);', [game_id,token])
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
        let data = await this.db.one('select * from users.rules_set($1,$2,$3,$4,$5,$6,$7,$8);', [game_id,token,rtp,j_limit,j_p,min,max,name])
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
