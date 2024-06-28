-- DROP FUNCTION IF EXISTS users.set_status(bigint, text, bigint, bigint, bigint, bigint, bigint, text);

CREATE OR REPLACE FUNCTION users.status_set_active(
	p_user_id bigint,
	p_new bool,
	p_token text)
    RETURNS TABLE(result bool) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
    v_admin_id BIGINT;
	v_role BIGINT;
	v_user_id BIGINT;
	v_user_role BIGINT;
BEGIN
    SELECT id, role FROM users.list WHERE token = p_token  AND is_active = true INTO v_admin_id, v_role;
	SELECT role FROM users.list WHERE id = p_user_id INTO v_user_role;

	IF(v_admin_id=p_user_id) THEN
		RAISE EXCEPTION 'impossible to change on your own';
	END IF;
	
	IF v_role = 1 or v_role < v_user_role THEN
		UPDATE users.list
			SET 
				is_active = p_new)
			WHERE id = p_user_id;
        RETURN QUERY SELECT true;
    ELSE
        RAISE EXCEPTION 'not enough rights';
	END IF;
END;
$BODY$;
