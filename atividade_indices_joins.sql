DROP TABLE IF EXISTS contratos CASCADE;
DROP TABLE IF EXISTS fornecedores CASCADE;

CREATE TABLE fornecedores (
    id SERIAL PRIMARY KEY,
    nome_fornecedor VARCHAR(100),
    cidade VARCHAR(100)
);

CREATE TABLE contratos (
    id SERIAL PRIMARY KEY,
    numero_contrato VARCHAR(20),
    data_contrato DATE,
    orgao VARCHAR(100),
    fornecedor VARCHAR(100)  -- manter mesmo formato de texto para o JOIN
);

INSERT INTO fornecedores (nome_fornecedor, cidade)
SELECT 
    'Fornecedor_' || i,
    CASE 
        WHEN i % 2 = 0 THEN 'São Paulo'
        WHEN i % 3 = 0 THEN 'Rio de Janeiro'
        ELSE 'Brasília'
    END
FROM generate_series(1, 1000) AS s(i);

INSERT INTO contratos (numero_contrato, data_contrato, orgao, fornecedor)
SELECT 
    'CT-' || lpad(i::text,5,'0'),
    CURRENT_DATE - (i % 365), 
    CASE 
        WHEN i % 2 = 0 THEN 'Prefeitura Municipal'
        WHEN i % 3 = 0 THEN 'Ministério da Saúde'
        ELSE 'Governo Federal'
    END,
    'Fornecedor_' || ((i % 1000) + 1)
FROM generate_series(1, 5000) AS s(i);

SELECT COUNT(*) AS total_contratos FROM contratos;
SELECT COUNT(*) AS total_fornecedores FROM fornecedores;

-- IMPORTANTE: anote o output do EXPLAIN ANALYZE (total runtime)
EXPLAIN ANALYZE
SELECT * FROM contratos WHERE numero_contrato = 'CT-02500';

CREATE INDEX idx_contratos_numero ON contratos(numero_contrato);

EXPLAIN ANALYZE
SELECT * FROM contratos WHERE numero_contrato = 'CT-02500';

CREATE INDEX idx_fornecedores_nome ON fornecedores(nome_fornecedor);

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

SELECT * FROM contratos ORDER BY id LIMIT 10;
SELECT * FROM fornecedores ORDER BY id LIMIT 10;
