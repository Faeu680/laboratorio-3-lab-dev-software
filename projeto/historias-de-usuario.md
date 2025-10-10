Histórias de Usuário — Aluno

US01 — Cadastro de Aluno
Como aluno, quero me cadastrar no sistema, informando meus dados pessoais (nome, e-mail, CPF, RG, endereço, instituição e curso),
para que eu possa participar do sistema de mérito e receber moedas dos professores.
Critérios de aceitação:
	•	O aluno deve selecionar uma instituição previamente cadastrada.
	•	Deve validar CPF, e-mail e obrigatoriedade de todos os campos.
	•	Deve gerar automaticamente uma conta (carteira) com saldo inicial zero.

⸻

US02 — Login e Autenticação
Como aluno, quero fazer login com e-mail e senha,
para que eu possa acessar o sistema com segurança.
Critérios de aceitação:
	•	Autenticação via JWT ou OAuth2.
	•	Mensagem de erro clara em caso de credenciais inválidas.

⸻

US03 — Receber Moedas e Notificação
Como aluno, quero receber moedas enviadas por professores,
para que meu reconhecimento seja registrado e eu possa usá-las futuramente.
Critérios de aceitação:
	•	Receber notificação automática por e-mail.
	•	O valor recebido deve ser somado ao saldo da carteira.
	•	O extrato deve exibir data, valor e professor emissor.

⸻

US04 — Consultar Extrato
Como aluno, quero visualizar meu extrato de transações,
para que eu saiba o saldo atual e o histórico de moedas recebidas e trocadas.
Critérios de aceitação:
	•	Deve listar todas as transações com tipo (recebimento/troca).
	•	Deve exibir saldo atualizado.

⸻

US05 — Trocar Moedas por Vantagens
Como aluno, quero usar minhas moedas para resgatar vantagens oferecidas por empresas,
para que eu possa usufruir de benefícios como descontos e produtos.
Critérios de aceitação:
	•	Deve exibir catálogo de vantagens ativas.
	•	O saldo deve ser verificado antes da troca.
	•	Ao confirmar, o sistema gera um código/cupom e envia por e-mail.
	•	Um e-mail também deve ser enviado à empresa parceira com o código.

⸻

Histórias de Usuário — Professor

US06 — Login e Autenticação de Professor
Como professor, quero acessar o sistema com meu login e senha,
para que eu possa distribuir moedas e consultar meu saldo.
Critérios de aceitação:
	•	Login disponível apenas para professores pré-cadastrados pela instituição.
	•	Autenticação segura (JWT/OAuth2).

⸻

US07 — Enviar Moedas a Alunos
Como professor, quero enviar moedas para alunos,
para que eu possa reconhecer sua participação e bom comportamento.
Critérios de aceitação:
	•	Deve possuir saldo suficiente para a transação.
	•	Deve informar o motivo (mensagem obrigatória).
	•	O aluno deve receber um e-mail automático.
	•	O extrato deve registrar a transação como “envio”.

⸻

US08 — Consultar Extrato de Professor
Como professor, quero consultar meu extrato,
para que eu possa ver o total de moedas e as transações realizadas.
Critérios de aceitação:
	•	Deve mostrar envios realizados e saldo atual.
	•	Saldo inicial é renovado (+1000 moedas) a cada semestre.

⸻

US09 — Receber Crédito Semestral
Como professor, quero ter meu saldo de moedas recarregado automaticamente a cada semestre,
para que eu possa continuar premiando alunos.
Critérios de aceitação:
	•	O sistema executa o crédito automaticamente (tarefa agendada).
	•	O saldo é acumulável (somado ao saldo anterior).

⸻

Histórias de Usuário — Empresa Parceira

US10 — Cadastro de Empresa Parceira
Como empresa parceira, quero me cadastrar no sistema,
para que eu possa oferecer vantagens aos alunos.
Critérios de aceitação:
	•	Deve informar nome, CNPJ, e-mail corporativo e senha.
	•	Após o cadastro, a empresa pode cadastrar vantagens.

⸻

US11 — Cadastrar Vantagens
Como empresa parceira, quero cadastrar vantagens,
para que os alunos possam resgatá-las com suas moedas.
Critérios de aceitação:
	•	Deve conter título, descrição, custo em moedas e foto.
	•	A vantagem deve poder ser ativada ou desativada.

⸻

US12 — Receber Notificação de Resgate
Como empresa parceira, quero receber um e-mail quando um aluno resgatar uma vantagem,
para que eu possa verificar o código do cupom e liberar o benefício.
Critérios de aceitação:
	•	O e-mail deve conter o código do resgate e os dados do aluno.
	•	Deve permitir validação do código no sistema.

⸻
Histórias de Usuário — Instituição de Ensino / Administrador

US13 — Pré-Cadastro de Instituições
Como administrador, quero pré-cadastrar instituições de ensino,
para que os alunos possam selecionar a instituição correta ao se registrarem.
Critérios de aceitação:
	•	Deve conter nome da instituição e dados básicos.
	•	As instituições aparecem em lista no cadastro de aluno.

⸻

US14 — Importar Professores Parceiros
Como instituição de ensino, quero enviar uma lista de professores vinculados,
para que eles sejam pré-cadastrados no sistema automaticamente.
Critérios de aceitação:
	•	Cada professor deve ter nome, CPF e departamento.
	•	Deve ser vinculado à instituição correspondente.

⸻

US15 — Gerenciar Usuários e Dados do Sistema
Como administrador, quero gerenciar cadastros, validar dados e manter integridade,
para que o sistema funcione de forma estável e segura.
Critérios de aceitação:
	•	Pode ativar/desativar usuários.
	•	Pode excluir registros inconsistentes.

⸻

Histórias de Usuário — Serviços do Sistema

US16 — Serviço de E-mail
Como sistema, quero enviar e-mails automáticos para alunos e empresas,
para que eles sejam notificados sobre recebimentos e resgates.
Critérios de aceitação:
	•	Deve funcionar de forma assíncrona.
	•	Deve registrar logs de envio e falha.

⸻

US17 — Agendador de Créditos Semestrais
Como sistema, quero executar uma tarefa automática a cada semestre,
para que os professores recebam suas 1000 moedas adicionais.
Critérios de aceitação:
	•	Deve rodar via job/scheduler configurado.
	•	Deve atualizar saldo e registrar transação de crédito.