--DROP FUNCTION transactions.balance_player(bigint,text);
CREATE OR REPLACE FUNCTION transactions.balance_player(p_user_id BIGINT, p_token TEXT)
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
BEGIN
	SELECT id, role FROM users.list WHERE token = p_token  AND is_active = true INTO v_user_id, v_role;
	
	IF COALESCE(v_user_id, 0) = 0 THEN
		RAISE EXCEPTION '[E1]not authorized';
	END IF;
	
	IF v_role = 5 AND p_user_id <> v_user_id THEN
		RAISE EXCEPTION '[E2]not enough rights';
	END IF;

	SELECT id, role FROM users.list WHERE id = p_user_id  AND is_active = true INTO v_target_user_id, v_user_role;

	IF COALESCE(v_target_user_id, 0) = 0 THEN
		RAISE EXCEPTION '[E3]this user blocked';
	END IF;

	RETURN QUERY SELECT transactions.balance_player_internal(p_user_id);
END;
$BODY$
LANGUAGE plpgsql VOLATILE;