CREATE OR REPLACE FUNCTION transactions.list_wd(p_token TEXT)
    RETURNS TABLE(
    	id BIGINT,
		user_id BIGINT,
		user_name TEXT,
		cashier_id BIGINT,
		cashier_name TEXT,
		cash BIGINT,
		status BIGINT,
		created TIMESTAMP WITH TIME ZONE,
		approved TIMESTAMP WITH TIME ZONE,
		description TEXT
	)
AS
$BODY$
DECLARE
    v_user_id BIGINT;
	v_user_role BIGINT;
	v_user_is_active BOOL;
BEGIN
	SELECT ul.id, ul.role, ul.is_active FROM users.list ul WHERE ul.token = p_token INTO v_user_id, v_user_role, v_user_is_active;

	IF COALESCE(v_user_id, 0) = 0 THEN
		RAISE EXCEPTION '[E1] not authorized';
	END IF;

	IF v_user_is_active = false THEN
		RAISE EXCEPTION '[E2] user blocked';
	END IF;

	IF v_user_role = 5 THEN
		RETURN QUERY SELECT tw.id, tw.user_id_from, ul1.name, tw.user_id_to, ul2.name, tw.cash, tw.status,
			tw.created, tw.approved, COALESCE(tw.description,'') FROM transactions.withdrawal tw 
		JOIN users.list ul1 on ul1.id = tw.user_id_from
		JOIN users.list ul2 on ul2.id = tw.user_id_to
		WHERE tw.user_id_from = v_user_id ORDER BY tw.id DESC;
	ELSE
		RETURN QUERY SELECT tw.id, tw.user_id_from, ul1.name, tw.user_id_to, ul2.name, tw.cash, tw.status,
			tw.created, tw.approved, COALESCE(tw.description,'') FROM transactions.withdrawal tw 
		JOIN users.list ul1 on ul1.id = tw.user_id_from
		JOIN users.list ul2 on ul2.id = tw.user_id_to
		ORDER BY tw.id DESC;
	END IF;

END;
$BODY$
LANGUAGE plpgsql VOLATILE;

--select * from transactions.withdrawal;
--select * from transactions.game;
--SELECT id, role, is_active FROM users.list

