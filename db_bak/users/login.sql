DROP FUNCTION IF EXISTS users.login(TEXT, TEXT);
CREATE OR REPLACE FUNCTION users.login(p_user_name TEXT, p_user_password TEXT)
    RETURNS TABLE(
    token TEXT,
	role BIGINT
)
AS
$BODY$
DECLARE
	v_token TEXT;
	v_role BIGINT;
BEGIN
	UPDATE users.list SET token=concat(md5(random()::text), md5(random()::text)), last_login=now() WHERE login = p_user_name AND password = crypt(p_user_password, password)
                                                             RETURNING users.list.token, users.list.role INTO v_token, v_role;

	RETURN QUERY SELECT COALESCE(v_token, ''), COALESCE(v_role, 0);
END;
$BODY$
LANGUAGE plpgsql VOLATILE;