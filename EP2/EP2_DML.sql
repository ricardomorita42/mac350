----Inserting roles----
select * from insert_role('guest');
select * from insert_role('student');
select * from insert_role('teacher');
select * from insert_role('admin');
select * from insert_role('intern');
select * from insert_role('superadmin');
select * from insert_role('dba');
select * from insert_role('debugger');
select * from insert_role('reitor');
select * from insert_role('api');


----!! Inserting person and then adding her as student!!----
select * from insert_person(227705861,'579.652.564-14','Tonya','Thibault','15-3-1974','F');
select * from insert_person(386930905,'290.027.844-46','Felipe','Derby','27-8-1986','M');
select * from insert_person(859852130,'100.538.773-74','Danny','Gaston','28-6-1978'	,'M');
select * from insert_person(310554114,'205.904.185-04','Lauryn','Slattery','1-7-1950'	,'F');
select * from insert_person(613923368,'948.503.790-51','Lillian','Moilanen','16-4-1963'	,'F');
select * from insert_person(311285463,'642.726.481-09','Jessica','Beck','30-1-1993'	,'F');
select * from insert_person(991002548,'343.678.948-39','Joann','Demmons','13-6-1992'	,'F');
select * from insert_person(158298846,'291.962.071-14','Robert','Hogan','7-11-1963'	,'M');
select * from insert_person(761213416,'467.354.008-36','Rodney','Twombley','16-1-1951'	,'M');
select * from insert_person(702391605,'927.817.720-15','James','Sims','11-10-1960'	,'M');
select * from insert_person(559853740,'315.581.410-54','Jeana','Hinman','2-7-1958'	,'F');
select * from insert_person(994567006,'193.565.251-02','Heather','Obrien','10-2-1958'	,'F');
select * from insert_person(230057892,'655.514.390-88','Otis','Sumner','30-4-1953'	,'M');
select * from insert_person(961065297,'773.246.643-22','Gregory','Exum','10-3-1996'	,'M');
select * from insert_person(162109146,'292.436.018-99','Kelly','Grant','17-2-1964'	,'F');
select * from insert_person(939847659,'672.773.696-97','Marie','Harris','8-6-1981'	,'F');
select * from insert_person(489997003,'894.893.268-76','Elliott','Jones','30-6-1959'	,'M');
select * from insert_person(365513041,'483.551.084-52','David','Rodgers','12-8-1955'	,'M');
select * from insert_person(300606205,'343.742.070-97','Chester','Madril','1-8-1991'	,'M');
select * from insert_person(815705605,'375.709.244-84','David','Turner','2-9-1951'	,'M');

select * from insert_user(227705861,'BCC' ,'tonya'	,'tonya@email.com'	,'aluno_secret'  ,'student');
select * from insert_user(386930905,'BMAT','felipe'	,'felipe@email.com'	,'aluno2_secret' ,'student');
select * from insert_user(859852130,'BCC' ,'danny'	,'danny@email.com'	,'aluno3_secret' ,'student');
select * from insert_user(310554114,'BCC' ,'lauryn'	,'lauryn@email.com'	,'aluno4_secret' ,'student');
select * from insert_user(613923368,'BCC' ,'lillian'	,'lillian@email.com'	,'aluno5_secret' ,'student');
select * from insert_user(311285463,'BCC' ,'jessica'	,'jessica@email.com'	,'aluno6_secret' ,'student');
select * from insert_user(991002548,'BCC' ,'joann'	,'joann@email.com'	,'aluno7_secret' ,'student');
select * from insert_user(158298846,'BCC' ,'robert'	,'robert@email.com'	,'aluno8_secret' ,'student');
select * from insert_user(761213416,'BCC' ,'rodney'	,'rodney@email.com'	,'aluno9_secret' ,'student');
select * from insert_user(702391605,'BCC' ,'james'	,'james@email.com'	,'aluno10_secret','student');
select * from insert_user(559853740,'BCC' ,'jeana'	,'jeana@email.com'	,'aluno11_secret','student');
select * from insert_user(994567006,'BCC' ,'heather'	,'heather@email.com'	,'aluno12_secret','student');
select * from insert_user(230057892,'BMAT','otis'	,'otis@email.com'	,'aluno13_secret','student');
select * from insert_user(961065297,'BMAT','gregory'	,'gregory@email.com'	,'aluno14_secret','student');
select * from insert_user(162109146,'BMAT','kelly'	,'kelly@email.com'	,'aluno15_secret','student');
select * from insert_user(939847659,'BMAT','marie'	,'marie@email.com'	,'aluno16_secret','student');
select * from insert_user(489997003,'BMAE','elliott'	,'elliott@email.com'	,'aluno17_secret','student');
select * from insert_user(365513041,'BMAE','david'	,'david@email.com'	,'aluno18_secret','student');
select * from insert_user(300606205,'BMAE','chester'	,'chester@email.com'	,'aluno19_secret','student');
select * from insert_user(815705605,'BMAE','dave'	,'dave@email.com'	,'aluno20_secret','student');

----!! Inserting person and then adding him as teacher !!----
select * from insert_person(588508512,'610.661.507-97','Ismael'	,'Brown','7-10-1950','M');
select * from insert_person(217525199,'705.516.821-01','Virginia','Mattingly','22-2-1959','F');
select * from insert_person(403856584,'614.793.727-54','Virginia','Phillips','24-2-1957','F');
select * from insert_person(629091676,'718.883.731-33','Roland','Cox','23-9-1977','M');
select * from insert_person(914806276,'935.664.937-77','Charles','Mishar','1-8-1965','M');
select * from insert_person(442932985,'489.656.198-67','Michelle','Grawe','7-11-1966','F');
select * from insert_person(292003247,'255.625.153-09','Laurence','Gibson','5-9-1980','M');
select * from insert_person(388414429,'271.414.864-10','Ray','Cromer','16-8-1983','M');
select * from insert_person(886902161,'823.449.865-83','Shane','Atkins','25-3-1959','M');
select * from insert_person(344149328,'774.313.118-03','Raymond','Ho','14-2-1992','M');

select * from insert_user(588508512,'POLI','ismael'	,'p_ismael@email.com'	,'teacher_secret'  ,'teacher');
select * from insert_user(217525199,'IME' ,'virginia'	,'p_virginia@email.com' ,'teacher2_secret' ,'teacher');
select * from insert_user(403856584,'IME' ,'virginia2'	,'p_virginia2@email.com','teacher3_secret' ,'teacher');
select * from insert_user(629091676,'IME' ,'roland'	,'p_roland@email.com'	,'teacher4_secret' ,'teacher');
select * from insert_user(914806276,'IME' ,'charles'	,'p_charles@email.com'  ,'teacher5_secret' ,'teacher');
select * from insert_user(442932985,'EACH','michelle'	,'p_michelle@email.com' ,'teacher6_secret' ,'teacher');
select * from insert_user(292003247,'POLI','laurence'	,'p_laurence@email.com' ,'teacher7_secret' ,'teacher');
select * from insert_user(388414429,'IME' ,'ray'	,'p_ray@email.com'	,'teacher8_secret' ,'teacher');
select * from insert_user(886902161,'IME' ,'shane'	,'p_shane@email.com'	,'teacher9_secret' ,'teacher');
select * from insert_user(344149328,'IME' ,'raymond'	,'p_raymond@email.com'	,'teacher10_secret','teacher');

----!! Inserting person and then adding her as admin !!----
select * from insert_person(933545064,'157.039.387-49','Ellen','Denney','28-3-1956','F');
select * from insert_person(169779300,'341.805.458-23','Ronald','Goyette','12-1-1996','M');
select * from insert_person(180318059,'879.023.781-32','Brenda','Cruz','12-3-1956','F');
select * from insert_person(813824779,'843.666.950-35','Jean','Mullis','25-4-1950','F');
select * from insert_person(704437879,'364.834.511-48','Katherine','Hayslip','2-4-1989','F');
select * from insert_person(773718543,'121.708.156-99','Zachary','Garrett','25-3-1958','M');
select * from insert_person(377913230,'497.067.626-10','Elizabeth','Mease','1-2-1975','F');
select * from insert_person(306625659,'444.190.340-59','Melanie','Parker','21-1-1969','F');
select * from insert_person(295230948,'237.426.428-81','Christy','Hinsley','13-8-1974','F');
select * from insert_person(897719693,'862.691.319-32','Karen','Mcraney','28-9-1950','F');

select * from insert_user(933545064,'IME' ,'ellen'	,'a_ellen@email.com'	,'admin1_secret' ,'admin');
select * from insert_user(169779300,'IME' ,'ronald'	,'a_ronald@email.com'	,'admin2_secret' ,'admin');
select * from insert_user(180318059,'IME' ,'brenda'	,'a_brenda@email.com'	,'admin3_secret' ,'admin');
select * from insert_user(813824779,'IME' ,'jean'	,'a_jean@email.com'	,'admin4_secret' ,'admin');
select * from insert_user(704437879,'POLI','katherine'	,'a_katherine@email.com','admin5_secret' ,'admin');
select * from insert_user(773718543,'IME' ,'zachary'	,'a_zachary@email.com'	,'admin6_secret' ,'admin');
select * from insert_user(377913230,'IME' ,'elizabeth'	,'a_elizabeth@email.com','admin7_secret' ,'admin');
select * from insert_user(306625659,'IME' ,'melanie'	,'a_melanie@email.com'	,'admin8_secret' ,'admin');
select * from insert_user(295230948,'POLI','christy'	,'a_christy@email.com'	,'admin9_secret' ,'admin');
select * from insert_user(897719693,'IME' ,'karen'	,'a_karen@email.com'	,'admin10_secret','admin');

----!! Inserting curriculum !!----
select * from insert_curriculum('BCC' ,'IME','Bacharelado em Ciencia da Computacao'		,111,52,24,933545064);
select * from insert_curriculum('BMAT','IME','Bacharelado em Matematica'			,111,52,24,169779300);
select * from insert_curriculum('BEST','IME','Bacharelado em Estatistica'			,121,40,20,180318059);
select * from insert_curriculum('LIC' ,'IME','Licenciatura em Matematica'			,110,32,19,813824779);
select * from insert_curriculum('BMA' ,'IME','Bacharelado em Matematica Aplicada '		,150,23,45,704437879);
select * from insert_curriculum('BMAC','IME','Bacharelado em Matematica Aplicada Computacional'	,90 ,22,44,773718543);
select * from insert_curriculum('BES' ,'IME','Bacharelado em Engenharia de Software'		,100,52,14,377913230);
select * from insert_curriculum('BTI' ,'IME','Bacharelado em Tecnologia da Informacao'		,123,22,40,306625659);
select * from insert_curriculum('BS'  ,'IME','Bacharelado em Sistemas'				,91 ,52,50,295230948);
select * from insert_curriculum('BBC' ,'IME','Bacharelado em Biologia Computacional'		,141,22,64,897719693);

----!! Inserting trilha !!----
select * from insert_trilha('Sistemas'			,NULL,'BCC' );
select * from insert_trilha('Redes'			,NULL,'BEST');
select * from insert_trilha('Ciencia de dados'		,NULL,'BMAT');
select * from insert_trilha('Inteligencia Artificial'	,NULL,'LIC' );
select * from insert_trilha('Teoria da Computacao'	,NULL,'BMA' );
select * from insert_trilha('Big Data'			,NULL,'BMAC');
select * from insert_trilha('Fisica Computacional'	,NULL,'BES' );
select * from insert_trilha('Metereologia'		,NULL,'BTI' );
select * from insert_trilha('Astronomia'		,NULL,'BS'  );
select * from insert_trilha('Teoria dos Jogos'		,NULL,'BBC' );

----!! Inserting modulo !!----
select * from insert_modulo('modulo a','isto é uma descrição '	,'Sistemas');
select * from insert_modulo('modulo b','isto é outra descrição'	,'Redes');
select * from insert_modulo('modulo c','isto é uma descrição?'	,'Ciencia de dados');
select * from insert_modulo('modulo d','isto é uma descrição!'	,'Inteligencia Artificial');
select * from insert_modulo('modulo e','isto é uma descrição...','Teoria da Computacao');
select * from insert_modulo('modulo f','pois é'			,'Big Data');
select * from insert_modulo('modulo g','cansei de descrever'	,'Fisica Computacional');
select * from insert_modulo('modulo h','isto é uma descrição x'	,'Metereologia');
select * from insert_modulo('modulo i','isto é uma descrição y'	,'Astronomia');
select * from insert_modulo('modulo j','isto é uma descrição z'	,'Teoria dos Jogos');

----!! Inserting disciplinas !!----
select * from insert_disciplina('MAC0101','IME' ,'Topicos basicos de computação',4,0,'modulo a');
select * from insert_disciplina('MAC0102','IME' ,'Teoria de computação'		,4,0,'modulo b');
select * from insert_disciplina('MAC0110','IME' ,'Computação intermediario'	,4,2,'modulo c');
select * from insert_disciplina('MAC0350','IME' ,'Banco de Dados'		,4,2,'modulo d');
select * from insert_disciplina('MAC0210','IME' ,'Laboratório de Programação'	,4,0,'modulo e');
select * from insert_disciplina('MAC0420','IME' ,'Autômatos'			,4,1,'modulo f');
select * from insert_disciplina('MAT0101','MAT' ,'Calculo I'			,4,0,'modulo g');
select * from insert_disciplina('MAT0102','MAT' ,'Calculo II'			,4,0,'modulo h');
select * from insert_disciplina('MAT0103','MAT' ,'Calculo III'			,4,0,'modulo i');
select * from insert_disciplina('7974123','EACH','Leitura Dramatica'		,2,2,'modulo j');

----!! Inserting planeja !!----
select * from insert_planeja(815705605,'MAC0101');
select * from insert_planeja(559853740,'MAC0102');
select * from insert_planeja(994567006,'MAC0110');
select * from insert_planeja(230057892,'MAC0350');
select * from insert_planeja(961065297,'MAC0210');
select * from insert_planeja(162109146,'MAC0420');
select * from insert_planeja(939847659,'MAT0101');
select * from insert_planeja(489997003,'MAT0102');
select * from insert_planeja(365513041,'MAT0103');
select * from insert_planeja(300606205,'7974123');

----!! Inserting ministras !!----
select * from insert_ministra(588508512,'MAC0101');
select * from insert_ministra(217525199,'MAC0102');
select * from insert_ministra(403856584,'MAC0110');
select * from insert_ministra(629091676,'MAC0350');
select * from insert_ministra(914806276,'MAC0210');
select * from insert_ministra(442932985,'MAC0420');
select * from insert_ministra(292003247,'MAT0101');
select * from insert_ministra(388414429,'MAT0102');
select * from insert_ministra(886902161,'MAT0103');
select * from insert_ministra(344149328,'7974123');

----!! Inserting oferecimentos !!----
select * from insert_oferecimento(588508512,'MAC0101',NULL);
select * from insert_oferecimento(217525199,'MAC0102',NULL);
select * from insert_oferecimento(403856584,'MAC0110',NULL);
select * from insert_oferecimento(629091676,'MAC0350',NULL);
select * from insert_oferecimento(914806276,'MAC0210',NULL);
select * from insert_oferecimento(442932985,'MAC0420',NULL);
select * from insert_oferecimento(292003247,'MAT0101',NULL);
select * from insert_oferecimento(388414429,'MAT0102',NULL);
select * from insert_oferecimento(886902161,'MAT0103',NULL);
select * from insert_oferecimento(344149328,'7974123',NULL);

----!! Inserting cursa !!----
select * from insert_cursa(815705605,588508512,'MAC0101',0.0,100.0);
select * from insert_cursa(559853740,217525199,'MAC0102',9.0,50.0);
select * from insert_cursa(994567006,403856584,'MAC0110',8.5,70.0);
select * from insert_cursa(230057892,629091676,'MAC0350',7.2,80.0);
select * from insert_cursa(961065297,914806276,'MAC0210',6.0,70.0);
select * from insert_cursa(162109146,442932985,'MAC0420',5.3,70.0);
select * from insert_cursa(939847659,292003247,'MAT0101',4.0,100.0);
select * from insert_cursa(489997003,388414429,'MAT0102',3.6,100.0);
select * from insert_cursa(365513041,886902161,'MAT0103',2.0,100.0);
select * from insert_cursa(300606205,344149328,'7974123',0.1,100.0);


select * from insert_trilha_extrareqs('Sistemas'		,'Fazer tcc na area'		);
select * from insert_trilha_extrareqs('Redes'			,'definir um tutor'		);
select * from insert_trilha_extrareqs('Ciencia de dados'	,'definir area de aplicacao'	);
select * from insert_trilha_extrareqs('Inteligencia Artificial'	,'Fazer tcc na area'		);
select * from insert_trilha_extrareqs('Teoria da Computacao'	,'definir um tutor'		);
select * from insert_trilha_extrareqs('Big Data'		,'Fazer tcc na area'		);
select * from insert_trilha_extrareqs('Fisica Computacional'	,'definir area de aplicacao'	);
select * from insert_trilha_extrareqs('Metereologia'		,'definir um tutor'		);
select * from insert_trilha_extrareqs('Astronomia'		,'Fazer tcc na area'		);
select * from insert_trilha_extrareqs('Teoria dos Jogos'	,'definir um tutor'		);

select * from insert_disciplina_requisitos('MAC0101','7974123');
select * from insert_disciplina_requisitos('MAC0101','MAC0102');
select * from insert_disciplina_requisitos('MAC0102','7974123');
select * from insert_disciplina_requisitos('MAC0110','7974123');
select * from insert_disciplina_requisitos('MAC0350','7974123');
select * from insert_disciplina_requisitos('MAC0210','7974123');
select * from insert_disciplina_requisitos('MAC0420','7974123');
select * from insert_disciplina_requisitos('MAT0101','7974123');
select * from insert_disciplina_requisitos('MAT0102','7974123');
select * from insert_disciplina_requisitos('MAT0103','7974123');

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

----!! Inserting functions into roles !!----
select * from insert_service('dba','insert_person',NULL);
select * from insert_service('dba','insert_role',NULL);
select * from insert_service('dba','insert_user',NULL);
select * from insert_service('dba','insert_service',NULL);
select * from insert_service('dba','insert_into_administra',NULL);
select * from insert_service('dba','insert_curriculum',NULL);
select * from insert_service('dba','insert_user_into_role',NULL);
select * from insert_service('dba','insert_trilha',NULL);
select * from insert_service('dba','insert_modulo',NULL);
select * from insert_service('dba','insert_disciplina',NULL);
select * from insert_service('dba','insert_ministra',NULL);
select * from insert_service('dba','insert_oferecimento',NULL);
select * from insert_service('dba','insert_planeja',NULL);
select * from insert_service('dba','insert_cursa',NULL);
select * from insert_service('dba','insert_trilha_extrareqs',NULL);
select * from insert_service('dba','insert_disciplina_requisitos',NULL);
select * from insert_service('dba','insert_disciplina_biblio',NULL);

select * from insert_service('dba','delete_perfil',NULL);
select * from insert_service('dba','delete_service',NULL);
select * from insert_service('dba','delete_perfil_from_user',NULL);
select * from insert_service('dba','delete_service_from_perfil',NULL);
select * from insert_service('dba','delete_pessoa',NULL);
select * from insert_service('dba','delete_aluno',NULL);
select * from insert_service('dba','delete_professor',NULL);
select * from insert_service('dba','delete_admin',NULL);
select * from insert_service('dba','delete_from_administra',NULL);
select * from insert_service('dba','delete_curriculo',NULL);
select * from insert_service('dba','delete_from_cur_tril',NULL);
select * from insert_service('dba','delete_trilha',NULL);
select * from insert_service('dba','delete_modulo',NULL);
select * from insert_service('dba','delete_from_ministra',NULL);
select * from insert_service('dba','delete_from_oferecimento',NULL);
select * from insert_service('dba','delete_from_dis_mod',NULL);
select * from insert_service('dba','delete_disciplina',NULL);

select * from insert_service('dba','update_nome',NULL);
select * from insert_service('dba','update_datanasc',NULL);
select * from insert_service('dba','update_sexo',NULL);
select * from insert_service('dba','update_email',NULL);
select * from insert_service('dba','update_password',NULL);
select * from insert_service('dba','update_perfil_descricao',NULL);
select * from insert_service('dba','update_service',NULL);
select * from insert_service('dba','update_prof_unidade',NULL);
select * from insert_service('dba','update_admin_unidade',NULL);
select * from insert_service('dba','update_aluno_curso',NULL);
select * from insert_service('dba','update_ofer_data',NULL);
select * from insert_service('dba','update_cursa_nota',NULL);
select * from insert_service('dba','update_cursa_presenca',NULL);
select * from insert_service('dba','update_planeja_disciplina',NULL);
select * from insert_service('dba','update_disciplina_unidade',NULL);
select * from insert_service('dba','update_disciplina_nome',NULL);
select * from insert_service('dba','update_disciplina_cred_aula',NULL);
select * from insert_service('dba','update_disciplina_cred_trabalho',NULL);
select * from insert_service('dba','update_administra_data_inicio',NULL);
select * from insert_service('dba','update_curriculo_unidade',NULL);
select * from insert_service('dba','update_curriculo_nome',NULL);
select * from insert_service('dba','update_curriculo_cred_obrig',NULL);
select * from insert_service('dba','update_curriculo_cred_opt_elet',NULL);
select * from insert_service('dba','update_curriculo_cred_opt_liv',NULL);
select * from insert_service('dba','update_trilha_descricao',NULL);
select * from insert_service('dba','update_modulo_descricao',NULL);
select * from insert_service('dba','update_disc_biblio_descricao',NULL);

select * from insert_service('guest','update_nome',NULL);
select * from insert_service('guest','update_sexo',NULL);
select * from insert_service('guest','update_password',NULL);
select * from insert_service('guest','update_datanasc',NULL);

select * from insert_service('student','update_aluno_curso',NULL);
select * from insert_service('student','update_planeja_disciplina',NULL);

select * from insert_service('teacher','update_prof_unidade',NULL);
select * from insert_service('teacher','update_ofer_data',NULL);
select * from insert_service('teacher','update_cursa_nota',NULL);
select * from insert_service('teacher','update_cursa_presenca',NULL);

select * from insert_service('admin','update_admin_unidade',NULL);
select * from insert_service('admin','update_disciplina_unidade',NULL);
select * from insert_service('admin','update_disciplina_nome',NULL);
select * from insert_service('admin','update_disciplina_cred_aula',NULL);
select * from insert_service('admin','update_disciplina_cred_trabalho',NULL);
select * from insert_service('admin','update_administra_data_inicio',NULL);
select * from insert_service('admin','update_curriculo_unidade',NULL);
select * from insert_service('admin','update_curriculo_nome',NULL);
select * from insert_service('admin','update_curriculo_cred_obrig',NULL);
select * from insert_service('admin','update_curriculo_cred_opt_elet',NULL);
select * from insert_service('admin','update_curriculo_cred_opt_liv',NULL);
select * from insert_service('admin','update_trilha_descricao',NULL);
select * from insert_service('admin','update_modulo_descricao',NULL);
select * from insert_service('admin','update_disc_biblio_descricao',NULL);

/*
select * from insert_service('guest','guest_insert_into_role_student','guest add para si o perfil aluno');
select * from insert_service('guest','guest_insert_into_role_teacher','guest add para si o perfil professor');
select * from insert_service('guest','guest_insert_into_role_admin','guest add para si o perfil admin');*/
