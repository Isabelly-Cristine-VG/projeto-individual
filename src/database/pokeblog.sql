-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS pokeblog;
USE pokeblog;

-- Tabela de usuários
CREATE TABLE usuario (
    idUsuario INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(45),
    email VARCHAR(45) UNIQUE,
    telefone VARCHAR(15),
    senha VARCHAR(255), 
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de tipos de Pokémon (simplificada)
CREATE TABLE tipoPokemon(
    idTipoPokemon INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    tipo VARCHAR(20) UNIQUE,
    cor VARCHAR(20) -- Adicionado para representação visual
);

-- Tabela para relações de vantagem/desvantagem
CREATE TABLE vantagemTipo (
    idTipoAtacante INT,
    idTipoDefensor INT,
    multiplicador DECIMAL(2,1), -- 0.5 para resistência, 1 para neutro, 2 para fraqueza
    PRIMARY KEY (idTipoAtacante, idTipoDefensor),
    FOREIGN KEY (idTipoAtacante) REFERENCES tipoPokemon(idTipoPokemon),
    FOREIGN KEY (idTipoDefensor) REFERENCES tipoPokemon(idTipoPokemon)
);

-- Tabela de Pokémon
CREATE TABLE pokemon(
    idPokemon INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(45),
    nivel INT,
    idTipoPokemon INT NOT NULL,
    idTipoPokemon2 INT,
    evolucao INT,
    idUsuario INT, -- Dono do Pokémon
    data_captura DATETIME DEFAULT CURRENT_TIMESTAMP,
    genero ENUM('M', 'F', 'N'), -- Masculino, Feminino, Neutro/Desconhecido
    FOREIGN KEY (idTipoPokemon) REFERENCES tipoPokemon(idTipoPokemon),
    FOREIGN KEY (idTipoPokemon2) REFERENCES tipoPokemon(idTipoPokemon),
    FOREIGN KEY (evolucao) REFERENCES pokemon(idPokemon),
    FOREIGN KEY (idUsuario) REFERENCES usuario(idUsuario)
);

-- Tabela de tipos favoritos
CREATE TABLE tiposFavoritos (
    idUsuario INT NOT NULL,
    idTipoPokemon INT NOT NULL,
    PRIMARY KEY (idUsuario, idTipoPokemon),
    FOREIGN KEY (idUsuario) REFERENCES usuario(idUsuario),
    FOREIGN KEY (idTipoPokemon) REFERENCES tipoPokemon(idTipoPokemon)
);

-- Tabela de times (estrutura melhorada)
CREATE TABLE timePokemon (
    idTimePokemon INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    idUsuario INT NOT NULL,
    nomeTime VARCHAR(45),
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idUsuario) REFERENCES usuario(idUsuario)
);

-- Tabela de membros do time
CREATE TABLE timePokemon_membros (
    idTimePokemon INT NOT NULL,
    idPokemon INT NOT NULL,
    posicao INT,
    PRIMARY KEY (idTimePokemon, idPokemon),
    FOREIGN KEY (idTimePokemon) REFERENCES timePokemon(idTimePokemon),
    FOREIGN KEY (idPokemon) REFERENCES pokemon(idPokemon)
);

-- INSERTS PARA TIPOS DE POKÉMON
INSERT INTO tipoPokemon (idTipoPokemon, tipo, cor) VALUES
(1, 'Normal', '#A8A878'),
(2, 'Fogo', '#F08030'),
(3, 'Água', '#6890F0'),
(4, 'Elétrico', '#F8D030'),
(5, 'Grama', '#78C850'),
(6, 'Gelo', '#98D8D8'),
(7, 'Lutador', '#C03028'),
(8, 'Venenoso', '#A040A0'),
(9, 'Terra', '#E0C068'),
(10, 'Voador', '#A890F0'),
(11, 'Psíquico', '#F85888'),
(12, 'Inseto', '#A8B820'),
(13, 'Pedra', '#B8A038'),
(14, 'Fantasma', '#705898'),
(15, 'Dragão', '#7038F8'),
(16, 'Sombrio', '#705848'),
(17, 'Aço', '#B8B8D0'),
(18, 'Fada', '#EE99AC');

-- INSERTS PARA RELAÇÕES DE TIPO (VANTAGENS/DESVANTAGENS)
-- Eficácia 2x (super efetivo)
-- Substitua a seção de INSERTS da tabela vantagemTipo por este código:

-- Primeiro, limpe a tabela se já existirem dados
TRUNCATE TABLE vantagemTipo;

-- INSERTS PARA RELAÇÕES DE TIPO (VANTAGENS/DESVANTAGENS)
-- Eficácia 2x (super efetivo) - apenas relações únicas
INSERT INTO vantagemTipo (idTipoAtacante, idTipoDefensor, multiplicador) VALUES
-- Fogo
(2, 5, 2), (2, 12, 2), (2, 6, 2), (2, 17, 2),
-- Água
(3, 2, 2), (3, 9, 2), (3, 13, 2),
-- Elétrico
(4, 3, 2), (4, 10, 2),
-- Grama
(5, 3, 2), (5, 9, 2), (5, 13, 2),
-- Gelo
(6, 5, 2), (6, 9, 2), (6, 10, 2), (6, 15, 2),
-- Lutador
(7, 1, 2), (7, 6, 2), (7, 13, 2), (7, 16, 2), (7, 17, 2),
-- Venenoso
(8, 5, 2), (8, 18, 2),
-- Terra
(9, 2, 2), (9, 4, 2), (9, 8, 2), (9, 13, 2), (9, 17, 2),
-- Voador
(10, 5, 2), (10, 7, 2), (10, 12, 2),
-- Psíquico
(11, 7, 2), (11, 8, 2),
-- Inseto
(12, 5, 2), (12, 11, 2), (12, 16, 2),
-- Pedra
(13, 2, 2), (13, 6, 2), (13, 10, 2), (13, 12, 2),
-- Fantasma
(14, 14, 2), (14, 11, 2),
-- Dragão
(15, 15, 2),
-- Sombrio
(16, 14, 2), (16, 11, 2),
-- Aço
(17, 6, 2), (17, 13, 2), (17, 18, 2),
-- Fada
(18, 7, 2), (18, 15, 2), (18, 16, 2),

-- Eficácia 0.5x (não muito efetivo)
-- Fogo
(2, 2, 0.5), (2, 3, 0.5), (2, 15, 0.5), (2, 13, 0.5),
-- Água
(3, 3, 0.5), (3, 5, 0.5), (3, 15, 0.5),
-- Elétrico
(4, 5, 0.5), (4, 15, 0.5), (4, 4, 0.5),
-- Grama
(5, 2, 0.5), (5, 5, 0.5), (5, 8, 0.5), (5, 10, 0.5), (5, 12, 0.5), (5, 15, 0.5), (5, 17, 0.5),
-- Gelo
(6, 2, 0.5), (6, 3, 0.5), (6, 6, 0.5), (6, 17, 0.5),
-- Lutador
(7, 8, 0.5), (7, 10, 0.5), (7, 11, 0.5), (7, 12, 0.5), (7, 18, 0.5),
-- Venenoso
(8, 8, 0.5), (8, 9, 0.5), (8, 13, 0.5), (8, 14, 0.5),
-- Terra
(9, 5, 0.5), (9, 12, 0.5),
-- Voador
(10, 4, 0.5), (10, 13, 0.5), (10, 17, 0.5),
-- Psíquico
(11, 11, 0.5), (11, 17, 0.5),
-- Inseto
(12, 2, 0.5), (12, 7, 0.5), (12, 8, 0.5), (12, 10, 0.5), (12, 14, 0.5), (12, 17, 0.5), (12, 18, 0.5),
-- Pedra
(13, 7, 0.5), (13, 9, 0.5), (13, 17, 0.5),
-- Fantasma
(14, 16, 0.5),
-- Dragão
(15, 17, 0.5),
-- Sombrio
(16, 7, 0.5), (16, 16, 0.5), (16, 18, 0.5),
-- Aço
(17, 2, 0.5), (17, 3, 0.5), (17, 4, 0.5), (17, 17, 0.5),
-- Fada
(18, 2, 0.5), (18, 8, 0.5), (18, 17, 0.5),

-- Eficácia 0x (imune) - apenas relações únicas
(4, 9, 0),    -- Terra é imune a Elétrico
(7, 14, 0),   -- Fantasma é imune a Lutador
(9, 10, 0),   -- Voador é imune a Terra
(11, 16, 0),  -- Sombrio é imune a Psíquico
(14, 1, 0),   -- Normal é imune a Fantasma
(1, 14, 0),   -- Fantasma é imune a Normal
(8, 17, 0);   -- Aço é imune a Venenoso

SELECT 
    t.tipo AS 'Tipo',
    (SELECT GROUP_CONCAT(t2.tipo SEPARATOR ', ') 
     FROM vantagemTipo v
     JOIN tipoPokemon t2 ON v.idTipoAtacante = t2.idTipoPokemon
     WHERE v.idTipoDefensor = t.idTipoPokemon AND v.multiplicador = 2) AS 'Fraco contra',
     
    (SELECT GROUP_CONCAT(t2.tipo SEPARATOR ', ') 
     FROM vantagemTipo v
     JOIN tipoPokemon t2 ON v.idTipoAtacante = t2.idTipoPokemon
     WHERE v.idTipoDefensor = t.idTipoPokemon AND v.multiplicador = 0.5) AS 'Resistente a',
     
    (SELECT GROUP_CONCAT(t2.tipo SEPARATOR ', ') 
     FROM vantagemTipo v
     JOIN tipoPokemon t2 ON v.idTipoAtacante = t2.idTipoPokemon
     WHERE v.idTipoDefensor = t.idTipoPokemon AND v.multiplicador = 0) AS 'Imune a'
FROM tipoPokemon t
ORDER BY t.tipo;