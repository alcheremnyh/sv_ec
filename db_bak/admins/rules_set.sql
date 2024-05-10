DROP FUNCTION admins.rules_get(bigint,text);
CREATE OR REPLACE FUNCTION admins.rules_get(p_game_id BIGINT, p_admin_token TEXT)
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
BEGIN
    SELECT id FROM admins.list WHERE token = p_admin_token INTO v_admin_id;

    IF v_admin_id > 0 THEN
        RETURN QUERY SELECT gr.rtp, gr.jackpot_limit, gr.jackpot_percentage, gr.min_win, gr.max_win, gr.update, gr.name FROM game_extracash.rules gr WHERE gr.id = p_game_id;
    ELSE
        RAISE EXCEPTION 'not authorized';
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;