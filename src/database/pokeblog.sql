-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS pokeblog;
USE pokeblog;

-- Tabela de usuários
CREATE TABLE usuario (
    idUsuario INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(45) NOT NULL,
    email VARCHAR(45) UNIQUE NOT NULL,
    telefone VARCHAR(15),
    senha VARCHAR(255) NOT NULL,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de regiões
CREATE TABLE regiao (
    idRegiao INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nomeRegiao VARCHAR(50) NOT NULL
);

-- Tabela de jogos
CREATE TABLE jogo (
    idJogo INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(50) NOT NULL,
    idRegiao INT NOT NULL,
    lancamento DATE,
    plataforma VARCHAR(30),
    FOREIGN KEY (idRegiao) REFERENCES regiao(idRegiao)
);

-- Tabela de tipos de Pokémon
CREATE TABLE tipoPokemon (
    idTipoPokemon INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    tipo VARCHAR(20) UNIQUE NOT NULL,
    cor VARCHAR(20) NOT NULL
);

-- Tabela para relações de vantagem/desvantagem
CREATE TABLE vantagemTipo (
    idTipoAtacante INT NOT NULL,
    idTipoDefensor INT NOT NULL,
    multiplicador DECIMAL(2,1) NOT NULL, -- 0.5 para resistência, 1 para neutro, 2 para fraqueza
    PRIMARY KEY (idTipoAtacante, idTipoDefensor),
    FOREIGN KEY (idTipoAtacante) REFERENCES tipoPokemon(idTipoPokemon),
    FOREIGN KEY (idTipoDefensor) REFERENCES tipoPokemon(idTipoPokemon)
);

-- Tabela de Pokémon
CREATE TABLE pokemon (
    idPokemon INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(45) NOT NULL,
    especie VARCHAR(45) NOT NULL, -- Ex.: "Pokémon Semente"
    descricao TEXT, -- Descrição flavor text
    altura DECIMAL(4,2) NULL, -- Em metros
    peso DECIMAL(5,2) NULL, -- Em kg
    idTipoPokemon INT NOT NULL,
    idTipoPokemon2 INT NULL,
    hp_base INT NOT NULL DEFAULT 1,
    ataque_base INT NOT NULL DEFAULT 1,
    defesa_base INT NOT NULL DEFAULT 1,
    ataque_especial_base INT NOT NULL DEFAULT 1,
    defesa_especial_base INT NOT NULL DEFAULT 1,
    velocidade_base INT NOT NULL DEFAULT 1,
    taxa_captura INT NULL, -- De 1 a 255
    taxa_genero DECIMAL(3,1) NULL, -- Porcentagem de fêmeas (ex.: 87.5)
    nivel_evolucao INT NULL, -- Nível para evoluir (se aplicável)
    imagemUrl VARCHAR(255),
    FOREIGN KEY (idTipoPokemon) REFERENCES tipoPokemon(idTipoPokemon),
    FOREIGN KEY (idTipoPokemon2) REFERENCES tipoPokemon(idTipoPokemon)
);

-- Tabela de habilidades (ampliada)
CREATE TABLE habilidade (
    idHabilidade INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(45) NOT NULL,
    descricao TEXT,
    idTipoPokemon INT NULL,
    poder INT NULL,
    precisao INT NULL, -- Valor de 0 a 100
    pp INT NULL, -- Poder Pontos
    efeito TEXT, -- Descrição detalhada do efeito
    categoria ENUM('Físico', 'Especial', 'Status') NULL,
    alvo ENUM('Alvo Único', 'Todos', 'Auto', 'Campo') NULL,
    FOREIGN KEY (idTipoPokemon) REFERENCES tipoPokemon(idTipoPokemon)
);

-- Tabela de habilidades que Pokémon podem aprender
CREATE TABLE pokemon_habilidades (
    idPokemon INT NOT NULL,
    idHabilidade INT NOT NULL,
    raridade ENUM('Comum', 'Incomum', 'Rara', 'Especial') DEFAULT 'Comum',
    metodo_aprendizado ENUM('Level Up', 'TM/HM', 'Ovo', 'Tutor') NOT NULL,
    nivel_aprender INT NULL, -- Se aprendido por level up
    PRIMARY KEY (idPokemon, idHabilidade, metodo_aprendizado),
    FOREIGN KEY (idPokemon) REFERENCES pokemon(idPokemon),
    FOREIGN KEY (idHabilidade) REFERENCES habilidade(idHabilidade)
);

-- Tabela de evoluções (com mais detalhes)
CREATE TABLE evolucao (
    idPokemonBase INT NOT NULL,
    idPokemonEvolucao INT NOT NULL,
    metodo VARCHAR(100) NOT NULL, -- Ex.: "Level 16", "Pedra do Trovão"
    condicao TEXT NULL, -- Condições especiais
    nivel INT NULL, -- Nível necessário
    item VARCHAR(45) NULL, -- Item necessário
    felicidade BOOLEAN NULL, -- Requer felicidade máxima?
    hora_dia ENUM('Dia', 'Noite', 'Qualquer') NULL,
    PRIMARY KEY (idPokemonBase, idPokemonEvolucao, metodo),
    FOREIGN KEY (idPokemonBase) REFERENCES pokemon(idPokemon),
    FOREIGN KEY (idPokemonEvolucao) REFERENCES pokemon(idPokemon)
);
-- Tabela de tipos favoritos
CREATE TABLE tiposFavoritos (
    idUsuario INT NOT NULL,
    idTipoPokemon INT NOT NULL,
    PRIMARY KEY (idUsuario, idTipoPokemon),
    FOREIGN KEY (idUsuario) REFERENCES usuario(idUsuario),
    FOREIGN KEY (idTipoPokemon) REFERENCES tipoPokemon(idTipoPokemon)
);

-- Tabela de times
CREATE TABLE timePokemon (
    idTimePokemon INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    idUsuario INT NOT NULL,
    nomeTime VARCHAR(45) NOT NULL,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idUsuario) REFERENCES usuario(idUsuario)
);

-- Tabela de membros do time
CREATE TABLE timePokemon_membros (
    idTimePokemon INT NOT NULL,
    idPokemon INT NOT NULL,
    posicao_no_time TINYINT NOT NULL, -- Posição 1-6 no time
    PRIMARY KEY (idTimePokemon, idPokemon),
    FOREIGN KEY (idTimePokemon) REFERENCES timePokemon(idTimePokemon),
    FOREIGN KEY (idPokemon) REFERENCES pokemon(idPokemon)
);

-- Tabela de líderes de ginásio
CREATE TABLE liderGinasio (
    idLider INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nomeLider VARCHAR(45) NOT NULL,
    imagemUrl VARCHAR(255),
    cidade VARCHAR(45) NOT NULL,
    idRegiao INT NOT NULL,
    idTimePokemon INT NOT NULL,
    FOREIGN KEY (idRegiao) REFERENCES regiao(idRegiao),
    FOREIGN KEY (idTimePokemon) REFERENCES timePokemon(idTimePokemon)
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

-- Eficácia 0x (imune)
(4, 9, 0),    -- Terra é imune a Elétrico
(7, 14, 0),   -- Fantasma é imune a Lutador
(9, 10, 0),   -- Voador é imune a Terra
(11, 16, 0),  -- Sombrio é imune a Psíquico
(14, 1, 0),   -- Normal é imune a Fantasma
(1, 14, 0),   -- Fantasma é imune a Normal
(8, 17, 0);   -- Aço é imune a Venenoso

-- INSERTS PARA REGIÕES
INSERT INTO regiao (idRegiao, nomeRegiao) VALUES
(1, 'Kanto'),
(2, 'Johto'),
(3, 'Hoenn'),
(4, 'Sinnoh'),
(5, 'Unova'),
(6, 'Kalos'),
(7, 'Alola'),
(8, 'Galar');

-- INSERTS PARA JOGOS
INSERT INTO jogo (idJogo, nome, idRegiao, lancamento, plataforma) VALUES
(1, 'Pokémon Red', 1, '1996-09-28', 'Game Boy'),
(2, 'Pokémon Blue', 1, '1996-10-15', 'Game Boy'),
(3, 'Pokémon Yellow', 1, '1998-09-12', 'Game Boy'),
(4, 'Pokémon Gold', 2, '1999-11-21', 'Game Boy Color'),
(5, 'Pokémon Silver', 2, '1999-11-21', 'Game Boy Color'),
(6, 'Pokémon Crystal', 2, '2000-12-14', 'Game Boy Color'),
(7, 'Pokémon Ruby', 3, '2002-11-21', 'Game Boy Advance'),
(8, 'Pokémon Sapphire', 3, '2002-11-21', 'Game Boy Advance'),
(9, 'Pokémon Emerald', 3, '2004-09-16', 'Game Boy Advance'),
(10, 'Pokémon Fire Red', 1, '2004-01-29', 'Game Boy Advance'),
(11, 'Pokémon Leaf Green', 1, '2004-01-29', 'Game Boy Advance');
