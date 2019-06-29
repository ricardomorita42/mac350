\c modulo_curriculo
SET ROLE dba;

--DROP TABLE IF EXISTS curriculo CASCADE;
--pode existir curriculo com mesmo nomes mas terão siglas diferentes 
CREATE TABLE curriculo (
	curriculo_sigla			TEXT NOT NULL,
	curriculo_unidade		TEXT ,
	curriculo_nome			TEXT ,
	curriculo_cred_obrig		INTEGER NOT NULL,
	curriculo_cred_opt_elet		INTEGER NOT NULL,
	curriculo_cred_opt_liv		INTEGER NOT NULL,
	
	CONSTRAINT pk_curriculo PRIMARY KEY (curriculo_sigla),
	CHECK (curriculo_cred_obrig > 0 AND curriculo_cred_obrig < 10000),
	CHECK (curriculo_cred_opt_elet > 0 AND curriculo_cred_opt_elet < 10000),
	CHECK (curriculo_cred_opt_liv > 0 AND curriculo_cred_opt_liv < 10000)
);

--DROP TABLE IF EXISTS trilha CASCADE;
CREATE TABLE trilha (
	trilha_nome			TEXT NOT NULL,
	trilha_descricao		TEXT,

	CONSTRAINT pk_trilha PRIMARY KEY (trilha_nome)
);

--Relacionamento trilha - modulo é 1:N logo 1a de trilha vai para modulo
--DROP TABLE IF EXISTS modulo CASCADE;
CREATE TABLE modulo (
	modulo_nome			TEXT NOT NULL,
	modulo_descricao		TEXT,
	modulo_trilha_nome		TEXT,

	CONSTRAINT pk_modulo PRIMARY KEY (modulo_nome),
	CONSTRAINT sk_modulo UNIQUE (modulo_trilha_nome),
	CONSTRAINT fk_modulo FOREIGN KEY (modulo_trilha_nome)
		REFERENCES trilha (trilha_nome)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

--DROP TABLE IF EXISTS disciplina CASCADE;
CREATE TABLE disciplina (
	disciplina_sigla		TEXT NOT NULL,
	disciplina_unidade		TEXT,
	disciplina_nome			TEXT,
	disciplina_cred_aula		INTEGER,
	disciplina_cred_trabalho	INTEGER,

	CONSTRAINT pk_disciplina PRIMARY KEY (disciplina_sigla),
	CHECK (disciplina_cred_trabalho >= 0 AND disciplina_cred_trabalho < 1000),
	CHECK (disciplina_cred_aula >= 0 AND disciplina_cred_aula < 1000)
);

--DROP TABLE IF EXISTS cur_tril CASCADE;
CREATE TABLE cur_tril (
	cur_tril_curriculo_sigla	TEXT NOT NULL,
	cur_tril_trilha_nome		TEXT NOT NULL,

	CONSTRAINT pk_cur_tril 
		PRIMARY KEY (cur_tril_curriculo_sigla, cur_tril_trilha_nome),
	CONSTRAINT fk_cur_tril1 FOREIGN KEY (cur_tril_curriculo_sigla)
		REFERENCES curriculo (curriculo_sigla)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_cur_tril2 FOREIGN KEY (cur_tril_trilha_nome)
		REFERENCES trilha (trilha_nome)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

--DROP TABLE IF EXISTS dis_mod CASCADE;
CREATE TABLE dis_mod (
	disc_mod_disciplina_sigla	TEXT NOT NULL,
	disc_mod_modulo_nome		TEXT NOT NULL,

	CONSTRAINT pk_disc_mod 
		PRIMARY KEY (disc_mod_disciplina_sigla, disc_mod_modulo_nome),
	CONSTRAINT fk_disc_mod1 FOREIGN KEY (disc_mod_disciplina_sigla)
		REFERENCES disciplina (disciplina_sigla)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_disc_mod2 FOREIGN KEY (disc_mod_modulo_nome)
		REFERENCES modulo (modulo_nome)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

--DROP TABLE IF EXISTS trilha_extrareqs CASCADE;
CREATE TABLE trilha_extrareqs (
	tril_extrareqs_trilha_nome	TEXT NOT NULL,
	tril_extrareqs_requisito	TEXT NOT NULL,

	CONSTRAINT pk_trilha_extrareqs 
		PRIMARY KEY (tril_extrareqs_trilha_nome,tril_extrareqs_requisito),
	CONSTRAINT fk_tril_extra FOREIGN KEY (tril_extrareqs_trilha_nome)
		REFERENCES trilha (trilha_nome)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

--DROP TABLE IF EXISTS disciplina_requisitos  CASCADE;
CREATE TABLE disciplina_requisitos (
	disc_reqs_disciplina_sigla	TEXT NOT NULL,
	disc_reqs_disciplina_requisito	TEXT NOT NULL,

	CONSTRAINT pk_disc_reqs 
		PRIMARY KEY (disc_reqs_disciplina_sigla, disc_reqs_disciplina_requisito),
	CONSTRAINT fk_disc_reqs1 FOREIGN KEY (disc_reqs_disciplina_sigla)
		REFERENCES disciplina (disciplina_sigla)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_disc_reqs2 FOREIGN KEY (disc_reqs_disciplina_requisito)
		REFERENCES disciplina (disciplina_sigla)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

--DROP TABLE IF EXISTS disciplina_biblio CASCADE;
CREATE TABLE disciplina_biblio (
	disc_biblio_disciplina_sigla	TEXT NOT NULL,
	disc_biblio_descricao		TEXT NOT NULL,

	CONSTRAINT pk_disc_biblio
		PRIMARY KEY (disc_biblio_disciplina_sigla),
	CONSTRAINT fk_disc_biblio FOREIGN KEY (disc_biblio_disciplina_sigla)
		REFERENCES disciplina (disciplina_sigla)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);
