--DROP TABLE IF EXISTS pessoa CASCADE;
CREATE TABLE pessoa (
	nusp				SERIAL NOT NULL,
	cpf				VARCHAR(14) NOT NULL,
	pnome				TEXT NOT NULL,
	snome				TEXT NOT NULL,
	datanasc			date NOT NULL,
	sexo				VARCHAR(1) NOT NULL,

	CONSTRAINT pk_pessoa	PRIMARY KEY (nusp),
	CONSTRAINT sk_pessoa	UNIQUE(cpf),
	CONSTRAINT cpf_check	CHECK(cpf LIKE '___.___.___-__'),
	CONSTRAINT sexo_check	CHECK(sexo IN ('F','M','O'))
);

--DROP TABLE IF EXISTS aluno CASCADE;
CREATE TABLE aluno (
	aluno_nusp		INTEGER,
	aluno_curso		TEXT NOT NULL,

	CONSTRAINT pk_aluno PRIMARY KEY (aluno_nusp, aluno_curso),
	CONSTRAINT sk_aluno UNIQUE (aluno_nusp),
	CONSTRAINT pf_al FOREIGN KEY (aluno_nusp) 
		REFERENCES pessoa (nusp)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

--DROP TABLE IF EXISTS professor CASCADE;
CREATE TABLE professor (
	prof_nusp		INTEGER,
	prof_unidade		TEXT NOT NULL,

	CONSTRAINT pk_professor	PRIMARY KEY (prof_nusp,prof_unidade),
	CONSTRAINT sk_professor UNIQUE (prof_nusp),
	CONSTRAINT pf_professor FOREIGN KEY (prof_nusp)
       		REFERENCES pessoa (nusp)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

--DROP TABLE IF EXISTS administrador CASCADE;
CREATE TABLE administrador (
	admin_nusp		INTEGER,
	admin_unidade		TEXT NOT NULL,

	CONSTRAINT pk_admin PRIMARY KEY (admin_nusp, admin_unidade),
	CONSTRAINT sk_admin UNIQUE (admin_nusp),
	CONSTRAINT pf_admin FOREIGN KEY (admin_nusp)
       		REFERENCES pessoa (nusp)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

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

--DROP TABLE IF EXISTS usuario CASCADE;
CREATE TABLE usuario(
	user_login			TEXT NOT NULL,
	user_email			TEXT NOT NULL,
	user_password			TEXT NOT NULL,	
	user_nusp			INT NOT NULL,

	CONSTRAINT pk_user PRIMARY KEY (user_login),
	CONSTRAINT fk_user FOREIGN KEY (user_nusp)
		REFERENCES pessoa (nusp)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT sk1_user UNIQUE (user_login),
	CONSTRAINT sk2_user UNIQUE (user_email)
);

--DROP TABLE IF EXISTS perfil CASCADE;
CREATE TABLE perfil (
	perfil_nome			TEXT NOT NULL,
	perfil_descricao		TEXT,

	CONSTRAINT pk_perfil PRIMARY KEY (perfil_nome)
);

--DROP TABLE IF EXISTS servico CASCADE;
CREATE TABLE service (
	service_nome			TEXT NOT NULL,
	service_descricao		TEXT NULL,

	CONSTRAINT pk_service PRIMARY KEY (service_nome)
);

--DROP TABLE IF EXISTS oferecimento CASCADE;
CREATE TABLE oferecimento(
	ofer_prof_nusp			INTEGER NOT NULL,
	ofer_disciplina_sigla		TEXT NOT NULL,
	ofer_ministra_data		date NOT NULL,

	CONSTRAINT pk_ofer PRIMARY KEY (ofer_prof_nusp, ofer_disciplina_sigla),
	CONSTRAINT fk_ofer1 FOREIGN KEY (ofer_prof_nusp)
		REFERENCES professor (prof_nusp)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_ofer2 FOREIGN KEY (ofer_disciplina_sigla)
		REFERENCES disciplina (disciplina_sigla)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE ministra(
	ministra_prof_nusp			INTEGER NOT NULL,
	ministra_disciplina_sigla		TEXT NOT NULL,

	CONSTRAINT pk_ministra PRIMARY KEY (ministra_prof_nusp, ministra_disciplina_sigla),
	CONSTRAINT fk_ministra1 FOREIGN KEY (ministra_prof_nusp)
		REFERENCES professor (prof_nusp)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_ministra2 FOREIGN KEY (ministra_disciplina_sigla)
		REFERENCES disciplina (disciplina_sigla)
		ON DELETE CASCADE
		ON UPDATE CASCADE
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

--DROP TABLE IF EXISTS administra CASCADE;
CREATE TABLE administra (
	administra_nusp			INTEGER NOT NULL,
	administra_curriculo_sigla	TEXT NOT NULL,
	administra_inicio		date,

	CONSTRAINT pk_administra
		PRIMARY KEY (administra_nusp, administra_curriculo_sigla),
	CONSTRAINT fk_administra1 FOREIGN KEY (administra_nusp)
		REFERENCES pessoa (nusp)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_administra2 FOREIGN KEY (administra_curriculo_sigla)
		REFERENCES curriculo (curriculo_sigla)
		ON DELETE CASCADE
		ON UPDATE CASCADE
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

--DROP TABLE IF EXISTS planeja CASCADE;
CREATE TABLE planeja (
	planeja_aluno_nusp		INTEGER NOT NULL,
	planeja_disciplina_sigla	TEXT NOT NULL,

	CONSTRAINT pk_planeja PRIMARY KEY (planeja_aluno_nusp, planeja_disciplina_sigla),
	CONSTRAINT fk_planeja1 FOREIGN KEY (planeja_aluno_nusp)
		REFERENCES aluno (aluno_nusp)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_planeja2 FOREIGN KEY (planeja_disciplina_sigla)
		REFERENCES disciplina (disciplina_sigla)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

--DROP TABLE IF EXISTS cursa CASCADE;
CREATE TABLE cursa (
	cursa_aluno_nusp		INTEGER NOT NULL,
	cursa_prof_nusp			INTEGER NOT NULL,
	cursa_disciplina_sigla		TEXT NOT NULL,
	cursa_nota			NUMERIC NOT NULL,
	cursa_presenca			NUMERIC NOT NULL,

	CONSTRAINT pk_cursa 
		PRIMARY KEY (cursa_aluno_nusp,cursa_prof_nusp,cursa_disciplina_sigla),
	CONSTRAINT fk_cursa1 FOREIGN KEY (cursa_aluno_nusp)
		REFERENCES aluno (aluno_nusp)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_cursa2 FOREIGN KEY (cursa_prof_nusp)
		REFERENCES professor (prof_nusp)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_cursa3 FOREIGN KEY (cursa_disciplina_sigla)
		REFERENCES disciplina (disciplina_sigla)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CHECK (cursa_nota >= 0 AND cursa_nota <= 10),
	CHECK (cursa_presenca >= 0 AND cursa_presenca <= 100)
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
