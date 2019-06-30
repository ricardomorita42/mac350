\c modulo_pessoa
SET ROLE DBA;

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
