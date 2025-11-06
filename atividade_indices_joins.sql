-- ==========================================
-- ATIVIDADE: ÍNDICES E JOIN - SCRIPT COMPLETO
-- Execute tudo de uma vez no Query Tool
-- ==========================================

-- Limpa tabelas antigas (para garantir ambiente limpo)
DROP TABLE IF EXISTS contratos CASCADE;
DROP TABLE IF EXISTS fornecedores CASCADE;

-- 1) Criar tabela de fornecedores (para usar JOIN depois)
CREATE TABLE fornecedores (
    id SERIAL PRIMARY KEY,
    nome_fornecedor VARCHAR(100),
    cidade VARCHAR(100)
);

-- 2) Criar tabela principal de contratos
CREATE TABLE contratos (
    id SERIAL PRIMARY KEY,
    numero_contrato VARCHAR(20),
    data_contrato DATE,
    orgao VARCHAR(100),
    fornecedor VARCHAR(100)  -- manter mesmo formato de texto para o JOIN
);

-- 3) Popular fornecedores (1.000 linhas) - base para o JOIN
INSERT INTO fornecedores (nome_fornecedor, cidade)
SELECT 
    'Fornecedor_' || i,
    CASE 
        WHEN i % 2 = 0 THEN 'São Paulo'
        WHEN i % 3 = 0 THEN 'Rio de Janeiro'
        ELSE 'Brasília'
    END
FROM generate_series(1, 1000) AS s(i);

-- 4) Popular contratos (5.000 linhas) - requisito mínimo da atividade
INSERT INTO contratos (numero_contrato, data_contrato, orgao, fornecedor)
SELECT 
    'CT-' || lpad(i::text,5,'0'),
    CURRENT_DATE - (i % 365), -- datas distribuídas no último ano
    CASE 
        WHEN i % 2 = 0 THEN 'Prefeitura Municipal'
        WHEN i % 3 = 0 THEN 'Ministério da Saúde'
        ELSE 'Governo Federal'
    END,
    'Fornecedor_' || ((i % 1000) + 1)
FROM generate_series(1, 5000) AS s(i);

-- 5) Conferir quantidades importadas (anotar no relatório)
SELECT COUNT(*) AS total_contratos FROM contratos;
SELECT COUNT(*) AS total_fornecedores FROM fornecedores;

-- 6) Consulta sem índice (timing inicial)
-- IMPORTANTE: anote o output do EXPLAIN ANALYZE (total runtime)
EXPLAIN ANALYZE
SELECT * FROM contratos WHERE numero_contrato = 'CT-02500';

-- 7) Criar índice na coluna usada no WHERE
CREATE INDEX idx_contratos_numero ON contratos(numero_contrato);

-- 8) Repetir a mesma consulta com índice (compare tempos)
EXPLAIN ANALYZE
SELECT * FROM contratos WHERE numero_contrato = 'CT-02500';

-- 9) Criar índice na tabela de fornecedores (ajuda no JOIN)
CREATE INDEX idx_fornecedores_nome ON fornecedores(nome_fornecedor);

-- 10) Consulta com JOIN (medir tempo e mostrar que funciona com índice)
EXPLAIN ANALYZE
SELECT 
    c.numero_contrato,
    c.data_contrato,
    c.orgao,
    f.nome_fornecedor,
    f.cidade
FROM contratos c
JOIN fornecedores f
  ON c.fornecedor = f.nome_fornecedor
WHERE f.cidade = 'São Paulo';

-- 11) Amostras de dados para anexar (opcional)
SELECT * FROM contratos ORDER BY id LIMIT 10;
SELECT * FROM fornecedores ORDER BY id LIMIT 10;
