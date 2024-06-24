--DROP FUNCTION transactions.balance_main_internal(bigint);
CREATE OR REPLACE FUNCTION transactions.balance_main_internal(p_user_id BIGINT)
    RETURNS TABLE(
    	balance BIGINT
	)
AS
$BODY$
DECLARE
	v_role BIGINT;

	v_operation_1f BIGINT;
	v_operation_2f BIGINT;
	v_operation_3f BIGINT;
	v_operation_1t BIGINT;
	v_operation_2t BIGINT;
	v_operation_4t BIGINT;
	v_operation_5t BIGINT;
BEGIN
	select role from users.list where id = p_user_id into v_role;

	IF v_role < 5 THEN
		
		select SUM(cash) from transactions.list where is_complete = true AND user_id_from = p_user_id AND operation_id = 1 INTO v_operation_1f;
		select SUM(cash) from transactions.list where is_complete = true AND user_id_from = p_user_id AND operation_id = 2 INTO v_operation_2f;
		select SUM(cash) from transactions.list where is_complete = true AND user_id_from = p_user_id AND operation_id = 3 INTO v_operation_3f;
	
		select SUM(cash) from transactions.list where is_complete = true AND user_id_to = p_user_id AND operation_id = 1 INTO v_operation_1t;
		select SUM(cash) from transactions.list where is_complete = true AND user_id_to = p_user_id AND operation_id = 2 INTO v_operation_2t;
	
		select SUM(cash) from transactions.list where is_complete = true AND user_id_to = p_user_id AND operation_id = 4 INTO v_operation_4t;
		select SUM(cash) from transactions.list where is_complete = true AND user_id_to = p_user_id AND operation_id = 5 INTO v_operation_5t;

		RETURN QUERY SELECT (COALESCE(v_operation_1t, 0) 
			+ COALESCE(v_operation_2t, 0) + COALESCE(v_operation_4t, 0) 
			- COALESCE(v_operation_5t, 0) - COALESCE(v_operation_1f, 0) 
			- COALESCE(v_operation_2f, 0) - COALESCE(v_operation_3f, 0) );
	ELSE
		RETURN QUERY SELECT 0::BIGINT;
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;