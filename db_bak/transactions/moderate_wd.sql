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
	
	v_approver_id BIGINT;
	
	v_cashier_id BIGINT;
	v_cash BIGINT;

	v_wd_id BIGINT;
	v_balance BIGINT;
	v_result BIGINT;

BEGIN
	SELECT id, role, is_active FROM users.list WHERE token = p_token INTO v_admin_id, v_admin_role, v_admin_is_active;

	IF v_admin_id = 0 THEN
		RAISE EXCEPTION '[E1] not authorized';
	END IF;

	IF v_admin_is_active = false THEN
		RAISE EXCEPTION '[E2] user blocked';
	END IF;

	IF v_admin_role = 0 or v_admin_role > 2 THEN
		RAISE EXCEPTION '[E3] wrong operation';
	END IF;

	SELECT user_id_to, approver_id, cash FROM transactions.withdrawal WHERE id = p_withdrawal_id INTO v_cashier_id, v_approver_id, v_cash;

	IF v_approver_id > 0 THEN
		RAISE EXCEPTION '[E4] operation is closed';
	END IF;

	IF p_is_approved = true THEN
		SELECT transactions.balance_main_internal(v_cashier_id) INTO v_balance;
		IF v_balance - v_cash < 0  THEN
			RAISE EXCEPTION '[E5] not enough money';
		END IF;
	ELSE
		IF p_description = ''  THEN
			RAISE EXCEPTION '[E6] need description';
		END IF;
	END IF;

	UPDATE transactions.withdrawal
		SET is_approved = p_is_approved, approver_id = v_admin_id, 
			description = p_description, approved = now() WHERE id = p_withdrawal_id;

	RETURN QUERY SELECT p_withdrawal_id;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

--select * from transactions.withdrawal;
--select * from transactions.game;
--SELECT id, role, is_active FROM users.list

