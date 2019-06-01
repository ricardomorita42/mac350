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
	CONSTRAINT pf_al FOREIGN KEY (aluno_nusp) REFERENCES pessoa (nusp)
);

--DROP TABLE IF EXISTS professor CASCADE;
CREATE TABLE professor (
	prof_nusp		INTEGER,
	prof_unidade		TEXT NOT NULL,

	CONSTRAINT pk_professor	PRIMARY KEY (prof_nusp,prof_unidade),
	CONSTRAINT sk_professor UNIQUE (prof_nusp),
	CONSTRAINT pf_professor FOREIGN KEY (prof_nusp) REFERENCES pessoa (nusp)
);

--DROP TABLE IF EXISTS admnistrador CASCADE;
CREATE TABLE admnistrador (
	admin_nusp		INTEGER,
	admin_unidade		TEXT NOT NULL,

	CONSTRAINT pk_admin PRIMARY KEY (admin_nusp, admin_unidade),
	CONSTRAINT sk_admin UNIQUE (admin_nusp),
	CONSTRAINT pf_admin FOREIGN KEY (admin_nusp) REFERENCES pessoa (nusp)
);

--DROP TABLE IF EXISTS curriculo CASCADE;
--pode existir curriculo com mesmo nomes mas terão siglas diferentes 
CREATE TABLE curriculo (
	curriculo_sigla			TEXT NOT NULL,
	curriculo_unidade		TEXT NOT NULL,
	curriculo_nome			TEXT NOT NULL,
	curriculo_cred_obrig		INTEGER,
	curriculo_cred_opt_elet		INTEGER,
	curriculo_cred_opt_liv		INTEGER,
	
	CONSTRAINT pk_curriculo PRIMARY KEY (curriculo_sigla),
	CHECK (curriculo_cred_obrig > 0 AND curriculo_cred_obrig < 10000),
	CHECK (curriculo_cred_opt_elet > 0 AND curriculo_cred_opt_elet < 10000),
	CHECK (curriculo_cred_opt_liv > 0 AND curriculo_cred_opt_liv < 10000)
);

--DROP TABLE IF EXISTS trilha CASCADE;
CREATE TABLE trilha (
	trilha_nome			TEXT NOT NULL,
	trilha_curriculo_sigla		TEXT NOT NULL,

	CONSTRAINT pk_trilha PRIMARY KEY (trilha_nome ,trilha_curriculo_sigla),
	CONSTRAINT sk_trilha UNIQUE (trilha_nome),
	CONSTRAINT fk_trilha FOREIGN KEY (trilha_curriculo_sigla)
		REFERENCES curriculo (curriculo_sigla)
);

--DROP TABLE IF EXISTS modulo CASCADE;
CREATE TABLE modulo (
	modulo_nome			TEXT NOT NULL,
	modulo_descricao		TEXT NOT NULL,

	CONSTRAINT pk_modulo PRIMARY KEY (modulo_nome)
);

--DROP TABLE IF EXISTS disciplina CASCADE;
CREATE TABLE disciplina (
	disciplina_sigla		TEXT NOT NULL,
	disciplina_unidade		TEXT NOT NULL,
	disciplina_nome			TEXT NOT NULL,
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

	CONSTRAINT pk_user PRIMARY KEY (user_login),
	CONSTRAINT sk1_user UNIQUE (user_login),
	CONSTRAINT sk2_user UNIQUE (user_email)
);

--DROP TABLE IF EXISTS perfil CASCADE;
CREATE TABLE perfil (
	perfil_nome			TEXT NOT NULL,
	perfil_descricao		TEXT NOT NULL,

	CONSTRAINT pk_perfil PRIMARY KEY (perfil_nome)
);

--DROP TABLE IF EXISTS servico CASCADE;
CREATE TABLE service (
	service_nome			TEXT NOT NULL,
	service_descricao		TEXT NOT NULL,

	CONSTRAINT pk_service PRIMARY KEY (service_nome)
);

--DROP TABLE IF EXISTS oferecimento CASCADE;
CREATE TABLE oferecimento(
	ofer_prof_nusp			INTEGER NOT NULL,
	ofer_disciplina_sigla		TEXT NOT NULL,
	ofer_ministra_data		date NOT NULL,

	CONSTRAINT pk_ofer PRIMARY KEY (ofer_prof_nusp, ofer_disciplina_sigla),
	CONSTRAINT fk_ofer1 FOREIGN KEY (ofer_prof_nusp)
		REFERENCES professor (prof_nusp),
	CONSTRAINT fk_ofer2 FOREIGN KEY (ofer_disciplina_sigla)
		REFERENCES disciplina (disciplina_sigla)
);

--DROP TABLE IF EXISTS pe_us CASCADE;
--cada pessoa tem um só login, o qual depende do nusp
CREATE TABLE pe_us (
	pe_us_nusp		INTEGER NOT NULL,
	pe_us_user_login	TEXT NOT NULL,

	CONSTRAINT pk_pe_us PRIMARY KEY (pe_us_nusp),
	CONSTRAINT fk_pe_us1 FOREIGN KEY (pe_us_nusp)
		REFERENCES pessoa (nusp),
	CONSTRAINT fk_pe_us2 FOREIGN KEY (pe_us_user_login)
		REFERENCES usuario (user_login)

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
		REFERENCES perfil (perfil_nome),
	CONSTRAINT fk_pf_se2 FOREIGN KEY (pf_se_service_nome)
		REFERENCES service (service_nome)
);

--DROP TABLE IF EXISTS admnistra CASCADE;
CREATE TABLE admnistra (
	admnistra_nusp			INTEGER NOT NULL,
	admnistra_curriculo_sigla	TEXT NOT NULL,
	admnistra_inicio		date,

	CONSTRAINT pk_admnistra
		PRIMARY KEY (admnistra_nusp, admnistra_curriculo_sigla),
	CONSTRAINT fk_admnistra1 FOREIGN KEY (admnistra_nusp)
		REFERENCES pessoa (nusp),
	CONSTRAINT fk_admnistra2 FOREIGN KEY (admnistra_curriculo_sigla)
		REFERENCES curriculo (curriculo_sigla)
);

--DROP TABLE IF EXISTS cur_tril CASCADE;
CREATE TABLE cur_tril (
	cur_tril_curriculo_sigla	TEXT NOT NULL,
	cur_tril_trilha_nome		TEXT NOT NULL,

	CONSTRAINT pk_cur_tril 
		PRIMARY KEY (cur_tril_curriculo_sigla, cur_tril_trilha_nome),
	CONSTRAINT fk_cur_tril1 FOREIGN KEY (cur_tril_curriculo_sigla)
		REFERENCES curriculo (curriculo_sigla),
	CONSTRAINT fk_cur_tril2 FOREIGN KEY (cur_tril_trilha_nome)
		REFERENCES trilha (trilha_nome)
);

--Esta certo este 1 :N? Uma trilha pode ter diversos modulos.
--DROP TABLE IF EXISTS tr_mod CASCADE;
CREATE TABLE tr_mod(
	tr_mod_trilha_nome		TEXT NOT NULL,
	tr_mod_modulo_nome		TEXT NOT NULL,

	CONSTRAINT pk_tr_mod 
		PRIMARY KEY (tr_mod_trilha_nome,tr_mod_modulo_nome),
	CONSTRAINT fk_tr_mod1 FOREIGN KEY (tr_mod_trilha_nome)
		REFERENCES trilha (trilha_nome),
	CONSTRAINT fk_tr_mod2 FOREIGN KEY (tr_mod_modulo_nome)
		REFERENCES modulo (modulo_nome)
);

--DROP TABLE IF EXISTS dis_mod CASCADE;
CREATE TABLE dis_mod (
	disc_mod_disciplina_sigla	TEXT NOT NULL,
	disc_mod_modulo_nome		TEXT NOT NULL,

	CONSTRAINT pk_disc_mod 
		PRIMARY KEY (disc_mod_disciplina_sigla, disc_mod_modulo_nome),
	CONSTRAINT fk_disc_mod1 FOREIGN KEY (disc_mod_disciplina_sigla)
		REFERENCES disciplina (disciplina_sigla),
	CONSTRAINT fk_disc_mod2 FOREIGN KEY (disc_mod_modulo_nome)
		REFERENCES modulo (modulo_nome)
);

--DROP TABLE IF EXISTS alu_cur CASCADE;
CREATE TABLE alu_cur (
	rel_alu_cur_aluno_nusp			INTEGER NOT NULL,
	rel_alu_cur_curriculo_sigla		TEXT NOT NULL,

	CONSTRAINT pk_rel_alucur 
		PRIMARY KEY (rel_alu_cur_aluno_nusp,rel_alu_cur_curriculo_sigla),
	CONSTRAINT fk_rel_alu_cur1 FOREIGN KEY (rel_alu_cur_aluno_nusp)
		REFERENCES aluno(aluno_nusp),
	CONSTRAINT fk_rel_alu_cur2 FOREIGN KEY (rel_alu_cur_curriculo_sigla)
		REFERENCES curriculo (curriculo_sigla)
);

--DROP TABLE IF EXISTS planeja CASCADE;
CREATE TABLE planeja (
	planeja_aluno_nusp		INTEGER NOT NULL,
	planeja_disciplina_sigla	TEXT NOT NULL,

	CONSTRAINT pk_planeja PRIMARY KEY (planeja_aluno_nusp, planeja_disciplina_sigla),
	CONSTRAINT fk_planeja1 FOREIGN KEY (planeja_aluno_nusp)
		REFERENCES aluno (aluno_nusp),
	CONSTRAINT fk_planeja2 FOREIGN KEY (planeja_disciplina_sigla)
		REFERENCES disciplina (disciplina_sigla)
);

--DROP TABLE IF EXISTS ministra CASCADE;
CREATE TABLE ministra (
	ministra_prof_nusp		INTEGER NOT NULL,
	ministra_disciplina_sigla	TEXT NOT NULL,

	CONSTRAINT pk_ministra
		PRIMARY KEY (ministra_prof_nusp, ministra_disciplina_sigla),
	CONSTRAINT fk_ministra1 FOREIGN KEY (ministra_prof_nusp)
		REFERENCES professor (prof_nusp),
	CONSTRAINT fk_ministra2 FOREIGN KEY (ministra_disciplina_sigla)
		REFERENCES disciplina (disciplina_sigla)
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
		REFERENCES aluno (aluno_nusp),
	CONSTRAINT fk_cursa2 FOREIGN KEY (cursa_prof_nusp)
		REFERENCES professor (prof_nusp),
	CONSTRAINT fk_cursa3 FOREIGN KEY (cursa_disciplina_sigla)
		REFERENCES disciplina (disciplina_sigla),
	CHECK (cursa_nota >= 0 AND cursa_nota <= 10),
	CHECK (cursa_presenca >= 0 AND cursa_presenca <= 100)
);

--DROP TABLE IF EXISTS perfil_permissoes CASCADE;
CREATE TABLE perfil_permissoes (
	perf_perm_perfil_nome		TEXT NOT NULL,
	perf_perm_permissao		TEXT NOT NULL,

	CONSTRAINT pk_perf_perm 
		PRIMARY KEY (perf_perm_perfil_nome,perf_perm_permissao),
	CONSTRAINT fk_perf_perm FOREIGN KEY (perf_perm_perfil_nome)
		REFERENCES perfil (perfil_nome)
);

--DROP TABLE IF EXISTS linguas CASCADE;
CREATE TABLE linguas (
	linguas_nusp		INTEGER NOT NULL,
	linguas_nome		TEXT NOT NULL,

	CONSTRAINT pk_attr_linguas 
		PRIMARY KEY (linguas_nusp,linguas_nome),
	CONSTRAINT fk_attr_linguas FOREIGN KEY (linguas_nusp)
		REFERENCES pessoa (nusp)
);

--DROP TABLE IF EXISTS disc_cursadas CASCADE;
CREATE TABLE disc_cursadas (
	disc_cursadas_aluno_nusp		INTEGER NOT NULL,
	disc_cursadas_curriculo_sigla		TEXT NOT NULL,
	disc_cursadas_disciplina_sigla		TEXT NOT NULL,

	CONSTRAINT pk_disc_cursadas
		PRIMARY KEY(disc_cursadas_aluno_nusp,disc_cursadas_curriculo_sigla,disc_cursadas_disciplina_sigla),
	CONSTRAINT fk_disc_cursadas1 FOREIGN KEY (disc_cursadas_aluno_nusp)
		REFERENCES aluno(aluno_nusp),
	CONSTRAINT fk_disc_cursadas2 FOREIGN KEY (disc_cursadas_curriculo_sigla)
		REFERENCES curriculo (curriculo_sigla),
	CONSTRAINT fk_disc_cursadas3 FOREIGN KEY (disc_cursadas_disciplina_sigla)
		REFERENCES disciplina (disciplina_sigla)
);

--DROP TABLE IF EXISTS trilha_extrareqs CASCADE;
CREATE TABLE trilha_extrareqs (
	tril_extrareqs_trilha_nome	TEXT NOT NULL,
	tril_extrareqs_requisito	TEXT NOT NULL,

	CONSTRAINT pk_trilha_extrareqs 
		PRIMARY KEY (tril_extrareqs_trilha_nome,tril_extrareqs_requisito),
	CONSTRAINT fk_tril_extra FOREIGN KEY (tril_extrareqs_trilha_nome)
		REFERENCES trilha (trilha_nome)
);

--DROP TABLE IF EXISTS disciplina_requisitos  CASCADE;
CREATE TABLE disciplina_requisitos (
	disc_reqs_disciplina_sigla	TEXT NOT NULL,
	disc_reqs_requisito		TEXT NOT NULL,

	CONSTRAINT pk_disc_reqs 
		PRIMARY KEY (disc_reqs_disciplina_sigla, disc_reqs_requisito),
	CONSTRAINT fk_disc_reqs FOREIGN KEY (disc_reqs_disciplina_sigla)
		REFERENCES disciplina (disciplina_sigla)
);

--DROP TABLE IF EXISTS disciplina_biblio CASCADE;
CREATE TABLE disciplina_biblio (
	disc_biblio_disciplina_sigla	TEXT NOT NULL,
	disc_biblio_requisito		TEXT NOT NULL,

	CONSTRAINT pk_disc_biblio
		PRIMARY KEY (disc_biblio_disciplina_sigla,disc_biblio_requisito),
	CONSTRAINT fk_disc_biblio FOREIGN KEY (disc_biblio_disciplina_sigla)
		REFERENCES disciplina (disciplina_sigla)
);

--DROP TABLE IF EXISTS cur_disc_opt_elet CASCADE;
CREATE TABLE cur_disc_opt_elet(
	cur_disc_opt_elet_curriculo_sigla	TEXT NOT NULL,
	cur_disc_opt_elet_disciplina_sigla	TEXT NOT NULL,

	CONSTRAINT pk_cur_disc_opt_elet 
		PRIMARY KEY (cur_disc_opt_elet_curriculo_sigla, cur_disc_opt_elet_disciplina_sigla),
	CONSTRAINT fk_cur_disc_opt_elet1 FOREIGN KEY (cur_disc_opt_elet_curriculo_sigla)
		REFERENCES curriculo (curriculo_sigla),
	CONSTRAINT fk_cur_disc_opt_elet2  FOREIGN KEY (cur_disc_opt_elet_disciplina_sigla)
		REFERENCES disciplina (disciplina_sigla)
);

--DROP TABLE IF EXISTS cur_disc_opt_liv CASCADE;
CREATE TABLE cur_disc_opt_liv (
	cur_disc_opt_livre_curriculo_sigla	TEXT NOT NULL,
	cur_disc_opt_livre_disciplina_sigla	TEXT NOT NULL,

	CONSTRAINT pk_cur_disc_opt_livre
		PRIMARY KEY (cur_disc_opt_livre_curriculo_sigla, cur_disc_opt_livre_disciplina_sigla),
	CONSTRAINT fk_cur_disc_opt_livre1 FOREIGN KEY (cur_disc_opt_livre_curriculo_sigla)
		REFERENCES curriculo (curriculo_sigla),
	CONSTRAINT fk_cur_disc_opt_livre2  FOREIGN KEY (cur_disc_opt_livre_disciplina_sigla)
		REFERENCES disciplina (disciplina_sigla)
);
