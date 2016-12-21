--EXERCICIOS AULA 01 (Consultando dados)
-- CRIAÇÃO DE TABELA COMPRAS
CREATE TABLE COMPRAS(
id int PRIMARY KEY IDENTITY NOT NULL,
valor decimal(10,2)  NULL,
data datetime  NULL,
observacoes nvarchar(200) NULL,
recebidas bit NULL
);

-- CONSULTANDO TODOS OS DADOS DA TABELA COMPRAS
SELECT * FROM COMPRAS

-- Selecione VALOR e OBSERVAÇÕES de todas as compras cuja data seja maior-ou-igual que 15/12/2008. 
SELECT valor, observacoes FROM COMPRAS WHERE DATA >= '2008-12-15'

-- Selecione todas as compras cuja data seja maior-ou-igual que 15/12/2008 e menor do que 15/12/2010. 

SELECT * FROM COMPRAS WHERE data >= 2008-12-15 AND  data < 2010-12-15

-- Selecione todas as compras cujo valor esteja entre R$15,00 e R$35,00 e a observação comece com a palavra 'LANCHONETE'. 
SELECT  * FROM COMPRAS WHERE valor >= 15.0 AND valor <= 35.0 AND observacoes LIKE 'LANCHONETE'

-- Selecione todas as compras que já foram recebidas.
SELECT * FROM COMPRAS WHERE recebidas = 1

-- Selecione todas as compras que ainda não foram recebidas.

SELECT * FROM COMPRAS WHERE recebidas = 0

-- Selecione todas as compras com valor maior que 5.000,00 ou que já foram recebidas. 

SELECT  * FROM COMPRAS WHERE valor > 5000 OR recebidas = 1

-- Selecione todas as compras que o valor esteja entre 1.000,00 e 3.000,00 ou maior que 5.000,00.

SELECT * FROM COMPRAS WHERE (valor > =1000 AND valor <=3000) OR (valor > 5000)

--EXERCICIOS AULA 02 (Atualizando e excluindo dados)

--Altere as compras, colocando a observação 'preparando o natal' para todas as que foram efetuadas no dia 20/12/2010.

UPDATE COMPRAS
SET observacoes = 'preparando o natal '
WHERE data   = '2010-12-20' 

-- Altere o VALOR das compras feitas antes de 01/06/2009. Some R$10,00 ao valor atual.

UPDATE COMPRAS
SET valor  = valor + 10
WHERE data < '2009-06-01'

-- Atualize todas as compras feitas entre 01/07/2009 e 01/07/2010 para que elas tenham a observação 'entregue antes de 2011' e a coluna recebida com o valor TRUE.

UPDATE COMPRAS
SET  observacoes = 'entregue antes de 2011', recebidas  = 'TRUE'
WHERE data between '2009-07-01' AND '2010-07-01'

-- Exclua as compras realizadas entre 05 e 20 março de 2009. Coloque abaixo o comando executado.

DELETE  FROM COMPRAS  WHERE data between '2009-03-05' AND '200-03-20'

-- Use o operador NOT e monte um SELECT que retorna todas as compras com valor diferente de R$ 108,00.

SELECT * FROM COMPRAS WHERE NOT valor = 108

--EXERCICIOS AULA 03 (Alterando e restringindo o formato de nossas tabelas)

--Configure o valor padrão para a coluna recebida.

ALTER TABLE COMPRAS add default '0' for recebida

-- Configure a coluna observacoes para não aceitar valores nulos.

ALTER TABLE COMPRAS alter column obervacoes NVARCHAR(200) NOT NULL

-- Reescreva o CREATE TABLE do começo do curso, marcando OBSERVACOES como nulo e valor padrão do RECEBIDO como 1.

CREATE TABLE COMPRAS(
id int PRIMARY KEY IDENTITY NOT NULL,
valor decimal(10,2),
data datetime,
observacoes text NULL,
recebida bit DEFAULT '1'
);

-- EXERCICIOS AULA 04 (Agrupando dados e fazendo consultas mais inteligentes)

--Calcule a média de todas as compras com datas inferiores a 12/05/2009. Cole a instrução SQL aqui quando acabar.

SELECT 
avg(valor)
FROM COMPRAS
WHERE data < '2009-05-12' 

-- Calcule a quantidade de compras com datas inferiores a 12/05/2009 e que já foram recebidas.

SELECT 
count(1)
FROM COMPRAS
WHERE data <'2009-05-12' AND recebidas = 1

-- Calcule a soma de todas as compras, agrupadas se a compra foi recebida ou não. 

SELECT 
recebidas,
sum(valor)
FROM COMPRAS
GROUP BY recebidas 

-- EXERCICIOS AULA 04 (Juntando dados de várias tabelas)
-- Crie a tabela compradores com id, nome, endereco e telefone.

CREATE TABLE COMPRADORES (
id int PRIMARY KEY IDENTITY NOT NULL,
nome NVARCHAR(20) NOT NULL,
endereco NVARCHAR(100) NOT NULL,
telefone NVARCHAR(20) NULL
);

-- Insira os compradores: Guilherme Silveira e Gabriel Ferreira. 

INSERT INTO COMPRADORES VALUES ('Guilherme Silveira', 'Rua azul 01', '1212-1212')
INSERT INTO COMPRADORES VALUES ('Gabriel Ferreira', 'Rua Roza 02', '1313-1313 ')

-- Adicione a coluna comprador_id na tabela compras e defina a chave estrangeira (foreign key)referenciando o id da tabela compradores.

ALTER TABLE COMPRAS add comprador_id int

ALTER TABLE COMPRAS
ADD CONSTRAINT FK_Compras_CompradorID FOREIGN KEY(comprador_id)
REFERENCES compradores(id)

-- Atualize a tabela compras e insira o id dos compradores na coluna comprador_id.

UPDATE COMPRAS set comprador_id = 1 WHERE id < 22;
UPDATE COMPRAS set comprador_id = 2 WHERE id > 21;

-- Exiba o NOME do comprador e o VALOR de todas as compras feitas antes de 09/08/2010. 

SELECT 
nome, 
valor 
FROM COMPRAS C1 INNER JOIN COMPRADORES C2 
ON C1.COMPRADOR_ID = C2.ID
WHERE data < '2010-08-09'

-- Exiba todas as compras do comprador que possui ID igual a 2.

SELECT *
FROM COMPRAS C1  INNER JOIN COMPRADORES C2
ON C1.COMPRADOR_ID = C2.ID 
WHERE comprador_id = 2

-- Exiba todas as compras (mas sem os dados do comprador), cujo comprador tenha nome que começa com 'GABRIEL'.

SELECT COMPRAS.*
FROM COMPRAS C1 INNER JOIN COMPRADORES C2
ON C1.COMPRADOR_ID = C2.ID 
WHERE nome LIKE 'GABRIEL'

-- Exiba o nome do comprador e a soma de todas as suas compras.

SELECT
C2.nome,
sum(valor)
FROM COMPRAS C1 INNER JOIN COMPRADORES C2
ON C1.COMPRADOR_ID = C2.ID
GROUP BY C2.nome










