\c pessoa
SET ROLE dba;

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
	CHECK (cursa_nota >= 0 AND cursa_nota <= 10),
	CHECK (cursa_presenca >= 0 AND cursa_presenca <= 100)
);

--DROP TABLE IF EXISTS oferecimento CASCADE;
CREATE TABLE oferecimento(
	ofer_prof_nusp			INTEGER NOT NULL,
	ofer_disciplina_sigla		TEXT NOT NULL,
	ofer_ministra_data		date NOT NULL,

	CONSTRAINT pk_ofer PRIMARY KEY (ofer_prof_nusp, ofer_disciplina_sigla)
);
