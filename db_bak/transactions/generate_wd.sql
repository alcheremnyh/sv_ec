CREATE OR REPLACE FUNCTION transactions.generate_wd(p_withdrawal_id BIGINT, p_token TEXT)
    RETURNS TABLE(
    	code TEXT
	)
AS
$BODY$
DECLARE
    v_user_id BIGINT;
	v_user_role BIGINT;
	v_user_is_active BOOL;
	
	v_is_approved BOOL;
	
	v_req_id BIGINT;
	v_cashier_id BIGINT;
	v_cash BIGINT;
	v_transaction_id BIGINT;

	v_code TEXT;
BEGIN
	SELECT id, role, is_active FROM users.list WHERE token = p_token INTO v_user_id, v_user_role, v_user_is_active;

	IF v_user_id = 0 THEN
		RAISE EXCEPTION '[E1] not authorized';
	END IF;

	IF v_user_is_active = false THEN
		RAISE EXCEPTION '[E2] user blocked';
	END IF;

	IF v_user_role <> 5 THEN
		RAISE EXCEPTION '[E3] wrong operation';
	END IF;

	SELECT user_id_from, user_id_to, cash, is_approved, transaction_id FROM transactions.withdrawal WHERE id = p_withdrawal_id INTO v_req_id, v_cashier_id, v_cash, v_is_approved, v_transaction_id;

	IF v_is_approved = false THEN
		RAISE EXCEPTION '[E4] operation not confirmed';
	END IF;

	IF v_req_id <> v_user_id THEN
		RAISE EXCEPTION '[E5] wrong operation';
	END IF;

	IF COALESCE(v_transaction_id, 0) <> 0 THEN
		RAISE EXCEPTION '[E6] alredy closed';
	END IF;

	v_code := substring(md5(random()::text), 1, 8);
	
	UPDATE transactions.withdrawal
		SET  
			description = crypt(v_code, gen_salt('md5'))
		WHERE id = p_withdrawal_id;

	RETURN QUERY SELECT v_code;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

--select * from transactions.withdrawal;
--select * from transactions.game;
--SELECT id, role, is_active FROM users.list

