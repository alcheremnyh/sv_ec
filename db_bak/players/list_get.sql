--DROP FUNCTION players.list_get(text);
CREATE OR REPLACE FUNCTION players.list_get(p_admin_token TEXT)
    RETURNS TABLE(
    id BIGINT,
    name TEXT,
    is_active BOOL,
    created TIMESTAMP WITH TIME ZONE
)
AS
$BODY$
BEGIN
	IF EXISTS (select 1 FROM admins.list WHERE token = p_token AND is_active = true)
		OR EXISTS (select 1 FROM cashiers.list WHERE token = p_token AND is_active = true) THEN
        RETURN QUERY SELECT al.id, al.name, al.is_active, al.created FROM players.list al ORDER BY al.id;
    ELSE
        RAISE EXCEPTION 'not authorized';
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;