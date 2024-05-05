CREATE OR REPLACE FUNCTION players.register_check() 
	RETURNS trigger
	LANGUAGE plpgsql AS
$register_check$
BEGIN
	IF EXISTS (select 1 FROM players.list WHERE name = NEW.name ) THEN 
    	RAISE EXCEPTION 'already exists';
    END IF;
	IF (length(NEW.name)<3) THEN
		RAISE EXCEPTION 'name cannot be less than 3 characters';
	END IF;
	IF(length(NEW.password)<6) THEN
		RAISE EXCEPTION 'password cannot be less than 6 characters';
	END IF;
	NEW.password := crypt(NEW.password, gen_salt('md5'));
    RETURN NEW;
END
$register_check$;

CREATE OR REPLACE TRIGGER register_check BEFORE INSERT ON players.list
    FOR EACH ROW EXECUTE PROCEDURE players.register_check();