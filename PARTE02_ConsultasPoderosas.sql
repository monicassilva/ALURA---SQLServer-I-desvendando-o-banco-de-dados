--Verificar os dados das tabelas
--sp_help aluno;
--sp_help curso;
--sp_help exercicio;
--sp_help matricula;
--sp_help nota;
--sp_help resposta;
--sp_help secao;

--Busque todos os alunos que não tenham nenhuma matrícula nos cursos.

select a.nome 
from aluno a 
where not exists 
			(select m.id 
			from matricula m 
			where m.aluno_id = a.id);

--Busque todos os alunos que não tiveram nenhuma matrícula nos últimos 45 dias, usando a instrução EXISTS.

select a.nome 
from aluno a 
where not exists 
			 (select m.id from matricula m 
			 where m.aluno_id = a.id and m.data > dateadd(DAY, -45, getdate()) 
			);

-- Exiba a média das notas por curso.

select c.nome, 
		avg(n.nota) 
from nota n
join resposta r on r.id = n.resposta_id
join exercicio e on e.id = r.exercicio_id
join secao s on s.id = e.secao_id
join curso c on c.id = s.curso_id
group by c.nome

--Devolva o curso e as médias de notas, levando em conta somente alunos que tenham "Silva" ou "Santos" no sobrenome.

select c.nome, 
		avg(n.nota) 
from nota n
join resposta r on r.id = n.resposta_id
join exercicio e on e.id = r.exercicio_id
join secao s on s.id = e.secao_id
join curso c on c.id = s.curso_id
join aluno a on a.id = r.aluno_id
where a.nome like '%Santos%' or a.nome like '%Silva%'
group by c.nome

-- Conte a quantidade de respostas por exercício. Exiba a pergunta e o número de respostas.

select e.pergunta, 
		count(r.id) 
from exercicio e 
join resposta r on e.id = r.exercicio_id
group by e.id, e.pergunta

-- Pegue a resposta do exercício anterior, e ordene por número de respostas, em ordem decrescente.

select e.pergunta, 
		count(r.id) 
from exercicio e 
join resposta r on e.id = r.exercicio_id
group by e.pergunta
order by count(r.id) desc

-- Podemos agrupar por mais de um campo de uma só vez. Por exemplo, se quisermos a média de notas por aluno por curso, podemos fazer 
--GROUP BY aluno.id, curso.id.

select a.nome, 
		c.nome, 
		avg(n.nota) 
from nota n
join resposta r on r.id = n.resposta_id
join exercicio e on e.id = r.exercicio_id
join secao s on s.id = e.secao_id
join curso c on c.id = s.curso_id
join aluno a on a.id = r.aluno_id
group by c.nome, a.nome

-- Devolva todos os alunos, cursos e a média de suas notas. Lembre-se de agrupar por aluno e por curso.
-- Filtre também pela nota: só mostre alunos com nota média menor do que 5.

select a.nome, 
		c.nome, 
		avg(n.nota) 
from nota n
join resposta r on r.id = n.resposta_id
join exercicio e on e.id = r.exercicio_id
join secao s on s.id = e.secao_id
join curso c on c.id = s.curso_id
join aluno a on a.id = r.aluno_id
group by c.nome, a.nome
having avg(n.nota) < 5

-- Exiba todos os cursos e a sua quantidade de matrículas. Mas, exiba somente cursos que tenham mais de 1 matrícula.

select c.nome, 
		count(m.id) 
from curso c 
join matricula m on c.id = m.curso_id 
group by c.nome 
having count(m.id) > 1

--Exiba o nome do curso e a quantidade de seções que existe nele. Mostre só cursos com mais de 3 seções.

select c.nome, 
		count(s.id) 
from curso c 
join secao s on c.id = s.curso_id 
group by c.id, c.nome 
having count(s.id) > 3

-- Exiba todos os tipos de matrícula que existem na tabela. Use DISTINCT para que não haja repetição.

select distinct tipo from matricula

-- Exiba todos os cursos e a sua quantidade de matrículas. Mas filtre por matrículas dos tipos PF ou PJ.

select c.nome, 
		count(m.id) 
from curso c 
join matricula m on c.id = m.curso_id
where m.tipo = 'PAGA_PF' or m.tipo = 'PAGA_PJ'
group by c.nome

-- Traga todas as perguntas e a quantidade de respostas de cada uma. Mas dessa vez, somente dos cursos com ID 1 e 3.

select e.pergunta, 
		count(r.id) 
from exercicio e 
join resposta r on e.id = r.exercicio_id 
join secao s on s.id = e.secao_id 
join curso c on s.curso_id = c.id 
where c.id in (1,3) 
group by e.pergunta

-- Exiba a média das notas por aluno, além de uma coluna com a diferença entre a média do aluno e a média geral. Use sub-queries para isso.

select a.nome, 
		avg(n.nota) as media, 
		avg(n.nota) - (select avg(n1.nota) 
						from nota n1) as diferenca 
from nota n 
join resposta r on r.id = n.resposta_id 
join aluno a on a.id = r.aluno_id 
group by a.nome

-- Exiba a quantidade de matrículas por curso. Além disso, exiba a divisão entre matrículas naquele curso e matrículas totais.

select c.nome, 
count(m.id), 
count(m.id) - (select count(id) 
				from matricula)
from curso c 
join matricula m on m.curso_id = c.id
group by c.nome

-- Exiba todos os alunos e suas possíveis respostas. Exiba todos os alunos, mesmo que eles não tenham respondido nenhuma pergunta.

select a.nome, 
		r.resposta_dada 
from aluno a 
left join resposta r on a.id = r.aluno_id

-- Exiba agora todos os alunos e suas possíveis respostas para o exercício com ID = 1. Exiba todos os alunos mesmo que ele não tenha respondido o exercício.

select a.nome, 
		r.resposta_dada 
from aluno a 
left join resposta r on a.id = r.aluno_id
and r.exercicio_id = 1

-- Escreva uma query que traga apenas os dois primeiros alunos da tabela.

select top 2 nome from aluno

-- Escreva uma SQL que devolva os 3 primeiros alunos que o e-mail termine com o domínio ".com".

 select top 3 nome, email from aluno where email like '%.com'

-- Devolva os 2 primeiros alunos que o e-mail termine com ".com", ordenando por nome.

select TOP 2 NOME, EMAIL from aluno where email like '%.com' order by nome












 