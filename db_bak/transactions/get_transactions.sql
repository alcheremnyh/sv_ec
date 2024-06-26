--DROP FUNCTION transactions.get_transactions(text)
CREATE OR REPLACE FUNCTION transactions.get_transactions(p_token text)
    RETURNS TABLE(
		id BIGINT,
		user_id_from BIGINT,
		user_id_to BIGINT,
		operation_id BIGINT,
		cash BIGINT,
		created TIMESTAMP WITH TIME ZONE,
		is_complete BOOL
	) 
AS $BODY$
DECLARE
	v_id BIGINT;
	v_user_id BIGINT;
	v_role BIGINT;
	v_token TEXT;
	v_created TIMESTAMP WITH TIME ZONE;
BEGIN
	SELECT ul.id, ul.role FROM users.list ul WHERE ul.token = p_token INTO v_user_id, v_role;
	IF v_role = 4 THEN
		select us.start from users.shifts us where us.user_id = v_user_id and us.complete = true ORDER BY us.id DESC LIMIT 1 INTO v_created;
		RETURN QUERY SELECT * FROM transactions.list tl WHERE (tl.user_id_from = v_user_id OR tl.user_id_to = v_user_id) AND tl.created>v_created ORDER BY tl.id DESC;
	ELSE
		RAISE EXCEPTION 'wrong role';
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

-- select * from transactions.list;