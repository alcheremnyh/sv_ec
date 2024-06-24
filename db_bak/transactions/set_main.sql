--DROP FUNCTION transactions.set_main(bigint,text);
CREATE OR REPLACE FUNCTION transactions.set_main(p_user_id_to BIGINT, p_operation_id BIGINT, p_cash BIGINT, p_token TEXT)
    RETURNS TABLE(
    	transaction_id BIGINT
	)
AS
$BODY$
DECLARE
    v_user_id_from BIGINT;
	v_user_role_from BIGINT;
	v_user_id_to BIGINT;
	v_user_role_to BIGINT;
	v_is_active BOOL;
	v_result BIGINT;
	v_balance BIGINT;
BEGIN
	IF p_operation_id < 1 OR p_operation_id > 5 THEN
		RAISE EXCEPTION 'wrong operation';
	END IF;

	IF p_cash <= 0 THEN
		RAISE EXCEPTION 'cannot be less than or equal to 0';
	END IF;
	
	SELECT id, role FROM users.list WHERE token = p_token  AND is_active = true INTO v_user_id_from, v_user_role_from;
	
	IF COALESCE(v_user_id_from, 0) = 0 THEN
		RAISE EXCEPTION 'not authorized';
	END IF;

	IF p_operation_id = 1 AND v_user_role_from > 3 THEN
		RAISE EXCEPTION 'not enough rights';
	END IF;
	
	IF p_operation_id = 2 AND v_user_role_from > 4 THEN
		RAISE EXCEPTION 'not enough rights';
	END IF;

	IF p_operation_id = 3 THEN
		RAISE EXCEPTION 'not enough rights';
	END IF;

	IF p_operation_id = 4 AND v_user_role_from > 1 THEN
		RAISE EXCEPTION 'not enough rights';
	END IF;
	
	IF p_operation_id = 5 AND v_user_role_from > 1 THEN
		RAISE EXCEPTION 'not enough rights';
	END IF;

	SELECT id, role, is_active FROM users.list WHERE id = p_user_id_to INTO v_user_id_to, v_user_role_to, v_is_active;

	IF v_user_id_from = v_user_id_to AND p_operation_id < 4 THEN
		RAISE EXCEPTION 'wrong operation';
	END IF;

	IF v_is_active = false THEN
		RAISE EXCEPTION 'this user blocked';
	END IF;

	
	
	IF p_operation_id = 2 AND v_user_role_to = 5 THEN
		INSERT INTO transactions.list VALUES(default, v_user_id_to, v_user_id_from, p_operation_id, p_cash, now(),default) RETURNING id INTO v_result;
		INSERT INTO transactions.game VALUES(default, v_user_id_to, v_result, 0, 1, now(), p_cash);
	ELSE
		IF p_operation_id = 1 THEN
			SELECT balance FROM transactions.balance_main_internal(v_user_id_to) INTO v_balance;
			IF v_balance >= p_cash THEN
				INSERT INTO transactions.list VALUES(default, v_user_id_to, v_user_id_from, p_operation_id, p_cash, now(),default) RETURNING id INTO v_result;
			ELSE
				RAISE EXCEPTION 'not enough money';
			END IF;
		ELSE
			SELECT balance FROM transactions.balance_main_internal(v_user_id_from) INTO v_balance;
		 	IF v_balance >= p_cash THEN
				INSERT INTO transactions.list VALUES(default, v_user_id_from, v_user_id_to, p_operation_id, p_cash, now(),default) RETURNING id INTO v_result;
			ELSE
				RAISE EXCEPTION 'not enough money';
			END IF;
		END IF;
	END IF;
	RETURN QUERY SELECT v_result;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;