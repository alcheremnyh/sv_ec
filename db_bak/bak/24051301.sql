PGDMP                       |            ecdb    16.3    16.2 =    G           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            H           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            I           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            J           1262    16398    ecdb    DATABASE        CREATE DATABASE ecdb WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE ecdb;
                ecus    false                        2615    16399    admins    SCHEMA        CREATE SCHEMA admins;
    DROP SCHEMA admins;
                ecus    false                        2615    16400    cashiers    SCHEMA        CREATE SCHEMA cashiers;
    DROP SCHEMA cashiers;
                ecus    false            	            2615    16401    game_extracash    SCHEMA        CREATE SCHEMA game_extracash;
    DROP SCHEMA game_extracash;
                ecus    false            
            2615    16402    players    SCHEMA        CREATE SCHEMA players;
    DROP SCHEMA players;
                ecus    false                        3079    16403    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                   false            K           0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                        false    2                       1255    16440    login(text, text)    FUNCTION     �  CREATE FUNCTION admins.login(p_user_name text, p_user_password text) RETURNS TABLE(token text)
    LANGUAGE plpgsql
    AS $$
DECLARE
	v_token TEXT;
BEGIN
	UPDATE admins.list SET token=concat(md5(random()::text), md5(random()::text)) WHERE name = p_user_name AND password = crypt(p_user_password, password)
                                                             RETURNING admins.list.token INTO v_token;

	RETURN QUERY SELECT COALESCE(v_token, '');
END;
$$;
 D   DROP FUNCTION admins.login(p_user_name text, p_user_password text);
       admins          postgres    false    7            
           1255    16441    register(text, text)    FUNCTION     ]  CREATE FUNCTION admins.register(p_name text, p_password text) RETURNS TABLE(v_token text)
    LANGUAGE plpgsql
    AS $$
DECLARE
	v_id BIGINT;
BEGIN
	INSERT INTO admins.list VALUES(default, p_name, p_password, true, now(),
    			concat(md5(random()::text), md5(random()::text))) RETURNING token INTO v_token;
	RETURN QUERY SELECT v_token;
END;
$$;
 =   DROP FUNCTION admins.register(p_name text, p_password text);
       admins          postgres    false    7                       1255    16501    register(text, text, text)    FUNCTION     C  CREATE FUNCTION admins.register(p_name text, p_password text, p_token text) RETURNS TABLE(login text, password text)
    LANGUAGE plpgsql
    AS $$
DECLARE
	v_id BIGINT;
	v_admin_id BIGINT;
	v_token TEXT;
BEGIN
	SELECT id FROM admins.list WHERE token = p_token INTO v_admin_id;

    IF v_admin_id = 1 THEN
		INSERT INTO admins.list VALUES(default, p_name, p_password, true, now(),
    			concat(md5(random()::text), md5(random()::text))) RETURNING token INTO v_token;
		RETURN QUERY SELECT p_name, p_password;
    ELSE
        RAISE EXCEPTION 'not authorized';
	END IF;
END;
$$;
 K   DROP FUNCTION admins.register(p_name text, p_password text, p_token text);
       admins          postgres    false    7                       1255    16442    register_check()    FUNCTION     �  CREATE FUNCTION admins.register_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF EXISTS (select 1 FROM admins.list WHERE name = NEW.name ) THEN 
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
$$;
 '   DROP FUNCTION admins.register_check();
       admins          postgres    false    7                       1255    16502    rules_get(bigint, text)    FUNCTION     �  CREATE FUNCTION admins.rules_get(p_game_id bigint, p_admin_token text) RETURNS TABLE(rtp bigint, jackpot_limit bigint, jackpot_percentage bigint, min_win bigint, max_win bigint, update timestamp with time zone, name text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_admin_id BIGINT;
BEGIN
    SELECT id FROM admins.list WHERE token = p_admin_token  AND is_active = true INTO v_admin_id;

    IF v_admin_id > 0 THEN
        RETURN QUERY SELECT gr.rtp, gr.jackpot_limit, gr.jackpot_percentage, gr.min_win, gr.max_win, gr.update, gr.name FROM game_extracash.rules gr WHERE gr.id = p_game_id;
    ELSE
        RAISE EXCEPTION 'not authorized';
	END IF;
END;
$$;
 F   DROP FUNCTION admins.rules_get(p_game_id bigint, p_admin_token text);
       admins          postgres    false    7                        1255    16444 E   rules_set(bigint, text, bigint, bigint, bigint, bigint, bigint, text)    FUNCTION     #  CREATE FUNCTION admins.rules_set(p_game_id bigint, p_admin_token text, p_rtp bigint, p_jackpot_limit bigint, p_jackpot_percentage bigint, p_min_win bigint, p_max_win bigint, p_name text) RETURNS TABLE(rtp bigint, jackpot_limit bigint, jackpot_percentage bigint, min_win bigint, max_win bigint, update timestamp with time zone, name text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_admin_id BIGINT;
BEGIN
    SELECT id FROM admins.list WHERE token = p_admin_token  AND is_active = true INTO v_admin_id;

    IF v_admin_id > 0 THEN
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
        RAISE EXCEPTION 'not authorized';
	END IF;
END;
$$;
 �   DROP FUNCTION admins.rules_set(p_game_id bigint, p_admin_token text, p_rtp bigint, p_jackpot_limit bigint, p_jackpot_percentage bigint, p_min_win bigint, p_max_win bigint, p_name text);
       admins          postgres    false    7                       1255    16445    login(text, text)    FUNCTION     �  CREATE FUNCTION cashiers.login(p_user_name text, p_user_password text) RETURNS TABLE(token text)
    LANGUAGE plpgsql
    AS $$
DECLARE
	v_token TEXT;
BEGIN
	UPDATE cashiers.list SET token=concat(md5(random()::text), md5(random()::text)) WHERE name = p_user_name AND password = crypt(p_user_password, password)
                                                             RETURNING cashiers.list.token INTO v_token;

	RETURN QUERY SELECT COALESCE(v_token, '');
END;
$$;
 F   DROP FUNCTION cashiers.login(p_user_name text, p_user_password text);
       cashiers          postgres    false    8            !           1255    16504    register(text, text, text)    FUNCTION     3  CREATE FUNCTION cashiers.register(p_name text, p_password text, p_admin_token text) RETURNS TABLE(login text, password text)
    LANGUAGE plpgsql
    AS $$
DECLARE
	v_id BIGINT;
	v_token TEXT;
BEGIN
	IF EXISTS (select 1 FROM admins.list WHERE token = p_admin_token AND is_active = true) THEN 
		INSERT INTO cashiers.list VALUES(default, p_name, p_password, true, now(),
	    			concat(md5(random()::text), md5(random()::text))) RETURNING token INTO v_token;
		RETURN QUERY SELECT p_name, p_password;
	ELSE
		RAISE EXCEPTION 'not enough rights';
	END IF;
END;
$$;
 S   DROP FUNCTION cashiers.register(p_name text, p_password text, p_admin_token text);
       cashiers          postgres    false    8                       1255    16447    register_check()    FUNCTION     �  CREATE FUNCTION cashiers.register_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF EXISTS (select 1 FROM cashiers.list WHERE name = NEW.name ) THEN 
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
$$;
 )   DROP FUNCTION cashiers.register_check();
       cashiers          postgres    false    8                       1255    16448 ,   transaction_set(text, text, integer, bigint)    FUNCTION     f  CREATE FUNCTION cashiers.transaction_set(p_cashier_token text, p_player_name text, p_operation integer, p_cash bigint) RETURNS TABLE(v_token text)
    LANGUAGE plpgsql
    AS $$
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
$$;
 v   DROP FUNCTION cashiers.transaction_set(p_cashier_token text, p_player_name text, p_operation integer, p_cash bigint);
       cashiers          postgres    false    8                       1255    16449    login(text, text)    FUNCTION     �  CREATE FUNCTION players.login(p_user_name text, p_user_password text) RETURNS TABLE(v_token text)
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE players.list SET token=concat(md5(random()::text), md5(random()::text)) WHERE name = p_user_name AND password = crypt(p_user_password, password)
                                                             RETURNING token INTO v_token;

	RETURN QUERY SELECT COALESCE(v_token, '');
END;
$$;
 E   DROP FUNCTION players.login(p_user_name text, p_user_password text);
       players          postgres    false    10                       1255    16450    register(text, text, text)    FUNCTION     S  CREATE FUNCTION players.register(p_name text, p_password text, p_token text) RETURNS TABLE(v_token text)
    LANGUAGE plpgsql
    AS $$
DECLARE
	v_id BIGINT;
BEGIN
	IF EXISTS (select 1 FROM admins.list WHERE token = p_token AND is_active = true)
		OR EXISTS (select 1 FROM cashiers.list WHERE token = p_token AND is_active = true) THEN 
		INSERT INTO players.list VALUES(default, p_name, p_password, true, now(),
	    			concat(md5(random()::text), md5(random()::text))) RETURNING token INTO v_token;
		RETURN QUERY SELECT v_token;
	ELSE
		RAISE EXCEPTION 'not enough rights';
	END IF;
END;
$$;
 L   DROP FUNCTION players.register(p_name text, p_password text, p_token text);
       players          postgres    false    10                       1255    16451    register_check()    FUNCTION     �  CREATE FUNCTION players.register_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;
 (   DROP FUNCTION players.register_check();
       players          postgres    false    10            �            1259    16452    list    TABLE     �   CREATE TABLE admins.list (
    id bigint NOT NULL,
    name text,
    password text,
    is_active boolean,
    created timestamp with time zone,
    token text
);
    DROP TABLE admins.list;
       admins         heap    ecus    false    7            �            1259    16457    list_id_seq    SEQUENCE     t   CREATE SEQUENCE admins.list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE admins.list_id_seq;
       admins          ecus    false    220    7            L           0    0    list_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE admins.list_id_seq OWNED BY admins.list.id;
          admins          ecus    false    221            �            1259    16458    list    TABLE     �   CREATE TABLE cashiers.list (
    id bigint NOT NULL,
    name text,
    password text,
    is_active boolean,
    created timestamp with time zone,
    token text
);
    DROP TABLE cashiers.list;
       cashiers         heap    ecus    false    8            �            1259    16463    list_id_seq    SEQUENCE     v   CREATE SEQUENCE cashiers.list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE cashiers.list_id_seq;
       cashiers          ecus    false    8    222            M           0    0    list_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE cashiers.list_id_seq OWNED BY cashiers.list.id;
          cashiers          ecus    false    223            �            1259    16464    transactions    TABLE     �   CREATE TABLE cashiers.transactions (
    id bigint NOT NULL,
    cashier_id bigint,
    operation_id integer,
    player_id bigint,
    cash bigint,
    created timestamp with time zone
);
 "   DROP TABLE cashiers.transactions;
       cashiers         heap    ecus    false    8            �            1259    16467    transactions_id_seq    SEQUENCE     ~   CREATE SEQUENCE cashiers.transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE cashiers.transactions_id_seq;
       cashiers          ecus    false    8    224            N           0    0    transactions_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE cashiers.transactions_id_seq OWNED BY cashiers.transactions.id;
          cashiers          ecus    false    225            �            1259    16468    rules    TABLE     �   CREATE TABLE game_extracash.rules (
    id bigint NOT NULL,
    rtp bigint,
    jackpot_limit bigint,
    jackpot_percentage bigint,
    min_win bigint,
    max_win bigint,
    update timestamp with time zone,
    admin_id bigint,
    name text
);
 !   DROP TABLE game_extracash.rules;
       game_extracash         heap    ecus    false    9            �            1259    16473    rules_id_seq    SEQUENCE     }   CREATE SEQUENCE game_extracash.rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE game_extracash.rules_id_seq;
       game_extracash          ecus    false    226    9            O           0    0    rules_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE game_extracash.rules_id_seq OWNED BY game_extracash.rules.id;
          game_extracash          ecus    false    227            �            1259    16474    list    TABLE     �   CREATE TABLE players.list (
    id bigint NOT NULL,
    name text,
    password text,
    is_active boolean,
    created timestamp with time zone,
    token text
);
    DROP TABLE players.list;
       players         heap    ecus    false    10            �            1259    16479    list_id_seq    SEQUENCE     u   CREATE SEQUENCE players.list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE players.list_id_seq;
       players          ecus    false    228    10            P           0    0    list_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE players.list_id_seq OWNED BY players.list.id;
          players          ecus    false    229            �           2604    16480    list id    DEFAULT     b   ALTER TABLE ONLY admins.list ALTER COLUMN id SET DEFAULT nextval('admins.list_id_seq'::regclass);
 6   ALTER TABLE admins.list ALTER COLUMN id DROP DEFAULT;
       admins          ecus    false    221    220            �           2604    16481    list id    DEFAULT     f   ALTER TABLE ONLY cashiers.list ALTER COLUMN id SET DEFAULT nextval('cashiers.list_id_seq'::regclass);
 8   ALTER TABLE cashiers.list ALTER COLUMN id DROP DEFAULT;
       cashiers          ecus    false    223    222            �           2604    16482    transactions id    DEFAULT     v   ALTER TABLE ONLY cashiers.transactions ALTER COLUMN id SET DEFAULT nextval('cashiers.transactions_id_seq'::regclass);
 @   ALTER TABLE cashiers.transactions ALTER COLUMN id DROP DEFAULT;
       cashiers          ecus    false    225    224            �           2604    16483    rules id    DEFAULT     t   ALTER TABLE ONLY game_extracash.rules ALTER COLUMN id SET DEFAULT nextval('game_extracash.rules_id_seq'::regclass);
 ?   ALTER TABLE game_extracash.rules ALTER COLUMN id DROP DEFAULT;
       game_extracash          ecus    false    227    226            �           2604    16484    list id    DEFAULT     d   ALTER TABLE ONLY players.list ALTER COLUMN id SET DEFAULT nextval('players.list_id_seq'::regclass);
 7   ALTER TABLE players.list ALTER COLUMN id DROP DEFAULT;
       players          ecus    false    229    228            ;          0    16452    list 
   TABLE DATA           M   COPY admins.list (id, name, password, is_active, created, token) FROM stdin;
    admins          ecus    false    220   �[       =          0    16458    list 
   TABLE DATA           O   COPY cashiers.list (id, name, password, is_active, created, token) FROM stdin;
    cashiers          ecus    false    222   _\       ?          0    16464    transactions 
   TABLE DATA           `   COPY cashiers.transactions (id, cashier_id, operation_id, player_id, cash, created) FROM stdin;
    cashiers          ecus    false    224   �\       A          0    16468    rules 
   TABLE DATA           }   COPY game_extracash.rules (id, rtp, jackpot_limit, jackpot_percentage, min_win, max_win, update, admin_id, name) FROM stdin;
    game_extracash          ecus    false    226   ]       C          0    16474    list 
   TABLE DATA           N   COPY players.list (id, name, password, is_active, created, token) FROM stdin;
    players          ecus    false    228   q]       Q           0    0    list_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('admins.list_id_seq', 2, true);
          admins          ecus    false    221            R           0    0    list_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('cashiers.list_id_seq', 7, true);
          cashiers          ecus    false    223            S           0    0    transactions_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('cashiers.transactions_id_seq', 1, false);
          cashiers          ecus    false    225            T           0    0    rules_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('game_extracash.rules_id_seq', 1, true);
          game_extracash          ecus    false    227            U           0    0    list_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('players.list_id_seq', 1, false);
          players          ecus    false    229            �           2606    16486    list list_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY admins.list
    ADD CONSTRAINT list_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY admins.list DROP CONSTRAINT list_pkey;
       admins            ecus    false    220            �           2606    16488    list list_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY cashiers.list
    ADD CONSTRAINT list_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY cashiers.list DROP CONSTRAINT list_pkey;
       cashiers            ecus    false    222            �           2606    16490    transactions transactions_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY cashiers.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY cashiers.transactions DROP CONSTRAINT transactions_pkey;
       cashiers            ecus    false    224            �           2606    16492    rules rules_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY game_extracash.rules
    ADD CONSTRAINT rules_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY game_extracash.rules DROP CONSTRAINT rules_pkey;
       game_extracash            ecus    false    226            �           2606    16494    list list_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY players.list
    ADD CONSTRAINT list_pkey PRIMARY KEY (id);
 9   ALTER TABLE ONLY players.list DROP CONSTRAINT list_pkey;
       players            ecus    false    228            �           2620    16495    list register_check    TRIGGER     r   CREATE TRIGGER register_check BEFORE INSERT ON admins.list FOR EACH ROW EXECUTE FUNCTION admins.register_check();
 ,   DROP TRIGGER register_check ON admins.list;
       admins          ecus    false    220    267            �           2620    16496    list register_check    TRIGGER     v   CREATE TRIGGER register_check BEFORE INSERT ON cashiers.list FOR EACH ROW EXECUTE FUNCTION cashiers.register_check();
 .   DROP TRIGGER register_check ON cashiers.list;
       cashiers          ecus    false    281    222            �           2620    16497    list register_check    TRIGGER     t   CREATE TRIGGER register_check BEFORE INSERT ON players.list FOR EACH ROW EXECUTE FUNCTION players.register_check();
 -   DROP TRIGGER register_check ON players.list;
       players          ecus    false    269    228            ;   �   x���
�0 �9�
�nR��䒴�X���A�K�ê--����F�4ΏI��TX����T]��:�N����Z��ǽY�|�`C�2��vM�Ha�E�IC��c���(1�����QE�Y!IFM�F����Z�6J'p      =   �   x�½
�0 �9y
�nb��O��XqD�A��%�-(X�����g��{�|��TV�~�\N�U}wÇ�ӑ3\�,��q�A-ʀq��+4�7�	5������Ƕ��""D1��i�"F�1��XH�%Ē\f�o����)      ?      x������ � �      A   F   x�3䴴�44 NC��4202�50�54T02�25�21�366615�60�t�()JTpN,������� ���      C      x������ � �     