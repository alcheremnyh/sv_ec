-- DROP FUNCTION IF EXISTS users.update_name(bigint, text, bigint, bigint, bigint, bigint, bigint, text);

CREATE OR REPLACE FUNCTION users.update_name(
	p_user_id bigint,
	p_new_name text,
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
	IF EXISTS (select 1 FROM users.list WHERE name = p_new_name ) THEN 
    	RAISE EXCEPTION 'already exists';
    END IF;
	IF(length(p_new_name)<3) THEN
		RAISE EXCEPTION 'name cannot be less than 3 characters';
	END IF;
	
    IF v_role = 1 or v_role < v_user_role THEN
		UPDATE users.list
			SET 
				name = p_new_name
			WHERE id = p_user_id;
        RETURN QUERY SELECT true;
    ELSE
        RAISE EXCEPTION 'not enough rights';
	END IF;
END;
$BODY$;
