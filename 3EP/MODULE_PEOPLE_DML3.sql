\c modulo_pessoa
SET ROLE DBA;

----!! Inserting oferecimentos !!----
select * from insert_oferecimento(588508512,'MAC0101','2019-01-01');
select * from insert_oferecimento(217525199,'MAC0102','2019-01-01');
select * from insert_oferecimento(403856584,'MAC0110','2019-01-01');
select * from insert_oferecimento(629091676,'MAC0350','2019-01-01');
select * from insert_oferecimento(914806276,'MAC0210','2019-01-01');
select * from insert_oferecimento(442932985,'MAC0420','2018-07-01');
select * from insert_oferecimento(292003247,'MAT0101','2018-07-01');
select * from insert_oferecimento(388414429,'MAT0102','2018-07-01');
select * from insert_oferecimento(886902161,'MAT0103','2018-07-01');
select * from insert_oferecimento(344149328,'7974123','2018-07-01');

----!! Inserting cursa !!----
select * from insert_cursa(559853740,'BCC' ,217525199,'MAC0102','2019-01-01',9.0,50.0);
select * from insert_cursa(994567006,'BCC' ,403856584,'MAC0110','2019-01-01',8.5,70.0);
select * from insert_cursa(230057892,'BMAT',629091676,'MAC0350','2019-01-01',7.2,80.0);
select * from insert_cursa(961065297,'BMAT',914806276,'MAC0210','2019-01-01',6.0,70.0);
select * from insert_cursa(162109146,'BMAT',442932985,'MAC0420','2018-07-01',5.3,70.0);
select * from insert_cursa(939847659,'BMAT',292003247,'MAT0101','2018-07-01',4.0,100.0);
select * from insert_cursa(489997003,'BMAE',388414429,'MAT0102','2018-07-01',3.6,100.0);
select * from insert_cursa(365513041,'BMAE',886902161,'MAT0103','2018-07-01',2.0,100.0);
select * from insert_cursa(300606205,'BMAE',344149328,'7974123','2018-07-01',0.1,100.0);
select * from insert_cursa(815705605,'BMAE' ,588508512,'MAC0101','2019-01-01',0.0,100.0);
