SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;

SET default_tablespace = '';
SET default_table_access_method = heap;

CREATE TABLE public.categoria (
    id bigint NOT NULL,
    nombre character varying(255) NOT NULL,
    descripcion character varying(255),
    padre_id bigint
);

ALTER TABLE public.categoria OWNER TO postgres;

CREATE SEQUENCE public.categoria_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.categoria_id_seq OWNER TO postgres;
ALTER SEQUENCE public.categoria_id_seq OWNED BY public.categoria.id;

CREATE TABLE public.ciudad_offline (
    id bigint NOT NULL,
    usuario_id uuid,
    nombre_ciudad character varying(255) NOT NULL,
    fecha_descarga timestamp without time zone,
    lugares_json text
);

ALTER TABLE public.ciudad_offline OWNER TO postgres;

CREATE SEQUENCE public.ciudad_offline_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.ciudad_offline_id_seq OWNER TO postgres;
ALTER SEQUENCE public.ciudad_offline_id_seq OWNED BY public.ciudad_offline.id;

CREATE TABLE public.evento (
    id bigint NOT NULL,
    lugar_id character varying(255),
    nombre character varying(255) NOT NULL,
    descripcion character varying(255),
    fecha_inicio timestamp without time zone,
    fecha_fin timestamp without time zone,
    hora_inicio time without time zone,
    hora_fin time without time zone,
    tipo character varying(255)
);

ALTER TABLE public.evento OWNER TO postgres;

CREATE SEQUENCE public.evento_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.evento_id_seq OWNER TO postgres;
ALTER SEQUENCE public.evento_id_seq OWNED BY public.evento.id;

CREATE TABLE public.favorito (
    id bigint NOT NULL,
    usuario_id uuid,
    lugar_id character varying(255),
    fecha_guardado timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE public.favorito OWNER TO postgres;

CREATE SEQUENCE public.favorito_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.favorito_id_seq OWNER TO postgres;
ALTER SEQUENCE public.favorito_id_seq OWNED BY public.favorito.id;

CREATE TABLE public.foto (
    id bigint NOT NULL,
    lugar_id character varying(255),
    url character varying(255) NOT NULL,
    descripcion character varying(255)
);

ALTER TABLE public.foto OWNER TO postgres;

CREATE SEQUENCE public.foto_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.foto_id_seq OWNER TO postgres;
ALTER SEQUENCE public.foto_id_seq OWNED BY public.foto.id;

CREATE TABLE public.lugar (
    id character varying(255) NOT NULL,
    nombre character varying(255) NOT NULL,
    latitud double precision NOT NULL,
    longitud double precision NOT NULL,
    direccion character varying(255),
    tipo character varying(255) NOT NULL,
    calificacion double precision,
    foto_url text,
    abierto_ahora boolean,
    duracion_estimada_minutos integer DEFAULT 30,
    usuario_id uuid,
    fecha_creacion timestamp without time zone
);

ALTER TABLE public.lugar OWNER TO postgres;

CREATE TABLE public.lugar_categoria (
    lugar_id character varying(255) NOT NULL,
    categoria_id bigint NOT NULL
);

ALTER TABLE public.lugar_categoria OWNER TO postgres;

CREATE TABLE public.lugares (
    id character varying(255) NOT NULL,
    nombre character varying(255) NOT NULL,
    direccion character varying(255) NOT NULL,
    latitud double precision NOT NULL,
    longitud double precision NOT NULL,
    categoria_general character varying(100) NOT NULL,
    subcategoria character varying(100) NOT NULL,
    rating double precision,
    precio integer,
    horario character varying(255),
    fuente character varying(50) DEFAULT 'Google'::character varying,
    ultima_actualizacion bigint,
    offline boolean DEFAULT false
);

ALTER TABLE public.lugares OWNER TO postgres;

CREATE TABLE public.review (
    id bigint NOT NULL,
    usuario_id uuid,
    lugar_id character varying(255),
    comentario character varying(255),
    puntuacion integer,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT review_puntuacion_check CHECK (((puntuacion >= 1) AND (puntuacion <= 5)))
);

ALTER TABLE public.review OWNER TO postgres;

CREATE SEQUENCE public.review_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.review_id_seq OWNER TO postgres;
ALTER SEQUENCE public.review_id_seq OWNED BY public.review.id;

CREATE TABLE public.ruta (
    id bigint NOT NULL,
    usuario_id uuid,
    nombre character varying(255),
    origen_lat double precision,
    origen_lng double precision,
    destino_lat double precision,
    destino_lng double precision,
    modo_transporte character varying(255),
    lugares_intermedios text,
    categoria character varying,
    ubicacion_id bigint,
    polyline_codificada text
);

ALTER TABLE public.ruta OWNER TO postgres;

CREATE SEQUENCE public.ruta_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.ruta_id_seq OWNER TO postgres;
ALTER SEQUENCE public.ruta_id_seq OWNED BY public.ruta.id;

CREATE TABLE public.ruta_lugar (
    id bigint NOT NULL,
    orden integer,
    lugar_id character varying(255),
    ruta_id bigint
);

ALTER TABLE public.ruta_lugar OWNER TO postgres;

ALTER TABLE public.ruta_lugar ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.ruta_lugar_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE public.ubicacion (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nombre text NOT NULL,
    latitud double precision NOT NULL,
    longitud double precision NOT NULL,
    tipo character varying(20) NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_id uuid NOT NULL,
    CONSTRAINT ubicacion_tipo_check CHECK (((tipo)::text = ANY ((ARRAY['país'::character varying, 'provincia'::character varying])::text[])))
);

ALTER TABLE public.ubicacion OWNER TO postgres;

CREATE TABLE public.usuario (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    nombre character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    contrasena character varying(255),
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    preferencias text,
    rol character varying(255) DEFAULT 'USUARIO'::character varying,
    apellido character varying(255),
    telefono character varying(255),
    verificado boolean DEFAULT false,
    pais character varying(255),
    ciudad character varying(255),
    direccion character varying(255),
    descripcion text,
    deleted_at timestamp without time zone,
    foto_perfil_url text
);

ALTER TABLE public.usuario OWNER TO postgres;

ALTER TABLE ONLY public.categoria ALTER COLUMN id SET DEFAULT nextval('public.categoria_id_seq'::regclass);
ALTER TABLE ONLY public.ciudad_offline ALTER COLUMN id SET DEFAULT nextval('public.ciudad_offline_id_seq'::regclass);
ALTER TABLE ONLY public.evento ALTER COLUMN id SET DEFAULT nextval('public.evento_id_seq'::regclass);
ALTER TABLE ONLY public.favorito ALTER COLUMN id SET DEFAULT nextval('public.favorito_id_seq'::regclass);
ALTER TABLE ONLY public.foto ALTER COLUMN id SET DEFAULT nextval('public.foto_id_seq'::regclass);
ALTER TABLE ONLY public.review ALTER COLUMN id SET DEFAULT nextval('public.review_id_seq'::regclass);
ALTER TABLE ONLY public.ruta ALTER COLUMN id SET DEFAULT nextval('public.ruta_id_seq'::regclass);

ALTER TABLE ONLY public.categoria ADD CONSTRAINT categoria_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ciudad_offline ADD CONSTRAINT ciudad_offline_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.evento ADD CONSTRAINT evento_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.favorito ADD CONSTRAINT favorito_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.foto ADD CONSTRAINT foto_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.lugar_categoria ADD CONSTRAINT lugar_categoria_pkey PRIMARY KEY (lugar_id, categoria_id);
ALTER TABLE ONLY public.lugar ADD CONSTRAINT lugar_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.lugares ADD CONSTRAINT lugares_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.review ADD CONSTRAINT review_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ruta_lugar ADD CONSTRAINT ruta_lugar_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ruta ADD CONSTRAINT ruta_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ubicacion ADD CONSTRAINT ubicacion_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.usuario ADD CONSTRAINT usuario_email_key UNIQUE (email);
ALTER TABLE ONLY public.usuario ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);

CREATE UNIQUE INDEX idx_unico_ubicacion ON public.ubicacion USING btree (usuario_id, latitud, longitud);

ALTER TABLE ONLY public.categoria ADD CONSTRAINT categoria_padre_id_fkey FOREIGN KEY (padre_id) REFERENCES public.categoria(id) ON DELETE SET NULL;
ALTER TABLE ONLY public.ciudad_offline ADD CONSTRAINT ciudad_offline_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuario(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.evento ADD CONSTRAINT evento_lugar_id_fkey FOREIGN KEY (lugar_id) REFERENCES public.lugar(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.favorito ADD CONSTRAINT favorito_lugar_id_fkey FOREIGN KEY (lugar_id) REFERENCES public.lugar(id);
ALTER TABLE ONLY public.favorito ADD CONSTRAINT favorito_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuario(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ruta_lugar ADD CONSTRAINT fk8eb7vnm77t6fjb043bqa6tlj0 FOREIGN KEY (lugar_id) REFERENCES public.lugar(id);
ALTER TABLE ONLY public.ubicacion ADD CONSTRAINT fk_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuario(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.lugar ADD CONSTRAINT fkjb6paj2ear4kyn1gk2wqw4fo9 FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);
ALTER TABLE ONLY public.ruta_lugar ADD CONSTRAINT fkp377hr9w70rg2qta5v43tp229 FOREIGN KEY (ruta_id) REFERENCES public.ruta(id);
ALTER TABLE ONLY public.foto ADD CONSTRAINT foto_lugar_id_fkey FOREIGN KEY (lugar_id) REFERENCES public.lugar(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.lugar_categoria ADD CONSTRAINT lugar_categoria_categoria_id_fkey FOREIGN KEY (categoria_id) REFERENCES public.categoria(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.lugar_categoria ADD CONSTRAINT lugar_categoria_lugar_id_fkey FOREIGN KEY (lugar_id) REFERENCES public.lugar(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.review ADD CONSTRAINT review_lugar_id_fkey FOREIGN KEY (lugar_id) REFERENCES public.lugar(id);
ALTER TABLE ONLY public.review ADD CONSTRAINT review_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuario(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ruta ADD CONSTRAINT ruta_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuario(id) ON DELETE CASCADE;
