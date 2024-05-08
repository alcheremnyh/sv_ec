class PGP {
    constructor() {
        this.pgp = require('pg-promise')()
        this.db = this.pgp('postgres://ecus:ecpwd@127.0.0.1:5432/ecdb')
    }

    async test(var0, var1){
        let data = await this.db.one('select $1 as id0, $2 as id1', [var0, var1])
            .then((data) => {
                console.log('DATA:', data.id0, data.id1)
                return data;
            })
            .catch((error) => {
                console.log('ERROR:', error)
                return 0; 
            })

        console.log(data)
        return data
    }
}
module.exports = new PGP()
