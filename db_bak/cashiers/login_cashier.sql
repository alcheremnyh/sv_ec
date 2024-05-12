CREATE OR REPLACE FUNCTION cashiers.login(p_user_name TEXT, p_user_password TEXT)
    RETURNS TABLE(
    token TEXT
)
AS
$BODY$
DECLARE
	v_token TEXT;
BEGIN
	UPDATE cashiers.list SET token=concat(md5(random()::text), md5(random()::text)) WHERE name = p_user_name AND password = crypt(p_user_password, password)
                                                             RETURNING cashiers.list.token INTO v_token;

	RETURN QUERY SELECT COALESCE(v_token, '');
END;
$BODY$
LANGUAGE plpgsql VOLATILE;