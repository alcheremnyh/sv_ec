--DROP FUNCTION users.rules_get(bigint,text);
CREATE OR REPLACE FUNCTION users.rules_get(p_game_id BIGINT, p_admin_token TEXT)
    RETURNS TABLE(
    rtp BIGINT,
    jackpot_limit BIGINT,
    jackpot_percentage BIGINT,
    min_win BIGINT,
    max_win BIGINT,
    update TIMESTAMP WITH TIME ZONE,
    name TEXT
)
AS
$BODY$
DECLARE
    v_admin_id BIGINT;
	v_role BIGINT;
BEGIN
    SELECT id, role FROM users.list WHERE token = p_admin_token  AND is_active = true INTO v_admin_id, v_role;

	IF v_role = 1 THEN
		RETURN QUERY SELECT gr.rtp, gr.jackpot_limit, gr.jackpot_percentage, gr.min_win, gr.max_win, gr.update, gr.name FROM game_extracash.rules gr WHERE gr.id = p_game_id;
	ELSE
		RAISE EXCEPTION 'not enough rights';
    END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;