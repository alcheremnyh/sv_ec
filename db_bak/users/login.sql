DROP FUNCTION IF EXISTS users.login(TEXT, TEXT);
CREATE OR REPLACE FUNCTION users.login(p_user_name TEXT, p_user_password TEXT)
    RETURNS TABLE(
    token TEXT,
	role BIGINT,
	is_shift BOOL
)
AS
$BODY$
DECLARE
	v_token TEXT;
	v_role BIGINT;
	v_id BIGINT;
	v_user_id BIGINT;
	v_is_shift BOOL;
BEGIN
	RAISE NOTICE 'start';
	UPDATE users.list SET token=concat(md5(random()::text), md5(random()::text)), last_login=now() WHERE login = p_user_name AND password = crypt(p_user_password, password)
                                                             RETURNING users.list.id, users.list.token, users.list.role INTO v_user_id, v_token, v_role;
	IF(COALESCE(v_token, '') = '') THEN
		RAISE EXCEPTION 'wrong login or password';
	ELSE
		RAISE NOTICE 'v_role = %', v_role;
		IF v_role = 4 THEN
			SELECT us.id FROM users.shifts us WHERE us.user_id = v_user_id AND us.complete=false INTO v_id;
			RAISE NOTICE 'v_id = %', v_id;
			IF(COALESCE(v_id, 0) = 0) THEN
				v_is_shift := false;
			ELSE
				v_is_shift := true;
			END IF;

		ELSE
			v_is_shift := true;
		END IF;

		RETURN QUERY SELECT COALESCE(v_token, ''), COALESCE(v_role, 0), COALESCE(v_is_shift, false);
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;