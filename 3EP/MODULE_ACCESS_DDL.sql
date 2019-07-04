\c modulo_acesso;
SET ROLE dba;

CREATE EXTENSION IF NOT EXISTS citext;
DROP DOMAIN IF EXISTS email;
CREATE DOMAIN email AS citext
  CHECK ( value ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$' );

--DROP TABLE IF EXISTS usuario CASCADE;
CREATE TABLE usuario(
	user_login			TEXT NOT NULL,
	user_email			email NOT NULL,
	user_password			TEXT NOT NULL,	

	CONSTRAINT pk_user PRIMARY KEY (user_login),
	CONSTRAINT sk1_user UNIQUE (user_login),
	CONSTRAINT sk2_user UNIQUE (user_email)
);

--DROP TABLE IF EXISTS perfil CASCADE;
CREATE TABLE perfil (
	perfil_nome			TEXT NOT NULL,
	perfil_descricao		TEXT,

	CONSTRAINT pk_perfil PRIMARY KEY (perfil_nome)
);

--DROP TABLE IF EXISTS service CASCADE;
CREATE TABLE service (
	service_nome			TEXT NOT NULL,
	service_descricao		TEXT NULL,

	CONSTRAINT pk_service PRIMARY KEY (service_nome)
);

--DROP TABLE IF EXISTS us_pf CASCADE;
CREATE TABLE us_pf (
	us_pf_user_login		TEXT NOT NULL,
	us_pf_perfil_nome		TEXT NOT NULL,
	us_pf_perfil_inicio		date,

	CONSTRAINT pk_us_pf PRIMARY KEY (us_pf_user_login,us_pf_perfil_nome),
	CONSTRAINT fk_us_pf1 FOREIGN KEY (us_pf_user_login)
		REFERENCES usuario (user_login),
	CONSTRAINT fk_us_pf2 FOREIGN KEY (us_pf_perfil_nome)
		REFERENCES perfil (perfil_nome)
);

--DROP TABLE IF EXISTS pf_se CASCADE;
CREATE TABLE pf_se (
	pf_se_perfil_nome	TEXT NOT NULL,
	pf_se_service_nome	TEXT NOT NULL,

	CONSTRAINT pk_pf_se PRIMARY KEY (pf_se_perfil_nome,pf_se_service_nome),
	CONSTRAINT fk_pf_se1 FOREIGN KEY (pf_se_perfil_nome)
		REFERENCES perfil (perfil_nome)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_pf_se2 FOREIGN KEY (pf_se_service_nome)
		REFERENCES service (service_nome)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO aluno;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO professor;
