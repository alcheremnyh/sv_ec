-- FUNCTION: admins.register(text, text)

DROP FUNCTION IF EXISTS admins.register(text, text, text);

CREATE OR REPLACE FUNCTION admins.register(
	p_name text,
	p_password text,
	p_token text)
    RETURNS TABLE(login text, password text) 
AS $BODY$
DECLARE
	v_id BIGINT;
	v_admin_id BIGINT;
	v_token TEXT;
BEGIN
	SELECT id FROM admins.list WHERE token = p_token INTO v_admin_id;

    IF v_admin_id = 1 THEN
		INSERT INTO admins.list VALUES(default, p_name, p_password, true, now(),
    			concat(md5(random()::text), md5(random()::text))) RETURNING token INTO v_token;
		RETURN QUERY SELECT p_name, p_password;
    ELSE
        RAISE EXCEPTION 'not authorized';
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;