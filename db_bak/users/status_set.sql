--DROP FUNCTION users.status_set(text);
CREATE OR REPLACE FUNCTION users.status_set(p_id BIGINT, p_active BOOL, p_admin_token TEXT, p_description TEXT)
    RETURNS TABLE(
    is_active BOOL
)
AS
$BODY$
DECLARE
    v_admin_id BIGINT;
	v_admin_role BIGINT;
	v_role BIGINT;
	v_active BOOL;
BEGIN
    SELECT ul.id, ul.role FROM users.list ul WHERE ul.token = p_admin_token  AND ul.is_active = true INTO v_admin_id, v_admin_role;
	IF v_admin_id = p_id THEN
		RAISE EXCEPTION '[E0] you can''t change your status';
	END IF;

	IF v_admin_role > 2 THEN
		RAISE EXCEPTION '[E1] you do not have rights to change status';
	END IF;

	SELECT ul.role, ul.is_active FROM users.list ul WHERE ul.id=p_id INTO v_role, v_active;

	IF v_admin_role = 2 AND v_role < 3 THEN
		RAISE EXCEPTION '[E2] you do not have rights to change status';
	END IF;

	IF v_active = p_active THEN
		RAISE EXCEPTION '[E3] the status already has this meaning';
	END IF;

	UPDATE users.list
		SET is_active = p_active
		WHERE id = p_id;
        RETURN QUERY SELECT ul.is_active FROM users.list ul WHERE ul.id=p_id;

	INSERT INTO users.status_reason VALUES(default, v_admin_id, p_id, p_active, p_description, now());
END;
$BODY$
LANGUAGE plpgsql VOLATILE;