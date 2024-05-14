--DROP FUNCTION players.status_set(text);
CREATE OR REPLACE FUNCTION players.status_set(p_id BIGINT, p_active BOOL, p_admin_token TEXT)
    RETURNS TABLE(
    is_active BOOL
)
AS
$BODY$
BEGIN
	IF EXISTS (select 1 FROM admins.list WHERE token = p_token AND is_active = true)
		OR EXISTS (select 1 FROM cashiers.list WHERE token = p_token AND is_active = true) THEN 
		UPDATE players.list
		SET is_active = p_active
		WHERE id = p_id;
        RETURN QUERY SELECT al.is_active FROM players.list al WHERE al.id=p_id ;
    ELSE
        RAISE EXCEPTION 'not authorized';
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;