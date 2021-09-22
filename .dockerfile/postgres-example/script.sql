CREATE DATABASE strimzi;

\c strimzi

CREATE TABLE public.users
(
    id serial NOT NULL,
    name character varying(50) NOT NULL,
    PRIMARY KEY (id)
)