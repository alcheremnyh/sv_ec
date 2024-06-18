-- FUNCTION: users.info(text, text)

--DROP FUNCTION IF EXISTS users.info(text, text, text, bigint, text);

CREATE OR REPLACE FUNCTION users.info(
	p_token text)
    RETURNS TABLE(
		id bigint, 
		login text, 
		name text, 
		role bigint, 
		balance bigint,
		is_active bool,
		last_login timestamp with time zone
	) 
AS $BODY$
DECLARE
	v_id BIGINT;
	v_user_id BIGINT;
	v_role BIGINT;
	v_token TEXT;
	v_balance BIGINT;
	v_last_login TIMESTAMP WITH TIME ZONE;
BEGIN
	SELECT ul.id, ul.role FROM users.list ul WHERE ul.token = p_token INTO v_user_id, v_role;

	IF COALESCE(v_user_id, 0) = 0 THEN
		RAISE EXCEPTION '[E1] not authorized';
	END IF;

	IF v_role < 1 OR v_role > 5 THEN
		RAISE EXCEPTION '[E2] wrong role';
	END IF;

	IF v_role < 5 THEN
		SELECT transactions.balance_main_internal(v_user_id) INTO v_balance;
	ELSE
		SELECT transactions.balance_player_internal(v_user_id) INTO v_balance;
	END IF;

	IF v_role = 4 THEN
		SELECT us.start FROM users.shifts us WHERE us.user_id = v_user_id AND us.complete=false INTO v_last_login;
	ELSE
		SELECT ul.last_login FROM users.list ul WHERE ul.token=p_token INTO v_last_login;
	END IF;

	RETURN QUERY SELECT ul.id, ul.login, ul.name, ul.role, v_balance, ul.is_active, v_last_login 
		FROM users.list ul 
		WHERE ul.token=p_token;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

-- select * from users.list;