CREATE OR REPLACE FUNCTION transactions.withdrawal(p_code TEXT, p_token TEXT)
    RETURNS TABLE(
    	transaction_id BIGINT
	)
AS
$BODY$
DECLARE
    v_user_id BIGINT;
	v_user_role BIGINT;
	v_user_is_active BOOL;
	

	v_withdrawal_id BIGINT;	
	v_cashier_id BIGINT;
	v_player_id BIGINT;


	v_cash BIGINT;
	v_balance BIGINT;
	v_transaction_id BIGINT;

BEGIN
	SELECT id, role, is_active FROM users.list WHERE token = p_token INTO v_user_id, v_user_role, v_user_is_active;

	IF v_user_id = 0 THEN
		RAISE EXCEPTION '[E1] not authorized';
	END IF;

	IF v_user_is_active = false THEN
		RAISE EXCEPTION '[E2] user blocked';
	END IF;

	IF v_user_role <> 4 THEN
		RAISE EXCEPTION '[E3] wrong operation';
	END IF;

	SELECT id, cash, user_id_from, user_id_to FROM transactions.withdrawal 
		WHERE is_approved = true 
			AND COALESCE(transactions.withdrawal.transaction_id, 0) = 0 AND description = crypt(p_code, description) 
		INTO v_withdrawal_id, v_cash, v_player_id, v_cashier_id;

	IF COALESCE(v_withdrawal_id, 0) = 0 THEN
		RAISE EXCEPTION '[E4] wrong code';
	END IF;

	IF v_user_id <> v_cashier_id THEN
		RAISE EXCEPTION '[E5] wrong cashier';
	END IF;
	
	SELECT transactions.balance_main_internal(v_cashier_id) INTO v_balance;
	IF v_balance - v_cash < 0  THEN
		RAISE EXCEPTION '[E6] not enough money on cashier';
	END IF;
	
	INSERT INTO transactions.list VALUES(default, v_cashier_id, v_player_id, 3, v_cash, now()) RETURNING id INTO v_transaction_id;
	
	IF COALESCE(v_transaction_id, 0) = 0 THEN
		RAISE EXCEPTION '[E7] brocken';
	END IF;

	UPDATE transactions.withdrawal
		SET transaction_id = v_transaction_id
		WHERE id = v_withdrawal_id;

	RETURN QUERY SELECT v_transaction_id;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

--select * from transactions.withdrawal;
--select * from transactions.game;
--SELECT id, role, is_active FROM users.list

