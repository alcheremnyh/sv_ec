PGDMP                  
        |            ecdb    15.3    15.3 3    N           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            O           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            P           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            Q           1262    17416    ecdb    DATABASE        CREATE DATABASE ecdb WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1251';
    DROP DATABASE ecdb;
                ecus    false                        2615    17418    admins    SCHEMA        CREATE SCHEMA admins;
    DROP SCHEMA admins;
                ecus    false            
            2615    17417    cashiers    SCHEMA        CREATE SCHEMA cashiers;
    DROP SCHEMA cashiers;
                ecus    false            	            2615    17447    game_extracash    SCHEMA        CREATE SCHEMA game_extracash;
    DROP SCHEMA game_extracash;
                ecus    false                        2615    17419    players    SCHEMA        CREATE SCHEMA players;
    DROP SCHEMA players;
                ecus    false                        3079    17479    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                   false            R           0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                        false    2            �            1255    17455    login(text, text)    FUNCTION     �  CREATE FUNCTION admins.login(p_user_name text, p_user_password text) RETURNS TABLE(v_token text)
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE admins.list SET token=concat(md5(random()::text), md5(random()::text)) WHERE name = p_user_name AND password = crypt(p_user_password, password)
                                                             RETURNING token INTO v_token;

	RETURN QUERY SELECT COALESCE(v_token, '');
END;
$$;
 D   DROP FUNCTION admins.login(p_user_name text, p_user_password text);
       admins          postgres    false    7                       1255    17470    register(text, text)    FUNCTION     ]  CREATE FUNCTION admins.register(p_name text, p_password text) RETURNS TABLE(v_token text)
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
       admins          postgres    false    7                       1255    17471    register_check()    FUNCTION     �  CREATE FUNCTION admins.register_check() RETURNS trigger
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
       admins          postgres    false    7                       1255    17466    rules_get(bigint, text)    FUNCTION     }  CREATE FUNCTION admins.rules_get(p_game_id bigint, p_admin_token text) RETURNS TABLE(rtp bigint, jackpot_limit bigint, jackpot_percentage bigint, min_win bigint, max_win bigint, update timestamp with time zone, name text)
    LANGUAGE plpgsql
    AS $$
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
$$;
 F   DROP FUNCTION admins.rules_get(p_game_id bigint, p_admin_token text);
       admins          postgres    false    7            �            1255    17456    login(text, text)    FUNCTION     �  CREATE FUNCTION cashiers.login(p_user_name text, p_user_password text) RETURNS TABLE(v_token text)
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE cashiers.list SET token=concat(md5(random()::text), md5(random()::text)) WHERE name = p_user_name AND password = crypt(p_user_password, password)
                                                             RETURNING token INTO v_token;

	RETURN QUERY SELECT COALESCE(v_token, '');
END;
$$;
 F   DROP FUNCTION cashiers.login(p_user_name text, p_user_password text);
       cashiers          postgres    false    10                       1255    17473    register(text, text, text)    FUNCTION       CREATE FUNCTION cashiers.register(p_name text, p_password text, p_admin_token text) RETURNS TABLE(v_token text)
    LANGUAGE plpgsql
    AS $$
DECLARE
	v_id BIGINT;
BEGIN
	IF EXISTS (select 1 FROM admins.list WHERE token = p_admin_token AND is_active = true) THEN 
		INSERT INTO cashiers.list VALUES(default, p_name, p_password, true, now(),
	    			concat(md5(random()::text), md5(random()::text))) RETURNING token INTO v_token;
		RETURN QUERY SELECT v_token;
	ELSE
		RAISE EXCEPTION 'not enough rights';
	END IF;
END;
$$;
 S   DROP FUNCTION cashiers.register(p_name text, p_password text, p_admin_token text);
       cashiers          postgres    false    10                       1255    17474    register_check()    FUNCTION     �  CREATE FUNCTION cashiers.register_check() RETURNS trigger
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
       cashiers          postgres    false    10            �            1255    17457    login(text, text)    FUNCTION     �  CREATE FUNCTION players.login(p_user_name text, p_user_password text) RETURNS TABLE(v_token text)
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE players.list SET token=concat(md5(random()::text), md5(random()::text)) WHERE name = p_user_name AND password = crypt(p_user_password, password)
                                                             RETURNING token INTO v_token;

	RETURN QUERY SELECT COALESCE(v_token, '');
END;
$$;
 E   DROP FUNCTION players.login(p_user_name text, p_user_password text);
       players          postgres    false    8                       1255    17476    register(text, text, text)    FUNCTION     S  CREATE FUNCTION players.register(p_name text, p_password text, p_token text) RETURNS TABLE(v_token text)
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
       players          postgres    false    8                       1255    17477    register_check()    FUNCTION     �  CREATE FUNCTION players.register_check() RETURNS trigger
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
       players          postgres    false    8            �            1259    17430    list    TABLE     �   CREATE TABLE admins.list (
    id bigint NOT NULL,
    name text,
    password text,
    is_active boolean,
    created timestamp with time zone,
    token text
);
    DROP TABLE admins.list;
       admins         heap    ecus    false    7            �            1259    17429    list_id_seq    SEQUENCE     t   CREATE SEQUENCE admins.list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE admins.list_id_seq;
       admins          ecus    false    222    7            S           0    0    list_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE admins.list_id_seq OWNED BY admins.list.id;
          admins          ecus    false    221            �            1259    17421    list    TABLE     �   CREATE TABLE cashiers.list (
    id bigint NOT NULL,
    name text,
    password text,
    is_active boolean,
    created timestamp with time zone,
    token text
);
    DROP TABLE cashiers.list;
       cashiers         heap    ecus    false    10            �            1259    17420    list_id_seq    SEQUENCE     v   CREATE SEQUENCE cashiers.list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE cashiers.list_id_seq;
       cashiers          ecus    false    220    10            T           0    0    list_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE cashiers.list_id_seq OWNED BY cashiers.list.id;
          cashiers          ecus    false    219            �            1259    17449    rules    TABLE     �   CREATE TABLE game_extracash.rules (
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
       game_extracash         heap    ecus    false    9            �            1259    17448    rules_id_seq    SEQUENCE     }   CREATE SEQUENCE game_extracash.rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE game_extracash.rules_id_seq;
       game_extracash          ecus    false    9    226            U           0    0    rules_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE game_extracash.rules_id_seq OWNED BY game_extracash.rules.id;
          game_extracash          ecus    false    225            �            1259    17439    list    TABLE     �   CREATE TABLE players.list (
    id bigint NOT NULL,
    name text,
    password text,
    is_active boolean,
    created timestamp with time zone,
    token text
);
    DROP TABLE players.list;
       players         heap    ecus    false    8            �            1259    17438    list_id_seq    SEQUENCE     u   CREATE SEQUENCE players.list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE players.list_id_seq;
       players          ecus    false    224    8            V           0    0    list_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE players.list_id_seq OWNED BY players.list.id;
          players          ecus    false    223            �           2604    17433    list id    DEFAULT     b   ALTER TABLE ONLY admins.list ALTER COLUMN id SET DEFAULT nextval('admins.list_id_seq'::regclass);
 6   ALTER TABLE admins.list ALTER COLUMN id DROP DEFAULT;
       admins          ecus    false    221    222    222            �           2604    17424    list id    DEFAULT     f   ALTER TABLE ONLY cashiers.list ALTER COLUMN id SET DEFAULT nextval('cashiers.list_id_seq'::regclass);
 8   ALTER TABLE cashiers.list ALTER COLUMN id DROP DEFAULT;
       cashiers          ecus    false    220    219    220            �           2604    17452    rules id    DEFAULT     t   ALTER TABLE ONLY game_extracash.rules ALTER COLUMN id SET DEFAULT nextval('game_extracash.rules_id_seq'::regclass);
 ?   ALTER TABLE game_extracash.rules ALTER COLUMN id DROP DEFAULT;
       game_extracash          ecus    false    225    226    226            �           2604    17442    list id    DEFAULT     d   ALTER TABLE ONLY players.list ALTER COLUMN id SET DEFAULT nextval('players.list_id_seq'::regclass);
 7   ALTER TABLE players.list ALTER COLUMN id DROP DEFAULT;
       players          ecus    false    223    224    224            G          0    17430    list 
   TABLE DATA           M   COPY admins.list (id, name, password, is_active, created, token) FROM stdin;
    admins          ecus    false    222   D       E          0    17421    list 
   TABLE DATA           O   COPY cashiers.list (id, name, password, is_active, created, token) FROM stdin;
    cashiers          ecus    false    220   �D       K          0    17449    rules 
   TABLE DATA           }   COPY game_extracash.rules (id, rtp, jackpot_limit, jackpot_percentage, min_win, max_win, update, admin_id, name) FROM stdin;
    game_extracash          ecus    false    226   BE       I          0    17439    list 
   TABLE DATA           N   COPY players.list (id, name, password, is_active, created, token) FROM stdin;
    players          ecus    false    224   �E       W           0    0    list_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('admins.list_id_seq', 1, true);
          admins          ecus    false    221            X           0    0    list_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('cashiers.list_id_seq', 2, true);
          cashiers          ecus    false    219            Y           0    0    rules_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('game_extracash.rules_id_seq', 1, true);
          game_extracash          ecus    false    225            Z           0    0    list_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('players.list_id_seq', 1, false);
          players          ecus    false    223            �           2606    17437    list list_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY admins.list
    ADD CONSTRAINT list_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY admins.list DROP CONSTRAINT list_pkey;
       admins            ecus    false    222            �           2606    17428    list list_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY cashiers.list
    ADD CONSTRAINT list_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY cashiers.list DROP CONSTRAINT list_pkey;
       cashiers            ecus    false    220            �           2606    17454    rules rules_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY game_extracash.rules
    ADD CONSTRAINT rules_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY game_extracash.rules DROP CONSTRAINT rules_pkey;
       game_extracash            ecus    false    226            �           2606    17446    list list_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY players.list
    ADD CONSTRAINT list_pkey PRIMARY KEY (id);
 9   ALTER TABLE ONLY players.list DROP CONSTRAINT list_pkey;
       players            ecus    false    224            �           2620    17472    list register_check    TRIGGER     r   CREATE TRIGGER register_check BEFORE INSERT ON admins.list FOR EACH ROW EXECUTE FUNCTION admins.register_check();
 ,   DROP TRIGGER register_check ON admins.list;
       admins          ecus    false    260    222            �           2620    17475    list register_check    TRIGGER     v   CREATE TRIGGER register_check BEFORE INSERT ON cashiers.list FOR EACH ROW EXECUTE FUNCTION cashiers.register_check();
 .   DROP TRIGGER register_check ON cashiers.list;
       cashiers          ecus    false    281    220            �           2620    17478    list register_check    TRIGGER     t   CREATE TRIGGER register_check BEFORE INSERT ON players.list FOR EACH ROW EXECUTE FUNCTION players.register_check();
 -   DROP TRIGGER register_check ON players.list;
       players          ecus    false    224    283            G   �   x����0�ڞ�	%�>��vZ�D 㳥��h؁�����:O�m��b��}��s�}�����y���#�ߧH��`�Y�EE��B���胒JϜ=�{B-�HJ�Z����Ko���##�      E   �   x�½
�0 �9y
�nb��O��XqD�A��%�-(X�����g��{�|��TV�~�\N�U}wÇ�ӑ3\�,��q�A-ʀq��+l:o:jdi����Ƕ��""D1��i�"F�1��XH�%Ē\f�o����~)
      K   G   x�3�4�44 NC��4202�50�50T00�22�2�Գ4�013�60�4�t�()JTpN,������� ���      I      x������ � �     