-- FUNCTION: admins.register(text, text)

-- DROP FUNCTION IF EXISTS admins.register(text, text);

CREATE OR REPLACE FUNCTION admins.register(
	p_name text,
	p_password text)
    RETURNS TABLE(v_token text) 
AS $BODY$
DECLARE
	v_id BIGINT;
BEGIN
	INSERT INTO admins.list VALUES(default, p_name, p_password, true, now(),
    			concat(md5(random()::text), md5(random()::text))) RETURNING token INTO v_token;
	RETURN QUERY SELECT v_token;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;