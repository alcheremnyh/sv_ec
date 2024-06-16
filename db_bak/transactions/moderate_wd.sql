CREATE OR REPLACE FUNCTION transactions.moderate_wd(p_withdrawal_id BIGINT, p_is_approved BOOL, p_description TEXT, p_token TEXT)
    RETURNS TABLE(
    	withdrawal_id BIGINT
	)
AS
$BODY$
DECLARE
    v_admin_id BIGINT;
	v_admin_role BIGINT;
	v_admin_is_active BOOL;
	v_user_id BIGINT;
	v_approver_id BIGINT;
	
	v_cashier_id BIGINT;
	v_cash BIGINT;

	v_wd_id BIGINT;
	v_balance BIGINT;
	v_result BIGINT;
	v_status BIGINT;
BEGIN
	SELECT id, role, is_active FROM users.list WHERE token = p_token INTO v_admin_id, v_admin_role, v_admin_is_active;

	IF COALESCE(v_admin_id, 0) = 0 THEN
		RAISE EXCEPTION '[E1] not authorized';
	END IF;

	IF v_admin_is_active = false THEN
		RAISE EXCEPTION '[E2] user blocked';
	END IF;

	IF v_admin_role = 0 or v_admin_role > 2 THEN
		RAISE EXCEPTION '[E3] wrong operation';
	END IF;

	SELECT user_id_from, user_id_to, approver_id, cash FROM transactions.withdrawal WHERE id = p_withdrawal_id INTO v_user_id, v_cashier_id, v_approver_id, v_cash;

	IF COALESCE(v_user_id, 0) = 0 THEN
		RAISE EXCEPTION '[E4] operation not found';
	END IF;

	IF v_approver_id > 0 THEN
		RAISE EXCEPTION '[E5] operation is closed';
	END IF;

	IF p_is_approved = true THEN
		SELECT transactions.balance_main_internal(v_cashier_id) INTO v_balance;
		IF v_balance - v_cash < 0  THEN
			RAISE EXCEPTION '[E6] not enough money';
		END IF;
		v_status:=3;
	ELSE
		IF p_description = ''  THEN
			RAISE EXCEPTION '[E7] need description';
		END IF;
		v_status:=2;
	END IF;

	UPDATE transactions.withdrawal
		SET is_approved = p_is_approved, approver_id = v_admin_id, 
			description = p_description, approved = now(), status=v_status WHERE id = p_withdrawal_id;
	INSERT INTO transactions.game VALUES(default, v_user_id, 0, p_withdrawal_id, 3, now(), v_cash);

	RETURN QUERY SELECT p_withdrawal_id;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

--select * from transactions.withdrawal;
--select * from transactions.game;
--SELECT id, role, is_active FROM users.list

