CREATE OR REPLACE FUNCTION users.shift_check(p_token text)
    RETURNS TABLE(complete bool) 
AS $BODY$
DECLARE
	v_id BIGINT;
	v_user_id BIGINT;
	v_role BIGINT;
	v_token TEXT;
BEGIN
	SELECT ul.id, ul.role FROM users.list ul WHERE ul.token = p_token INTO v_user_id, v_role;
	IF v_role = 4 THEN
		SELECT us.id FROM users.shifts us WHERE us.user_id = v_user_id AND us.complete=false INTO v_id;	
		
		IF(COALESCE(v_id, 0) = 0) THEN
			INSERT INTO users.shifts VALUES(default, v_user_id, now(), default, false) RETURNING id INTO v_id;
			
			RETURN QUERY SELECT true;
		ELSE
			RAISE EXCEPTION 'shift is still open';
		END IF;
	ELSE
		RAISE EXCEPTION 'wrong role';
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

-- select * from users.shifts;