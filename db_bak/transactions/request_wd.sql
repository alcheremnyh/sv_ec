CREATE OR REPLACE FUNCTION transactions.request_wd(p_cashier_id BIGINT, p_cash BIGINT, p_token TEXT)
    RETURNS TABLE(
    	withdrawal_id BIGINT
	)
AS
$BODY$
DECLARE
    v_user_id BIGINT;
	v_user_role BIGINT;
	v_is_active BOOL;

    v_cashier_id BIGINT;
	v_cashier_role BIGINT;
	v_cashier_is_active BOOL;

	v_wd_id BIGINT;
	v_balance BIGINT;
	v_result BIGINT;

BEGIN
	SELECT id, role, is_active FROM users.list WHERE token = p_token INTO v_user_id, v_user_role, v_is_active;

	IF COALESCE(v_user_id, 0) = 0 THEN
		RAISE EXCEPTION '[E1] not authorized';
	END IF;

	IF v_is_active = false THEN
		RAISE EXCEPTION '[E2] user blocked';
	END IF;

	IF v_user_role <> 5 THEN
		RAISE EXCEPTION '[E3] wrong operation';
	END IF;

	SELECT id, role, is_active FROM users.list WHERE id = p_cashier_id  INTO v_cashier_id, v_cashier_role, v_cashier_is_active;
	
	IF v_cashier_id = 0 THEN
		RAISE EXCEPTION '[E4] not found';
	END IF;

	IF v_cashier_is_active = false THEN
		RAISE EXCEPTION '[E5] cashier unavailable';
	END IF;

	IF v_cashier_role <> 4 THEN
		RAISE EXCEPTION '[E6] wrong operation';
	END IF;

	IF p_cash <= 0 THEN
		RAISE EXCEPTION '[E7] wrong operation';
	END IF;

	SELECT transactions.balance_player_internal(v_user_id) INTO v_balance;

	IF v_balance < p_cash THEN
		RAISE EXCEPTION '[E8] not enough money';
	END IF;
	
	INSERT INTO transactions.withdrawal VALUES(default, v_user_id, v_cashier_id, p_cash, now(), false, 0, null,'',0, 1) RETURNING id INTO v_result;

	INSERT INTO transactions.game VALUES(default, v_user_id, 0, v_result, 2, now(), p_cash) RETURNING id INTO v_result;

	RETURN QUERY SELECT v_result;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

--select * from transactions.withdrawal;
--select * from transactions.game;
--SELECT id, role, is_active FROM users.list

