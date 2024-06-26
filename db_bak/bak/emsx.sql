PGDMP                         |            emsxdb %   14.11 (Ubuntu 14.11-0ubuntu0.22.04.1)    15.3                0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    16387    emsxdb    DATABASE     n   CREATE DATABASE emsxdb WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C.UTF-8';
    DROP DATABASE emsxdb;
                emsxus    false                        2615    2200    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                postgres    false                       0    0    SCHEMA public    ACL     Q   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   postgres    false    5                        2615    16388    users    SCHEMA        CREATE SCHEMA users;
    DROP SCHEMA users;
                emsxus    false                        3079    16389    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                   false    5                       0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                        false    2            �            1255    16426    login(text, text)    FUNCTION     �  CREATE FUNCTION users.login(p_nickname text, p_password text) RETURNS TABLE(v_token text)
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE users.list SET token=concat(md5(random()::text), md5(random()::text)), 
    	token_updated=now() WHERE nickname = p_nickname AND password = crypt(p_password, password)
                                                             RETURNING token INTO v_token;

	RETURN QUERY SELECT COALESCE(v_token, '');
END;
$$;
 =   DROP FUNCTION users.login(p_nickname text, p_password text);
       users          postgres    false    7            �            1259    16427    list    TABLE     �   CREATE TABLE users.list (
    id bigint NOT NULL,
    nickname text,
    password text,
    created timestamp with time zone,
    token text,
    token_updated timestamp with time zone,
    employee_id bigint,
    enabled boolean
);
    DROP TABLE users.list;
       users         heap    emsxus    false    7            �            1259    16432    list_id_seq    SEQUENCE     s   CREATE SEQUENCE users.list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 !   DROP SEQUENCE users.list_id_seq;
       users          emsxus    false    7    211                        0    0    list_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE users.list_id_seq OWNED BY users.list.id;
          users          emsxus    false    212            �           2604    16433    list id    DEFAULT     `   ALTER TABLE ONLY users.list ALTER COLUMN id SET DEFAULT nextval('users.list_id_seq'::regclass);
 5   ALTER TABLE users.list ALTER COLUMN id DROP DEFAULT;
       users          emsxus    false    212    211                      0    16427    list 
   TABLE DATA           j   COPY users.list (id, nickname, password, created, token, token_updated, employee_id, enabled) FROM stdin;
    users          emsxus    false    211          !           0    0    list_id_seq    SEQUENCE SET     8   SELECT pg_catalog.setval('users.list_id_seq', 1, true);
          users          emsxus    false    212            �           2606    16435    list list_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY users.list
    ADD CONSTRAINT list_pkey PRIMARY KEY (id);
 7   ALTER TABLE ONLY users.list DROP CONSTRAINT list_pkey;
       users            emsxus    false    211               �   x�U̽
�0 �9}
�nb��咴�ХZ)���Ll�`�^��C%�zU�%��gy۞.�BӞ�aX�洖MU��P���~]����y��?���Vi�ff�~�� S0fĞ�� *DȊ���b$���X�r�������tA4� z�L}^h*PgΠ���A=�C�$�5     