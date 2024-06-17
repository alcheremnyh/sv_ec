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
	
	IF COALESCE(v_user_id, 0) = 0 THEN
		RAISE EXCEPTION '[E1]not authorized';
	END IF;
	
	IF v_role > 4 THEN
		RAISE EXCEPTION '[E2]wrong operation';
	END IF;

	IF v_role = 4 AND p_user_id <> v_user_id THEN
		RAISE EXCEPTION '[E3]not enough rights';
	END IF;

	SELECT id, role FROM users.list WHERE id = p_user_id  AND is_active = true INTO v_target_user_id, v_user_role;

	IF COALESCE(v_target_user_id, 0) = 0 THEN
		RAISE EXCEPTION '[E4]this user blocked';
	END IF;
	
	IF v_role >= v_user_role AND p_user_id <> v_user_id THEN
		RAISE EXCEPTION '[E5]not enough rights';
	END IF;

	
	

	RETURN QUERY SELECT transactions.balance_main_internal(p_user_id);
END;
$BODY$
LANGUAGE plpgsql VOLATILE;