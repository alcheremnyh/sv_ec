CREATE OR REPLACE FUNCTION users.shift_end(p_token text)
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
			RAISE EXCEPTION 'impossible to close, no open shifts';
		ELSE
			UPDATE users.shifts
				SET "end"=now(), "complete"=true WHERE id = v_id;
			
			RETURN QUERY SELECT true;
		END IF;
	ELSE
		RAISE EXCEPTION 'wrong role';
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

-- select * from users.shifts;