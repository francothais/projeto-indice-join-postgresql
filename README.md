# Projeto: Índices e Join no PostgreSQL

## Objetivo
Avaliar o impacto do uso de índices em consultas e demonstrar o uso de JOIN entre tabelas.

## Estrutura
- Tabela `contratos` com 5000 registros
- Tabela `fornecedores` com 1000 registros

## Etapas realizadas
1. Criação das tabelas
2. Inserção de registros com `generate_series`
3. Execução de consultas com e sem índice
4. Criação de índices em colunas estratégicas
5. Execução de consultas com `JOIN`
6. Comparação dos tempos obtidos via `EXPLAIN ANALYZE`

## Resultados esperados
- **Sem índice:** tempo maior (uso de `Seq Scan`)
- **Com índice:** tempo reduzido (uso de `Index Scan`)
- **JOIN:** execução rápida quando ambas as tabelas têm índices nas colunas de junção

## Conclusão
O uso de índices melhora significativamente o desempenho de consultas em tabelas grandes. 
A combinação com JOIN permite cruzar informações de maneira eficiente.
