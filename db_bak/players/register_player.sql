-- FUNCTION: players.register(text, text, text)

-- DROP FUNCTION IF EXISTS players.register(text, text, text);

CREATE OR REPLACE FUNCTION players.register(
	p_name text,
	p_password text,
	p_token text)
    RETURNS TABLE(v_token text) 
AS $BODY$
DECLARE
	v_id BIGINT;
BEGIN
	IF EXISTS (select 1 FROM admins.list WHERE token = p_token AND is_active = true)
		OR EXISTS (select 1 FROM cashiers.list WHERE token = p_token AND is_active = true) THEN 
		INSERT INTO players.list VALUES(default, p_name, p_password, true, now(),
	    			concat(md5(random()::text), md5(random()::text))) RETURNING token INTO v_token;
		RETURN QUERY SELECT v_token;
	ELSE
		RAISE EXCEPTION 'not enough rights';
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;