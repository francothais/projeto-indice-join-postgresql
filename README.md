-- Tabela de clientes
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    cidade VARCHAR(100),
    email VARCHAR(150)
);

-- Tabela de contratos
CREATE TABLE contratos (
    id_contrato SERIAL PRIMARY KEY,
    numero_contrato VARCHAR(30),
    id_cliente INT REFERENCES clientes(id_cliente),
    valor NUMERIC(10,2),
    data_contrato DATE,
    status VARCHAR(20)
);

INSERT INTO clientes (nome, cidade, email)
SELECT
    'Cliente ' || i,
    'Cidade ' || (i % 20),
    'cliente' || i || '@exemplo.com'
FROM generate_series(1, 100) AS s(i);

INSERT INTO contratos (numero_contrato, id_cliente, valor, data_contrato, status)
SELECT
    'CT-' || i,
    (i % 100) + 1,
    (random() * 10000)::NUMERIC(10,2),
    NOW() - (i || ' days')::INTERVAL,
    CASE
        WHEN i % 3 = 0 THEN 'Ativo'
        WHEN i % 3 = 1 THEN 'Encerrado'
        ELSE 'Pendente'
    END
FROM generate_series(1, 5000) AS s(i);

EXPLAIN ANALYZE SELECT * FROM contratos WHERE id_cliente = 45;

CREATE INDEX idx_contratos_cliente ON contratos(id_cliente);

EXPLAIN ANALYZE SELECT * FROM contratos WHERE id_cliente = 45;

CREATE INDEX idx_contratos_status ON contratos(status);

EXPLAIN ANALYZE SELECT * FROM contratos WHERE status = 'Ativo';

SELECT
    c.nome,
    c.cidade,
    ct.numero_contrato,
    ct.valor,
    ct.status
FROM contratos ct
JOIN clientes c ON ct.id_cliente = c.id_cliente
WHERE ct.status = 'Ativo';
