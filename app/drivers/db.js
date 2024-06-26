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
                return {error: error.message}
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
                return {error: error.message}
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
                return {error: error.message}
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
                return {error: error.message} 
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
                return {error: error.message}
            })

        return data
    }

    async user_info_get(token){
        let data = await this.db.one('select * from users.info($1);', [token])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return {error: error.message}
            })

        return data
    }

    async shift_start(token){
        let data = await this.db.one('select * from users.shift_start($1);', [token])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return {error: error.message} 
            })

        return data
    }

    async shift_end(token){
        let data = await this.db.one('select * from users.shift_end($1);', [token])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return {error: error.message} 
            })

        return data
    }

    async update_name(id, new_data,token){
        let data = await this.db.one('select * from users.update_name($1, $2, $3);', [id, new_data, token])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return {error: error.message}
            })

        return data
    }

    async update_password(id, new_data,token){
        let data = await this.db.one('select * from users.update_password($1, $2, $3);', [id, new_data, token])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return {error: error.message}
            })

        return data
    }

    async status_set_active(id, new_data,token){
        let data = await this.db.one('select * from users.status_set_active($1, $2, $3);', [id, new_data, token])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return {error: error.message}
            })

        return data
    }


    //////////////////////////////////////////////////////////////////////////

    async balance(user_id, token){
        let data = await this.db.one('select * from transactions.balance_main($1,$2);', [user_id,token])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return {error: error.message}
            })

        return data
    }

    async game_balance(user_id, token){
        let data = await this.db.one('select * from transactions.balance_player($1,$2);', [user_id,token])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return {error: error.message}
            })

        return data
    }

    async game_balance(user_id, token){
        let data = await this.db.one('select * from transactions.balance_player($1,$2);', [user_id,token])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return {error: error.message}
            })

        return data
    }

    async transaction_set(to_user_id, operation_id, cash, token){
        let data = await this.db.one('select * from transactions.set_main($1,$2,$3,$4);', [to_user_id,operation_id,cash,token])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return {error: error.message}
            })

        return data
    }

    async transaction_get(token){
        let data = await this.db.any('select * from transactions.get_transactions($1);', [token])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return {error: error.message}
            })

        return data
    }

    async transaction_get_custom(token, id){
        let data = await this.db.any('select * from transactions.get_transactions_custom($1, $2);', [id, token])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return {error: error.message}
            })

        return data
    }

    async transaction_get_one(token, id){
        let data = await this.db.one('select * from transactions.get_transaction($1,$2);', [token, id])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return {error: error.message}
            })

        return data
    }

    async transaction_cancel(token, id){
        let data = await this.db.one('select * from transactions.cancel($1,$2);', [token, id])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return {error: error.message}
            })

        return data
    }

    async generate_wd(withdrawal_id, token){
        let data = await this.db.one('select * from transactions.generate_wd($1,$2);', [withdrawal_id,token])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return {error: error.message}
            })

        return data
    }

    async moderate_wd(withdrawal_id, is_approve, description, token){
        let data = await this.db.one('select * from transactions.moderate_wd($1,$2,$3,$4);', [withdrawal_id,is_approve,description,token])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return {error: error.message}
            })

        return data
    }

    async request_wd(cashier_id, cash, token){
        let data = await this.db.one('select * from transactions.request_wd($1,$2,$3);', [cashier_id,cash,token])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return {error: error.message}
            })

        return data
    }

    async withdrawal(code, token){
        let data = await this.db.one('select * from transactions.withdrawal($1,$2);', [code,token])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return {error: error.message}
            })

        return data
    }

    async list_wd(token){
        let data = await this.db.any('select * from transactions.list_wd($1);', [token])
            .then((data) => {
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return {error: error.message}
            })

        return data
    }
}
module.exports = new PGP()
