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
    hpBase INT NOT NULL DEFAULT 1,
    ataqueBase INT NOT NULL DEFAULT 1,
    defesaBase INT NOT NULL DEFAULT 1,
    ataqueEspecial_base INT NOT NULL DEFAULT 1,
    defesaEspecial_base INT NOT NULL DEFAULT 1,
    velocidadeBase INT NOT NULL DEFAULT 1,
    taxaCaptura INT NULL, -- De 1 a 255
    taxaGenero DECIMAL(3,1) NULL, -- Porcentagem de fêmeas (ex.: 87.5)
    preEvolucao INT,
    metodoEvolucao VARCHAR(50),
    nivelEvolucao INT NULL, -- Nível para evoluir (se aplicável)
    imagemUrl VARCHAR(255),
    FOREIGN KEY (preEvolucao) REFERENCES pokemon(idPokemon),
    FOREIGN KEY (idTipoPokemon) REFERENCES tipoPokemon(idTipoPokemon),
    FOREIGN KEY (idTipoPokemon2) REFERENCES tipoPokemon(idTipoPokemon)
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

-- Primeiro insira todos os Pokémon básicos (sem preEvolucao)
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Pokémon de Pedra/Terra sem pré-evolução
('Geodude', 'Pokémon Pedra', 'Encontrado em campos e montanhas. Gosta de rolar em trilhas montanhosas.', 0.4, 20.0, 13, 9, 40, 80, 100, 30, 30, 20, 255, 50.0, NULL, 'Level 25', 25, 'https://pokeportuga.pt/img/jogos/sprites/frlg/074.png'),
('Onix', 'Pokémon Cobra de Pedra', 'Escava o solo a 80 km/h e deixa um túnel característico para trás.', 8.8, 210.0, 13, 9, 35, 45, 160, 30, 45, 70, 45, 50.0, NULL, 'Trade com Metal Coat', NULL, 'https://pokeportuga.pt/img/jogos/sprites/hgss/095.png'),
('Rhyhorn', 'Pokémon Espinhoso', 'Seu cérebro é pequeno, mas sua força é enorme. Destrói edifícios sem perceber.', 1.0, 115.0, 9, 13, 80, 85, 95, 30, 30, 25, 120, 50.0, NULL, 'Level 42', 42, 'https://pokeportuga.pt/img/jogos/sprites/hgss/111_m.png'),
('Omanyte', 'Pokémon Espiral', 'Um Pokémon pré-histórico que foi regenerado a partir de um fóssil.', 0.4, 7.5, 3, 13, 35, 40, 100, 90, 55, 35, 45, 87.5, NULL, 'Level 40', 40, 'https://pokeportuga.pt/img/jogos/sprites/hgss/138.png'),
('Kabuto', 'Pokémon Cascudo', 'Um Pokémon fóssil que foi regenerado. Viveu no fundo do mar há 300 milhões de anos.', 0.5, 11.5, 3, 13, 30, 80, 90, 55, 45, 55, 45, 87.5, NULL, 'Level 40', 40, 'https://pokeportuga.pt/img/jogos/sprites/hgss/140.png'),
('Aerodactyl', 'Pokémon Fóssil', 'Um Pokémon feroz e pré-histórico que ataca com mandíbulas serrilhadas.', 1.8, 59.0, 13, 10, 80, 105, 65, 60, 75, 130, 45, 87.5, NULL, NULL, NULL, 'https://pokeportuga.pt/img/jogos/sprites/hgss/142.png'),
('Dugtrio', 'Pokémon Toupeira', 'Um trio de Diglett. Causa terremotos massivos ao cavar 100 km abaixo da terra.', 0.7, 33.3, 9, NULL, 35, 80, 50, 50, 70, 120, 50, 50.0, NULL, NULL, NULL, 'https://pokeportuga.pt/img/jogos/sprites/frlg/051.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Pokémon Elétricos sem pré-evolução
('Pichu', 'Pokémon Ratinho', 'Ainda não consegue armazenar eletricidade. Frequentemente se choca acidentalmente.', 0.3, 2.0, 4, NULL, 20, 40, 15, 35, 35, 60, 190, 50.0, NULL, 'Amizade alta', NULL, 'https://pokeportuga.pt/img/jogos/sprites/hgss/172.png'),
('Voltorb', 'Pokémon Bola', 'Muito semelhante a uma Pokébola. Já causou muitos acidentes por causa disso.', 0.5, 10.4, 4, NULL, 40, 30, 50, 55, 55, 100, 190, NULL, NULL, 'Level 30', 30, 'https://pokeportuga.pt/img/jogos/sprites/frlg/100.png'),
('Magnemite', 'Pokémon Ímã', 'Usa eletricidade para se mover. Frequentemente encontrado perto de usinas de energia.', 0.3, 6.0, 4, 17, 25, 35, 70, 95, 55, 45, 190, NULL, NULL, 'Level 30', 30, 'https://pokeportuga.pt/img/jogos/sprites/hgss/081.png'),
('Electabuzz', 'Pokémon Elétrico', 'Armazena eletricidade em seu corpo. Frequentemente encontrado perto de usinas.', 1.1, 30.0, 4, NULL, 65, 83, 57, 95, 85, 105, 45, 75.0, NULL, 'Trade com Electirizer', NULL, 'https://pokeportuga.pt/img/jogos/sprites/hgss/125.png'),
('Elekid', 'Pokémon Elétrico', 'Gira os braços para gerar eletricidade, mas frequentemente se cansa rapidamente.', 0.6, 23.5, 4, NULL, 45, 63, 37, 65, 55, 95, 45, 75.0, NULL, 'Level 30', 30, 'https://pokeportuga.pt/img/jogos/sprites/hgss/239.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Pokémon Aquáticos sem pré-evolução
('Staryu', 'Pokémon Estrela', 'No centro de seu corpo está um olho vermelho que brilha misteriosamente.', 0.8, 34.5, 3, NULL, 30, 45, 55, 70, 55, 85, 225, NULL, NULL, 'Pedra da Água', NULL, 'https://pokeportuga.pt/img/jogos/sprites/frlg/120.png'),
('Psyduck', 'Pokémon Pato', 'Sofre constantemente de dores de cabeça. Quando a dor piora, usa poderes psíquicos.', 0.8, 19.6, 3, NULL, 50, 52, 48, 65, 50, 55, 190, 50.0, NULL, 'Level 33', 33, 'https://pokeportuga.pt/img/jogos/sprites/hgss/054.png'),
('Poliwag', 'Pokémon Girino', 'Suas pernas recém-nascidas não podem suportar seu peso. Apenas nada em padrões espirais.', 0.6, 12.4, 3, NULL, 40, 50, 40, 40, 40, 90, 255, 50.0, NULL, 'Level 25', 25, 'https://pokeportuga.pt/img/jogos/sprites/hgss/060.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Pokémon de Planta sem pré-evolução
('Tangela', 'Pokémon Vinha', 'Seu corpo é coberto por vinhas semelhantes a algas. Elas balançam quando se move.', 1.0, 35.0, 5, NULL, 65, 55, 115, 100, 40, 60, 45, 50.0, NULL, NULL, NULL, 'https://pokeportuga.pt/img/jogos/sprites/hgss/114.png'),
('Exeggcute', 'Pokémon Ovo', 'Seis ovos formam um grupo que se comunica telepaticamente. Podese fundir com outros grupos.', 0.4, 2.5, 5, 11, 60, 40, 80, 60, 45, 40, 90, 50.0, NULL, 'Pedra Evolutiva', NULL, 'https://pokeportuga.pt/img/jogos/sprites/hgss/102.png'),
('Oddish', 'Pokémon Erva Daninha', 'Durante o dia, fica enterrado no solo. À noite, vagueia para espalhar suas sementes.', 0.5, 5.4, 5, 8, 45, 50, 55, 75, 65, 30, 255, 50.0, NULL, 'Level 21', 21, 'https://pokeportuga.pt/img/jogos/sprites/hgss/043.png'),
('Bellsprout', 'Pokémon Flor', 'Prefere locais quentes e úmidos. Captura pequenos insetos com suas folhas em forma de concha.', 0.7, 4.0, 5, 8, 50, 75, 35, 70, 30, 40, 255, 50.0, NULL, 'Level 21', 21, 'https://pokeportuga.pt/img/jogos/sprites/hgss/069.png'),
('Hoppip', 'Pokémon Algodão', 'Flutua no vento para evitar ataques terrestres. Pode viajar milhas se pego por uma forte corrente de ar.', 0.4, 0.5, 5, 10, 35, 35, 40, 35, 55, 50, 255, 50.0, NULL, 'Level 18', 18, 'https://pokeportuga.pt/img/jogos/sprites/hgss/187.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Pokémon Venenosos sem pré-evolução
('Koffing', 'Pokémon Gás Venenoso', 'Como seu corpo está cheio de gases venenosos, ele balança enquanto voa.', 0.6, 1.0, 8, NULL, 40, 65, 95, 60, 45, 35, 190, 50.0, NULL, 'Nível', 35, 'https://pokeportuga.pt/img/jogos/sprites/frlg/109.png'),
('Grimer', 'Pokémon Lodo', 'Feito de lixo tóxico que se reuniu em esgotos. Pode derreter qualquer coisa com seu corpo ácido.', 0.9, 30.0, 8, NULL, 80, 80, 50, 40, 50, 25, 190, 50.0, NULL, 'Nível', 38, 'https://pokeportuga.pt/img/jogos/sprites/hgss/088.png'),
('Nidoran♀', 'Pokémon Venenoso', 'Tem um temperamento dócil. Libera veneno fraco quando ameaçado para se proteger.', 0.4, 7.0, 8, NULL, 55, 47, 52, 40, 40, 41, 235, null, NULL, 'Pedra da Lua', NULL, 'https://pokeportuga.pt/img/jogos/sprites/hgss/029.png'),
('Nidoran♂', 'Pokémon Venenoso', 'Mais agressivo que a fêmea. Seus grandes chifres secretam um poderoso veneno.', 0.5, 9.0, 8, NULL, 46, 57, 40, 40, 40, 50, 235, 0.0, NULL, 'Pedra da Lua', NULL, 'https://pokeportuga.pt/img/jogos/sprites/hgss/032.png'),
('Zubat', 'Pokémon Morcego', 'Não tem olhos, então emite ondas ultrassônicas para navegar e caçar presas.', 0.8, 7.5, 8, 10, 40, 45, 35, 30, 40, 55, 255, 50.0, NULL, 'Amizade', 22, 'https://pokeportuga.pt/img/jogos/sprites/hgss/041.png'),
('Spinarak', 'Pokémon Aranha', 'Constrói uma teia fina, mas resistente. Fica imóvel, esperando por presas incautas.', 0.5, 8.5, 12, 8, 40, 60, 40, 40, 40, 30, 255, 50.0, NULL, 'Nível', 22, 'https://pokeportuga.pt/img/jogos/sprites/hgss/167.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Pokémon Psíquicos sem pré-evolução
('Abra', 'Pokémon Psíquico', 'Dorme 18 horas por dia. Mesmo dormindo, pode usar telepatia para escapar do perigo.', 0.9, 19.5, 11, NULL, 25, 20, 15, 105, 55, 90, 200, 75.0, NULL, 'Nível', 16, 'https://pokeportuga.pt/img/jogos/sprites/hgss/063.png'),
('Mr. Mime', 'Pokémon Barreira', 'Um mestre da pantomima. Suas barreiras invisíveis são na verdade paredes de ar comprimido.', 1.3, 54.5, 11, 18, 40, 45, 65, 100, 120, 90, 45, 50.0, NULL, NULL, NULL, 'https://pokeportuga.pt/img/jogos/sprites/frlg/122.png'),
('Eevee', 'Pokémon Evolução', 'Seu código genético irregular permite evoluir para várias formas quando exposto a estímulos.', 0.3, 6.5, 1, NULL, 55, 55, 50, 45, 65, 55, 45, 87.5, NULL, NULL, NULL, 'https://pokeportuga.pt/img/jogos/sprites/hgss/133.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Pokémon de Fogo sem pré-evolução
('Growlithe', 'Pokémon Cachorro', 'Muito protetor de seu território. Late e morde para afastar intrusos.', 0.7, 19.0, 2, NULL, 55, 70, 45, 70, 50, 60, 190, 75.0, NULL, 'Pedra Evolutiva', NULL, 'https://pokeportuga.pt/img/jogos/sprites/frlg/058.png'),
('Ponyta', 'Pokémon Cavalo de Fogo', 'Seus cascos são 10 vezes mais duros que diamante. Pode esmagar qualquer coisa ao galopar.', 1.0, 30.0, 2, NULL, 50, 85, 55, 65, 65, 90, 190, 50.0, NULL, 'Nível', 40, 'https://pokeportuga.pt/img/jogos/sprites/frlg/077.png'),
('Slugma', 'Pokémon Lava', 'Seu corpo é composto de magma. Se esfria, sua pele se solidifica e racha, liberando mais magma.', 0.7, 35.0, 2, NULL, 40, 40, 40, 70, 40, 20, 190, 50.0, NULL, 'Nível', 38, 'https://pokeportuga.pt/img/jogos/sprites/hgss/218.png'),
('Magmar', 'Pokémon Cuspe de Fogo', 'Nascido em um vulcão ativo. Seu corpo queima com chamas que atingem 1.100 graus Celsius.', 1.3, 44.5, 2, NULL, 65, 95, 57, 100, 85, 93, 45, 75.0, NULL, NULL, NULL, 'https://pokeportuga.pt/img/jogos/sprites/hgss/126.png');

-- Agora insira as evoluções (com preEvolucao)
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Evoluções de Geodude (assumindo que Geodude recebeu idPokemon = 1)
('Graveler', 'Pokémon Pedra', 'Rola pelas encostas das montanhas para se mover. Esmaga qualquer obstáculo no caminho.', 1.0, 105.0, 13, 9, 55, 95, 115, 45, 45, 35, 120, 50.0, 1, 'Level 25', 25, 'https://pokeportuga.pt/img/jogos/sprites/hgss/075.png'),
('Golem', 'Pokémon Megaton', 'Seu corpo é duro como pedra e pode suportar explosões de dinamite sem sofrer danos.', 1.4, 300.0, 13, 9, 80, 120, 130, 55, 65, 45, 45, 50.0, 2, 'Trade', NULL, 'https://pokeportuga.pt/img/jogos/sprites/hgss/076.png'),

-- Evolução de Onix (assumindo idPokemon = 3)
('Steelix', 'Pokémon Cobra de Ferro', 'Seu corpo foi comprimido sob o solo. É mais duro que diamante.', 9.2, 400.0, 17, 9, 75, 85, 200, 55, 65, 30, 25, 50.0, 3, 'Trade com Metal Coat', NULL, 'https://pokeportuga.pt/img/jogos/sprites/hgss/208.png'),

-- Evolução de Rhyhorn (assumindo idPokemon = 4)
('Rhydon', 'Pokémon Broca', 'Protegido por uma armadura, é capaz de viver em lava de 3.600 graus.', 1.9, 120.0, 9, 13, 105, 130, 120, 45, 45, 40, 60, 50.0, 4, 'Level 42', 42, 'https://pokeportuga.pt/img/jogos/sprites/hgss/112_m.png'),
('Rhyperior', 'Pokémon Broca', 'Pode disparar pedaços de rocha de seus buracos nas mãos como mísseis.', 2.4, 282.8, 9, 13, 115, 140, 130, 55, 55, 40, 30, 50.0, 5, 'Trade com Protector', NULL, 'https://pokeportuga.pt/img/jogos/sprites/hgss/464.png'),

-- Evolução de Omanyte (assumindo idPokemon = 6)
('Omastar', 'Pokémon Espiral', 'Um Pokémon pré-histórico que foi regenerado a partir de um fóssil. Usa tentáculos para capturar presas.', 1.0, 35.0, 3, 13, 70, 60, 125, 115, 70, 55, 45, 87.5, 6, 'Level 40', 40, 'https://pokeportuga.pt/img/jogos/sprites/hgss/139.png'),

-- Evolução de Kabuto (assumindo idPokemon = 7)
('Kabutops', 'Pokémon Cascudo', 'Seu corpo aerodinâmico permite que nade rapidamente. Corta presas com suas garras afiadas.', 1.3, 40.5, 3, 13, 60, 115, 105, 65, 70, 80, 45, 87.5, 7, 'Level 40', 40, 'https://pokeportuga.pt/img/jogos/sprites/hgss/141.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Evoluções elétricas (assumindo Pichu = 8, Voltorb = 9, Magnemite = 10, Elekid = 11)
('Pikachu', 'Pokémon Rato', 'Quando vários deles se reúnem, sua eletricidade pode construir e causar tempestades.', 0.4, 6.0, 4, NULL, 35, 55, 40, 50, 50, 90, 190, 50.0, 8, 'Amizade alta', NULL, 'https://pokeportuga.pt/img/jogos/sprites/frlg/025.png'),
('Raichu', 'Pokémon Rato', 'Sua cauda descarga eletricidade no ar, causando faíscas que podem incendiar florestas.', 0.8, 30.0, 4, NULL, 60, 90, 55, 90, 80, 110, 75, 50.0, 12, 'Pedra do Trovão', NULL, 'https://pokeportuga.pt/img/jogos/sprites/hgss/026_m.png'),
('Electrode', 'Pokémon Bola', 'Armazena energia elétrica em seu corpo. Explode em resposta a estímulos mínimos.', 1.2, 66.6, 4, NULL, 60, 50, 70, 80, 80, 150, 60, NULL, 9, 'Level 30', 30, 'https://pokeportuga.pt/img/jogos/sprites/hgss/101.png'),
('Magneton', 'Pokémon Ímã', 'Formado por três Magnemites unidos. Gera ondas de rádio que derrubam aparelhos eletrônicos.', 1.0, 60.0, 4, 17, 50, 60, 95, 120, 70, 70, 60, NULL, 10, 'Level 30', 30, 'https://pokeportuga.pt/img/jogos/sprites/hgss/082.png'),
('Magnezone', 'Pokémon Ímã', 'Controla campos magnéticos para flutuar. Evoluiu quando exposto a um campo magnético especial.', 1.2, 180.0, 4, 17, 70, 70, 115, 130, 90, 60, 30, NULL, 13, 'Trade com Metal Coat', NULL, 'https://pokeportuga.pt/img/jogos/sprites/hgss/462.png'),
('Electivire', 'Pokémon Trovão', 'Segura seus chifres para liberar eletricidade. Pode derrubar um edifício com uma descarga.', 1.8, 138.6, 4, NULL, 75, 123, 67, 95, 85, 95, 30, 75.0, 11, 'Trade com Electirizer', NULL, 'https://pokeportuga.pt/img/jogos/sprites/hgss/466.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Evoluções aquáticas (assumindo Staryu = 14, Psyduck = 15, Poliwag = 16)
('Starmie', 'Pokémon Misterioso', 'Dizem que seu núcleo brilha com as sete cores do arco-íris.', 1.1, 80.0, 3, 11, 60, 75, 85, 100, 85, 115, 60, NULL, 14, 'Pedra da Água', NULL, 'https://pokeportuga.pt/img/jogos/sprites/frlg/121.png'),
('Golduck', 'Pokémon Pato', 'Nadador habilidoso, frequentemente visto em rios e lagos. Conhecido por seus poderes psíquicos.', 1.7, 76.6, 3, NULL, 80, 82, 78, 95, 80, 85, 75, 50.0, 15, 'Level 33', 33, 'https://pokeportuga.pt/img/jogos/sprites/hgss/055.png'),
('Poliwhirl', 'Pokémon Girino', 'Capaz de viver dentro ou fora da água. Quando fora, sua pele permanece úmida com suor.', 1.0, 20.0, 3, NULL, 65, 65, 65, 50, 50, 90, 120, 50.0, 16, 'Level 25', 25, 'https://pokeportuga.pt/img/jogos/sprites/hgss/061.png'),
('Poliwrath', 'Pokémon Girino', 'Nadador especialista. Usa todos os seus músculos para golpes poderosos.', 1.3, 54.0, 3, 7, 90, 95, 95, 70, 90, 70, 45, 50.0, 22, 'Pedra da Água', NULL, 'https://pokeportuga.pt/img/jogos/sprites/hgss/062.png'),
('Politoed', 'Pokémon Sapo', 'Quando Poliwag evolui, o redemoinho em sua barriga se transforma em padrões elegantes.', 1.1, 33.9, 3, NULL, 90, 75, 75, 90, 100, 70, 45, 50.0, 22, 'Trade com King\'s Rock', NULL, 'https://pokeportuga.pt/img/jogos/sprites/hgss/186.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Evoluções de planta (assumindo Oddish = 17, Bellsprout = 18, Exeggcute = 19, Hoppip = 20)
('Gloom', 'Pokémon Erva Daninha', 'Secreta um néctar fedorento da boca. O odor pode causar desmaios a 2 km de distância.', 0.8, 8.6, 5, 8, 60, 65, 70, 85, 75, 40, 120, 50.0, 17, 'Level 21', 21, 'https://pokeportuga.pt/img/jogos/sprites/hgss/044.png'),
('Vileplume', 'Pokémon Flor', 'Tem as maiores pétalas do mundo. Com cada passo, espalha pólen altamente alergênico.', 1.2, 18.6, 5, 8, 75, 80, 85, 110, 90, 50, 45, 50.0, 23, 'Pedra Evolutiva', NULL, 'https://pokeportuga.pt/img/jogos/sprites/frlg/045.png'),
('Bellossom', 'Pokémon Flor', 'Quando dança, suas pétalas se esfregam e emitem um som agradável e relaxante.', 0.4, 5.8, 5, NULL, 75, 80, 95, 90, 100, 50, 45, 50.0, 23, 'Pedra do Sol', NULL, 'https://pokeportuga.pt/img/jogos/sprites/hgss/182.png'),
('Weepinbell', 'Pokémon Planta Carnívora', 'Cospe ácido poderoso que derrete até ferro. Usa ganchos para se prender em árvores.', 1.0, 6.4, 5, 8, 65, 90, 50, 85, 45, 55, 120, 50.0, 18, 'Level 21', 21, 'https://pokeportuga.pt/img/jogos/sprites/hgss/070.png'),
('Victreebel', 'Pokémon Planta Carnívora', 'Atrai a presa com um aroma doce de mel. Dissolve a vítima em seu interior em apenas um dia.', 1.7, 15.5, 5, 8, 80, 105, 65, 100, 70, 70, 45, 50.0, 25, 'Pedra Evolutiva', NULL, 'https://pokeportuga.pt/img/jogos/sprites/hgss/071.png'),
('Exeggutor', 'Pokémon Coco', 'Dizem que quando uma cabeça cresce muito grande, ela cai e se torna um Exeggcute.', 2.0, 120.0, 5, 11, 95, 95, 85, 125, 75, 55, 45, 50.0, 19, 'Pedra Evolutiva', NULL, 'https://pokeportuga.pt/img/jogos/sprites/hgss/103.png'),
('Skiploom', 'Pokémon Algodão', 'Flutua no ar para ajustar sua temperatura corporal. Abre sua flor em temperaturas acima de 18°C.', 0.6, 1.0, 5, 10, 55, 45, 50, 45, 65, 80, 120, 50.0, 20, 'Level 18', 18, 'https://pokeportuga.pt/img/jogos/sprites/hgss/188.png'),
('Jumpluff', 'Pokémon Algodão', 'Flutua com o vento para viajar. Pode controlar sua direção ajustando as pétalas.', 0.8, 3.0, 5, 10, 75, 55, 70, 55, 95, 110, 45, 50.0, 28, 'Level 27', 27, 'https://pokeportuga.pt/img/jogos/sprites/hgss/189.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Evoluções venenosas (assumindo Koffing = 21, Grimer = 22, Nidoran♀ = 23, Nidoran♂ = 24, Zubat = 25, Spinarak = 26)
('Weezing', 'Pokémon Gás Venenoso', 'Raramente visto na natureza. Dois Koffings podem se fundir para formar um Weezing.', 1.2, 9.5, 8, NULL, 65, 90, 120, 85, 70, 60, 60, 50.0, 21, 'Level 35', 35, 'https://pokeportuga.pt/img/jogos/sprites/hgss/110.png'),
('Muk', 'Pokémon Lodo', 'Deixa um rastro fedorento atrás de si. A grama não cresce no local por um ano.', 1.2, 30.0, 8, NULL, 105, 105, 75, 65, 100, 50, 75, 50.0, 22, 'Level 38', 38, 'https://pokeportuga.pt/img/jogos/sprites/frlg/089.png'),
('Nidorina', 'Pokémon Venenoso', 'O chifre feminino se desenvolve lentamente. Prefere ataques físicos como arranhões e mordidas.', 0.8, 20.0, 8, NULL, 70, 62, 67, 55, 55, 56, 120, null, 23, 'Level 16', 16, 'https://pokeportuga.pt/img/jogos/sprites/hgss/030.png'),
('Nidoqueen', 'Pokémon Broca', 'Seu corpo é coberto por escamas duras. Protege ferozmente seus filhotes.', 1.3, 60.0, 8, 9, 90, 92, 87, 75, 85, 76, 45, 0.0, 29, 'Pedra da Lua', NULL, 'https://pokeportuga.pt/img/jogos/sprites/frlg/031.png'),
('Nidorino', 'Pokémon Venenoso', 'Tem um temperamento violento. Quando ataca, seu chifre secreta um veneno poderoso.', 0.9, 19.5, 8, NULL, 61, 72, 57, 55, 55, 65, 120, 0.0, 24, 'Level 16', 16, 'https://pokeportuga.pt/img/jogos/sprites/hgss/033.png'),
('Nidoking', 'Pokémon Broca', 'Usa seu rabo poderoso para esmagar o inimigo. Quebra até diamante com facilidade.', 1.4, 62.0, 8, 9, 81, 102, 77, 85, 75, 85, 45, null, 31, 'Pedra da Lua', NULL, 'https://pokeportuga.pt/img/jogos/sprites/frlg/034.png'),
('Golbat', 'Pokémon Morcego', 'Drena o sangue de presas vivas com seus dentes afiados como agulhas. Bebe até ficar satisfeito.', 1.6, 55.0, 8, 10, 75, 80, 70, 65, 75, 90, 90, 50.0, 25, 'Amizade', 22, 'https://pokeportuga.pt/img/jogos/sprites/hgss/042.png'),
('Crobat', 'Pokémon Morcego', 'Voam silenciosamente à noite, usando ondas ultrassônicas para identificar presas.', 1.8, 75.0, 8, 10, 85, 90, 80, 70, 80, 130, 90, 50.0, 32, 'Amizade', NULL, 'https://pokeportuga.pt/img/jogos/sprites/hgss/169.png'),
('Ariados', 'Pokémon Aranha', 'Tece teias com fios finos, mas resistentes, que podem deter até aves em voo.', 1.1, 33.5, 12, 8, 70, 90, 70, 60, 70, 40, 90, 50.0, 26, 'Level 22', 22, 'https://pokeportuga.pt/img/jogos/sprites/hgss/168.png');


select * from pokemon;
