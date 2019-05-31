--DROP TABLE IF EXISTS b01_pessoa CASCADE;
CREATE TABLE b01_pessoa (
	NUSP				SERIAL NOT NULL,
	CPF				VARCHAR(14) NOT NULL,
	PNome				TEXT NOT NULL,
	SNome				TEXT NOT NULL,
	DataNasc			date NOT NULL,
	Sexo				VARCHAR(1) NOT NULL,

	CONSTRAINT pk_pessoa	PRIMARY KEY (nusp),
	CONSTRAINT sk_pessoa	UNIQUE(CPF),
	CONSTRAINT cpf_check	CHECK(CPF LIKE '___.___.___-__'),
	CONSTRAINT sexo_check	CHECK(Sexo IN ('F','M','O'))
);

--DROP TABLE IF EXISTS b02_aluno CASCADE;
CREATE TABLE b02_aluno (
	al_NUSP				INTEGER,
	al_Curso			TEXT NOT NULL,

	CONSTRAINT pk_aluno PRIMARY KEY (al_NUSP),
	CONSTRAINT pf_al FOREIGN KEY (al_NUSP) REFERENCES b01_pessoa (NUSP)
);

--DROP TABLE IF EXISTS b03_professor CASCADE;
CREATE TABLE b03_professor (
	prof_NUSP			INTEGER,
	prof_Unidade			TEXT NOT NULL,

	CONSTRAINT pk_professor	PRIMARY KEY (prof_NUSP),
	CONSTRAINT pf_prof FOREIGN KEY (prof_NUSP) REFERENCES b01_pessoa (NUSP)
);

--DROP TABLE IF EXISTS b04_admnistrador CASCADE;
CREATE TABLE b04_admnistrador (
	adm_NUSP			INTEGER,
	adm_Unidade			TEXT NOT NULL,

	CONSTRAINT pk_adm PRIMARY KEY (adm_NUSP),
	CONSTRAINT pf_adm FOREIGN KEY (adm_NUSP) REFERENCES b01_pessoa (NUSP)
);

--DROP TABLE IF EXISTS b05_curriculo CASCADE;
CREATE TABLE b05_curriculo (
	cur_ID			SERIAL NOT NULL,
	cur_Unidade		TEXT NOT NULL,
	cur_Nome		TEXT NOT NULL,
	cur_Cred_Obrig		INTEGER,
	cur_Cred_OptElet	INTEGER,
	cur_Cred_OptLiv		INTEGER,

	
	CHECK (cur_Cred_Obrig > 0 AND cur_Cred_Obrig < 10000),
	CHECK (cur_Cred_OptElet > 0 AND cur_Cred_OptElet < 10000),
	CHECK (cur_Cred_OptLiv > 0 AND cur_Cred_OptLiv < 10000),
	CONSTRAINT pk_curriculo PRIMARY KEY (cur_ID),
	CONSTRAINT sk_curriculo UNIQUE (cur_Nome)
);

--DROP TABLE IF EXISTS b06_trilha CASCADE;
CREATE TABLE b06_trilha (
	trilha_ID			SERIAL NOT NULL,
	trilha_Nome			TEXT NOT NULL,
	trilha_Cur_ID			INTEGER NOT NULL,

	CONSTRAINT pk_trilha PRIMARY KEY (trilha_ID),
	CONSTRAINT sk_trilha FOREIGN KEY (trilha_Cur_ID)
		REFERENCES b05_curriculo (cur_ID)
);

--DROP TABLE IF EXISTS b07_modulo CASCADE;
CREATE TABLE b07_modulo (
	mod_ID			SERIAL NOT NULL,
	mod_Curriculo		INTEGER NOT NULL,
	mod_Nome		TEXT NOT NULL,
	mod_Trilha_ID		INTEGER NOT NULL,

	CONSTRAINT pk_modulo PRIMARY KEY (mod_ID),
	CONSTRAINT sk_modulo FOREIGN KEY (mod_Curriculo)
		REFERENCES b05_curriculo (cur_ID),
	CONSTRAINT sk2_modulo FOREIGN KEY (mod_Trilha_ID)
		REFERENCES b06_trilha (Trilha_ID)
);

--DROP TABLE IF EXISTS b08_disciplina CASCADE;
CREATE TABLE b08_disciplina (
	disc_ID			SERIAL NOT NULL,
	disc_Unidade		TEXT NOT NULL,
	disc_Sigla		TEXT NOT NULL,
	disc_Nome		TEXT NOT NULL,
	disc_CredAula		INTEGER,
	disc_CredTrabalho	INTEGER,

	CHECK (disc_CredTrabalho >= 0 AND disc_CredTrabalho < 1000),
	CHECK (disc_CredAula >= 0 AND disc_CredAula < 1000),
	CONSTRAINT pk_disciplina PRIMARY KEY (disc_ID),
	CONSTRAINT sk_disciplina UNIQUE (disc_Sigla)
);

--DROP TABLE IF EXISTS b09_perfil CASCADE;
CREATE TABLE b09_perfil (
	perfil_ID			SERIAL,
	perfil_Nome			TEXT NOT NULL,

	CONSTRAINT pk_perfil PRIMARY KEY (perfil_ID),
	CONSTRAINT sk_perfil UNIQUE (perfil_Nome)
);

--DROP TABLE IF EXISTS b10_usuario CASCADE;
CREATE TABLE b10_usuario(
	us_ID				SERIAL,
	us_email			TEXT,
	us_password			TEXT NOT NULL,	

	CONSTRAINT pk_user PRIMARY KEY (us_ID),
	CONSTRAINT sk_user UNIQUE (us_email)
);

--DROP TABLE IF EXISTS b11_servico CASCADE;
CREATE TABLE b11_servico (
	serv_ID				SERIAL NOT NULL,
	serv_Codigo			TEXT NOT NULL,
	serv_Nome			TEXT NOT NULL,

	CONSTRAINT pk_servico PRIMARY KEY (serv_ID)
);

--DROP TABLE IF EXISTS b12_oferecimento CASCADE;
CREATE TABLE b12_oferecimento(
	ofer_ID				SERIAL NOT NULL,
	ofer_NUSP			INTEGER NOT NULL,
	ofer_disc_ID			INTEGER NOT NULL,
	ofer_ministra_Data		date NOT NULL,

	CONSTRAINT pk_ofer PRIMARY KEY (ofer_ID),
	CONSTRAINT fk_ofer1 FOREIGN KEY (ofer_NUSP)
		REFERENCES b01_pessoa (NUSP),
	CONSTRAINT fk_ofer2 FOREIGN KEY (ofer_disc_ID)
		REFERENCES b08_disciplina (disc_ID)
);

--DROP TABLE IF EXISTS b13_rel_us_pf CASCADE;
CREATE TABLE b13a_rel_pe_us (
	rel_peus_ID			SERIAL NOT NULL,
	rel_peus_NUSP			INTEGER NOT NULL,
	rel_peus_us_ID			INTEGER NOT NULL,

	CONSTRAINT pk_rel_pe_us PRIMARY KEY (rel_peus_ID),
	CONSTRAINT fk_rel_peus1 FOREIGN KEY (rel_peus_NUSP)
		REFERENCES b01_pessoa (NUSP),
	CONSTRAINT fk_rel_peus2 FOREIGN KEY (rel_peus_us_ID)
		REFERENCES b10_usuario (us_ID)

);

CREATE TABLE b13b_rel_us_pf (
	rel_uspf_ID			SERIAL NOT NULL,
	rel_uspf_us_ID			INTEGER NOT NULL,
	rel_uspf_serv_ID		INTEGER NOT NULL,
	perf_inicio			date,

	CONSTRAINT pk_rel_us_pf PRIMARY KEY (rel_uspf_ID),
	CONSTRAINT fk_rel_uspf1 FOREIGN KEY (rel_uspf_us_ID)
		REFERENCES b10_usuario (us_ID),
	CONSTRAINT fk_rel_uspf2 FOREIGN KEY (rel_uspf_serv_ID)
		REFERENCES b11_servico (serv_ID)
);

--DROP TABLE IF EXISTS b14_rel_pf_se CASCADE;
CREATE TABLE b14_rel_pf_se (
	rel_pfse_ID			SERIAL NOT NULL,
	rel_pfse_perf_ID		INTEGER NOT NULL,
	rel_pfse_serv_ID		INTEGER NOT NULL,

	CONSTRAINT pk_rel_pf_se PRIMARY KEY (rel_pfse_ID),
	CONSTRAINT fk_rel_pfse1 FOREIGN KEY (rel_pfse_perf_ID)
		REFERENCES b09_perfil (perfil_ID),
	CONSTRAINT fk_rel_pfse2	FOREIGN KEY (rel_pfse_serv_ID)
		REFERENCES b11_servico (serv_ID)
);

--DROP TABLE IF EXISTS b15_rel_admnistra CASCADE;
CREATE TABLE b15_rel_admnistra (
	rel_adm_ID			SERIAL NOT NULL,
	rel_adm_NUSP			INTEGER NOT NULL,
	rel_adm_cur_ID			INTEGER NOT NULL,
	admnistra_Inicio		date,

	CONSTRAINT pk_rel_admnistra PRIMARY KEY (rel_adm_ID),
	CONSTRAINT fk_rel_admnistra1 FOREIGN KEY (rel_adm_NUSP)
		REFERENCES b01_pessoa (NUSP),
	CONSTRAINT fk_rel_admnistra2 FOREIGN KEY (rel_adm_cur_ID)
		REFERENCES b05_curriculo (cur_ID)
);

--DROP TABLE IF EXISTS b16_rel_cur_tril CASCADE;
CREATE TABLE b16_rel_cur_tril (
	rel_curtril_ID			SERIAL NOT NULL,
	rel_curtril_cur_ID		INTEGER NOT NULL,
	rel_curtril_trilha_ID		INTEGER NOT NULL,

	CONSTRAINT pk_rel_curtril PRIMARY KEY (rel_curtril_ID),
	CONSTRAINT fk_rel_curtril1 FOREIGN KEY (rel_curtril_cur_ID)
		REFERENCES b05_curriculo (cur_ID),
	CONSTRAINT fk_rel_curtril2 FOREIGN KEY (rel_curtril_trilha_ID)
		REFERENCES b06_trilha (trilha_ID)
);

--DROP TABLE IF EXISTS b17_rel_dis_mod CASCADE;
CREATE TABLE b17_rel_dis_mod (
	rel_dismod_ID			SERIAL NOT NULL,
	rel_dismod_disc_ID		INTEGER NOT NULL,
	rel_dismod_mod_ID		INTEGER NOT NULL,

	CONSTRAINT pk_rel_dismod PRIMARY KEY (rel_dismod_ID),
	CONSTRAINT fk_rel_dismod1 FOREIGN KEY (rel_dismod_disc_ID)
		REFERENCES b08_disciplina (disc_ID),
	CONSTRAINT fk_rel_dismod2 FOREIGN KEY (rel_dismod_mod_ID)
		REFERENCES b07_modulo (mod_ID)
);

--DROP TABLE IF EXISTS b18_rel_alu_cur CASCADE;
CREATE TABLE b18_rel_alu_cur (
	rel_alucur_ID			SERIAL NOT NULL,
	rel_alucur_NUSP			INTEGER NOT NULL,
	rel_alucur_cur_ID		INTEGER NOT NULL,

	CONSTRAINT pk_rel_alucur PRIMARY KEY (rel_alucur_ID),
	CONSTRAINT fk_rel_alucur1 FOREIGN KEY (rel_alucur_NUSP)
		REFERENCES b01_pessoa (NUSP),
	CONSTRAINT fk_rel_alucur2 FOREIGN KEY (rel_alucur_cur_ID)
		REFERENCES b05_curriculo (cur_ID)
);

--DROP TABLE IF EXISTS b19_rel_planeja CASCADE;
CREATE TABLE b19_rel_planeja (
	rel_planeja_ID			SERIAL NOT NULL,
	rel_planeja_NUSP		INTEGER NOT NULL,
	rel_planeja_disc_ID		INTEGER NOT NULL,

	CONSTRAINT pk_rel_planeja PRIMARY KEY (rel_planeja_ID),
	CONSTRAINT fk_rel_planeja1 FOREIGN KEY (rel_planeja_NUSP)
		REFERENCES b01_pessoa (NUSP),
	CONSTRAINT fk_rel_planeja2 FOREIGN KEY (rel_planeja_disc_ID)
		REFERENCES b08_disciplina (disc_ID)
);

--DROP TABLE IF EXISTS b20_rel_ministra CASCADE;
CREATE TABLE b20_rel_ministra (
	rel_ministra_ID			SERIAL NOT NULL,
	rel_ministra_NUSP		INTEGER NOT NULL,
	rel_ministra_disc_ID		INTEGER NOT NULL,

	CONSTRAINT pk_rel_ministra PRIMARY KEY (rel_ministra_NUSP, rel_ministra_disc_ID),
	CONSTRAINT fk_rel_ministra1 FOREIGN KEY (rel_ministra_NUSP)
		REFERENCES b01_pessoa (NUSP),
	CONSTRAINT fk_rel_ministra2 FOREIGN KEY (rel_ministra_disc_ID)
		REFERENCES b08_disciplina (disc_ID)
);

--DROP TABLE IF EXISTS b21_rel_cursa CASCADE;
CREATE TABLE b21_rel_cursa (
	rel_cursa_ID			SERIAL NOT NULL,
	rel_cursa_NUSP			INTEGER NOT NULL,
	rel_cursa_disc_ID		INTEGER NOT NULL,
	rel_cursa_ministra_Data		date NOT NULL,
	rel_cursa_Nota			numeric NOT NULL,
	rel_cursa_Presenca		numeric NOT NULL,

	CHECK (rel_cursa_Nota >= 0 AND rel_cursa_Nota <= 10),
	CHECK (rel_cursa_Presenca >= 0 AND rel_cursa_Presenca <= 100),
	CONSTRAINT pk_rel_cursa PRIMARY KEY (rel_cursa_ID),
	CONSTRAINT fk_rel_cursa1 FOREIGN KEY (rel_cursa_NUSP)
		REFERENCES b01_pessoa (NUSP),
	CONSTRAINT fk_rel_cursa2 FOREIGN KEY (rel_cursa_disc_ID)
		REFERENCES b08_disciplina (disc_ID)
);

--DROP TABLE IF EXISTS b22_attr_perfil_permissoes CASCADE;
CREATE TABLE b22_attr_perfil_permissoes (
	attr_ID				SERIAL NOT NULL,
	attr_perfperm_perf_ID		INTEGER NOT NULL,
	attr_perfperm_permissao		TEXT NOT NULL,

	CONSTRAINT pk_attr_perfperm 
		PRIMARY KEY (attr_perfperm_perf_ID,attr_perfperm_permissao),
	CONSTRAINT fk_attr_perfperm FOREIGN KEY (attr_perfperm_perf_ID)
		REFERENCES b09_perfil (perfil_ID)
);

--DROP TABLE IF EXISTS b23_attr_linguas CASCADE;
CREATE TABLE b23_attr_linguas (
	attr_linguas_ID			SERIAL NOT NULL,
	attr_linguas_NUSP		INTEGER NOT NULL,
	attr_linguas_lingua		TEXT NOT NULL,

	CONSTRAINT pk_attr_linguas 
		PRIMARY KEY (attr_linguas_NUSP,attr_linguas_lingua),
	CONSTRAINT fk_attr_linguas FOREIGN KEY (attr_linguas_NUSP)
		REFERENCES b01_pessoa (NUSP)
);

--DROP TABLE IF EXISTS b24_attr_disc_Cursadas CASCADE;
CREATE TABLE b24_attr_disc_Cursadas (
	attr_disccurs_ID		SERIAL NOT NULL,
	attr_disccurs_NUSP		INTEGER NOT NULL,
	attr_disccurs_cur_ID		INTEGER NOT NULL,
	attr_disccurs_disc_ID		INTEGER NOT NULL,

	CONSTRAINT pk_attr_disccurs 
		PRIMARY KEY(attr_disccurs_NUSP,attr_disccurs_cur_ID,attr_disccurs_disc_ID),
	CONSTRAINT fk_attr_disccurs1 FOREIGN KEY (attr_disccurs_NUSP)
		REFERENCES b01_pessoa (NUSP),
	CONSTRAINT fk_attr_disccurs2 FOREIGN KEY (attr_disccurs_cur_ID)
		REFERENCES b05_curriculo (cur_ID),
	CONSTRAINT fk_attr_disccurs3 FOREIGN KEY (attr_disccurs_disc_ID)
		REFERENCES b08_disciplina (disc_ID)
);

--DROP TABLE IF EXISTS b25_attr_trilha_extrareqs CASCADE;
CREATE TABLE b25_attr_trilha_extrareqs (
	attr_trilhextra_ID		SERIAL NOT NULL,
	attr_trilhextra_trilha_ID	INTEGER NOT NULL,
	attr_trilhextra_Requisito	TEXT NOT NULL,

	CONSTRAINT pk_attr_trilhextra 
		PRIMARY KEY (attr_trilhextra_trilha_ID,attr_trilhextra_Requisito),
	CONSTRAINT fk_attr_trilhextra FOREIGN KEY (attr_trilhextra_trilha_ID)
		REFERENCES b06_trilha (trilha_ID)
);

--DROP TABLE IF EXISTS b26_attr_disc_reqs CASCADE;
CREATE TABLE b26_attr_disc_reqs (
	attr_discreqs_ID		SERIAL NOT NULL,
	attr_discreqs_trilha_ID		INTEGER NOT NULL,
	attr_discreqs_Requisito		INTEGER NOT NULL,

	CONSTRAINT pk_attr_discreqs 
		PRIMARY KEY (attr_discreqs_trilha_ID, attr_discreqs_Requisito),
	CONSTRAINT fk_attr_discreqs1 FOREIGN KEY (attr_discreqs_trilha_ID)
		REFERENCES b06_trilha (trilha_ID),
	CONSTRAINT fk_attr_discreqs2 FOREIGN KEY (attr_discreqs_Requisito)
		REFERENCES b08_disciplina (disc_ID)
);

--DROP TABLE IF EXISTS b27_attr_disc_biblio CASCADE;
CREATE TABLE b27_attr_disc_biblio (
	attr_discbibl_ID		SERIAL NOT NULL,
	attr_discbibl_disc_ID		INTEGER NOT NULL,
	attr_discbibl_Requisito		TEXT NOT NULL,

	CONSTRAINT pk_attr_discbibl 
		PRIMARY KEY (attr_discbibl_disc_ID),
	CONSTRAINT fk_attr_discbibl FOREIGN KEY (attr_discbibl_disc_ID)
		REFERENCES b08_disciplina (disc_ID)
);

--DROP TABLE IF EXISTS b28_attr_cur_discoptelet CASCADE;
CREATE TABLE b28_attr_cur_discoptelet(
	attr_curoptelet_ID		SERIAL NOT NULL,
	attr_curoptelet_cur_ID		INTEGER NOT NULL,
	attr_curoptelet_disc_ID		INTEGER  NOT NULL,

	CONSTRAINT pk_attr_curelet 
		PRIMARY KEY (attr_curoptelet_cur_ID, attr_curoptelet_disc_ID),
	CONSTRAINT fk_attr_curelet1 FOREIGN KEY (attr_curoptelet_cur_ID)
		REFERENCES b05_curriculo (cur_ID),
	CONSTRAINT fk_attr_curelet2 FOREIGN KEY (attr_curoptelet_disc_ID)
		REFERENCES b08_disciplina (disc_ID)
);

--DROP TABLE IF EXISTS b29_attr_cur_discoptliv CASCADE;
CREATE TABLE b29_attr_cur_discoptliv (
	attr_curoptliv_ID		SERIAL NOT NULL,
	attr_curoptliv_cur_ID		INTEGER NOT NULL,
	attr_curoptliv_disc_ID		INTEGER  NOT NULL,

	CONSTRAINT pk_attr_curliv 
		PRIMARY KEY (attr_curoptliv_cur_ID, attr_curoptliv_disc_ID),
	CONSTRAINT fk_attr_curliv1 FOREIGN KEY (attr_curoptliv_cur_ID)
		REFERENCES b05_curriculo (cur_ID),
	CONSTRAINT fk_attr_curliv2 FOREIGN KEY (attr_curoptliv_disc_ID)
		REFERENCES b08_disciplina (disc_ID)
);
