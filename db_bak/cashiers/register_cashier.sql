-- FUNCTION: cashiers.register(text, text, text)

DROP FUNCTION IF EXISTS cashiers.register(text, text, text);

CREATE OR REPLACE FUNCTION cashiers.register(
	p_name text,
	p_password text,
	p_admin_token text)
    RETURNS TABLE(login text, password text) 
AS $BODY$
DECLARE
	v_id BIGINT;
	v_token TEXT;
BEGIN
	IF EXISTS (select 1 FROM admins.list WHERE token = p_admin_token AND is_active = true) THEN 
		INSERT INTO cashiers.list VALUES(default, p_name, p_password, true, now(),
	    			concat(md5(random()::text), md5(random()::text))) RETURNING token INTO v_token;
		RETURN QUERY SELECT p_name, p_password;
	ELSE
		RAISE EXCEPTION 'not enough rights';
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;