\c inter_pes_cur
SET ROLE dba;

--DROP TABLE IF EXISTS oferecimento CASCADE;
CREATE TABLE oferecimento(
	ofer_prof_nusp			INTEGER NOT NULL,
	ofer_disciplina_sigla		TEXT NOT NULL,
	ofer_ministra_data		date NOT NULL,

	CONSTRAINT pk_ofer PRIMARY KEY (ofer_prof_nusp, ofer_disciplina_sigla)
);

--DROP TABLE IF EXISTS planeja CASCADE;
CREATE TABLE planeja (
	planeja_aluno_nusp		INTEGER NOT NULL,
	planeja_disciplina_sigla	TEXT NOT NULL,

	CONSTRAINT pk_planeja PRIMARY KEY (planeja_aluno_nusp, planeja_disciplina_sigla)
);
