--DROP FUNCTION admins.list_get(text);
CREATE OR REPLACE FUNCTION admins.list_get(p_admin_token TEXT)
    RETURNS TABLE(
    id BIGINT,
    name TEXT,
    is_active BOOL,
    created TIMESTAMP WITH TIME ZONE
)
AS
$BODY$
DECLARE
    v_admin_id BIGINT;
BEGIN
    SELECT al.id FROM admins.list al WHERE al.token = p_admin_token  AND al.is_active = true INTO v_admin_id;

    IF v_admin_id = 1 THEN
        RETURN QUERY SELECT al.id, al.name, al.is_active, al.created FROM admins.list al ORDER BY al.id;
    ELSE
        RAISE EXCEPTION 'not authorized';
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;