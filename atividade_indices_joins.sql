DROP TABLE IF EXISTS contratos CASCADE;
DROP TABLE IF EXISTS clientes CASCADE;

CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome_cliente VARCHAR(100) NOT NULL,
    cidade VARCHAR(80),
    estado CHAR(2)
);

CREATE TABLE contratos (
    id_contrato SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    numero_contrato VARCHAR(20) NOT NULL,
    valor DECIMAL(10,2),
    data_contrato DATE,
    status VARCHAR(20),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Inserindo 100 clientes
INSERT INTO clientes (nome_cliente, cidade, estado)
SELECT 
    'Cliente ' || i,
    'Cidade ' || (i % 10),
    'SP'
FROM generate_series(1, 100) AS s(i);

INSERT INTO contratos (id_cliente, numero_contrato, valor, data_contrato, status)
SELECT 
    (random() * 99 + 1)::INT, -- cliente aleatório entre 1 e 100
    'CTR-' || LPAD(i::TEXT, 5, '0'), -- número de contrato formatado
    (random() * 9000 + 1000)::NUMERIC(10,2), -- valor entre 1000 e 10000
    CURRENT_DATE - (i % 365), -- data nos últimos 12 meses
    CASE 
        WHEN random() < 0.7 THEN 'Ativo'
        WHEN random() < 0.9 THEN 'Encerrado'
        ELSE 'Pendente'
    END
FROM generate_series(1, 5000) AS s(i);

-- Buscar contratos de um cliente específico
SELECT * FROM contratos WHERE id_cliente = 42;

-- Buscar contratos com status 'Ativo'
SELECT * FROM contratos WHERE status = 'Ativo';

-- Buscar contratos com valor acima de 8000
SELECT * FROM contratos WHERE valor > 8000;

-- Índice por cliente (melhora buscas por id_cliente)
CREATE INDEX idx_contratos_cliente ON contratos(id_cliente);

-- Índice por status (melhora buscas por contratos ativos/inativos)
CREATE INDEX idx_contratos_status ON contratos(status);

-- Índice composto (cliente + status)
CREATE INDEX idx_contratos_cliente_status ON contratos(id_cliente, status);

-- Contratos de um cliente específico (usa idx_contratos_cliente)
SELECT * FROM contratos WHERE id_cliente = 42;

-- Contratos ativos (usa idx_contratos_status)
SELECT * FROM contratos WHERE status = 'Ativo';

-- Contratos ativos de um cliente (usa idx_contratos_cliente_status)
SELECT * FROM contratos WHERE id_cliente = 42 AND status = 'Ativo';

-- JOIN simples entre contratos e clientes
SELECT 
    c.id_contrato,
    c.numero_contrato,
    c.valor,
    c.status,
    cl.nome_cliente,
    cl.cidade
FROM contratos c
JOIN clientes cl ON c.id_cliente = cl.id_cliente
WHERE c.status = 'Ativo'
ORDER BY c.valor DESC
LIMIT 10;
