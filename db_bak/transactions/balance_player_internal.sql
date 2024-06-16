--DROP FUNCTION transactions.balance_player_internal(bigint);
CREATE OR REPLACE FUNCTION transactions.balance_player_internal(p_user_id BIGINT)
    RETURNS TABLE(
    	balance BIGINT
	)
AS
$BODY$
DECLARE
	v_operation_1 BIGINT;
	v_operation_2 BIGINT;
	v_operation_3 BIGINT;
	v_operation_b1 BIGINT;
	v_operation_b2 BIGINT;
	v_result BIGINT;
BEGIN
	select SUM(cash) from transactions.game where user_id = p_user_id AND operation_id = 1 INTO v_operation_1;
	select SUM(cash) from transactions.game where user_id = p_user_id AND operation_id = 2 INTO v_operation_2;
	select SUM(cash) from transactions.game where user_id = p_user_id AND operation_id = 3 INTO v_operation_3;
	select SUM(cash) from transactions.bids where user_id = p_user_id AND operation_id = 1 INTO v_operation_b1;
	select SUM(cash) from transactions.bids where user_id = p_user_id AND operation_id = 2 INTO v_operation_b2;
	
	RETURN QUERY SELECT (COALESCE(v_operation_1, 0) + COALESCE(v_operation_3, 0) 
		- COALESCE(v_operation_2, 0) - COALESCE(v_operation_b1, 0) + COALESCE(v_operation_b2, 0));
END;
$BODY$
LANGUAGE plpgsql VOLATILE;