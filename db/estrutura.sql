use avuldb;

/*
DROP TABLE IF EXISTS usuario;
DROP TABLE IF EXISTS registro_atividades;
DROP TABLE IF EXISTS entrada_saida_intervalo;
DROP TABLE IF EXISTS formulario;
*/

CREATE TABLE usuario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(80) UNIQUE NOT NULL,
    senha VARCHAR(200) NOT NULL
);

CREATE TABLE registro_atividades (
    id INT PRIMARY KEY AUTO_INCREMENT,
    atividade_iniciada ENUM("Viagem de acompanhamento de Condutor", "Apoio à operação / Fiscalização e Reciclagens", "Avaliação de condutor (experiência e 70 horas)"),
    /*Atividade Iniciada
    V -> Viagem de acompanhamento de Condutor
    A -> Apoio à operação / Fiscalização e Reciclagens
    C -> Avaliação de condutor (experiência e 70 horas)*/
    
    registro TEXT NOT NULL
    
    /*
    # V
    
    # A também
    motorista VARCHAR(80) NOT NULL,
    prefixo TINYINT NOT NULL,
    numero_linha VARCHAR(5) NOT NULL,
    local_embarque VARCHAR(120) NOT NULL,
    checklist_anjo ENUM("Sim / Ok", "Não") NOT NULL,
    checklist_cinto ENUM("Sim / Ok", "Não") NOT NULL,
    checklist_limpeza ENUM("Sim / Ok", "Não") NOT NULL,
    checklist_asseio ENUM("Sim / Ok", "Não") NOT NULL,
    observacoes VARCHAR(300),
    qtd_falhas_operacionais ENUM("Sem falhas", "1", "2", "3", "4", "5 ou +") NOT NULL,
    # Fim - A também
    descricao_observacoes VARCHAR(300),
    qtd_falhas_ctb ENUM("Sem falhas", "1", "2", "3", "4", "5 ou +") NOT NULL,
    descricao_observacoes_ctb VARCHAR(300),
    telemetria_ace ENUM("Sem falhas", "1", "2", "3", "4", "5 ou +") NOT NULL,
    telemetria_cb ENUM("Sem falhas", "1", "2", "3", "4", "5 ou +") NOT NULL,
    telemetria_fb ENUM("Sem falhas", "1", "2", "3", "4", "5 ou +") NOT NULL,
    telemetria_vel ENUM("Sem falhas", "1", "2", "3", "4", "5 ou +") NOT NULL,
    telemetria_tffv ENUM("Sem falhas", "1", "2", "3", "4", "5 ou +") NOT NULL,
    telemetria_cpa ENUM("Sem falhas", "1", "2", "3", "4", "5 ou +") NOT NULL,
    telemetria_mle ENUM("Sem falhas", "1", "2", "3", "4", "5 ou +") NOT NULL,
    descricao_observacoes_telemetria VARCHAR(300),

    # Seção 3
    local_desembarque VARCHAR(120),
	horario_inicio TIME NOT NULL,
    horario_final TIME NOT NULL,
    
    # A
    motivo ENUM(
        'Orientações / Reciclagem dos operadores',
        'Orientar desvios',
        'Participar de treinamentos / Palestras',
        'Ponto Crítico / Telemetria',
        'Sair dirigindo / Cobrando',
        'Other'
    ) NOT NULL,
    outro_motivo VARCHAR(200),
    descricao_observacoes_orientacao VARCHAR(500) NOT NULL,
    local_ponto_garagem TINYINT UNSIGNED NOT NULL,
	horario_inicio TIME NOT NULL,
    horario_final TIME NOT NULL,
    local_encerramento VARCHAR(120),
    descricao_observacoes_atividade VARCHAR(300),
    
    # C
    tipo_acompanhamento ENUM("70 horas", "Experiência") NOT NULL,
    acompanhamento ENUM("Primeiro", "Segundo", "Terceiro") NOT NULL*/
);

CREATE TABLE entrada_saida_intervalo (
    id INT PRIMARY KEY AUTO_INCREMENT,
    setor VARCHAR(20) NOT NULL,
    local_pegada VARCHAR(120),
    horario_entrada TIME NOT NULL,
    horario_saida TIME NOT NULL,
    intervalo_inicio TIME NOT NULL,
    intervalo_final TIME NOT NULL,
    local_largada VARCHAR(120) NOT NULL
);

CREATE TABLE formulario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_monitor INT NOT NULL,
    FOREIGN KEY (id_monitor)
        REFERENCES usuario (id),
    data_relatorio DATE NOT NULL,
    id_registro_atividades INT UNIQUE NULL,
    id_entrada_saida_intervalo INT UNIQUE NULL,
    FOREIGN KEY (id_registro_atividades)
        REFERENCES registro_atividades (id),
    FOREIGN KEY (id_registro_atividades)
        REFERENCES registro_atividades (id),
    CONSTRAINT apenas_um_tipo_atividade CHECK (((id_registro_atividades IS NOT NULL)
        AND (id_entrada_saida_intervalo IS NULL))
        OR ((id_registro_atividades IS NULL)
        AND (id_entrada_saida_intervalo IS NOT NULL)))
);