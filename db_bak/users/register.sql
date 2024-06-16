-- FUNCTION: users.register(text, text)

--DROP FUNCTION IF EXISTS users.register(text, text, text, bigint, text);

CREATE OR REPLACE FUNCTION users.register(
	p_login text,
	p_password text,
	p_name text,
	p_role bigint,
	p_token text)
    RETURNS TABLE(login text, password text, role bigint) 
AS $BODY$
DECLARE
	v_id BIGINT;
	v_admin_id BIGINT;
	v_role BIGINT;
	v_token TEXT;
BEGIN
	SELECT ul.id, ul.role FROM users.list ul WHERE ul.token = p_token INTO v_admin_id, v_role;
	IF p_role < 1 OR p_role > 5 THEN
		RAISE EXCEPTION 'wrong role';
	END IF;
    IF v_role = 1 OR v_role < p_role THEN
		IF v_role = 3 THEN
	        RAISE EXCEPTION 'not enough rights';
		END IF;
		INSERT INTO users.list VALUES(default, p_login, p_password, p_name, p_role, true,
    			concat(md5(random()::text), md5(random()::text)), now(), null, v_admin_id) RETURNING token INTO v_token;
		RETURN QUERY SELECT p_login, p_password, p_role;
    ELSE
        RAISE EXCEPTION 'not enough rights';
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

-- select * from users.list;