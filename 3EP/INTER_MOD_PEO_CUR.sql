\c inter_pes_cur
SET ROLE dba;

--DROP TABLE IF EXISTS administra CASCADE;
CREATE TABLE administra (
	administra_nusp			INTEGER NOT NULL,
	administra_curriculo_sigla	TEXT NOT NULL,
	administra_inicio		date,

	CONSTRAINT pk_administra
		PRIMARY KEY (administra_nusp, administra_curriculo_sigla)
);

--DROP TABLE IF EXISTS planeja CASCADE;
CREATE TABLE planeja (
	planeja_aluno_nusp		INTEGER NOT NULL,
	planeja_disciplina_sigla	TEXT NOT NULL,

	CONSTRAINT pk_planeja PRIMARY KEY (planeja_aluno_nusp, planeja_disciplina_sigla)
);

--DROP TABLE IF EXISTS ministra CASCADE;
CREATE TABLE ministra(
	ministra_prof_nusp			INTEGER NOT NULL,
	ministra_disciplina_sigla		TEXT NOT NULL,

	CONSTRAINT pk_ministra PRIMARY KEY (ministra_prof_nusp, ministra_disciplina_sigla)
);
