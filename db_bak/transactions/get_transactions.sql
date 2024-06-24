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
BEGIN
	SELECT ul.id, ul.role FROM users.list ul WHERE ul.token = p_token INTO v_user_id, v_role;
	IF v_role = 4 THEN
		RETURN QUERY SELECT * FROM transactions.list tl WHERE tl.user_id_from = v_user_id OR tl.user_id_to = v_user_id ORDER BY id DESC;
	ELSE
		RAISE EXCEPTION 'wrong role';
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

-- select * from transactions.list;