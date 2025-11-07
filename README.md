# Projeto indices e junção de tabelas no postgreSQL

Este projeto foi desenvolvido para demonstrar o uso de índices em consultas SQL e o ganho de desempenho em um banco de dados com mais de 5,000 registros.

## Estrutura do projeto 
- contratos.csv - contém 5000 registros de contratos
- atividade_indices_joins_sql - código sql completo
- readme.md - explicação e resultado
 
## etapas realizadas
1. criação das tabelas contratos e clientes
2. importação dos arquivos .csv para o PostgreSQL
3. Execução de consulta sem índice
4. criação de índice na coluna numero_contrato
5. execução de consulta com índice (melhor desempenho)
6. execução de JOIN entre consultas e clientes

 ## resultados observados
 - sem índice execução mais lenta, o PostgreSQL usa *Sequential Scan*
 - com índice execução muito mais rápida, usando *index scan*
 - com JOIN junção entre tabelas mostrou as relações entre clientes e contratos.

## conclusão
- o uso e índices melhora significativamente o tempo de resposta de consultas, principalmente quando há muitos registros. O JOIN foi utilizado para relacionar dados de diferentes tabelas, simulando uma situação real de banco de dados relacional.
