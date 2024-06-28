--DROP FUNCTION transactions.get_transactions_custom(BIGINT, text)
CREATE OR REPLACE FUNCTION transactions.get_transactions_custom(p_user_id BIGINT, p_token text)
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
	v_role_user BIGINT;
	v_token TEXT;
	v_created TIMESTAMP WITH TIME ZONE;
BEGIN
	SELECT ul.id, ul.role FROM users.list ul WHERE ul.token = p_token INTO v_user_id, v_role;
	SELECT ul.role FROM users.list ul WHERE ul.id = p_user_id INTO v_role_user;
	IF v_role = 1 or v_user_id < v_role_user or p_user_id=v_user_id THEN
		RETURN QUERY SELECT * FROM transactions.list tl WHERE (tl.user_id_from = p_user_id OR tl.user_id_to = p_user_id) ORDER BY tl.id DESC;
	ELSE
		RAISE EXCEPTION 'wrong role';
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

-- select * from transactions.list;