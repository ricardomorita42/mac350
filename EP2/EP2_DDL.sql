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
	CONSTRAINT pf_al FOREIGN KEY (aluno_nusp) REFERENCES pessoa (nusp)
);

--DROP TABLE IF EXISTS professor CASCADE;
CREATE TABLE professor (
	prof_nusp		INTEGER,
	prof_unidade		TEXT NOT NULL,

	CONSTRAINT pk_professor	PRIMARY KEY (prof_nusp,prof_unidade),
	CONSTRAINT pf_prof FOREIGN KEY (prof_nusp) REFERENCES pessoa (nusp)
);

--DROP TABLE IF EXISTS admnistrador CASCADE;
CREATE TABLE admnistrador (
	admin_nusp		INTEGER,
	admin_unidade		TEXT NOT NULL,

	CONSTRAINT pk_admin PRIMARY KEY (admin_nusp, admin_unidade),
	CONSTRAINT pf_admin FOREIGN KEY (admin_nusp) REFERENCES pessoa (nusp)
);

--DROP TABLE IF EXISTS curriculo CASCADE;
--pode existir curriculo com mesmo nome mas id seria diferente (mudanca de curriculo)
CREATE TABLE curriculo (
	curriculo_id			SERIAL NOT NULL,
	curriculo_unidade		TEXT NOT NULL,
	curriculo_nome			TEXT NOT NULL,
	curriculo_cred_obrig		INTEGER,
	curriculo_cred_opt_elet		INTEGER,
	curriculo_cred_opt_liv		INTEGER,

	
	CHECK (curriculo_cred_obrig > 0 AND curriculo_cred_obrig < 10000),
	CHECK (curriculo_cred_opt_elet > 0 AND curriculo_cred_opt_elet < 10000),
	CHECK (curriculo_cred_opt_liv > 0 AND curriculo_cred_opt_liv < 10000),
	CONSTRAINT pk_curriculo PRIMARY KEY (curriculo_id),
	CONSTRAINT sk_curriculo UNIQUE (curriculo_nome)
);

--DROP TABLE IF EXISTS trilha CASCADE;
CREATE TABLE trilha (
	trilha_nome			TEXT NOT NULL,
	trilha_curriculo_id		INTEGER NOT NULL,

	CONSTRAINT pk_trilha PRIMARY KEY (trilha_nome ,trilha_Curriculo_id),
	CONSTRAINT sk_trilha FOREIGN KEY (trilha_Curriculo_id)
		REFERENCES curriculo (curriculo_id)
);

--DROP TABLE IF EXISTS modulo CASCADE;
CREATE TABLE modulo (
	modulo_id			SERIAL NOT NULL,
	modulo_curriculo		INTEGER NOT NULL,
	modulo_nome			TEXT NOT NULL,
	modulo_trilha_nome		TEXT NOT NULL,

	CONSTRAINT pk_modulo PRIMARY KEY (modulo_id),
	CONSTRAINT sk_modulo FOREIGN KEY (modulo_curriculo)
		REFERENCES curriculo (curriculo_id),
	CONSTRAINT sk2_modulo FOREIGN KEY (modulo_trilha_nome)
		REFERENCES trilha (trilha_nome)
);

--DROP TABLE IF EXISTS disciplina CASCADE;
CREATE TABLE disciplina (
	disciplina_id			SERIAL NOT NULL,
	disciplina_unidade		TEXT NOT NULL,
	disciplina_sigla		TEXT NOT NULL,
	disciplina_nome			TEXT NOT NULL,
	disciplina_cred_aula		INTEGER,
	disciplina_cred_trabalho	INTEGER,

	CONSTRAINT pk_disciplina PRIMARY KEY (disciplina_id),
	CONSTRAINT sk_disciplina UNIQUE (disciplina_sigla),
	CHECK (disciplina_cred_trabalho >= 0 AND disciplina_cred_trabalho < 1000),
	CHECK (disciplina_cred_aula >= 0 AND disciplina_cred_aula < 1000)
);

--DROP TABLE IF EXISTS perfil CASCADE;
CREATE TABLE perfil (
	perfil_nome			TEXT NOT NULL,
	perfil_descricao		TEXT NOT NULL,

	CONSTRAINT pk_perfil PRIMARY KEY (perfil_nome)
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

--DROP TABLE IF EXISTS servico CASCADE;
CREATE TABLE servico (
	service_id			SERIAL NOT NULL,
	service_nome			TEXT NOT NULL,

	CONSTRAINT pk_servico PRIMARY KEY (service_id,service_nome)
);

--DROP TABLE IF EXISTS oferecimento CASCADE;
CREATE TABLE oferecimento(
	ofer_id				SERIAL NOT NULL,
	ofer_prof_nusp			INTEGER NOT NULL,
	ofer_disciplina_id		INTEGER NOT NULL,
	ofer_ministra_data		date NOT NULL,

	CONSTRAINT pk_ofer PRIMARY KEY (ofer_id),
	CONSTRAINT fk_ofer1 FOREIGN KEY (ofer_nusp)
		REFERENCES professor (prof_nusp),
	CONSTRAINT fk_ofer2 FOREIGN KEY (ofer_disciplina_id)
		REFERENCES disciplina (disciplina_id)
);

--DROP TABLE IF EXISTS pe_us CASCADE;
CREATE TABLE pe_us (
	pe_us_id		SERIAL NOT NULL,
	pe_us_nusp		INTEGER NOT NULL,
	pe_us_user_id		INTEGER NOT NULL,

	CONSTRAINT pk_pe_us PRIMARY KEY (pe_us_id),
	CONSTRAINT fk_pe_us1 FOREIGN KEY (pe_us_nusp)
		REFERENCES pessoa (NUSP),
	CONSTRAINT fk_pe_us2 FOREIGN KEY (pe_us_user_id)
		REFERENCES usuario (user_id)

);

--DROP TABLE IF EXISTS us_pf CASCADE;
CREATE TABLE us_pf (
	us_pf_id			SERIAL NOT NULL,
	us_pf_user_id			INTEGER NOT NULL,
	us_pf_perfil_id			INTEGER NOT NULL,
	us_pf_perfil_inicio		date,

	CONSTRAINT pk_us_pf PRIMARY KEY (us_pf_id),
	CONSTRAINT fk_us_pf1 FOREIGN KEY (us_pf_user_id)
		REFERENCES usuario (user_id),
	CONSTRAINT fk_us_pf2 FOREIGN KEY (us_pf_perfil_id)
		REFERENCES perfil (perfil_id)
);

--DROP TABLE IF EXISTS rel_pf_se CASCADE;
CREATE TABLE pf_se (
	pf_se_id		SERIAL NOT NULL,
	pf_se_perfil_id		INTEGER NOT NULL,
	pf_se_service_id	INTEGER NOT NULL,

	CONSTRAINT pk_pf_se PRIMARY KEY (pf_se_id),
	CONSTRAINT fk_pf_se1 FOREIGN KEY (pf_se_perfil_id)
		REFERENCES perfil (perfil_id),
	CONSTRAINT fk_pf_se2	FOREIGN KEY (pf_se_service_id)
		REFERENCES servico (service_id)
);

--DROP TABLE IF EXISTS rel_admnistra CASCADE;
CREATE TABLE admnistra (
	admnistra_id			SERIAL NOT NULL,
	admnistra_nusp			INTEGER NOT NULL,
	admnistra_curriculo_id		INTEGER NOT NULL,
	admnistra_inicio		date,

	CONSTRAINT pk_admnistra PRIMARY KEY (admnistra_id),
	CONSTRAINT fk_admnistra1 FOREIGN KEY (admnistra_nusp)
		REFERENCES pessoa (nusp),
	CONSTRAINT fk_admnistra2 FOREIGN KEY (admnistra_curriculo_id)
		REFERENCES curriculo (curriculo_id)
);

--DROP TABLE IF EXISTS b16_rel_cur_tril CASCADE;
CREATE TABLE cur_tril (
	cur_tril_curriculo_id		INTEGER NOT NULL,
	cur_tril_trilha_id		INTEGER NOT NULL,

	CONSTRAINT pk_cur_tril 
		PRIMARY KEY (cur_tril_curriculo, cur_tril_trilha_id),
	CONSTRAINT fk_cur_tril1 FOREIGN KEY (cur_tril_curriculo_id)
		REFERENCES curriculo (curriculo_id),
	CONSTRAINT fk_cur_tril2 FOREIGN KEY (cur_tril_trilha_id)
		REFERENCES trilha (trilha_id)
);

--DROP TABLE IF EXISTS b17_rel_dis_mod CASCADE;
CREATE TABLE dis_mod (
	disc_mod_disciplina_id		INTEGER NOT NULL,
	disc_mod_modulo_id		INTEGER NOT NULL,

	CONSTRAINT pk_disc_mod 
		PRIMARY KEY (disc_mod_disciplina_id, disc_mod_modulo_id),
	CONSTRAINT fk_disc_mod1 FOREIGN KEY (disc_mod_disciplina_id)
		REFERENCES disciplina (disciplina_id),
	CONSTRAINT fk_disc_mod2 FOREIGN KEY (disc_mod_modulo_id)
		REFERENCES modulo (modulo_id)
);

--DROP TABLE IF EXISTS b18_rel_alu_cur CASCADE;
CREATE TABLE alu_cur (
	rel_alu_cur_al_nusp			INTEGER NOT NULL,
	rel_alu_cur_curriculo_id		INTEGER NOT NULL,

	CONSTRAINT pk_rel_alucur 
		PRIMARY KEY (rel_alu_cur_al_nusp,rel_alu_cur_curriculo_id),
	CONSTRAINT fk_rel_alu_cur1 FOREIGN KEY (rel_alu_cur_al_nusp)
		REFERENCES aluno(al_nusp),
	CONSTRAINT fk_rel_alu_cur2 FOREIGN KEY (rel_alu_cur_curriculo_id)
		REFERENCES curriculo (curriculo_id)
);

--DROP TABLE IF EXISTS b19_rel_planeja CASCADE;
CREATE TABLE planeja (
	planeja_nusp			INTEGER NOT NULL,
	planeja_disciplina_id		INTEGER NOT NULL,

	CONSTRAINT pk_planeja PRIMARY KEY (planeja_nusp, planeja_disciplina_id),
	CONSTRAINT fk_planeja1 FOREIGN KEY (planeja_nusp)
		REFERENCES aluno (al_nusp),
	CONSTRAINT fk_planeja2 FOREIGN KEY (planeja_disciplina_id)
		REFERENCES disciplina (disciplina_id)
);

--DROP TABLE IF EXISTS ministra CASCADE;
CREATE TABLE ministra (
	ministra_id		SERIAL NOT NULL,
	ministra_prof_nusp	INTEGER NOT NULL,
	ministra_disc_id	INTEGER NOT NULL,

	CONSTRAINT pk_ministra PRIMARY KEY (ministra_prof_nusp, ministra_disc_id),
	CONSTRAINT fk_ministra1 FOREIGN KEY (ministra_prof_nusp)
		REFERENCES professor (prof_nusp),
	CONSTRAINT fk_ministra2 FOREIGN KEY (ministra_disciplina_id)
		REFERENCES disciplina (disciplina_d)
);

--DROP TABLE IF EXISTS b21_rel_cursa CASCADE;
CREATE TABLE cursa (
	cursa_id		SERIAL NOT NULL,
	cursa_al_nusp		INTEGER NOT NULL,
	cursa_disciplina_id	INTEGER NOT NULL,
	cursa_nota		numeric NOT NULL,
	cursa_presenca		numeric NOT NULL,

	CHECK (rel_cursa_nota >= 0 AND rel_cursa_nota <= 10),
	CHECK (rel_cursa_presenca >= 0 AND rel_cursa_presenca <= 100),
	CONSTRAINT pk_cursa PRIMARY KEY (cursa_id),
	CONSTRAINT fk_cursa1 FOREIGN KEY (cursa_al_nusp)
		REFERENCES aluno (al_nusp),
	CONSTRAINT fk_cursa2 FOREIGN KEY (cursa_disciplina_id)
		REFERENCES disciplina (disciplina_id)
);

--DROP TABLE IF EXISTS b22_attr_perfil_permissoes CASCADE;
CREATE TABLE perfil_permissoes (
	perf_perm_perfil_id		INTEGER NOT NULL,
	perf_perm_permissao		TEXT NOT NULL,

	CONSTRAINT pk_perf_perm 
		PRIMARY KEY (perf_perm_perfil_id,perf_perm_permissao),
	CONSTRAINT fk_perf_perm FOREIGN KEY (perf_perm_perfil_id)
		REFERENCES perfil (perfil_id)
);

--DROP TABLE IF EXISTS b23_attr_linguas CASCADE;
CREATE TABLE linguas (
	linguas_nusp		INTEGER NOT NULL,
	linguas_nome		TEXT NOT NULL,

	CONSTRAINT pk_attr_linguas 
		PRIMARY KEY (linguas_nusp,linguas_nome),
	CONSTRAINT fk_attr_linguas FOREIGN KEY (linguas_nusp)
		REFERENCES pessoa (nusp)
);

--DROP TABLE IF EXISTS b24_attr_disc_Cursadas CASCADE;
CREATE TABLE disc_cursadas (
	disc_cursadas_al_nusp			INTEGER NOT NULL,
	disc_cursadas_curriculo			INTEGER NOT NULL,
	disc_cursadas_disciplina		INTEGER NOT NULL,

	CONSTRAINT pk_disc_cursadas
		PRIMARY KEY(disc_cursadas_nusp,disc_cursadas_curriculo_id,disc_cursadas_disc_id),
	CONSTRAINT fk_disc_cursadas1 FOREIGN KEY (disc_cursadas_nusp)
		REFERENCES aluno(al_nusp),
	CONSTRAINT fk_disc_cursadas2 FOREIGN KEY (disc_cursadas_curriculo)
		REFERENCES curriculo (curriculo_id),
	CONSTRAINT fk_disc_cursadas3 FOREIGN KEY (disc_cursadas_disciplina)
		REFERENCES disciplina (disciplina_id)
);

--DROP TABLE IF EXISTS b25_attr_trilha_extrareqs CASCADE;
CREATE TABLE trilha_extrareqs (
	tril_extrareqs_trilha_id	INTEGER NOT NULL,
	tril_extrareqs_requisito	TEXT NOT NULL,

	CONSTRAINT pk_trilha_extrareqs 
		PRIMARY KEY (tril_extrareqs_trilha_id,tril_extrareqs_requisito),
	CONSTRAINT fk_tril_extra FOREIGN KEY (tril_extrareqs_trilha_id)
		REFERENCES trilha (trilha_id)
);

--DROP TABLE IF EXISTS b26_attr_disc_reqs CASCADE;
CREATE TABLE disciplina_requisitos (
	disc_reqs_disciplina_id		SERIAL NOT NULL,
	disc_reqs_requisito		TEXT NOT NULL,

	CONSTRAINT pk_disc_reqs 
		PRIMARY KEY (disc_reqs_disciplina_id, disc_reqs_requisito)
	--CONSTRAINT fk_disc_reqs FOREIGN KEY (disc_reqs_requisito)
	--	REFERENCES disciplina (disciplina_id)
);

--DROP TABLE IF EXISTS disc_biblio CASCADE;
CREATE TABLE disciplina_biblio (
	disc_biblio_disciplina_id	INTEGER NOT NULL,
	disc_biblio_requisito		TEXT NOT NULL,

	CONSTRAINT pk_disc_biblio
		PRIMARY KEY (disc_biblio_disciplina_id,disc_biblio_requisito),
	CONSTRAINT fk_disc_biblio FOREIGN KEY (disc_biblio_disciplina_id)
		REFERENCES disciplina (disciplina_id)
);

--DROP TABLE IF EXISTS cur_discoptelet CASCADE;
CREATE TABLE cur_disc_opt_elet(
	cur_disc_opt_elet_curriculo_id		INTEGER NOT NULL,
	cur_disc_opt_elet_disciplina_id		INTEGER NOT NULL,

	CONSTRAINT pk_cur_disc_opt_elet 
		PRIMARY KEY (cur_disc_opt_elet_curriculo_id, cur_disc_opt_elet_disciplina_id),
	CONSTRAINT fk_cur_disc_opt_elet1 FOREIGN KEY (cur_disc_opt_elet_cur_id)
		REFERENCES curriculo (curriculo_id),
	CONSTRAINT fk_cur_disc_opt_elet2  FOREIGN KEY (cur_disc_opt_elet_disciplina_id)
		REFERENCES disciplina (disciplina_id)
);

--DROP TABLE IF EXISTS cur_disc_opt_liv CASCADE;
CREATE TABLE cur_disc_opt_liv (
	cur_disc_opt_livre_curriculo_id		INTEGER NOT NULL,
	cur_disc_opt_livre_disciplina_id	INTEGER NOT NULL,

	CONSTRAINT pk_cur_disc_opt_livre
		PRIMARY KEY (cur_disc_opt_livre_curriculo_id, cur_disc_opt_livre_disciplina_id),
	CONSTRAINT fk_cur_disc_opt_livre1 FOREIGN KEY (cur_disc_opt_livre_curriculo_id)
		REFERENCES curriculo (curriculo_id),
	CONSTRAINT fk_cur_disc_opt_livre2  FOREIGN KEY (cur_disc_opt_livre_disciplina_id)
		REFERENCES disciplina (disciplina_id)
);
