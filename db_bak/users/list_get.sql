DROP FUNCTION users.list_get(TEXT, BIGINT);
CREATE OR REPLACE FUNCTION users.list_get(p_admin_token TEXT, p_filter_role BIGINT)
    RETURNS TABLE(
    id BIGINT,
	login TEXT,
    name TEXT,
	role BIGINT,
	balance BIGINT,
	in_game_balance BIGINT,
    is_active BOOL,
    created TIMESTAMP WITH TIME ZONE,
	last_login TIMESTAMP WITH TIME ZONE

)
AS
$BODY$
DECLARE
    v_admin_id BIGINT;
	v_role BIGINT;

BEGIN
    SELECT al.id, al.role FROM users.list al WHERE al.token = p_admin_token  AND al.is_active = true INTO v_admin_id, v_role;

    IF v_role = 1 THEN
		IF p_filter_role=0 THEN
        	RETURN QUERY SELECT al.id, al.login, al.name, al.role,
				COALESCE((select transactions.balance_main_internal(al.id)), 0), 
				COALESCE((select transactions.balance_player_internal(al.id)), 0),
					al.is_active, al.created, al.last_login FROM users.list al ORDER BY al.id;
		ELSE
        	RETURN QUERY SELECT al.id, al.login, al.name, al.role, 
				COALESCE((select transactions.balance_main_internal(al.id)), 0), 
				COALESCE((select transactions.balance_player_internal(al.id)), 0),
					al.is_active, al.created, al.last_login FROM users.list al WHERE al.role = p_filter_role ORDER BY al.id;
		END IF;
	END IF;
	    IF v_role > 1 AND v_role < 5 THEN
		IF p_filter_role=0 THEN
        	RETURN QUERY SELECT al.id, al.login, al.name, al.role,
				COALESCE((select transactions.balance_main_internal(al.id)), 0), 
				COALESCE((select transactions.balance_player_internal(al.id)), 0),
					al.is_active, al.created, al.last_login FROM users.list al WHERE al.role > v_role ORDER BY al.id;
		ELSE
        	RETURN QUERY SELECT al.id, al.login, al.name, al.role,
				COALESCE((select transactions.balance_main_internal(al.id)), 0), 
				COALESCE((select transactions.balance_player_internal(al.id)), 0),
					al.is_active, al.created, al.last_login FROM users.list al WHERE al.role = p_filter_role AND al.role > v_role ORDER BY al.id;
		END IF;
--    ELSE
--        RAISE EXCEPTION 'not authorized';
	END IF;

END;
$BODY$
LANGUAGE plpgsql VOLATILE;