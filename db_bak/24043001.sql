PGDMP     /                    |            ecdb    15.3    15.3 $               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    17416    ecdb    DATABASE        CREATE DATABASE ecdb WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1251';
    DROP DATABASE ecdb;
                ecus    false                        2615    17418    admins    SCHEMA        CREATE SCHEMA admins;
    DROP SCHEMA admins;
                ecus    false                        2615    17417    cashier    SCHEMA        CREATE SCHEMA cashier;
    DROP SCHEMA cashier;
                ecus    false            	            2615    17447    game_extracash    SCHEMA        CREATE SCHEMA game_extracash;
    DROP SCHEMA game_extracash;
                ecus    false                        2615    17419    players    SCHEMA        CREATE SCHEMA players;
    DROP SCHEMA players;
                ecus    false            �            1259    17430    list    TABLE     �   CREATE TABLE admins.list (
    id bigint NOT NULL,
    name text,
    password text,
    is_active boolean,
    created timestamp with time zone
);
    DROP TABLE admins.list;
       admins         heap    ecus    false    7            �            1259    17429    list_id_seq    SEQUENCE     t   CREATE SEQUENCE admins.list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE admins.list_id_seq;
       admins          ecus    false    7    221                        0    0    list_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE admins.list_id_seq OWNED BY admins.list.id;
          admins          ecus    false    220            �            1259    17421    list    TABLE     �   CREATE TABLE cashier.list (
    id bigint NOT NULL,
    name text,
    password text,
    is_active boolean,
    created timestamp with time zone
);
    DROP TABLE cashier.list;
       cashier         heap    ecus    false    6            �            1259    17420    list_id_seq    SEQUENCE     u   CREATE SEQUENCE cashier.list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE cashier.list_id_seq;
       cashier          ecus    false    6    219            !           0    0    list_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE cashier.list_id_seq OWNED BY cashier.list.id;
          cashier          ecus    false    218            �            1259    17449    rules    TABLE     �   CREATE TABLE game_extracash.rules (
    id bigint NOT NULL,
    rtp bigint,
    jackpot_limit bigint,
    jackpot_percentage bigint,
    min_win bigint,
    max_win bigint,
    update timestamp with time zone,
    admin_id bigint
);
 !   DROP TABLE game_extracash.rules;
       game_extracash         heap    ecus    false    9            �            1259    17448    rules_id_seq    SEQUENCE     }   CREATE SEQUENCE game_extracash.rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE game_extracash.rules_id_seq;
       game_extracash          ecus    false    9    225            "           0    0    rules_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE game_extracash.rules_id_seq OWNED BY game_extracash.rules.id;
          game_extracash          ecus    false    224            �            1259    17439    list    TABLE     �   CREATE TABLE players.list (
    id bigint NOT NULL,
    name text,
    password text,
    is_active boolean,
    created timestamp with time zone
);
    DROP TABLE players.list;
       players         heap    ecus    false    8            �            1259    17438    list_id_seq    SEQUENCE     u   CREATE SEQUENCE players.list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE players.list_id_seq;
       players          ecus    false    8    223            #           0    0    list_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE players.list_id_seq OWNED BY players.list.id;
          players          ecus    false    222            y           2604    17433    list id    DEFAULT     b   ALTER TABLE ONLY admins.list ALTER COLUMN id SET DEFAULT nextval('admins.list_id_seq'::regclass);
 6   ALTER TABLE admins.list ALTER COLUMN id DROP DEFAULT;
       admins          ecus    false    220    221    221            x           2604    17424    list id    DEFAULT     d   ALTER TABLE ONLY cashier.list ALTER COLUMN id SET DEFAULT nextval('cashier.list_id_seq'::regclass);
 7   ALTER TABLE cashier.list ALTER COLUMN id DROP DEFAULT;
       cashier          ecus    false    218    219    219            {           2604    17452    rules id    DEFAULT     t   ALTER TABLE ONLY game_extracash.rules ALTER COLUMN id SET DEFAULT nextval('game_extracash.rules_id_seq'::regclass);
 ?   ALTER TABLE game_extracash.rules ALTER COLUMN id DROP DEFAULT;
       game_extracash          ecus    false    224    225    225            z           2604    17442    list id    DEFAULT     d   ALTER TABLE ONLY players.list ALTER COLUMN id SET DEFAULT nextval('players.list_id_seq'::regclass);
 7   ALTER TABLE players.list ALTER COLUMN id DROP DEFAULT;
       players          ecus    false    222    223    223                      0    17430    list 
   TABLE DATA           F   COPY admins.list (id, name, password, is_active, created) FROM stdin;
    admins          ecus    false    221   �"                 0    17421    list 
   TABLE DATA           G   COPY cashier.list (id, name, password, is_active, created) FROM stdin;
    cashier          ecus    false    219   #                 0    17449    rules 
   TABLE DATA           w   COPY game_extracash.rules (id, rtp, jackpot_limit, jackpot_percentage, min_win, max_win, update, admin_id) FROM stdin;
    game_extracash          ecus    false    225   *#                 0    17439    list 
   TABLE DATA           G   COPY players.list (id, name, password, is_active, created) FROM stdin;
    players          ecus    false    223   G#       $           0    0    list_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('admins.list_id_seq', 1, false);
          admins          ecus    false    220            %           0    0    list_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('cashier.list_id_seq', 1, false);
          cashier          ecus    false    218            &           0    0    rules_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('game_extracash.rules_id_seq', 1, false);
          game_extracash          ecus    false    224            '           0    0    list_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('players.list_id_seq', 1, false);
          players          ecus    false    222                       2606    17437    list list_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY admins.list
    ADD CONSTRAINT list_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY admins.list DROP CONSTRAINT list_pkey;
       admins            ecus    false    221            }           2606    17428    list list_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY cashier.list
    ADD CONSTRAINT list_pkey PRIMARY KEY (id);
 9   ALTER TABLE ONLY cashier.list DROP CONSTRAINT list_pkey;
       cashier            ecus    false    219            �           2606    17454    rules rules_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY game_extracash.rules
    ADD CONSTRAINT rules_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY game_extracash.rules DROP CONSTRAINT rules_pkey;
       game_extracash            ecus    false    225            �           2606    17446    list list_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY players.list
    ADD CONSTRAINT list_pkey PRIMARY KEY (id);
 9   ALTER TABLE ONLY players.list DROP CONSTRAINT list_pkey;
       players            ecus    false    223                  x������ � �            x������ � �            x������ � �            x������ � �     