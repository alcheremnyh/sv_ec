-- FUNCTION: users.rules_set(bigint, text, bigint, bigint, bigint, bigint, bigint, text)

-- DROP FUNCTION IF EXISTS users.rules_set(bigint, text, bigint, bigint, bigint, bigint, bigint, text);

CREATE OR REPLACE FUNCTION users.rules_set(
	p_game_id bigint,
	p_admin_token text,
	p_rtp bigint,
	p_jackpot_limit bigint,
	p_jackpot_percentage bigint,
	p_min_win bigint,
	p_max_win bigint,
	p_name text)
    RETURNS TABLE(rtp bigint, jackpot_limit bigint, jackpot_percentage bigint, min_win bigint, max_win bigint, update timestamp with time zone, name text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
    v_admin_id BIGINT;
	v_role BIGINT;
BEGIN
    SELECT id, role FROM users.list WHERE token = p_admin_token  AND is_active = true INTO v_admin_id, v_role;

    IF v_role = 0 THEN
		UPDATE game_extracash.rules
			SET 
				rtp = p_rtp, 
				jackpot_limit = p_jackpot_limit, 
				jackpot_percentage = p_jackpot_percentage, 
				min_win = p_min_win, 
				max_win = p_max_win, 
				update = now(),
				admin_id = v_admin_id,
				name = p_name
			WHERE id = p_game_id;
        RETURN QUERY SELECT gr.rtp, gr.jackpot_limit, gr.jackpot_percentage, gr.min_win, gr.max_win, gr.update, gr.name FROM game_extracash.rules gr WHERE gr.id = p_game_id;
    ELSE
        RAISE EXCEPTION 'not enough rights';
	END IF;
END;
$BODY$;

ALTER FUNCTION admins.rules_set(bigint, text, bigint, bigint, bigint, bigint, bigint, text)
    OWNER TO postgres;
