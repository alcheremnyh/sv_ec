DROP FUNCTION transactions.get_transaction(text, BIGINT);
CREATE OR REPLACE FUNCTION transactions.get_transaction(p_token text, p_id BIGINT)
    RETURNS TABLE(
		id BIGINT,
		user_id_from BIGINT,
		user_name_from TEXT,
		user_id_to BIGINT,
		user_name_to TEXT,
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
		RETURN QUERY SELECT tl.id, tl.user_id_from, ul.name, tl.user_id_to, ul1.name,
						tl.operation_id, tl.cash, tl.created, tl.is_complete FROM transactions.list tl 
								JOIN users.list ul ON ul.id = tl.user_id_from 
								JOIN users.list ul1 ON ul1.id = tl.user_id_to 
			WHERE tl.id = p_id AND (tl.user_id_from = v_user_id OR tl.user_id_to = v_user_id) ORDER BY id DESC;
	ELSE
		RAISE EXCEPTION 'wrong role';
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

-- select * from transactions.list;