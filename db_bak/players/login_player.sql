CREATE OR REPLACE FUNCTION players.login(p_user_name TEXT, p_user_password TEXT)
    RETURNS TABLE(
    v_token TEXT
)
AS
$BODY$
BEGIN
	UPDATE players.list SET token=concat(md5(random()::text), md5(random()::text)) WHERE name = p_user_name AND password = crypt(p_user_password, password)
                                                             RETURNING token INTO v_token;

	RETURN QUERY SELECT COALESCE(v_token, '');
END;
$BODY$
LANGUAGE plpgsql VOLATILE;