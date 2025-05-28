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
    dataFavoritado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (idUsuario, idTipoPokemon),
    FOREIGN KEY (idUsuario) REFERENCES usuario(idUsuario),
    FOREIGN KEY (idTipoPokemon) REFERENCES tipoPokemon(idTipoPokemon)
);

-- Tabela de líderes de ginásio
CREATE TABLE liderGinasio (
    idLider INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nomeLider VARCHAR(45) NOT NULL,
    imagemUrl VARCHAR(255),
    cidade VARCHAR(45) NOT NULL,
    idRegiao INT NOT NULL,
    FOREIGN KEY (idRegiao) REFERENCES regiao(idRegiao)
);


-- Tabela de times
CREATE TABLE timePokemon (
    idTimePokemon INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    idUsuario INT,
    idLider INT,
    nomeTime VARCHAR(45) NOT NULL,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idUsuario) REFERENCES usuario(idUsuario),
    FOREIGN KEY (idLider) REFERENCES liderGinasio(idLider)
);

-- Tabela de membros do time
CREATE TABLE timePokemon_membros (
    idTimePokemon INT NOT NULL,
    idPokemon INT NOT NULL,
    posicao_no_time TINYINT NOT NULL, -- Posição 1-6 no time
    PRIMARY KEY (idTimePokemon, posicao_no_time), -- Garante que cada posição no time seja única
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

select * from tipoPokemon;

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
(8, 'Galar'),
(9, 'Paldea');

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
('Geodude', 'Pokémon Pedra', 'Encontrado em campos e montanhas. Gosta de rolar em trilhas montanhosas.', 0.4, 20.0, 13, 9, 40, 80, 100, 30, 30, 20, 255, 50.0, NULL, 'Level 25', 25, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/074.png'),
('Onix', 'Pokémon Cobra de Pedra', 'Escava o solo a 80 km/h e deixa um túnel característico para trás.', 8.8, 210.0, 13, 9, 35, 45, 160, 30, 45, 70, 45, 50.0, NULL, 'Trade com Metal Coat', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/095.png'),
('Rhyhorn', 'Pokémon Espinhoso', 'Seu cérebro é pequeno, mas sua força é enorme. Destrói edifícios sem perceber.', 1.0, 115.0, 9, 13, 80, 85, 95, 30, 30, 25, 120, 50.0, NULL, 'Level 42', 42, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/111.png'),
('Omanyte', 'Pokémon Espiral', 'Um Pokémon pré-histórico que foi regenerado a partir de um fóssil.', 0.4, 7.5, 3, 13, 35, 40, 100, 90, 55, 35, 45, 87.5, NULL, 'Level 40', 40, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/138.png'),
('Kabuto', 'Pokémon Cascudo', 'Um Pokémon fóssil que foi regenerado. Viveu no fundo do mar há 300 milhões de anos.', 0.5, 11.5, 3, 13, 30, 80, 90, 55, 45, 55, 45, 87.5, NULL, 'Level 40', 40, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/140.png'),
('Aerodactyl', 'Pokémon Fóssil', 'Um Pokémon feroz e pré-histórico que ataca com mandíbulas serrilhadas.', 1.8, 59.0, 13, 10, 80, 105, 65, 60, 75, 130, 45, 87.5, NULL, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/142.png'),
('Diglett', 'Pokémon Toupeira', 'Vive cerca de um metro abaixo do solo. Alimenta-se de raízes e aparece raramente na superfície.', 0.2, 0.8, 9, NULL, 10, 55, 25, 35, 45, 95, 255, 50.0, NULL, 'Nível', 26, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/050.png');


INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Pokémon Elétricos sem pré-evolução
('Pichu', 'Pokémon Ratinho', 'Ainda não consegue armazenar eletricidade. Frequentemente se choca acidentalmente.', 0.3, 2.0, 4, NULL, 20, 40, 15, 35, 35, 60, 190, 50.0, NULL, 'Amizade alta', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/172.png'),
('Voltorb', 'Pokémon Bola', 'Muito semelhante a uma Pokébola. Já causou muitos acidentes por causa disso.', 0.5, 10.4, 4, NULL, 40, 30, 50, 55, 55, 100, 190, NULL, NULL, 'Level 30', 30, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/100.png'),
('Magnemite', 'Pokémon Ímã', 'Usa eletricidade para se mover. Frequentemente encontrado perto de usinas de energia.', 0.3, 6.0, 4, 17, 25, 35, 70, 95, 55, 45, 190, NULL, NULL, 'Level 30', 30, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/081.png'),
('Electabuzz', 'Pokémon Elétrico', 'Armazena eletricidade em seu corpo. Frequentemente encontrado perto de usinas.', 1.1, 30.0, 4, NULL, 65, 83, 57, 95, 85, 105, 45, 75.0, NULL, 'Trade com Electirizer', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/125.png'),
('Elekid', 'Pokémon Elétrico', 'Gira os braços para gerar eletricidade, mas frequentemente se cansa rapidamente.', 0.6, 23.5, 4, NULL, 45, 63, 37, 65, 55, 95, 45, 75.0, NULL, 'Level 30', 30, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/239.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Pokémon Aquáticos sem pré-evolução
('Staryu', 'Pokémon Estrela', 'No centro de seu corpo está um olho vermelho que brilha misteriosamente.', 0.8, 34.5, 3, NULL, 30, 45, 55, 70, 55, 85, 225, NULL, NULL, 'Pedra da Água', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/120.png'),
('Psyduck', 'Pokémon Pato', 'Sofre constantemente de dores de cabeça. Quando a dor piora, usa poderes psíquicos.', 0.8, 19.6, 3, NULL, 50, 52, 48, 65, 50, 55, 190, 50.0, NULL, 'Level 33', 33, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/054.png'),
('Poliwag', 'Pokémon Girino', 'Suas pernas recém-nascidas não podem suportar seu peso. Apenas nada em padrões espirais.', 0.6, 12.4, 3, NULL, 40, 50, 40, 40, 40, 90, 255, 50.0, NULL, 'Level 25', 25, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/060.png'),
('Magikarp', 'Pokémon Peixe', 'Um Pokémon patético que só sabe se debater. Em todo o mundo, é símbolo de fraqueza.', 0.9, 10.0, 11, NULL, 20, 10, 55, 15, 20, 80, 255, 50.0, NULL, 'Level 20', 20, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/129.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Pokémon de Planta sem pré-evolução
('Tangela', 'Pokémon Vinha', 'Seu corpo é coberto por vinhas semelhantes a algas. Elas balançam quando se move.', 1.0, 35.0, 5, NULL, 65, 55, 115, 100, 40, 60, 45, 50.0, NULL, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/114.png'),
('Exeggcute', 'Pokémon Ovo', 'Seis ovos formam um grupo que se comunica telepaticamente. Pode se fundir com outros grupos.', 0.4, 2.5, 5, 11, 60, 40, 80, 60, 45, 40, 90, 50.0, NULL, 'Pedra Evolutiva', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/102.png'),
('Oddish', 'Pokémon Erva Daninha', 'Durante o dia, fica enterrado no solo. À noite, vagueia para espalhar suas sementes.', 0.5, 5.4, 5, 8, 45, 50, 55, 75, 65, 30, 255, 50.0, NULL, 'Level 21', 21, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/043.png'),
('Bellsprout', 'Pokémon Flor', 'Prefere locais quentes e úmidos. Captura pequenos insetos com suas folhas em forma de concha.', 0.7, 4.0, 5, 8, 50, 75, 35, 70, 30, 40, 255, 50.0, NULL, 'Level 21', 21, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/069.png'),
('Hoppip', 'Pokémon Algodão', 'Flutua no vento para evitar ataques terrestres. Pode viajar milhas se pego por uma forte corrente de ar.', 0.4, 0.5, 5, 10, 35, 35, 40, 35, 55, 50, 255, 50.0, NULL, 'Level 18', 18, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/187.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Pokémon Venenosos sem pré-evolução
('Koffing', 'Pokémon Gás Venenoso', 'Como seu corpo está cheio de gases venenosos, ele balança enquanto voa.', 0.6, 1.0, 8, NULL, 40, 65, 95, 60, 45, 35, 190, 50.0, NULL, 'Nível', 35, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/109.png'),
('Grimer', 'Pokémon Lodo', 'Feito de lixo tóxico que se reuniu em esgotos. Pode derreter qualquer coisa com seu corpo ácido.', 0.9, 30.0, 8, NULL, 80, 80, 50, 40, 50, 25, 190, 50.0, NULL, 'Nível', 38, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/088.png'),
('Nidoran♀', 'Pokémon Venenoso', 'Tem um temperamento dócil. Libera veneno fraco quando ameaçado para se proteger.', 0.4, 7.0, 8, NULL, 55, 47, 52, 40, 40, 41, 235, null, NULL, 'Pedra da Lua', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/029.png'),
('Nidoran♂', 'Pokémon Venenoso', 'Mais agressivo que a fêmea. Seus grandes chifres secretam um poderoso veneno.', 0.5, 9.0, 8, NULL, 46, 57, 40, 40, 40, 50, 235, 0.0, NULL, 'Pedra da Lua', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/032.png'),
('Zubat', 'Pokémon Morcego', 'Não tem olhos, então emite ondas ultrassônicas para navegar e caçar presas.', 0.8, 7.5, 8, 10, 40, 45, 35, 30, 40, 55, 255, 50.0, NULL, 'Amizade', 22, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/041.png'),
('Spinarak', 'Pokémon Aranha', 'Constrói uma teia fina, mas resistente. Fica imóvel, esperando por presas incautas.', 0.5, 8.5, 12, 8, 40, 60, 40, 40, 40, 30, 255, 50.0, NULL, 'Nível', 22, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/167.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Pokémon Psíquicos sem pré-evolução
('Abra', 'Pokémon Psíquico', 'Dorme 18 horas por dia. Mesmo dormindo, pode usar telepatia para escapar do perigo.', 0.9, 19.5, 11, NULL, 25, 20, 15, 105, 55, 90, 200, 75.0, NULL, 'Nível', 16, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/063.png'),
('Mr. Mime', 'Pokémon Barreira', 'Um mestre da pantomima. Suas barreiras invisíveis são na verdade paredes de ar comprimido.', 1.3, 54.5, 11, 18, 40, 45, 65, 100, 120, 90, 45, 50.0, NULL, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/122.png'),
('Eevee', 'Pokémon Evolução', 'Seu código genético irregular permite evoluir para várias formas quando exposto a estímulos.', 0.3, 6.5, 1, NULL, 55, 55, 50, 45, 65, 55, 45, 87.5, NULL, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/133.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Pokémon de Fogo sem pré-evolução
('Growlithe', 'Pokémon Cachorro', 'Muito protetor de seu território. Late e morde para afastar intrusos.', 0.7, 19.0, 2, NULL, 55, 70, 45, 70, 50, 60, 190, 75.0, NULL, 'Pedra Evolutiva', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/058.png'),
('Ponyta', 'Pokémon Cavalo de Fogo', 'Seus cascos são 10 vezes mais duros que diamante. Pode esmagar qualquer coisa ao galopar.', 1.0, 30.0, 2, NULL, 50, 85, 55, 65, 65, 90, 190, 50.0, NULL, 'Nível', 40, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/077.png'),
('Slugma', 'Pokémon Lava', 'Seu corpo é composto de magma. Se esfria, sua pele se solidifica e racha, liberando mais magma.', 0.7, 35.0, 2, NULL, 40, 40, 40, 70, 40, 20, 190, 50.0, NULL, 'Nível', 38, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/218.png'),
('Magmar', 'Pokémon Cuspe de Fogo', 'Nascido em um vulcão ativo. Seu corpo queima com chamas que atingem 1.100 graus Celsius.', 1.3, 44.5, 2, NULL, 65, 95, 57, 100, 85, 93, 45, 75.0, NULL, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/126.png');

-- Agora insira as evoluções (com preEvolucao)
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Evoluções de Geodude (assumindo que Geodude recebeu idPokemon = 1)
('Graveler', 'Pokémon Pedra', 'Rola pelas encostas das montanhas para se mover. Esmaga qualquer obstáculo no caminho.', 1.0, 105.0, 13, 9, 55, 95, 115, 45, 45, 35, 120, 50.0, 1, 'Level 25', 25, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/075.png'),
('Golem', 'Pokémon Megaton', 'Seu corpo é duro como pedra e pode suportar explosões de dinamite sem sofrer danos.', 1.4, 300.0, 13, 9, 80, 120, 130, 55, 65, 45, 45, 50.0, 2, 'Trade', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/076.png'),

-- Evolução de Onix (assumindo idPokemon = 3)
('Steelix', 'Pokémon Cobra de Ferro', 'Seu corpo foi comprimido sob o solo. É mais duro que diamante.', 9.2, 400.0, 17, 9, 75, 85, 200, 55, 65, 30, 25, 50.0, 3, 'Trade com Metal Coat', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/208.png'),

-- Evolução de Rhyhorn (assumindo idPokemon = 4)
('Rhydon', 'Pokémon Broca', 'Protegido por uma armadura, é capaz de viver em lava de 3.600 graus.', 1.9, 120.0, 9, 13, 105, 130, 120, 45, 45, 40, 60, 50.0, 4, 'Level 42', 42, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/112.png'),
('Rhyperior', 'Pokémon Broca', 'Pode disparar pedaços de rocha de seus buracos nas mãos como mísseis.', 2.4, 282.8, 9, 13, 115, 140, 130, 55, 55, 40, 30, 50.0, 5, 'Trade com Protector', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/464.png'),

-- Evolução de Omanyte (assumindo idPokemon = 6)
('Omastar', 'Pokémon Espiral', 'Um Pokémon pré-histórico que foi regenerado a partir de um fóssil. Usa tentáculos para capturar presas.', 1.0, 35.0, 3, 13, 70, 60, 125, 115, 70, 55, 45, 87.5, 6, 'Level 40', 40, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/139.png'),

-- Evolução de Kabuto (assumindo idPokemon = 7)
('Kabutops', 'Pokémon Cascudo', 'Seu corpo aerodinâmico permite que nade rapidamente. Corta presas com suas garras afiadas.', 1.3, 40.5, 3, 13, 60, 115, 105, 65, 70, 80, 45, 87.5, 7, 'Level 40', 40, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/141.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Evoluções elétricas (assumindo Pichu = 8, Voltorb = 9, Magnemite = 10, Elekid = 11)
('Pikachu', 'Pokémon Rato', 'Quando vários deles se reúnem, sua eletricidade pode construir e causar tempestades.', 0.4, 6.0, 4, NULL, 35, 55, 40, 50, 50, 90, 190, 50.0, 8, 'Amizade alta', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/025.png'),
('Raichu', 'Pokémon Rato', 'Sua cauda descarga eletricidade no ar, causando faíscas que podem incendiar florestas.', 0.8, 30.0, 4, NULL, 60, 90, 55, 90, 80, 110, 75, 50.0, 12, 'Pedra do Trovão', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/026.png'),
('Electrode', 'Pokémon Bola', 'Armazena energia elétrica em seu corpo. Explode em resposta a estímulos mínimos.', 1.2, 66.6, 4, NULL, 60, 50, 70, 80, 80, 150, 60, NULL, 9, 'Level 30', 30, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/101.png'),
('Magneton', 'Pokémon Ímã', 'Formado por três Magnemites unidos. Gera ondas de rádio que derrubam aparelhos eletrônicos.', 1.0, 60.0, 4, 17, 50, 60, 95, 120, 70, 70, 60, NULL, 10, 'Level 30', 30, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/082.png'),
('Magnezone', 'Pokémon Ímã', 'Controla campos magnéticos para flutuar. Evoluiu quando exposto a um campo magnético especial.', 1.2, 180.0, 4, 17, 70, 70, 115, 130, 90, 60, 30, NULL, 13, 'Trade com Metal Coat', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/462.png'),
('Electivire', 'Pokémon Trovão', 'Segura seus chifres para liberar eletricidade. Pode derrubar um edifício com uma descarga.', 1.8, 138.6, 4, NULL, 75, 123, 67, 95, 85, 95, 30, 75.0, 11, 'Trade com Electirizer', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/466.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Evoluções aquáticas (assumindo Staryu = 14, Psyduck = 15, Poliwag = 16)
('Starmie', 'Pokémon Misterioso', 'Dizem que seu núcleo brilha com as sete cores do arco-íris.', 1.1, 80.0, 3, 11, 60, 75, 85, 100, 85, 115, 60, NULL, 14, 'Pedra da Água', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/121.png'),
('Golduck', 'Pokémon Pato', 'Nadador habilidoso, frequentemente visto em rios e lagos. Conhecido por seus poderes psíquicos.', 1.7, 76.6, 3, NULL, 80, 82, 78, 95, 80, 85, 75, 50.0, 15, 'Level 33', 33, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/055.png'),
('Poliwhirl', 'Pokémon Girino', 'Capaz de viver dentro ou fora da água. Quando fora, sua pele permanece úmida com suor.', 1.0, 20.0, 3, NULL, 65, 65, 65, 50, 50, 90, 120, 50.0, 16, 'Level 25', 25, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/061.png'),
('Poliwrath', 'Pokémon Girino', 'Nadador especialista. Usa todos os seus músculos para golpes poderosos.', 1.3, 54.0, 3, 7, 90, 95, 95, 70, 90, 70, 45, 50.0, 22, 'Pedra da Água', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/062.png'),
('Politoed', 'Pokémon Sapo', 'Quando Poliwag evolui, o redemoinho em sua barriga se transforma em padrões elegantes.', 1.1, 33.9, 3, NULL, 90, 75, 75, 90, 100, 70, 45, 50.0, 22, 'Trade com King\s Rock', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/186.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Evoluções de planta (assumindo Oddish = 17, Bellsprout = 18, Exeggcute = 19, Hoppip = 20)
('Gloom', 'Pokémon Erva Daninha', 'Secreta um néctar fedorento da boca. O odor pode causar desmaios a 2 km de distância.', 0.8, 8.6, 5, 8, 60, 65, 70, 85, 75, 40, 120, 50.0, 17, 'Level 21', 21, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/044.png'),
('Vileplume', 'Pokémon Flor', 'Tem as maiores pétalas do mundo. Com cada passo, espalha pólen altamente alergênico.', 1.2, 18.6, 5, 8, 75, 80, 85, 110, 90, 50, 45, 50.0, 23, 'Pedra Evolutiva', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/045.png'),
('Bellossom', 'Pokémon Flor', 'Quando dança, suas pétalas se esfregam e emitem um som agradável e relaxante.', 0.4, 5.8, 5, NULL, 75, 80, 95, 90, 100, 50, 45, 50.0, 23, 'Pedra do Sol', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/182.png'),
('Weepinbell', 'Pokémon Planta Carnívora', 'Cospe ácido poderoso que derrete até ferro. Usa ganchos para se prender em árvores.', 1.0, 6.4, 5, 8, 65, 90, 50, 85, 45, 55, 120, 50.0, 18, 'Level 21', 21, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/070.png'),
('Victreebel', 'Pokémon Planta Carnívora', 'Atrai a presa com um aroma doce de mel. Dissolve a vítima em seu interior em apenas um dia.', 1.7, 15.5, 5, 8, 80, 105, 65, 100, 70, 70, 45, 50.0, 25, 'Pedra Evolutiva', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/071.png'),
('Exeggutor', 'Pokémon Coco', 'Dizem que quando uma cabeça cresce muito grande, ela cai e se torna um Exeggcute.', 2.0, 120.0, 5, 11, 95, 95, 85, 125, 75, 55, 45, 50.0, 19, 'Pedra Evolutiva', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/103.png'),
('Skiploom', 'Pokémon Algodão', 'Flutua no ar para ajustar sua temperatura corporal. Abre sua flor em temperaturas acima de 18°C.', 0.6, 1.0, 5, 10, 55, 45, 50, 45, 65, 80, 120, 50.0, 20, 'Level 18', 18, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/188.png'),
('Jumpluff', 'Pokémon Algodão', 'Flutua com o vento para viajar. Pode controlar sua direção ajustando as pétalas.', 0.8, 3.0, 5, 10, 75, 55, 70, 55, 95, 110, 45, 50.0, 28, 'Level 27', 27, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/189.png');


INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Evoluções venenosas (assumindo Koffing = 21, Grimer = 22, Nidoran♀ = 23, Nidoran♂ = 24, Zubat = 25, Spinarak = 26)
('Weezing', 'Pokémon Gás Venenoso', 'Raramente visto na natureza. Dois Koffings podem se fundir para formar um Weezing.', 1.2, 9.5, 8, NULL, 65, 90, 120, 85, 70, 60, 60, 50.0, 21, 'Level 35', 35, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/110.png'),
('Muk', 'Pokémon Lodo', 'Deixa um rastro fedorento atrás de si. A grama não cresce no local por um ano.', 1.2, 30.0, 8, NULL, 105, 105, 75, 65, 100, 50, 75, 50.0, 22, 'Level 38', 38, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/089.png'),
('Nidorina', 'Pokémon Venenoso', 'O chifre feminino se desenvolve lentamente. Prefere ataques físicos como arranhões e mordidas.', 0.8, 20.0, 8, NULL, 70, 62, 67, 55, 55, 56, 120, null, 23, 'Level 16', 16, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/030.png'),
('Nidoqueen', 'Pokémon Broca', 'Seu corpo é coberto por escamas duras. Protege ferozmente seus filhotes.', 1.3, 60.0, 8, 9, 90, 92, 87, 75, 85, 76, 45, 0.0, 29, 'Pedra da Lua', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/031.png'),
('Nidorino', 'Pokémon Venenoso', 'Tem um temperamento violento. Quando ataca, seu chifre secreta um veneno poderoso.', 0.9, 19.5, 8, NULL, 61, 72, 57, 55, 55, 65, 120, 0.0, 24, 'Level 16', 16, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/033.png'),
('Nidoking', 'Pokémon Broca', 'Usa seu rabo poderoso para esmagar o inimigo. Quebra até diamante com facilidade.', 1.4, 62.0, 8, 9, 81, 102, 77, 85, 75, 85, 45, null, 31, 'Pedra da Lua', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/034.png'),
('Golbat', 'Pokémon Morcego', 'Drena o sangue de presas vivas com seus dentes afiados como agulhas. Bebe até ficar satisfeito.', 1.6, 55.0, 8, 10, 75, 80, 70, 65, 75, 90, 90, 50.0, 25, 'Amizade', 22, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/042.png'),
('Crobat', 'Pokémon Morcego', 'Voam silenciosamente à noite, usando ondas ultrassônicas para identificar presas.', 1.8, 75.0, 8, 10, 85, 90, 80, 70, 80, 130, 90, 50.0, 32, 'Amizade', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/169.png'),
('Ariados', 'Pokémon Aranha', 'Tece teias com fios finos, mas resistentes, que podem deter até aves em voo.', 1.1, 33.5, 12, 8, 70, 90, 70, 60, 70, 40, 90, 50.0, 26, 'Level 22', 22, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/168.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Pokémon Psíquicos
('Kadabra', 'Pokémon Psíquico', 'Dorme enquanto flutua no ar. Seu rabo está conectado a dimensões alternativas.', 1.3, 56.5, 11, NULL, 40, 35, 30, 120, 70, 105, 100, 75.0, 27, 'Troca', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/064.png'),
('Alakazam', 'Pokémon Psíquico', 'Seu cérebro superdesenvolvido pode realizar cálculos como um supercomputador.', 1.5, 48.0, 11, NULL, 55, 50, 45, 135, 95, 120, 50, 75.0, 69, 'Troca', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/065.png'),
('Mr. Mime', 'Pokémon Barreira', 'Um mestre da pantomima. Suas barreiras invisíveis são na verdade paredes de ar comprimido.', 1.3, 54.5, 11, 18, 40, 45, 65, 100, 120, 90, 45, 50.0, NULL, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/122.png'),
('Espeon', 'Pokémon Sol', 'Usa seus poderes psíquicos para prever os movimentos do inimigo e o clima.', 0.9, 26.5, 11, NULL, 65, 65, 60, 130, 95, 110, 45, 12.5, 29, 'Amizade (Dia)', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/196.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Pokémon de Fogo
('Arcanine', 'Pokémon Lendário', 'Um Pokémon lendário na China. Corre elegantemente com passos graciosos.', 1.9, 155.0, 2, NULL, 90, 110, 80, 100, 80, 95, 75, 75.0, 30, 'Pedra Evolutiva', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/059.png'),
('Rapidash', 'Pokémon Cavalo de Fogo', 'Adora correr. Se vir algo mais rápido que ele, perseguirá em velocidade máxima.', 1.7, 95.0, 2, NULL, 65, 100, 70, 80, 80, 105, 60, 50.0, 31, 'Nível', 40, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/078.png'),
('Magcargo', 'Pokémon Lava', 'Seu corpo é tão quente que a chuva evapora ao tocar nele. Vive em crateras vulcânicas.', 0.8, 55.0, 2, 9, 60, 50, 120, 90, 80, 30, 75, 50.0, 33, 'Nível', 38, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/219.png');

-- JOHTO

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Pokémon voador/normal sem pré-evolução
('Pidgey', 'Pokémon passaro pequeno', 'Geralmente se esconde na grama alta. Como não gosta de brigas, se protege chutando areia.', 0.3, 1.8, 1, 10, 40, 45, 40, 35, 35, 56, 255, 50.0, NULL, 'Level 18', 18, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/016.png'),
('Cleffa', 'Pokémon estrela', 'Sua pele é extremamente sensível. Dizem que sente até as mais leves brisas noturnas que sopram da lua.', 0.3, 3.0, 18, NULL, 50, 25, 28, 45, 55, 15, 150, 25.0, NULL, 'Amizade + Level up à noite', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/173.png'),
('Miltank', 'Pokémon Vaca Leiteira', 'Produz um leite nutritivo e delicioso. Sua bebida favorita é o leite de Moomoo.', 1.2, 75.5, 1, NULL, 95, 80, 105, 40, 70, 100, 45, 0.0, NULL, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/241.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES

-- Pokémon dragão sem pré-evolução
('Dratini', 'Pokémon Dragão', 'Raro e difícil de encontrar. Troca de pele continuamente enquanto cresce.', 1.8, 3.3, 15, NULL, 41, 64, 45, 50, 50, 50, 45, 50.0, NULL, 'Level 30', 30, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/147.png'),
('Horsea', 'Pokémon Dragão', 'Se esconde em corais e dispara jatos de tinta na cara de predadores para fugir.', 0.4, 8.0, 3, 15, 30, 40, 70, 70, 25, 60, 225, 50.0, NULL, 'Level 32', 32, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/116.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Pokémon inseto/voador sem pré-evolução
('Weedle', 'Pokémon Lagarta Venenosa', 'Possui um ferrão venenoso na cabeça. Usa-o para se defender enquanto se esconde em árvores.', 0.3, 3.2, 7, 4, 40, 35, 30, 20, 20, 50, 255, 50.0, NULL, 'Level 7', 7, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/013.png'),
('Scyther', 'Pokémon Louva-a-Deus', 'Move-se tão rápido que parece invisível. Suas garras afiadas cortam qualquer coisa como uma lâmina.', 1.5, 56.0, 7, 3, 70, 110, 80, 55, 80, 105, 45, 50.0, NULL, 'Troca com Metal Coat', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/123.png'),
('Caterpie', 'Pokémon Lagarta', 'Se alimenta avidamente de folhas. Seu corpo libera um líquido fedorento para se proteger de predadores.', 0.3, 2.9, 7, NULL, 45, 30, 35, 20, 20, 45, 255, 50.0, NULL, 'Level 7', 7, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/010.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Pokémon fantasma sem pré-evolução
('Gastly', 'Pokémon Gasoso', 'Feito quase inteiramente de gás venenoso. Pode sufocar inimigos envolvendo-os com seu corpo gasoso.', 1.3, 0.1, 8, 4, 30, 35, 30, 100, 35, 80, 190, 50.0, NULL, 'Level 25', 25, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/092.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Pokémon lutador sem pré-evolução
('Mankey', 'Pokémon Porco Macaco', 'Extremamente irritável. Fica furioso com nada e ataca qualquer coisa que se mova.', 0.5, 28.0, 2, NULL, 40, 80, 35, 35, 45, 70, 190, 50.0, NULL, 'Level 28', 28, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/056.png');


INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Pokémon gelo sem pré-evolução
('Swinub', 'Pokémon Porco', 'Fareja cogumelos sob a neve com seu focinho sensível. Adora banhos de lama.', 0.4, 6.5, 6, 9, 50, 50, 40, 30, 30, 50, 225, 50.0, NULL, 'Level 33', 33, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/220.png'),
('Seel', 'Pokémon Foca', 'Adora águas geladas. Nada alegremente em temperaturas de -10°C, protegido por sua gordura corporal.', 1.1, 90.0, 3, NULL, 65, 45, 55, 45, 70, 45, 190, 50.0, NULL, 'Level 34', 34, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/086.png');


INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- EVOLUÇÕES
('Pidgeotto', 'Pokémon Pássaro', 'Protege ferozmente seu território. Ataca com garras afiadas qualquer intruso.', 1.1, 30.0, 1, 10, 63, 60, 55, 50, 50, 71, 120, 50.0, 77, 'Level 36', 36, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/017.png'),
('Pidgeot', 'Pokémon Pássaro', 'Voando a velocidades supersônicas, cria ondas de choque com suas asas poderosas.', 1.5, 39.5, 1, 10, 83, 80, 75, 70, 70, 101, 45, 50.0, 89, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/018.png'),
('Clefairy', 'Pokémon Fada', 'Sua pele macia e delicada faz todos quererem abraçá-lo. Dança sob a luz da lua cheia.', 0.6, 7.5, 18, NULL, 70, 45, 48, 60, 65, 35, 150, 25.0, 78, 'Pedra da Lua', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/035.png'),
('Clefable', 'Pokémon Fada', 'Extremamente tímido, raramente é visto. Corre quando detecta a presença de pessoas.', 1.3, 40.0, 18, NULL, 95, 70, 73, 95, 90, 60, 25, 25.0, 91, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/036.png'),
('Dragonair', 'Pokémon Dragão', 'Dizem que controla o clima. Vive em mares e lagos, cercado por uma aura misteriosa.', 4.0, 16.5, 15, NULL, 61, 84, 65, 70, 70, 70, 45, 50.0, 80, 'Level 55', 55, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/148.png'),
('Dragonite', 'Pokémon Dragão', 'Inteligente e bondoso, voa ao redor do mundo para salvar pessoas em perigo no mar.', 2.2, 210.0, 15, 10, 91, 134, 95, 100, 100, 80, 45, 50.0, 93, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/149.png'),
('Seadra', 'Pokémon Dragão', 'Espinhos venenosos cobrem seu corpo. Esmaga presas com sua cauda musculosa.', 1.2, 25.0, 3, NULL, 55, 65, 95, 95, 45, 85, 75, 50.0, 81, 'Troca com Dragon Scale', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/117.png'),
('Kingdra', 'Pokémon Dragão', 'Dorme em cavernas submarinas. Quando desperta, causa redemoinhos gigantes.', 1.8, 152.0, 3, 15, 75, 95, 95, 95, 95, 85, 45, 50.0, 95, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/230.png'),
('Scizor', 'Pokémon Pinça', 'Seu corpo duro como aço o torna resistente. Usa suas pinças para esmagar inimigos com força incrível.', 1.8, 118.0, 12, 17, 70, 130, 100, 55, 80, 65, 25, 50.0, 83, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/212.png'),
('Haunter', 'Pokémon Sombrio', 'Adora assustar pessoas à noite. Se você sentir um arrepio repentino, pode ser um Haunter passando por você.', 1.6, 0.1, 8, 14, 45, 50, 45, 115, 55, 95, 90, 50.0, 85, 'Troca', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/093.png'),
('Gengar', 'Pokémon Sombrio', 'Sombra sorridente que absorve calor do ambiente. Dizem que traz má sorte a quem o vê.', 1.5, 40.5, 8, 14, 60, 65, 60, 130, 75, 110, 45, 50.0, 98, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/094.png'),
('Primeape', 'Pokémon Porco Macaco', 'Sua raiva nunca acaba. Persegue inimigos até exaustão, mesmo que isso o machuque.', 1.0, 32.0, 7, NULL, 65, 105, 60, 60, 70, 95, 75, 50.0, 86, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/057.png'),
('Piloswine', 'Pokémon Porco', 'Seus longos pelos o protegem do frio. Ataca com presas afiadas cobertas de gelo.', 1.1, 55.8, 6, 9, 100, 100, 80, 60, 60, 50, 75, 50.0, 87, 'Level up movendo Ancient Power', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/221.png'),
('Mamoswine', 'Pokémon Porco', 'Surgiu durante a Era do Gelo. Seu pelo grosso o protege do frio extremo.', 2.5, 291.0, 6, 9, 110, 130, 80, 70, 60, 80, 50, 50.0, 101, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/473.png'),
('Dewgong', 'Pokémon Foca', 'Seu corpo é branco como a neve. Armazena calor sob sua pele para sobreviver em icebergs.', 1.7, 120.0, 3, 6, 90, 70, 80, 70, 95, 70, 75, 50.0, 88, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/087.png'),
('Gyarados', 'Pokémon Atroz', 'Tem temperamento violento e destrói cidades com hiper-raios. Conhecido como "o demônio dos mares".', 6.5, 235.0, 11, 3, 95, 125, 79, 60, 100, 81, 45, 50.0, 16, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/130.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Metapod', 'Pokémon Casulo', 'Endurece seu casulo para se proteger enquanto se prepara para evoluir. Só consegue usar o movimento "Endure".', 0.7, 9.9, 7, NULL, 50, 20, 55, 25, 25, 30, 120, 50.0, 84, 'Level 10', 10, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/011.png'),
('Butterfree', 'Pokémon Borboleta', 'Suas asas liberam pólen tóxico ao bater. Adora néctar de flores e pode carregar pequenos objetos.', 1.1, 32.0, 7, 3, 60, 45, 50, 90, 80, 70, 45, 50.0, 105, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/012.png');

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Kakuna', 'Pokémon Casulo', 'Quase incapaz de se mover. Endurece seu casulo para se proteger até evoluir.', 0.6, 10.0, 7, 4, 45, 25, 50, 25, 25, 35, 120, 50.0, 82, 'Level 10', 10, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/014.png'),
('Beedrill', 'Pokémon Abelha', 'Extremamente territorial. Ataca em enxames com ferrões venenosos se seu ninho for ameaçado.', 1.0, 29.5, 7, 4, 65, 90, 40, 45, 80, 75, 45, 50.0, 107, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/015.png');


-- Pokémon dos Líderes de Ginásio de Hoenn 

INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, 
ataqueBase, defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase,
taxaCaptura, taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Líder Roxanne (Pedra)
('Aron', 'Pokémon Ferro', 'Se alimenta de minérios de ferro. Seu corpo de aço é mais duro que diamante.', 0.4, 60.0, 17, 13, 50, 70, 100, 40, 40, 30, 180, 50.0, NULL, 'Level 32', 32, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/304.png'),

-- Líder Brawly (Lutador)
('Makuhita', 'Pokémon Gordura', 'Treina derrubando árvores com golpes de palma.', 1.0, 86.4, 7, NULL, 72, 60, 30, 20, 30, 25, 180, 75.0, NULL, 'Level 24', 24, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/296.png'),
('Meditite', 'Pokémon Meditação', 'Medita para aumentar sua energia interior.', 0.6, 11.2, 7, 11, 30, 40, 55, 40, 55, 60, 180, 50.0, NULL, 'Level 37', 37, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/307.png'),

-- Líder Wattson (Elétrico)
('Electrike', 'Pokémon Relâmpago', 'Armazena eletricidade na pelagem.', 0.6, 15.2, 4, NULL, 40, 45, 40, 65, 40, 65, 120, 50.0, NULL, 'Level 26', 26, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/309.png'),

-- Líder Norman (Normal)
('Slakoth', 'Pokémon Preguiça', 'Dorme 20 horas por dia.', 0.8, 24.0, 1, NULL, 60, 60, 60, 35, 35, 30, 255, 50.0, NULL, 'Level 18', 18, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/287.png'),

-- Líder Winona (Voador)
('Swablu', 'Pokémon Pássaro de Algodão', 'Cobre inimigos com penas fofas.', 0.4, 1.2, 1, 10, 45, 40, 60, 40, 75, 50, 255, 50.0, NULL, 'Level 35', 35, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/333.png'),

-- Líder Wallace/Juan (Água)
('Feebas', 'Pokémon Peixe Feio', 'Vive em águas sujas.', 0.6, 7.4, 3, NULL, 20, 15, 20, 10, 55, 80, 255, 50.0, NULL, 'Beleza máxima + Level up', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/349.png');


-- Evolução de Aron (ID 127 - assumindo que é o próximo ID disponível)
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2,
 hpBase, ataqueBase, defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura,
 taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
-- Evolução de Aron (assumindo que Aron é o ID 109)
('Lairon', 'Pokémon Ferro', 'Esmaga rochas com seu corpo resistente.', 0.9, 120.0, 17, 13, 60, 90, 140, 50, 50, 40, 90, 50.0, 109, 'Level 42', 42, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/305.png'),
('Aggron', 'Pokémon Armadura', 'Protege ferozmente seu território.', 2.1, 360.0, 17, 13, 70, 110, 180, 60, 60, 50, 45, 50.0, 110, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/306.png'),

-- Evolução de Makuhita (assumindo ID 110) e Meditite (ID 111)
('Hariyama', 'Pokémon Gordura', 'Aplaude antes de atacar para intimidar.', 2.3, 253.8, 7, NULL, 144, 120, 60, 40, 60, 50, 200, 75.0, 110, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/297.png'),
('Medicham', 'Pokémon Meditação', 'Pode prever movimentos do oponente.', 1.3, 31.5, 7, 11, 60, 60, 75, 60, 75, 80, 90, 50.0, 111, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/308.png'),

-- Evolução de Electrike (assumindo ID 112)
('Manectric', 'Pokémon Descarga', 'Dispara poderosos raios.', 1.5, 40.2, 4, NULL, 70, 75, 60, 105, 60, 105, 45, 50.0, 112, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/310.png'),

-- Evolução de Slakoth (assumindo ID 113)
('Vigoroth', 'Pokémon Selvagem', 'Fica agitado se parar de se mover.', 1.4, 46.5, 1, NULL, 80, 80, 80, 55, 55, 90, 120, 50.0, 113, 'Level 36', 36, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/288.png'),
('Slaking', 'Pokémon Preguiça', 'Só ataca a cada 3 segundos.', 2.0, 130.5, 1, NULL, 150, 160, 100, 95, 65, 100, 45, 50.0, 114, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/289.png'),

-- Evolução de Swablu (assumindo ID 115)
('Altaria', 'Pokémon Pássaro', 'Voam nas nuvens.', 1.1, 20.6, 15, 10, 75, 70, 90, 70, 105, 80, 45, 50.0, 115, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/334.png'),

-- Evolução de Feebas (assumindo ID 116)
('Milotic', 'Pokémon Terno', 'Escamas mudam de cor sob a luz lunar.', 6.2, 162.0, 3, NULL, 95, 60, 79, 100, 125, 81, 60, 50.0, 116, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/350.png');


-- Nosepass (Pokémon original da 3ª geração - Hoenn)
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Nosepass', 'Pokémon Bússola', 'Seu nariz magnético sempre aponta para o norte. Fica imóvel para não perder a direção.', 1.0, 97.0, 13, NULL, 30, 45, 135, 45, 90, 30, 255, 50.0, NULL, 'Evolui em área magnética (Mt. Coronet/Sinnoh)', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/299.png'),

('Probopass', 'Pokémon Bússola', 'Controla três unidades chamadas "Mini-Noses" com campos magnéticos.', 1.4, 340.0, 13, 17, 60, 55, 145, 75, 150, 40, 60, 50.0, 117, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/476.png'),

('Skarmory', 'Pokémon Armadura', 'Suas penas de aço afiadas são usadas como lâminas. Constrói ninhos em penhascos íngremes.', 1.7, 50.5, 17, 10, 65, 80, 140, 40, 70, 70, 25, 50.0, NULL, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/227.png'),

('Wingull', 'Pokémon Gaivota', 'Voam sobre o mar buscando comida. Armazenam sal em seus corpos.', 0.6, 9.5, 3, 10, 40, 30, 30, 55, 30, 85, 190, 50.0, NULL, 'Level 25', 25, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/278.png'),

('Pelipper', 'Pokémon Ave Aquática', 'Transporta pequenos Pokémon em seu bico. Caça mergulhando na água.', 1.2, 28.0, 3, 10, 60, 50, 100, 95, 70, 65, 45, 50.0, 119, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/279.png'),

('Taillow', 'Pokémon Andorinha', 'Corajoso mesmo contra oponentes maiores. Mostra resistência em batalhas.', 0.3, 2.3, 1, 10, 40, 55, 30, 30, 30, 85, 200, 50.0, NULL, 'Level 22', 22, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/276.png'),

('Swellow', 'Pokémon Andorinha', 'Voam em círculos acima de presas. Atacam com mergulhos precisos a 300km/h.', 0.7, 19.8, 1, 10, 60, 85, 60, 75, 50, 125, 45, 50.0, 120, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/277.png');

-- Lunatone (Pokémon Meteorito Lunar - Especialista em ataques especiais)
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Lunatone', 'Pokémon Meteorito', 'Descoberto após queda de meteorito. Flutua misteriosamente e ataca com energia lunar.', 1.0, 168.0, 13, 11, 90, 55, 65, 95, 85, 70, 45, NULL, NULL, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/337.png'),

('Solrock', 'Pokémon Meteorito', 'Emite luz solar intensa durante a batalha. Dizem que roda para absorver energia do sol.', 1.2, 154.0, 13, 11, 90, 95, 85, 55, 65, 70, 45, NULL, NULL, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/338.png'),

('Luvdisc', 'Pokémon Afeição', 'Seu formato de coração simboliza o amor. Vive em mares tropicais e é dado como presente romântico.', 0.6, 8.7, 3, NULL, 43, 30, 55, 40, 65, 97, 225, 25.0, NULL, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/370.png'),

('Spheal', 'Pokémon Bola', 'Rola para se locomover. Seus olhos grandes veem bem na escuridão das águas profundas.', 0.8, 39.5, 6, 3, 70, 40, 50, 55, 50, 25, 255, 50.0, NULL, 'Level 32', 32, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/363.png'),

('Sealeo', 'Pokémon Bola', 'Equilibra objetos no nariz para treinar. Vive em icebergs e adora brincar na neve.', 1.1, 87.6, 6, 3, 90, 60, 70, 75, 70, 45, 120, 50.0, 134, 'Level 44', 44, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/364.png'),

('Goldeen', 'Pokémon Peixe', 'Sua barbatana caudal flutuante atrai parceiros. Nada contra correntes fortes.', 0.6, 15.0, 3, NULL, 45, 67, 60, 35, 50, 63, 225, 50.0, NULL, 'Nível 33', 33, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/118.png'),

('Seaking', 'Pokémon Peixe', 'Usa seu chifre para escavar pedras no leito dos rios. Suas cores vivas mudam no outono.', 1.3, 39.0, 3, NULL, 80, 92, 65, 65, 80, 68, 60, 50.0, 136, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/119.png'),

('Barboach', 'Pokémon Catfish', 'Sensível a vibrações na água, detecta presas mesmo na escuridão total.', 0.4, 1.9, 3, 9, 50, 48, 43, 46, 41, 60, 190, 50.0, NULL, 'Nível 30', 30, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/339.png'),

('Whiscash', 'Pokémon Catfish', 'Dorme enterrado na lama. Lendas dizem que seu bocejo causa terremotos.', 0.9, 23.6, 3, 9, 110, 78, 73, 76, 71, 60, 75, 50.0, 138, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/340.png');

-- Pokémon dos Líderes de Sinnoh --

-- Linha do Cranidos (Líder Roark - Pedra) - IDs 140-141
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Cranidos', 'Pokémon Cabeça Dura', 'Reviveu de um fóssil. Ataca com cabeçadas poderosas, mas é fraco em defesa.', 0.9, 31.5, 13, NULL, 67, 125, 40, 30, 30, 58, 45, 87.5, NULL, 'Level 30', 30, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/408.png'),
('Rampardos', 'Pokémon Cabeça Dura', 'Seu crânio é extremamente duro. Destruiu montanhas com cabeçadas em tempos pré-históricos.', 1.6, 102.5, 13, NULL, 97, 165, 60, 65, 50, 58, 45, 87.5, 140, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/409.png');

-- Linha do Turtwig (Líder Gardenia - Grama) - IDs 142-144
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Turtwig', 'Pokémon Minitartaruga', 'A concha em suas costas é feita de solo e endurece quando bebe água.', 0.4, 10.2, 5, NULL, 55, 68, 64, 45, 55, 31, 45, 87.5, NULL, 'Level 18', 18, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/387.png'),
('Grotle', 'Pokémon Tartaruga', 'Armazena energia em sua concha para fotossíntese. Seu cheiro lembra floresta fresca.', 1.1, 97.0, 5, NULL, 75, 89, 85, 55, 65, 36, 45, 87.5, 142, 'Level 32', 32, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/388.png'),
('Torterra', 'Pokémon Continente', 'Pokémon enorme que carrega um pequeno ecossistema em seu casco.', 2.2, 310.0, 5, 9, 95, 109, 105, 75, 85, 56, 45, 87.5, 143, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/389.png');

-- Linha do Cherubi (Líder Gardenia - Grama) - IDs 145-146
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Cherubi', 'Pokémon Cereja', 'A cereja em sua cabeça é cheia de nutrientes e dobra de tamanho quando madura.', 0.4, 3.3, 5, NULL, 45, 35, 45, 62, 53, 35, 190, 50.0, NULL, 'Level 25', 25, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/420.png'),
('Cherrim', 'Pokémon Florescência', 'Muda de forma com a luz solar. Em dias nublados fica fechado e quieto.', 0.5, 9.3, 5, NULL, 70, 60, 70, 87, 78, 85, 75, 50.0, 145, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/421.png');

-- Linha do Riolu (Líder Maylene - Lutador) - IDs 147-148
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Riolu', 'Pokémon Aura', 'Consegue sentir a aura das pessoas. Evolui quando treina com forte vínculo emocional.', 0.7, 20.2, 7, NULL, 40, 70, 40, 35, 40, 60, 75, 87.5, NULL, 'Amizade durante dia', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/447.png'),
('Lucario', 'Pokémon Aura', 'Consegue sentir a aura de todos os seres vivos. É leal apenas a treinadores dignos.', 1.2, 54.0, 7, 17, 70, 110, 70, 115, 70, 90, 45, 87.5, 147, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/448.png');

-- Linha do Buizel (Líder Wake - Água) - IDs 149-150
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Buizel', 'Pokémon Lontra', 'Nada girando como uma hélice usando sua cauda. Vive em rios de correnteza forte.', 0.7, 29.5, 3, NULL, 55, 65, 35, 60, 30, 85, 190, 50.0, NULL, 'Level 26', 26, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/418.png'),
('Floatzel', 'Pokémon Lontra', 'Nada a 60 km/h usando sua cauda como hélice. Caça presas em rios rápidos.', 1.1, 33.5, 3, NULL, 85, 105, 55, 85, 50, 115, 75, 50.0, 149, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/419.png');

-- Linha do Machop (Líder Maylene - Lutador) - IDs 151-153
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Machop', 'Pokémon Superpoder', 'Treina seus músculos todos os dias. Pode levantar pessoas com apenas um dedo.', 0.8, 19.5, 7, NULL, 70, 80, 50, 35, 35, 35, 180, 75.0, NULL, 'Level 28', 28, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/066.png'),
('Machoke', 'Pokémon Superpoder', 'Seu corpo musculoso é tão forte que precisa de um cinto para limitar seus movimentos.', 1.5, 70.5, 7, NULL, 80, 100, 70, 50, 60, 45, 90, 75.0, 151, 'Trade', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/067.png'),
('Machamp', 'Pokémon Superpoder', 'Seus quatro braços podem lançar mil socos em dois segundos. Domina todas as artes marciais.', 1.6, 130.0, 7, NULL, 90, 130, 80, 65, 85, 55, 45, 75.0, 152, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/068.png');

-- Pokémon dos Líderes de Unova --

-- Linha do Pansage (Líder Cilan - Grama) - IDs 154-155
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Pansage', 'Pokémon Macaco Folha', 'Come folhas que crescem em sua cabeça. Ajuda Pokémon fracos compartilhando comida.', 0.6, 10.5, 5, NULL, 50, 53, 48, 53, 48, 64, 190, 87.5, NULL, 'Pedra Evolutiva', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/511.png'),
('Simisage', 'Pokémon Macaco Folha', 'Provoca incêndios florestais balançando sua cauda flamejante para assustar inimigos.', 1.1, 30.5, 5, NULL, 75, 98, 63, 98, 63, 101, 75, 87.5, 154, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/512.png'),

-- Linha do Pansear (Líder Chili - Fogo) - IDs 156-157
('Pansear', 'Pokémon Macaco Chama', 'A chama em sua cabeça queima mais forte quando está animado. Come frutas assadas.', 0.6, 11.0, 2, NULL, 50, 53, 48, 53, 48, 64, 190, 87.5, NULL, 'Pedra Evolutiva', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/513.png'),
('Simisear', 'Pokémon Macaco Chama', 'Provoca incêndios florestais balançando sua cauda flamejante para assustar inimigos.', 1.0, 28.0, 2, NULL, 75, 98, 63, 98, 63, 101, 75, 87.5, 156, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/514.png'),

-- Linha do Panpour (Líder Cress - Água) - IDs 158-159
('Panpour', 'Pokémon Macaco Água', 'A água que jorra de sua cabeça pode curar feridas. Vive perto de rios.', 0.6, 13.5, 3, NULL, 50, 53, 48, 53, 48, 64, 190, 87.5, NULL, 'Pedra Evolutiva', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/515.png'),
('Simipour', 'Pokémon Macaco Água', 'A água que jorra de sua cabeça tem propriedades curativas. Pode apagar grandes incêndios.', 1.0, 29.0, 3, NULL, 75, 98, 63, 98, 63, 101, 75, 87.5, 158, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/516.png'),

-- Linha do Lillipup (Líder Lenora - Normal) - IDs 160-162
('Lillipup', 'Pokémon Filhote', 'Inteligente e obediente. Seu pelo bem cuidado é um ponto de orgulho para treinadores.', 0.4, 4.1, 1, NULL, 45, 60, 45, 25, 45, 55, 255, 50.0, NULL, 'Level 16', 16, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/506.png'),
('Herdier', 'Pokémon Leal', 'Extremamente leal ao seu treinador. Usa seu bigode para sentir perigos próximos.', 0.9, 14.7, 1, NULL, 65, 80, 65, 35, 65, 60, 120, 50.0, 160, 'Level 32', 32, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/507.png'),
('Stoutland', 'Pokémon Grande Cão', 'Seu bigode sensível detecta perigos. Resgata pessoas perdidas em nevascas.', 1.2, 61.0, 1, NULL, 85, 110, 90, 45, 90, 80, 45, 50.0, 161, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/508.png'),

-- Linha do Patrat (Líder Lenora - Normal) - IDs 163-164
('Patrat', 'Pokémon Vigia', 'Extremamente vigilante. Fica em pé sobre as patas traseiras para ver melhor ao longe.', 0.5, 11.6, 1, NULL, 45, 55, 39, 35, 39, 42, 255, 50.0, NULL, 'Level 20', 20, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/504.png'),
('Watchog', 'Pokémon Vigilância', 'Usa os padrões em seu corpo para hipnotizar oponentes. Nunca dorme.', 1.1, 27.0, 1, NULL, 60, 85, 69, 60, 69, 77, 255, 50.0, 163, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/505.png'),

-- Linha do Dwebble (Líder Burgh - Inseto) - IDs 165-166
('Dwebble', 'Pokémon Caranguejo Rocha', 'Escava tocas em rochas macias para viver. A rocha em suas costas é sua casa.', 0.3, 14.5, 12, 13, 50, 65, 85, 35, 35, 55, 190, 50.0, NULL, 'Level 34', 34, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/557.png'),
('Crustle', 'Pokémon Caranguejo Rocha', 'Carrega uma enorme rocha nas costas. É forte o suficiente para esmagar aço.', 1.4, 200.0, 12, 13, 70, 105, 125, 65, 75, 45, 75, 50.0, 165, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/558.png'),

-- Linha do Sewaddle (Líder Burgh - Inseto) - IDs 167-169
('Sewaddle', 'Pokémon Costura', 'Vive dentro de capas feitas de folhas que ele mesmo cose. Adora folhas frescas.', 0.3, 2.5, 12, 5, 45, 53, 70, 40, 60, 42, 255, 50.0, NULL, 'Level 20', 20, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/540.png'),
('Swadloon', 'Pokémon Casulo de Folha', 'Protege-se com folhas duras. Reage a carícias balançando seu corpo.', 0.5, 7.3, 12, 5, 55, 63, 90, 50, 80, 42, 120, 50.0, 167, 'Amizade', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/541.png'),
('Leavanny', 'Pokémon Corte de Folha', 'Cria roupas para outros Pokémon com folhas. Extremamente protetor com seus amigos.', 1.2, 20.5, 12, 5, 75, 103, 80, 70, 80, 92, 45, 50.0, 168, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/542.png');

-- Linha do Joltik (Líder Elesa - Elétrico) - IDs 170-171
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Joltik', 'Pokémon Aranha', 'Se alimenta de eletricidade estática. Pode grudar em grandes Pokémon para sugar energia.', 0.1, 0.6, 12, 4, 50, 47, 50, 57, 50, 65, 190, 50.0, NULL, 'Level 36', 36, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/595.png'),
('Galvantula', 'Pokémon Aranha Elétrica', 'Cria teias elétricas para capturar presas. Trabalha em grupo para derrubar alvos grandes.', 0.8, 14.3, 12, 4, 70, 77, 60, 97, 60, 108, 75, 50.0, 170, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/596.png'),

-- Pokémon individuais (sem pré-evoluções) - IDs 172-173
('Emolga', 'Pokémon Esquilo Voador', 'Armazena eletricidade em suas bochechas. Planando, libera choques em inimigos.', 0.4, 5.0, 4, 10, 55, 75, 60, 75, 60, 103, 200, 50.0, NULL, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/587.png'),
('Zebstrika', 'Pokémon Relâmpago', 'Seus cascos produzem eletricidade quando galopa. Seus gritos soam como trovões.', 1.6, 79.5, 4, NULL, 75, 100, 63, 80, 63, 116, 75, 50.0, NULL, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/523.png'),

-- Quagsire e sua pré-evolução (ID 175-176)
('Wooper', 'Pokémon Peixe DÁgua', 'Vive em água fria. Sai da água para procurar comida quando esfria demais.', 0.4, 8.5, 3, 9, 55, 45, 45, 25, 25, 15, 255, 50.0, NULL, 'Level 20', 20, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/194.png'),
('Quagsire', 'Pokémon Peixe DÁgua', 'Sua mente é lenta e despreocupada. Não sente dor mesmo quando atacado.', 1.4, 75.0, 3, 9, 95, 85, 85, 65, 65, 35, 90, 50.0, 175, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/195.png'),

-- Drifblim e sua pré-evolução (ID 177-178)
('Drifloon', 'Pokémon Balão', 'Atrai crianças com sua aparência de balão e as leva para o mundo espiritual.', 0.4, 1.2, 14, 10, 90, 50, 34, 60, 44, 70, 125, 50.0, NULL, 'Level 28', 28, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/425.png'),
('Drifblim', 'Pokémon Balão', 'Vaga pelos céus carregando pessoas e Pokémon. Dizem que leva para o além.', 1.2, 15.0, 14, 10, 150, 80, 44, 90, 54, 80, 60, 50.0, 177, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/426.png'),

-- Mismagius e sua pré-evolução (ID 179-180)
('Misdreavus', 'Pokémon Grito', 'Adora assustar pessoas com gritos assustadores. Alimenta-se de medo.', 0.7, 1.0, 14, NULL, 60, 60, 60, 85, 85, 85, 45, 50.0, NULL, 'Pedra Dusk', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/200.png'),
('Mismagius', 'Pokémon Mágico', 'Seus feitiços causam alucinações. Dizem que traz má sorte a quem o vê.', 0.9, 4.4, 14, NULL, 60, 60, 60, 105, 105, 105, 45, 50.0, 179, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/429.png'),

-- Bronzor e sua evolução (ID 181-182)
('Bronzor', 'Pokémon Bronze', 'Antigamente era usado como espelho. Reflete energia misteriosa.', 0.5, 60.5, 17, 11, 57, 24, 86, 24, 86, 23, 255, NULL, NULL, 'Level 33', 33, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/436.png'),
('Bronzong', 'Pokémon Sino', 'Dizem que traz chuva ou sol. Adorado em tempos antigos como causador de colheitas.', 1.3, 187.0, 17, 11, 67, 89, 116, 79, 116, 33, 90, NULL, 181, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/437.png'),

-- Bastiodon e sua linha evolutiva (ID 183-184)
('Shieldon', 'Pokémon Escudo', 'Viveu na floresta há 100 milhões de anos. Seu rosto é extremamente resistente.', 0.5, 57.0, 13, 17, 30, 42, 118, 42, 88, 30, 45, 87.5, NULL, 'Level 30', 30, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/410.png'),
('Bastiodon', 'Pokémon Muralha', 'Seu rosto pode repelir ataques de qualquer criatura. Vive em pequenos grupos.', 1.3, 149.5, 13, 17, 60, 52, 168, 47, 138, 30, 45, 87.5, 183, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/411.png'),

-- Abomasnow e sua pré-evolução (ID 185-186)
('Snover', 'Pokémon Árvore de Neve', 'Vive em regiões montanhosas cobertas de neve. Produz neve de seus galhos.', 1.0, 50.5, 5, 6, 60, 62, 50, 62, 60, 40, 120, 50.0, NULL, 'Level 40', 40, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/459.png'),
('Abomasnow', 'Pokémon Árvore de Neve', 'Chama nevascas para esconder-se. Seus braços são poderosos o suficiente para esmagar rochas.', 2.2, 135.5, 5, 6, 90, 92, 75, 92, 85, 60, 60, 50.0, 185, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/460.png'),

-- Sneasel e sua evolução (ID 187-188)
('Sneasel', 'Pokémon Garras', 'Ataca silenciosamente à noite. Suas garras afiadas deixam feridas que não param de sangrar.', 0.9, 28.0, 16, 6, 55, 95, 55, 35, 75, 115, 60, 50.0, NULL, 'Nível up à noite segurando Razor Claw', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/215.png'),
('Weavile', 'Pokémon Garras Afiadas', 'Caça em grupos táticos. Comunica-se com sinais de garra em árvores e gelo.', 1.1, 34.0, 16, 6, 70, 120, 65, 45, 85, 125, 45, 50.0, 187, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/461.png'),

-- Roserade e sua linha evolutiva (ID 189-191)
('Budew', 'Pokémon Broto', 'Aprende movimentos poderosos rapidamente. Libera pólen venenoso quando ameaçado.', 0.2, 1.2, 5, 8, 40, 30, 35, 50, 70, 55, 255, 50.0, NULL, 'Amizade durante dia', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/406.png'),
('Roselia', 'Pokémon Espinho', 'Suas flores contêm óleos que acalmam e curam. Os espinhos são venenosos.', 0.3, 2.0, 5, 8, 50, 60, 45, 100, 80, 65, 150, 50.0, 189, 'Pedra Shiny', NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/315.png'),
('Roserade', 'Pokémon Buquê', 'Atrai presas com flores doces e depois ataca com chicotes venenosos.', 0.9, 14.5, 5, 8, 60, 70, 65, 125, 105, 90, 75, 50.0, 190, NULL, NULL, 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/detail/407.png');

-- Octillery e sua pré-evolução (ID 192-193)
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Remoraid', 'Pokémon Atirador', 'Dispara água com precisão para derrubar insetos voadores. Pode atirar até 100m.', 0.6, 12.0, 3, NULL, 35, 65, 35, 65, 35, 65, 190, 50.0, NULL, 'Level 25', 25, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/223.png'),
('Octillery', 'Pokémon Canhão', 'Usa seus tentáculos como armas. Se agarra em rochas enquanto atira jatos de tinta.', 0.9, 28.5, 3, NULL, 75, 105, 75, 105, 75, 45, 75, 50.0, 192, NULL, NULL, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/224.png');

-- Ambipom e sua pré-evolução (ID 194-195)
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Aipom', 'Pokémon Cauda de Mão', 'Usa sua cauda ágil como uma mão extra. Vive no topo das árvores.', 0.8, 11.5, 1, NULL, 55, 70, 55, 40, 55, 85, 45, 50.0, NULL, 'Level up conhecendo Double Hit', NULL, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/190.png'),
('Ambipom', 'Pokémon Cauda Longa', 'Usa suas duas caudas com habilidade. Pode digitar em dois teclados ao mesmo tempo.', 1.2, 20.3, 1, NULL, 75, 100, 66, 60, 66, 115, 45, 50.0, 194, NULL, NULL, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/424.png');

-- Luxray e sua linha evolutiva (ID 196-198)
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Shinx', 'Pokémon Brilho', 'Seus olhos brilham no escuro. Comunica-se com outros com flashes de luz.', 0.5, 9.5, 4, NULL, 45, 65, 34, 40, 34, 45, 235, 50.0, NULL, 'Level 15', 15, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/403.png'),
('Luxio', 'Pokémon Faísca', 'Vive em pequenos grupos. Seus pelos conduzem eletricidade quando excitado.', 0.9, 30.5, 4, NULL, 60, 85, 49, 60, 49, 60, 120, 50.0, 196, 'Level 30', 30, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/404.png'),
('Luxray', 'Pokémon Brilho', 'Pode ver através de objetos sólidos com seus olhos. Localiza presas escondidas.', 1.4, 42.0, 4, NULL, 80, 120, 79, 95, 79, 70, 45, 50.0, 197, NULL, NULL, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/405.png');

-- Krokorok e sua linha evolutiva (ID 199-201)
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Sandile', 'Pokémon Crocodilo da Areia', 'Vive enterrado na areia do deserto. Só deixa visíveis seus olhos e nariz enquanto espera por presas.', 0.7, 15.2, 9, 16, 50, 72, 35, 35, 35, 65, 180, 50.0, NULL, 'Level 29', 29, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/551.png'),
('Krokorok', 'Pokémon Crocodilo do Deserto', 'Protegido por uma película sobre os olhos, pode caçar mesmo em tempestades de areia.', 1.0, 33.4, 9, 16, 60, 82, 45, 45, 45, 74, 90, 50.0, 199, 'Level 40', 40, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/552.png'),
('Krookodile', 'Pokémon Intimidador', 'Seus olhos vermelhos podem enxergar presas mesmo através da areia. Tem mandíbulas que esmagam aço.', 1.5, 96.3, 9, 16, 95, 117, 80, 65, 70, 92, 45, 50.0, 200, NULL, NULL, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/553.png');

-- Palpitoad e sua linha evolutiva (ID 202-204)
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Tympole', 'Pokémon Girino', 'Usa vibrações na água para comunicar-se. Quando em perigo, faz um barulho ensurdecedor.', 0.5, 4.5, 3, NULL, 50, 50, 40, 50, 40, 64, 255, 50.0, NULL, 'Level 25', 25, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/535.png'),
('Palpitoad', 'Pokémon Vibração', 'Cria ondas de choque batendo os dedos contra o solo. Pode derrubar uma casa com vibrações.', 0.8, 17.0, 3, 9, 75, 65, 55, 65, 55, 69, 120, 50.0, 202, 'Level 36', 36, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/536.png'),
('Seismitoad', 'Pokémon Vibração', 'Pode fazer o chão tremer com as almofadas em seus dedos. Sua força muscular é incrível.', 1.5, 62.0, 3, 9, 105, 95, 75, 85, 75, 74, 45, 50.0, 203, NULL, NULL, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/537.png');

-- Excadrill e sua pré-evolução (ID 205-206)
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Drilbur', 'Pokémon Broca', 'Cava túneis em alta velocidade usando suas garras afiadas. Vive no subsolo.', 0.3, 8.5, 9, NULL, 60, 85, 40, 30, 45, 68, 120, 50.0, NULL, 'Level 31', 31, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/529.png'),
('Excadrill', 'Pokémon Broca', 'Suas garras de aço podem perfurar até rochas duras. Trabalha em equipe para cavar túneis.', 0.7, 40.4, 9, 17, 110, 135, 60, 50, 65, 88, 60, 50.0, 205, NULL, NULL, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/530.png');

-- Swoobat e sua pré-evolução (ID 207-208)
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Woobat', 'Pokémon Morcego Beijo', 'Vive em cavernas escuras. Mostra afeto deixando marcas de coração com seu nariz.', 0.4, 2.1, 11, 10, 65, 45, 43, 55, 43, 72, 190, 50.0, NULL, 'Amizade', NULL, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/527.png'),
('Swoobat', 'Pokémon Morcego Beijo', 'Libera ondas ultrassônicas em forma de coração para confundir presas e predadores.', 0.9, 10.5, 11, 10, 67, 57, 55, 77, 55, 114, 45, 50.0, 207, NULL, NULL, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/528.png');

-- Unfezant e sua linha evolutiva (ID 209-211)
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Pidove', 'Pokémon Pombo Pequeno', 'Muito dócil e obediente. Segue seu treinador fielmente como um pombo-correio.', 0.3, 2.1, 1, 10, 50, 55, 50, 36, 30, 43, 255, 50.0, NULL, 'Level 21', 21, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/519.png'),
('Tranquill', 'Pokémon Pombo Selvagem', 'Marca seu território com gritos altos. Extremamente protetor com seu grupo.', 0.6, 15.0, 1, 10, 62, 77, 62, 50, 42, 65, 120, 50.0, 209, 'Level 32', 32, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/520.png'),
('Unfezant', 'Pokémon Pombo Orgulhoso', 'Diferenças visíveis entre machos e fêmeas. Os machos têm plumagem mais colorida e são mais agressivos.', 1.2, 29.0, 1, 10, 80, 115, 80, 65, 55, 93, 45, 50.0, 210, NULL, NULL, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/521.png');

-- Swanna e sua pré-evolução (ID 212-213)
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Ducklett', 'Pokémon Pato', 'Flutua na água enquanto procura comida. Suas penas repelem a água e o frio.', 0.5, 5.5, 3, 10, 62, 44, 50, 44, 50, 55, 190, 50.0, NULL, 'Level 35', 35, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/580.png'),
('Swanna', 'Pokémon Cisne', 'Elegante ao nadar e voar. Ataca com danças graciosas e golpes de asa poderosos.', 1.3, 24.2, 3, 10, 75, 87, 63, 87, 63, 98, 45, 50.0, 212, NULL, NULL, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/581.png');

-- Vanillish e sua linha evolutiva (ID 214-216)
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Vanillite', 'Pokémon Neve Fresca', 'Nascido de gotículas de neve congeladas. Exala ar frio a -50°C.', 0.4, 5.7, 6, NULL, 36, 50, 50, 65, 60, 44, 255, 50.0, NULL, 'Level 35', 35, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/582.png'),
('Vanillish', 'Pokémon Neve', 'Coberto por uma camada de gelo duro como aço. Congela inimigos com ar -50°C.', 1.1, 41.0, 6, NULL, 51, 65, 65, 80, 75, 59, 120, 50.0, 214, 'Level 47', 47, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/583.png'),
('Vanilluxe', 'Pokémon Nevasca', 'As duas cabeças pensam em uníssono. Causa nevascas ao liberar ar congelante.', 1.3, 57.5, 6, NULL, 71, 95, 85, 110, 95, 79, 45, 50.0, 215, NULL, NULL, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/584.png');

-- Cryogonal (ID 217 - sem pré-evolução)
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Cryogonal', 'Pokémon Cristal de Gelo', 'Formado a partir de partículas de gelo na atmosfera. Congela inimigos com ar -100°C.', 1.1, 148.0, 6, NULL, 80, 50, 50, 95, 135, 105, 25, NULL, NULL, NULL, NULL, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/615.png');

-- Beartic e sua pré-evolução (ID 218-219)
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Cubchoo', 'Pokémon Urso Chorão', 'Seu nariz escorre quando está resfriado. A muco se torna gelado e é usado em ataques.', 0.5, 8.5, 6, NULL, 55, 70, 40, 60, 40, 40, 120, 50.0, NULL, 'Level 37', 37, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/613.png'),
('Beartic', 'Pokémon Urso Congelante', 'Congela sua respiração para criar garras e presas de gelo. Pode esmagar rochas facilmente.', 2.6, 260.0, 6, NULL, 95, 130, 80, 70, 80, 50, 60, 50.0, 218, NULL, NULL, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/614.png');

-- Fraxure e sua linha evolutiva (ID 220-222)
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Axew', 'Pokémon Presa', 'Treina constantemente suas presas em troncos de árvores. Suas marcas podem ser vistas em florestas.', 0.6, 18.0, 15, NULL, 46, 87, 60, 30, 40, 57, 75, 50.0, NULL, 'Level 38', 38, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/610.png'),
('Fraxure', 'Pokémon Machado', 'Suas presas podem cortar aço. Vive em florestas e protege seu território ferozmente.', 1.0, 36.0, 15, NULL, 66, 117, 70, 40, 50, 67, 60, 50.0, 220, 'Level 48', 48, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/611.png'),
('Haxorus', 'Pokémon Machado', 'Seu corpo é coberto por placas duras. Suas presas afiadas podem cortar qualquer coisa.', 1.8, 105.5, 15, NULL, 76, 147, 90, 60, 70, 97, 45, 50.0, 221, NULL, NULL, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/612.png');

-- Druddigon (ID 223 - sem pré-evolução)
INSERT INTO pokemon (nome, especie, descricao, altura, peso, idTipoPokemon, idTipoPokemon2, hpBase, ataqueBase, 
                    defesaBase, ataqueEspecial_base, defesaEspecial_base, velocidadeBase, taxaCaptura, 
                    taxaGenero, preEvolucao, metodoEvolucao, nivelEvolucao, imagemUrl) VALUES
('Druddigon', 'Pokémon Caverna', 'Esculpe seu ninho em paredes de cavernas com suas garras afiadas. Tem pele dura como pedra.', 1.6, 139.0, 15, NULL, 77, 120, 90, 60, 90, 48, 45, 50.0, NULL, NULL, NULL, 'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/621.png');


-- 1. INSERIR OS LÍDERES (agora sem referência a timePokemon)
INSERT INTO liderGinasio (nomeLider, imagemUrl, cidade, idRegiao) VALUES
('Brock', 'https://archives.bulbagarden.net/media/upload/3/3b/Spr_FRLG_Brock.png', 'Pewter City', 1),
('Misty', 'https://archives.bulbagarden.net/media/upload/0/08/Spr_FRLG_Misty.png', 'Cerulean City', 1),
('Lt. Surge', 'https://archives.bulbagarden.net/media/upload/4/4a/Spr_FRLG_Lt_Surge.png', 'Vermilion City', 1),
('Erika', 'https://archives.bulbagarden.net/media/upload/4/4e/Spr_FRLG_Erika.png', 'Celadon City', 1),
('Koga', 'https://archives.bulbagarden.net/media/upload/5/59/Spr_FRLG_Koga.png', 'Fuchsia City', 1),
('Sabrina', 'https://archives.bulbagarden.net/media/upload/2/2e/Spr_FRLG_Sabrina.png', 'Saffron City', 1),
('Blaine', 'https://archives.bulbagarden.net/media/upload/7/7f/Spr_FRLG_Blaine.png', 'Cinnabar Island', 1),
('Giovanni', 'https://archives.bulbagarden.net/media/upload/4/44/Spr_FRLG_Giovanni.png', 'Viridian City', 1);

-- 2. CRIAR OS TIMES REFERENCIANDO OS LÍDERES
INSERT INTO timePokemon (idLider, nomeTime, data_criacao) VALUES
(1, 'Time de Brock', NOW()),
(2, 'Time de Misty', NOW()),
(3, 'Time de Lt. Surge', NOW()),
(4, 'Time de Erika', NOW()),
(5, 'Time de Koga', NOW()),
(6, 'Time de Sabrina', NOW()),
(7, 'Time de Blaine', NOW()),
(8, 'Time de Giovanni', NOW());

INSERT INTO liderGinasio (nomeLider, imagemUrl, cidade, idRegiao) VALUES
('Falkner', 'https://archives.bulbagarden.net/media/upload/thumb/f/f1/Spr_HGSS_Falkner.png/150px-Spr_HGSS_Falkner.png', 'Violet City', 2),
('Bugsy', 'https://archives.bulbagarden.net/media/upload/thumb/d/d0/Spr_HGSS_Bugsy.png/150px-Spr_HGSS_Bugsy.png', 'Azalea Town', 2),
('Whitney', 'https://archives.bulbagarden.net/media/upload/thumb/d/d7/Spr_HGSS_Whitney.png/150px-Spr_HGSS_Whitney.png', 'Goldenrod City', 2),
('Morty', 'https://archives.bulbagarden.net/media/upload/thumb/8/8a/Spr_HGSS_Morty.png/150px-Spr_HGSS_Morty.png', 'Ecruteak City', 2),
('Chuck', 'https://archives.bulbagarden.net/media/upload/thumb/a/a5/Spr_HGSS_Chuck.png/150px-Spr_HGSS_Chuck.png', 'Cianwood City', 2),
('Jasmine', 'https://archives.bulbagarden.net/media/upload/thumb/1/1c/Spr_HGSS_Jasmine.png/150px-Spr_HGSS_Jasmine.png', 'Olivine City', 2),
('Pryce', 'https://archives.bulbagarden.net/media/upload/thumb/4/41/Spr_HGSS_Pryce.png/150px-Spr_HGSS_Pryce.png', 'Mahogany Town', 2),
('Clair', 'https://archives.bulbagarden.net/media/upload/thumb/a/a9/Spr_HGSS_Clair.png/150px-Spr_HGSS_Clair.png', 'Blackthorn City', 2);

-- 2. CRIAR OS TIMES REFERENCIANDO OS LÍDERES DE JOHTO
INSERT INTO timePokemon (idLider, nomeTime, data_criacao) VALUES
(9, 'Time de Falkner', NOW()),
(10, 'Time de Bugsy', NOW()),
(11, 'Time de Whitney', NOW()),
(12, 'Time de Morty', NOW()),
(13, 'Time de Chuck', NOW()),
(14, 'Time de Jasmine', NOW()),
(15, 'Time de Pryce', NOW()),
(16, 'Time de Clair', NOW());

-- Líderes de Hoenn (assumindo que idRegiao = 3)
INSERT INTO liderGinasio (nomeLider, imagemUrl, cidade, idRegiao) VALUES
( 'Roxanne', 'https://archives.bulbagarden.net/media/upload/6/6e/Spr_RS_Roxanne.png', 'Rustboro City', 3),
( 'Brawly', 'https://archives.bulbagarden.net/media/upload/3/3e/Spr_RS_Brawly.png', 'Dewford Town', 3),
( 'Wattson', 'https://archives.bulbagarden.net/media/upload/2/2a/Spr_RS_Wattson.png', 'Mauville City', 3),
( 'Flannery', 'https://archives.bulbagarden.net/media/upload/6/6f/Spr_RS_Flannery.png', 'Lavaridge Town', 3),
( 'Norman', 'https://archives.bulbagarden.net/media/upload/8/8b/Spr_RS_Norman.png', 'Petalburg City', 3),
( 'Winona', 'https://archives.bulbagarden.net/media/upload/5/5c/Spr_RS_Winona.png', 'Fortree City', 3),
( 'Tate & Liza', 'https://archives.bulbagarden.net/media/upload/6/6e/Spr_RS_Tate_and_Liza.png', 'Mossdeep City', 3),
( 'Wallace', 'https://archives.bulbagarden.net/media/upload/5/5b/Spr_RS_Wallace.png', 'Sootopolis City', 3);


-- Times de Hoenn
INSERT INTO timePokemon (idLider, nomeTime, data_criacao) VALUES
(17, 'Time de Roxanne', NOW()),
(18, 'Time de Brawly', NOW()),
(19, 'Time de Wattson', NOW()),
(20, 'Time de Flannery', NOW()),
(21, 'Time de Norman', NOW()),
(22, 'Time de Winona', NOW()),
(23, 'Time de Tate & Liza', NOW()),
(24, 'Time de Wallace', NOW());

-- Líderes de Sinnoh (idRegiao = 4)
INSERT INTO liderGinasio (nomeLider, imagemUrl, cidade, idRegiao) VALUES
('Roark', 'https://archives.bulbagarden.net/media/upload/3/33/Spr_DP_Roark.png', 'Oreburgh City', 4),
('Gardenia', 'https://archives.bulbagarden.net/media/upload/6/6d/Spr_DP_Gardenia.png', 'Eterna City', 4),
('Maylene', 'https://archives.bulbagarden.net/media/upload/0/0d/Spr_DP_Maylene.png', 'Veilstone City', 4),
('Wake', 'https://archives.bulbagarden.net/media/upload/9/9b/Spr_DP_Wake.png', 'Pastoria City', 4),
('Fantina', 'https://archives.bulbagarden.net/media/upload/6/6d/Spr_DP_Fantina.png', 'Hearthome City', 4),
('Byron', 'https://archives.bulbagarden.net/media/upload/4/4b/Spr_DP_Byron.png', 'Canalave City', 4),
('Candice', 'https://archives.bulbagarden.net/media/upload/3/3e/Spr_DP_Candice.png', 'Snowpoint City', 4),
('Volkner', 'https://archives.bulbagarden.net/media/upload/3/3f/Spr_DP_Volkner.png', 'Sunyshore City', 4);

-- Times de Sinnoh
INSERT INTO timePokemon (idLider, nomeTime, data_criacao) VALUES
(25, 'Time de Roark', NOW()),
(26, 'Time de Gardenia', NOW()),
(27, 'Time de Maylene', NOW()),
(28, 'Time de Wake', NOW()),
(29, 'Time de Fantina', NOW()),
(30, 'Time de Byron', NOW()),
(31, 'Time de Candice', NOW()),
(32, 'Time de Volkner', NOW());


-- Líderes de Unova
INSERT INTO liderGinasio (nomeLider, imagemUrl, cidade, idRegiao) VALUES
('Cilan', 'https://archives.bulbagarden.net/media/upload/3/3b/Spr_BW_Cilan.png', 'Striaton City', 5),
('Chili', 'https://archives.bulbagarden.net/media/upload/4/4e/Spr_BW_Chili.png', 'Striaton City', 5),
('Cress', 'https://archives.bulbagarden.net/media/upload/0/0d/Spr_BW_Cress.png', 'Striaton City', 5),
('Lenora', 'https://archives.bulbagarden.net/media/upload/0/0f/Spr_BW_Lenora.png', 'Nacrene City', 5),
('Burgh', 'https://archives.bulbagarden.net/media/upload/0/0a/Spr_BW_Burgh.png', 'Castelia City', 5),
('Elesa', 'https://archives.bulbagarden.net/media/upload/3/3a/Spr_BW_Elesa.png', 'Nimbasa City', 5),
('Clay', 'https://archives.bulbagarden.net/media/upload/3/3d/Spr_BW_Clay.png', 'Driftveil City', 5),
('Skyla', 'https://archives.bulbagarden.net/media/upload/5/5e/Spr_BW_Skyla.png', 'Mistralton City', 5),
('Brycen', 'https://archives.bulbagarden.net/media/upload/1/1a/Spr_BW_Brycen.png', 'Icirrus City', 5),
('Drayden', 'https://archives.bulbagarden.net/media/upload/8/8c/Spr_BW_Drayden.png', 'Opelucid City', 5);

-- Times de Unova
INSERT INTO timePokemon (idLider, nomeTime, data_criacao) VALUES
(33, 'Time de Cilan', NOW()),
(34, 'Time de Chili', NOW()),
(35, 'Time de Cress', NOW()),
(36, 'Time de Lenora', NOW()),
(37, 'Time de Burgh', NOW()),
(38, 'Time de Elesa', NOW()),
(39, 'Time de Clay', NOW()),
(40, 'Time de Skyla', NOW()),
(41, 'Time de Brycen', NOW()),
(42, 'Time de Drayden', NOW());

-- Líderes de Kalos
INSERT INTO liderGinasio (nomeLider, imagemUrl, cidade, idRegiao) VALUES
('Viola', 'https://archives.bulbagarden.net/media/upload/0/0e/Spr_XY_Viola.png', 'Santalune City', 6),
('Grant', 'https://archives.bulbagarden.net/media/upload/1/1f/Spr_XY_Grant.png', 'Cyllage City', 6),
('Korrina', 'https://archives.bulbagarden.net/media/upload/9/9c/Spr_XY_Korrina.png', 'Shalour City', 6),
('Ramos', 'https://archives.bulbagarden.net/media/upload/2/2e/Spr_XY_Ramos.png', 'Coumarine City', 6),
('Clemont', 'https://archives.bulbagarden.net/media/upload/5/5f/Spr_XY_Clemont.png', 'Lumiose City', 6),
('Valerie', 'https://archives.bulbagarden.net/media/upload/4/4d/Spr_XY_Valerie.png', 'Laverre City', 6),
('Olympia', 'https://archives.bulbagarden.net/media/upload/5/5e/Spr_XY_Olympia.png', 'Anistar City', 6),
('Wulfric', 'https://archives.bulbagarden.net/media/upload/5/5f/Spr_XY_Wulfric.png', 'Snowbelle City', 6);

-- Times de Kalos
INSERT INTO timePokemon (idLider, nomeTime, data_criacao) VALUES
(41, 'Time de Viola', NOW()),
(42, 'Time de Grant', NOW()),
(43, 'Time de Korrina', NOW()),
(44, 'Time de Ramos', NOW()),
(45, 'Time de Clemont', NOW()),
(46, 'Time de Valerie', NOW()),
(47, 'Time de Olympia', NOW()),
(48, 'Time de Wulfric', NOW());

-- Kahunas e Líderes de Prova de Alola
INSERT INTO liderGinasio (nomeLider, imagemUrl, cidade, idRegiao) VALUES
('Hala', 'https://archives.bulbagarden.net/media/upload/7/7a/Spr_SM_Hala.png', 'Iki Town', 7),
('Olivia', 'https://archives.bulbagarden.net/media/upload/6/6a/Spr_SM_Olivia.png', 'Konikoni City', 7),
('Nanu', 'https://archives.bulbagarden.net/media/upload/2/2b/Spr_SM_Nanu.png', 'Po Town', 7),
('Hapu', 'https://archives.bulbagarden.net/media/upload/4/4e/Spr_SM_Hapu.png', 'Vast Poni Canyon', 7);

-- Times de Alola
INSERT INTO timePokemon (idLider, nomeTime, data_criacao) VALUES
(49, 'Time de Hala', NOW()),
(50, 'Time de Olivia', NOW()),
(51, 'Time de Nanu', NOW()),
(52, 'Time de Hapu', NOW());

-- Líderes de Galar
INSERT INTO liderGinasio (nomeLider, imagemUrl, cidade, idRegiao) VALUES
('Milo', 'https://archives.bulbagarden.net/media/upload/6/6c/SwSh_Milo.png', 'Turffield', 8),
('Nessa', 'https://archives.bulbagarden.net/media/upload/3/3e/SwSh_Nessa.png', 'Hulbury', 8),
('Kabu', 'https://archives.bulbagarden.net/media/upload/8/8c/SwSh_Kabu.png', 'Motostoke', 8),
('Bea', 'https://archives.bulbagarden.net/media/upload/5/5e/SwSh_Bea.png', 'Stow-on-Side', 8),
('Allister', 'https://archives.bulbagarden.net/media/upload/1/1b/SwSh_Allister.png', 'Stow-on-Side', 8),
('Opal', 'https://archives.bulbagarden.net/media/upload/1/1e/SwSh_Opal.png', 'Ballonlea', 8),
('Gordie', 'https://archives.bulbagarden.net/media/upload/7/7a/SwSh_Gordie.png', 'Circhester', 8),
('Melony', 'https://archives.bulbagarden.net/media/upload/3/3a/SwSh_Melony.png', 'Circhester', 8),
('Piers', 'https://archives.bulbagarden.net/media/upload/1/1f/SwSh_Piers.png', 'Spikemuth', 8),
('Raihan', 'https://archives.bulbagarden.net/media/upload/3/3c/SwSh_Raihan.png', 'Hammerlocke', 8);

-- Times de Galar
INSERT INTO timePokemon (idLider, nomeTime, data_criacao) VALUES
(53, 'Time de Milo', NOW()),
(54, 'Time de Nessa', NOW()),
(55, 'Time de Kabu', NOW()),
(56, 'Time de Bea/Allister', NOW()),  -- Depende da versão (Espada/Escudo)
(57, 'Time de Opal', NOW()),
(58, 'Time de Gordie/Melony', NOW()), -- Depende da versão
(59, 'Time de Piers', NOW()),
(60, 'Time de Raihan', NOW());

-- Líderes de Ginásio de Paldea
INSERT INTO liderGinasio (nomeLider, imagemUrl, cidade, idRegiao) VALUES
('Katy', 'https://archives.bulbagarden.net/media/upload/thumb/5/5e/SV_Katy.png/250px-SV_Katy.png', 'Cortondo', 9),
('Brassius', 'https://archives.bulbagarden.net/media/upload/thumb/9/9e/SV_Brassius.png/250px-SV_Brassius.png', 'Artazon', 9),
('Iono', 'https://archives.bulbagarden.net/media/upload/thumb/4/4b/SV_Iono.png/250px-SV_Iono.png', 'Levincia', 9),
('Kofu', 'https://archives.bulbagarden.net/media/upload/thumb/1/1e/SV_Kofu.png/250px-SV_Kofu.png', 'Cascarrafa', 9),
('Larry', 'https://archives.bulbagarden.net/media/upload/thumb/1/1e/SV_Larry.png/250px-SV_Larry.png', 'Medali', 9),
('Ryme', 'https://archives.bulbagarden.net/media/upload/thumb/4/4b/SV_Ryme.png/250px-SV_Ryme.png', 'Montenevera', 9),
('Tulip', 'https://archives.bulbagarden.net/media/upload/thumb/0/0a/SV_Tulip.png/250px-SV_Tulip.png', 'Alfornada', 9),
('Grusha', 'https://archives.bulbagarden.net/media/upload/thumb/5/5a/SV_Grusha.png/250px-SV_Grusha.png', 'Glaseado Mountain', 9);

-- Times de Paldea
INSERT INTO timePokemon (idLider, nomeTime, data_criacao) VALUES
(61, 'Time de Katy', NOW()),
(62, 'Time de Brassius', NOW()),
(63, 'Time de Iono', NOW()),
(64, 'Time de Kofu', NOW()),
(65, 'Time de Larry', NOW()),
(66, 'Time de Ryme', NOW()),
(67, 'Time de Tulip', NOW()),
(68, 'Time de Grusha', NOW());

-- 3. INSERIR OS MEMBROS DOS TIMES
-- Time de Brock (Pedra/Terra)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(1, 1, 1), (1, 2, 2);

-- Time de Misty (Água)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(2, 13, 1), (2, 48, 2);

select * from timePokemon_membros;
-- Time de Lt. Surge (Elétrico)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(3, 9, 1), (3, 42, 2), (3, 43, 3);

-- Time de Erika (Planta)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(4, 57, 1), (4, 17, 2), (4, 54, 3);

-- Time de Koga (Venenoso)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(5, 22, 1), (5, 62, 2), (5, 22, 3), (5, 61, 4);

-- Time de Sabrina (Psíquico)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(6, 70, 1), (6, 29, 2), (6, 71, 3);

-- Time de Blaine (Fogo)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(7, 31, 1), (7, 32, 2), (7, 75, 3), (7, 74, 4);

-- Time de Giovanni (Terra)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(8, 3, 1), (8, 7, 2), (8, 64, 3), (8, 66, 4), (8, 38, 5);

-- JOHTO

-- Time de Falkner (Voador)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(9, 77, 1), (9, 89, 2);

-- Time de Bugsy (Inseto)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(10, 105, 1), (10, 107, 2), (10, 83, 3);

-- Time de Whitney (Normal)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(11, 91, 1), (11, 79, 2);

-- Time de Morty (Fantasma)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(12, 85, 1), (12, 98, 2), (12, 98, 3), (12, 99, 4);

-- Time de Chuck (Lutador)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(13, 86, 1), (13, 51, 2);

-- Time de Jasmine (Aço)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(14, 10, 1), (14, 10, 2), (14, 37, 3);

-- Time de Pryce (Gelo)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(15, 88, 1), (15, 103, 2), (15, 101, 3);

-- Time de Clair (Dragão)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(16, 104, 1), (16, 93, 2), (16, 93, 3), (16, 96, 4);

-- HOENN

-- Time da Roxanne (Pedra)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(17, 1, 1), 
(17, 125, 2);

-- Time de Brawly (Lutador)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(18, 110, 1), (18, 111, 2);  -- Makuhita e Meditite

-- Time de Wattson (Elétrico)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(19, 10, 1), (19, 9, 2), (19, 45, 3);    -- Electrike e Voltorb

-- Time de Flannery (Fogo)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(20, 33, 1), (20, 33, 2), (20, 34, 3);   -- Torkoal e Slugma

-- Time de Norman (Normal)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(21, 122, 1), (21, 121, 2), (21, 122, 3);  -- Slakoth, Vigoroth, Slaking

-- Time de Winona (Voador)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(22, 131, 1), (22, 129, 2), (22, 127, 3), (22, 123, 4);  -- Swablu, Altaria, Skarmory

-- Time de Tate & Liza (Psíquico)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(23, 132, 1), (23, 133, 2);  -- Lunatone, Solrock, Claydol

-- Time de Wallace (Água)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(24, 134, 1), (24, 136, 2), (24, 138, 3), (24, 140, 4), (24, 124, 5);  -- Feebas, Milotic, Luvdisc, Whiscash

-- TIMES DE SINNOH

-- Time de Roark (Pedra)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(25, 1, 1), (25, 2, 2), (25, 141, 3);

-- Time de Gardenia (Planta)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(26, 146, 1), (26, 143, 2), (26, 55, 3);

-- Time de Maylene (Lutador)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(27, 111, 1), (27, 153, 2), (27, 149, 3);

-- Time de Wake (Água)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(28, 104, 1), (28, 176, 2), (28, 151, 3);

-- Time de Fantina (Fantasma)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(29, 178, 1), (29, 99, 2), (29, 180, 3);

-- Time de Byron (Aço)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(30, 181, 1), (30, 37, 2), (30, 184, 3);

-- Time de Candice (Gelo)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(31, 185, 1), (31, 187, 2), (31, 119, 3), (31, 186, 4);

-- Time de Volkner (Elétrico)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(32, 43, 1), (32, 193, 2), (32, 195, 3), (32, 198, 4);


-- TIMES DE UNOVA 

-- Time de Cilan/Chili/Cress (Planta/Fogo/Água)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(33, 161, 1), (33, 155, 2);  -- Cilan (Planta)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(34, 161, 1), (34, 157, 2);  -- Chili (Fogo)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(35, 161, 1), (35, 159, 2);  -- Cress (Água)


-- Time de Lenora (Normal)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(36, 162, 1), (36, 165, 2);

-- Time de Burgh (Inseto)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(37, 165, 1), (37, 166, 2), (37, 170, 3);

-- Time de Elesa (Elétrico)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(38, 173, 1), (38, 173, 2), (38, 174, 3);

-- Time de Clay (Terra)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(39, 200, 1), (39, 203, 2), (39, 206, 3);

-- Time de Skyla (Voador)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(40, 208, 1), (40, 211, 2), (40, 213, 3);

-- Time de Brycen (Gelo)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(41, 215, 1), (41, 217, 2), (41, 219, 3);

-- Time de Drayden (Dragão)
INSERT INTO timePokemon_membros (idTimePokemon, idPokemon, posicao_no_time) VALUES
(42, 221, 1), (42, 223, 2), (42, 222, 3);

SELECT liderGinasio.nomeLider AS lider, liderGinasio.cidade AS cidade, regiao.nomeRegiao, timePokemon.nomeTime AS nomeT, timePokemon_membros.posicao_no_time AS posicao,
pokemon.nome AS nomeP, pokemon.imagemUrl AS pokemon, tipoPokemon.tipo AS tipo, tipoPokemon.cor AS tipoCor
FROM timePokemon_membros
JOIN pokemon ON timePokemon_membros.idPokemon = pokemon.idPokemon
JOIN tipoPokemon ON pokemon.idTipoPokemon = tipoPokemon.idTipoPokemon
JOIN timePokemon ON timePokemon_membros.idTimePokemon = timePokemon.idTimePokemon
JOIN liderGinasio ON timePokemon.idLider = liderGinasio.idLider
JOIN regiao ON liderGinasio.idRegiao = regiao.idRegiao;