--DROP FUNCTION admins.status_set(text);
CREATE OR REPLACE FUNCTION admins.status_set(p_id BIGINT, p_active BOOL, p_admin_token TEXT)
    RETURNS TABLE(
    is_active BOOL
)
AS
$BODY$
DECLARE
    v_admin_id BIGINT;
BEGIN
    SELECT al.id FROM admins.list al WHERE al.token = p_admin_token  AND al.is_active = true INTO v_admin_id;
	IF v_admin_id = p_id THEN
		RAISE EXCEPTION 'you can''t change your status';
	END IF;

    IF v_admin_id = 1 THEN
		UPDATE admins.list
		SET is_active = p_active
		WHERE id = p_id;
        RETURN QUERY SELECT al.is_active FROM admins.list al WHERE al.id=p_id ;
    ELSE
        RAISE EXCEPTION 'not authorized';
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;