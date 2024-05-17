--select * from admins.list;
--delete from admins.list where id = 2
--select * from cashiers.list;
--delete from cashiers.list where id = 7

--select crypt('ip{^qey(H–qCTz0', gen_salt('md5'));

--select * from admins.login('admin_main', 'ip{^qey(H–qCTz0');

--select '$1$4tdEkaqP$HHuXe2JxId1hVcljucb1G/' = crypt('ip{^qey(H–qCTz0', '$1$4tdEkaqP$HHuXe2JxId1hVcljucb1G/');

--select COALESCE('14','11') as token;

--select * from admins.rules_get(1,'df1578f8506ab47cf5b22285153ab6844351a327f7bf6212ab1f89f7a0fe31fa');

--select * from admins.rules_set(1,'df1578f8506ab47cf5b22285153ab6844351a327f7bf6212ab1f89f7a0fe31fa');

--select * from admins.rules_set(1,'df1578f8506ab47cf5b22285153ab6844351a327f7bf6212ab1f89f7a0fe31fa',98,100000,1,100,10000,'Extra Cash');

--select * from game_extracash.rules;

--select * from admins.register('admin_test','abc123!@#','df1578f8506ab47cf5b22285153ab6844351a327f7bf6212ab1f89f7a0fe31fa');

--select * from admins.list_get('f9b5852c22dce565d6eabc6c0365aa70c68a35512585efb4ca5cbf6b9f351453');


--select * from cashiers.login('cashier_test','abc123!@#');

--select * from admins.status_set(2, false, 'f9b5852c22dce565d6eabc6c0365aa70c68a35512585efb4ca5cbf6b9f351453');

select * from players.list;