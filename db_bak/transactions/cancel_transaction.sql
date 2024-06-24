--DROP FUNCTION transactions.cancel(text, BIGINT);
CREATE OR REPLACE FUNCTION transactions.cancel(p_token text, p_id BIGINT)
    RETURNS TABLE(
		id BIGINT,
		is_complete BOOL
	) 
AS $BODY$
DECLARE
	v_id BIGINT;
	v_user_id BIGINT;
	v_role BIGINT;
	v_token TEXT;
	v_is_complete BOOL;
BEGIN
	SELECT ul.id, ul.role FROM users.list ul WHERE ul.token = p_token INTO v_user_id, v_role;
	IF v_role = 4 THEN
		UPDATE transactions.list
			SET is_complete = false
			WHERE transactions.list.id = p_id AND operation_id=2 AND(user_id_from = v_user_id OR user_id_to = v_user_id) RETURNING transactions.list.id, transactions.list.is_complete INTO v_id, v_is_complete;
		RETURN QUERY SELECT v_id, v_is_complete;	
	ELSE
		RAISE EXCEPTION 'wrong role';
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

-- select * from transactions.list;