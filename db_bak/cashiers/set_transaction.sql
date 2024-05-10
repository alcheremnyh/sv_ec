-- FUNCTION: cashiers.transaction_set(text, text, integer, bigint)

-- DROP FUNCTION IF EXISTS cashiers.transaction_set(text, text, integer, bigint);

CREATE OR REPLACE FUNCTION cashiers.transaction_set(
	p_cashier_token text,
	p_player_name text,
	p_operation integer,
	p_cash bigint
	)
    RETURNS TABLE(v_token text) 
AS $BODY$
DECLARE
	v_cashier_id BIGINT;
	v_player_id BIGINT;
	v_cash_in BIGINT;
	v_cash_out BIGINT;
	v_cash_amount BIGINT;
BEGIN
	SELECT id FROM cashiers.list WHERE token = p_cashier_token AND is_active = true INTO v_cashier_id;
	
	-- p_operation = 1 - пополнение
	-- p_operation = 2 - снятие
	
	IF (p_cash <= 0) THEN
		RAISE EXCEPTION 'impossible amount of money';
	END IF;
	
	IF (v_cashier_id > 0) THEN
		SELECT id FROM players.list WHERE name = p_player_name AND is_active = true INTO v_player_id;
		
		IF (v_player_id > 0) THEN
			IF (p_operation = 2) THEN
				SELECT SUM(cash) FROM cashiers.transactions WHERE id = v_player_id AND operation = 1 INTO v_cash_in;
				SELECT SUM(cash) FROM cashiers.transactions WHERE id = v_player_id AND operation = 2 INTO v_cash_out;				
				v_cash_amount := v_cash_in - v_cash_out;
				
				IF (v_cash_amount >= p_cash) THEN
					INSERT INTO cashiers.transactions VALUES 
					(default, v_cashier_id, p_operation, v_player_id, p_cash, now());
				ELSE
					RAISE EXCEPTION 'the player doesn`t have that much money';
				END IF;
			END IF;
		ELSE
			RAISE EXCEPTION 'player not founds';
		END IF;
	ELSE
		RAISE EXCEPTION 'not enough rights';
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

--select * from cashiers.transactions;