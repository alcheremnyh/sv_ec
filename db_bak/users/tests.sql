--select * from users.login('admin_main1', 'ip{^qey(H–qCTz0');
--select * from  users.list;

--select * from users.list;
--select crypt('assass', gen_salt('md5'));
--select crypt('assass', '$1$xcF.JxlT$zQjvLxCsFd6KQnkMbRi9k1');
--select crypt('ip{^qey(H–qCTz0', gen_salt('md5'));
--select crypt('ip{^qey(H–qCTz0','$1$T70yBsaE$LkaCGmuzts0k.lcKnk54C0');

--select * from users.register('admin_test', 'passpass', 'Тестовый Главный Админ', 1, '679ae4f700fbd335bdbab8e54e9218681db0e25848461184ba21bf9897759154');
--select * from users.register('admin_test1', 'passpass', 'Тестовый Обычный Админ', 2, '679ae4f700fbd335bdbab8e54e9218681db0e25848461184ba21bf9897759154');
--select * from users.register('collector_test', 'passpass', 'Тестовый Инкассатор', 3, '679ae4f700fbd335bdbab8e54e9218681db0e25848461184ba21bf9897759154');
--select * from users.register('cashier_test', 'passpass', 'Тестовый Кассир', 4, '679ae4f700fbd335bdbab8e54e9218681db0e25848461184ba21bf9897759154');
--select * from users.register('player_test', 'passpass', 'Тестовый Игрок', 5, '679ae4f700fbd335bdbab8e54e9218681db0e25848461184ba21bf9897759154');

--select * from users.register('admin_test1-1', 'passpass', 'Тестовый админ 2', 2, '679ae4f700fbd335bdbab8e54e9218681db0e25848461184ba21bf9897759154');

--delete from users.list where id>1;

--select * from users.list WHERE name = 'admin_main' AND password = crypt('ip{^qey(H–qCTz0', password);


--select * from users.status_set(9, true, '679ae4f700fbd335bdbab8e54e9218681db0e25848461184ba21bf9897759154', 'тестовое включение');
--select * from users.login('admin_test1', 'passpass');
--select * from users.login('collector_test', 'passpass');
--select * from users.login('cashier_test', 'passpass');


--select * from users.status_reason;
--select * from users.rules_get(1, '2f3806b81b1cbd9bf072e25b06bbc3703091dc181d341adba84fb16a9c62673e');
--select * from users.status_set(1, false, '2f3806b81b1cbd9bf072e25b06bbc3703091dc181d341adba84fb16a9c62673e', 'тестовое включение');

--select * from transactions.set_main(1, 4, 500, '679ae4f700fbd335bdbab8e54e9218681db0e25848461184ba21bf9897759154');
--select * from transactions.set_main(11, 2, 1000, '679ae4f700fbd335bdbab8e54e9218681db0e25848461184ba21bf9897759154');
--select * from transactions.set_main(12, 2, 1000, '7c53f9ac9cc2c3e1c10d9ea852dc5e158a8f2226fe3e32430419c1a0c86637ff');

--select * from transactions.set_main(13, 2, 250, 'd8b630576372c53282477349805293bb4438aa93fc18c8a00f770da66ca5bb9f');

--select * from  users.list;

--select * from transactions.list;
--select * from transactions.game;

--select * from transactions.list where user_id_from = 11;
--select * from transactions.list where user_id_to = 11 AND operation_id = 2;

--select sum(cash) from transactions.list ;

--select * from transactions.balance_main(12, '2f3806b81b1cbd9bf072e25b06bbc3703091dc181d341adba84fb16a9c62673e');
--select * from transactions.balance_main(11, '679ae4f700fbd335bdbab8e54e9218681db0e25848461184ba21bf9897759154');
--select * from transactions.balance_main(10, '7c53f9ac9cc2c3e1c10d9ea852dc5e158a8f2226fe3e32430419c1a0c86637ff');

--select * from transactions.balance_main_internal(13);

--"admin_main" "679ae4f700fbd335bdbab8e54e9218681db0e25848461184ba21bf9897759154"
--"admin_test" "32ea98a3e4984a6d7a547af2da6fe5906a324086b3e2ab219a65ce517d23c5b8"
--"admin_test1" "2f3806b81b1cbd9bf072e25b06bbc3703091dc181d341adba84fb16a9c62673e"
--"collector_test" "7c53f9ac9cc2c3e1c10d9ea852dc5e158a8f2226fe3e32430419c1a0c86637ff"
--"cashier_test" "d8b630576372c53282477349805293bb4438aa93fc18c8a00f770da66ca5bb9f"
--"player_test" "38d2de23398de4ead28867a5181a3ab38013dbc34a1c591817d6383477f0a86d"

--select * from transactions.balance_player_internal(13);

--select * from transactions.list;
--select * from transactions.game;
--select * from transactions.withdrawal;

--select * from transactions.balance_player(13,'679ae4f700fbd335bdbab8e54e9218681db0e25848461184ba21bf9897759154');

--select * from transactions.request_wd(12, 100, '38d2de23398de4ead28867a5181a3ab38013dbc34a1c591817d6383477f0a86d');
--select * from transactions.moderate_wd(1, false, 'тест отмены', '32ea98a3e4984a6d7a547af2da6fe5906a324086b3e2ab219a65ce517d23c5b8');
--select substring(md5(random()::text), 1, 8),md5(random()::text);

--select * from transactions.generate_wd(1, '38d2de23398de4ead28867a5181a3ab38013dbc34a1c591817d6383477f0a86d')
--"3431aeb3"

--select * from transactions.withdrawal('3431aeb3', 'd8b630576372c53282477349805293bb4438aa93fc18c8a00f770da66ca5bb9f');

--select * from  users.list_get('679ae4f700fbd335bdbab8e54e9218681db0e25848461184ba21bf9897759154', 0);
--select id, login, name, role, is_active from users.list where token='d8b630576372c53282477349805293bb4438aa93fc18c8a00f770da66ca5bb9f';
--select * from  transactions.list_wd('38d2de23398de4ead28867a5181a3ab38013dbc34a1c591817d6383477f0a86d');
--SELECT transactions.balance_main_internal(1);
select * from users.info('679ae4f700fbd335bdbab8e54e9218681db0e25848461184ba21bf9897759154')