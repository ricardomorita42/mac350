\c modulo_curriculo
SET ROLE dba;

----!! Inserting curriculum !!----
select * from insert_curriculum('BCC' ,'IME','Bacharelado em Ciencia da Computacao'		,111,52,24);
select * from insert_curriculum('BMAT','IME','Bacharelado em Matematica'			,111,52,24);
select * from insert_curriculum('BEST','IME','Bacharelado em Estatistica'			,121,40,20);
select * from insert_curriculum('LIC' ,'IME','Licenciatura em Matematica'			,110,32,19);
select * from insert_curriculum('BMA' ,'IME','Bacharelado em Matematica Aplicada '		,150,23,45);
select * from insert_curriculum('BMAC','IME','Bacharelado em Matematica Aplicada Computacional'	,90 ,22,44);
select * from insert_curriculum('BES' ,'IME','Bacharelado em Engenharia de Software'		,100,52,14);
select * from insert_curriculum('BTI' ,'IME','Bacharelado em Tecnologia da Informacao'		,123,22,40);
select * from insert_curriculum('BS'  ,'IME','Bacharelado em Sistemas'				,91 ,52,50);
select * from insert_curriculum('BBC' ,'IME','Bacharelado em Biologia Computacional'		,141,22,64);

----!! Inserting trilha !!----
select * from insert_trilha('SIST'	,'Sistemas'			);
select * from insert_trilha('REDES'	,'Redes'			);
select * from insert_trilha('CIDA'	,'Ciencia de dados'		);
select * from insert_trilha('IA'	,'Inteligencia Artificial'	);
select * from insert_trilha('TEOCOMP'	,'Teoria da Computacao'		);
select * from insert_trilha('BIGD'	,'Big Data'			);
select * from insert_trilha('FISCOMP'	,'Fisica Computacional'		);
select * from insert_trilha('METEO'	,'Metereologia'			);
select * from insert_trilha('ASTRO'	,'Astronomia'			);
select * from insert_trilha('TEOJOGOS'	,'Teoria dos Jogos'		);

----!! Inserting rel_cur_tril !!----
select * from insert_cur_tril('BCC' ,'SIST'	);
select * from insert_cur_tril('BEST','REDES'	);
select * from insert_cur_tril('BMAT','CIDA'	);
select * from insert_cur_tril('LIC' ,'IA'	);
select * from insert_cur_tril('BMA' ,'TEOCOMP'	);
select * from insert_cur_tril('BMAC','BIGD'	);
select * from insert_cur_tril('BES' ,'FISCOMP'	);
select * from insert_cur_tril('BTI' ,'METEO'	);
select * from insert_cur_tril('BS'  ,'ASTRO'	);
select * from insert_cur_tril('BBC' ,'TEOJOGOS'	);

----!! Inserting modulo !!----
select * from insert_modulo('MOD_A','modulo a','SIST'	);
select * from insert_modulo('MOD_B','modulo b','REDES'	);
select * from insert_modulo('MOD_C','modulo c','CIDA'	);
select * from insert_modulo('MOD_D','modulo d','IA'	);
select * from insert_modulo('MOD_E','modulo e','TEOCOMP');
select * from insert_modulo('MOD_F','modulo f','BIGD'	);
select * from insert_modulo('MOD_G','modulo g','FISCOMP');
select * from insert_modulo('MOD_H','modulo h','METEO'	);
select * from insert_modulo('MOD_I','modulo i','ASTRO'	);
select * from insert_modulo('MOD_J','modulo j','TEOJOGOS');

----!! Inserting disciplinas !!----
select * from insert_disciplina('MAC0101','IME' ,'Topicos basicos de computação',4,0);
select * from insert_disciplina('MAC0102','IME' ,'Teoria de computação'		,4,0);
select * from insert_disciplina('MAC0110','IME' ,'Computação intermediario'	,4,2);
select * from insert_disciplina('MAC0350','IME' ,'Banco de Dados'		,4,2);
select * from insert_disciplina('MAC0210','IME' ,'Laboratório de Programação'	,4,0);
select * from insert_disciplina('MAC0420','IME' ,'Autômatos'			,4,1);
select * from insert_disciplina('MAT0101','MAT' ,'Calculo I'			,4,0);
select * from insert_disciplina('MAT0102','MAT' ,'Calculo II'			,4,0);
select * from insert_disciplina('MAT0103','MAT' ,'Calculo III'			,4,0);
select * from insert_disciplina('7974123','EACH','Leitura Dramatica'		,2,2);

----!! Inserting rel_dis_mod !!----
select * from insert_dis_mod('MAC0101','MOD_A');
select * from insert_dis_mod('MAC0102','MOD_B');
select * from insert_dis_mod('MAC0110','MOD_C');
select * from insert_dis_mod('MAC0350','MOD_D');
select * from insert_dis_mod('MAC0210','MOD_E');
select * from insert_dis_mod('MAC0420','MOD_F');
select * from insert_dis_mod('MAT0101','MOD_G');
select * from insert_dis_mod('MAT0102','MOD_H');
select * from insert_dis_mod('MAT0103','MOD_I');
select * from insert_dis_mod('7974123','MOD_J');

select * from insert_trilha_extrareq('SIST'	,'Fazer tcc na area'		);
select * from insert_trilha_extrareq('REDES'	,'definir um tutor'		);
select * from insert_trilha_extrareq('CIDA'	,'definir area de aplicacao'	);
select * from insert_trilha_extrareq('IA'	,'Fazer tcc na area'		);
select * from insert_trilha_extrareq('TEOCOMP'	,'definir um tutor'		);
select * from insert_trilha_extrareq('BIGD'	,'Fazer tcc na area'		);
select * from insert_trilha_extrareq('FISCOMP'	,'definir area de aplicacao'	);
select * from insert_trilha_extrareq('METEO'	,'definir um tutor'		);
select * from insert_trilha_extrareq('ASTRO'	,'Fazer tcc na area'		);
select * from insert_trilha_extrareq('TEOJOGOS'	,'definir um tutor'		);

select * from insert_disciplina_requisito('MAC0101','7974123');
select * from insert_disciplina_requisito('MAC0101','MAC0102');
select * from insert_disciplina_requisito('MAC0102','7974123');
select * from insert_disciplina_requisito('MAC0110','7974123');
select * from insert_disciplina_requisito('MAC0350','7974123');
select * from insert_disciplina_requisito('MAC0210','7974123');
select * from insert_disciplina_requisito('MAC0420','7974123');
select * from insert_disciplina_requisito('MAT0101','7974123');
select * from insert_disciplina_requisito('MAT0102','7974123');
select * from insert_disciplina_requisito('MAT0103','7974123');

select * from insert_disciplina_biblio('MAC0101','BESTERMAN, Theodore. A world bibliography of bibliographies and of bibliographical catalogues, calendars, abstracts, digests, indexes, and the like. 4. ed. Rowan & Littlefield, Totwan, N.J. 1980 (5 vol.)');
select * from insert_disciplina_biblio('MAC0102','IOS – International Organization for Standardization. Norma ISO 690');
select * from insert_disciplina_biblio('MAC0110','IPT – Instituto Politécnico de Leiria. Serviços de Documentação. Como Elaborar Bibliografias.');
select * from insert_disciplina_biblio('MAC0350','MALCLÈS, Louise-Noëlle. La Bibliographie. Paris: Presses Universitaires de France, 1977.');
select * from insert_disciplina_biblio('MAC0210','NORONHA, Daisy Pires; FERREIRA, Sueli Mara S. P. "Bibliografia especializada". In: Recursos informacionais II - CBD201 (disciplina de graduação). São Paulo: ECA/USP, 1999.');
select * from insert_disciplina_biblio('MAC0420','WALRAVENS, Hartmut (Hrsg.): Internationale Bibliographie der Bibliographien 1959–1988. IBB. Saur, München 1998–2007, ISBN 3-598-33734-5 (13 Bde; Paralleltitel: International bibliography of bibliographies).');
select * from insert_disciplina_biblio('MAT0101','Bibliotheca universalis sive catalogus omnium scriptorum locupletissimus in tribus linguis Latina, Graeca et Hebraica: extantium & non extantium, veterum & recentiorum.');
select * from insert_disciplina_biblio('MAT0102','HALLEWELL (2005), p. 392.');
select * from insert_disciplina_biblio('MAT0103','PETRY, Fernando Floriani. Revista do livro: um projeto político, literário e cultural. T');
select * from insert_disciplina_biblio('7974123','LIMA, João Alberto de Oliveira; CUNHA, Murilo Bastos Tratamento da Informação legislativa e Jurídica: Uma perspetiva histórica');

