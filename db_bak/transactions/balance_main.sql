--DROP FUNCTION transactions.set_main(bigint,text);
CREATE OR REPLACE FUNCTION transactions.balance_main(p_user_id BIGINT, p_token TEXT)
    RETURNS TABLE(
    	balance BIGINT
	)
AS
$BODY$
DECLARE
    v_user_id BIGINT;
	v_role BIGINT;
 	v_target_user_id BIGINT;
	v_user_role BIGINT;
	v_operation_1f BIGINT;
	v_operation_2f BIGINT;
	v_operation_3f BIGINT;
	v_operation_1t BIGINT;
	v_operation_2t BIGINT;
	v_operation_4t BIGINT;
	v_operation_5t BIGINT;
	v_result BIGINT;
BEGIN
	SELECT id, role FROM users.list WHERE token = p_token  AND is_active = true INTO v_user_id, v_role;
	
	IF v_user_id = 0 THEN
		RAISE EXCEPTION '[E1]not authorized';
	END IF;
	
	IF v_role > 4 THEN
		RAISE EXCEPTION '[E2]wrong operation';
	END IF;

	IF v_role = 4 AND p_user_id <> v_user_id THEN
		RAISE EXCEPTION '[E3]not enough rights';
	END IF;

	SELECT id, role FROM users.list WHERE id = p_user_id  AND is_active = true INTO v_target_user_id, v_user_role;

	IF v_target_user_id = 0 THEN
		RAISE EXCEPTION '[E4]this user blocked';
	END IF;
	
	IF v_role >= v_user_role AND p_user_id <> v_user_id THEN
		RAISE EXCEPTION '[E5]not enough rights';
	END IF;

	select SUM(cash) from transactions.list where user_id_from = v_target_user_id AND operation_id = 1 INTO v_operation_1f;
	select SUM(cash) from transactions.list where user_id_from = v_target_user_id AND operation_id = 2 INTO v_operation_2f;
	select SUM(cash) from transactions.list where user_id_from = v_target_user_id AND operation_id = 3 INTO v_operation_3f;

	select SUM(cash) from transactions.list where user_id_to = v_target_user_id AND operation_id = 1 INTO v_operation_1t;
	select SUM(cash) from transactions.list where user_id_to = v_target_user_id AND operation_id = 2 INTO v_operation_2t;

	select SUM(cash) from transactions.list where user_id_to = v_target_user_id AND operation_id = 4 INTO v_operation_4t;
	select SUM(cash) from transactions.list where user_id_to = v_target_user_id AND operation_id = 5 INTO v_operation_5t;

	

	RETURN QUERY SELECT (COALESCE(v_operation_1t, 0) 
		+ COALESCE(v_operation_2t, 0) + COALESCE(v_operation_4t, 0) 
		- COALESCE(v_operation_5t, 0) - COALESCE(v_operation_1f, 0) 
		- COALESCE(v_operation_2f, 0) - COALESCE(v_operation_3f, 0) );
END;
$BODY$
LANGUAGE plpgsql VOLATILE;