--CRIAÇÃO DA TABELA PRINCIPAL - CONTRATOS

DROP TABLE IF EXISTS contratos CASCADE;
DROP TABLE IF EXISTS clientes CASCADE;

--CRIAÇÃO DA TABELA PRINCIPAL - CONTRATOS
CREATE TABLE contratos (
    id_contrato SERIAL PRIMARY KEY,
    numero_contrato VARCHAR (30),
    data_contrato DATE,
    valor NUMERIC(12,2),
    id_cliente INT REFERENCES clientes(id_cliente),
);

-- CRIAÇÃO DA SEGUNDA TABELA - CLIENTES
    CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome_cliente VARCHAR(100) NOT NULL,
    cidade VARCHAR(50)
);

-- IMPORTAÇÃO DOS DADOS VIA CSV
COPY clientes (id_cliente, nome_cliente, cidade)
FROM 'C:/Users/thais/Downloads/clientes.csv'
WITH (FORMAT csv, HEADER, DELIMITER ',', ENCODING 'UTF8');

COPY contratos (numero_contrato, data_contrato, valor, id_cliente)
FROM 'C:/Users/thais/Downloads/contratos.csv'
WITH (FORMAT csv, HEADER, DELIMITER ',', ENCODING 'UTF8');

-- TESTE DE DESEMPENHO SEM ÍNDICE
EXPLAIN ANALYZE
SELECT * FROM contratos WHERE numero_contrato = 'CT-3500';

-- CRIAÇÃO DO ÍNDICE
CREATE INDEX idx_contrato_numero ON contratos(numero_contrato);

-- TESTE DE DESEMPENHO COM ÍNDICE
EXPLAIN ANALYZE
SELECT * FROM contratos WHERE numero_contrato = 'CT-3500';

-- JOIN ENTRE AS TABELAS
EXPLAIN ANALYZE
SELECT c.numero_contrato, c.valor, cl.nome_cliente, cl.cidade
FROM contratos c
JOIN clientes cl ON c.id_cliente = cl.id_cliente
WHERE c.valor > 9000;
