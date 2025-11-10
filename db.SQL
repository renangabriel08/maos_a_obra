-- ==========================================
-- CREATE DATABASE
-- ==========================================
CREATE DATABASE IF NOT EXISTS maos_a_obra;
USE maos_a_obra;

-- ==========================================
-- TABLE userTypes
-- ==========================================
CREATE TABLE userTypes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(45) NOT NULL
);

-- ==========================================
-- TABLE users
-- ==========================================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    cpf CHAR(11) UNIQUE,
    birthDate DATE,
    password VARCHAR(255) NOT NULL,
    photo VARCHAR(255),
    cnpj CHAR(14) UNIQUE,
    experience TEXT,
    userTypeId INT NOT NULL,
    FOREIGN KEY (userTypeId) REFERENCES userTypes(id)
);

-- ==========================================
-- TABLE addresses (N:1 with users)
-- ==========================================
CREATE TABLE addresses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    zipCode CHAR(8),
    state CHAR(2),
    city VARCHAR(100),
    district VARCHAR(100),
    street VARCHAR(150),
    number VARCHAR(10),
    complement VARCHAR(100),
    userId INT NOT NULL,
    FOREIGN KEY (userId) REFERENCES users(id)
);

-- ==========================================
-- TABLE posts (N:1 with users)
-- ==========================================
CREATE TABLE posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    description TEXT,
    likes INT DEFAULT 0,
    createdAt DATETIME,
    userId INT NOT NULL,
    FOREIGN KEY (userId) REFERENCES users(id)
);

-- ==========================================
-- TABLE comments (N:1 with posts)
-- ==========================================
CREATE TABLE comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    description TEXT,
    createdAt DATETIME,
    postId INT NOT NULL,
    FOREIGN KEY (postId) REFERENCES posts(id)
);

-- ==========================================
-- TABLE statuses
-- ==========================================
CREATE TABLE statuses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(45) NOT NULL
);

-- ==========================================
-- TABLE budgets (N:N with users, 1:N with statuses)
-- ==========================================
CREATE TABLE budgets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    description TEXT,
    visit BOOLEAN,
    createdAt DATETIME,
    rating TINYINT,
    feedback TEXT,
    notes TEXT,
    statusId INT NOT NULL,
    FOREIGN KEY (statusId) REFERENCES statuses(id)
);

-- Relationship N:N between users and budgets
CREATE TABLE userBudgets (
    userId INT NOT NULL,
    budgetId INT NOT NULL,
    PRIMARY KEY (userId, budgetId),
    FOREIGN KEY (userId) REFERENCES users(id),
    FOREIGN KEY (budgetId) REFERENCES budgets(id)
);

-- ==========================================
-- TABLE notificationTypes
-- ==========================================
CREATE TABLE notificationTypes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- ==========================================
-- TABLE notifications (N:1 with budgets and notificationTypes)
-- ==========================================
CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    createdAt DATETIME,
    description TEXT,
    budgetId INT NOT NULL,
    notificationTypeId INT NOT NULL,
    FOREIGN KEY (budgetId) REFERENCES budgets(id),
    FOREIGN KEY (notificationTypeId) REFERENCES notificationTypes(id)
);

-- ==========================================
-- TABLE imageTypes
-- ==========================================
CREATE TABLE imageTypes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(45) NOT NULL
);

-- ==========================================
-- TABLE images (N:1 with posts OR budgets + 1:N with imageTypes)
-- ==========================================
CREATE TABLE images (
    id INT AUTO_INCREMENT PRIMARY KEY,
    path VARCHAR(255),
    postId INT NULL,
    budgetId INT NULL,
    imageTypeId INT NOT NULL,
    FOREIGN KEY (postId) REFERENCES posts(id),
    FOREIGN KEY (budgetId) REFERENCES budgets(id),
    FOREIGN KEY (imageTypeId) REFERENCES imageTypes(id),
    CHECK (
        (postId IS NOT NULL AND budgetId IS NULL) OR 
        (postId IS NULL AND budgetId IS NOT NULL)
    )
);

-- ==========================================
-- TABLE specialties
-- ==========================================
CREATE TABLE specialties (
    id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(45) NOT NULL
);

-- Relationship N:N between users and specialties
CREATE TABLE userSpecialties (
    userId INT NOT NULL,
    specialtyId INT NOT NULL,
    PRIMARY KEY (userId, specialtyId),
    FOREIGN KEY (userId) REFERENCES users(id),
    FOREIGN KEY (specialtyId) REFERENCES specialties(id)
);

-- ==========================================
-- SEED DATA
-- ==========================================

-- User types
INSERT INTO userTypes (description) VALUES
("super_admin"),
("admin"),
("service_provider"),
("client");

-- Statuses (lowercase)
INSERT INTO statuses (description) VALUES
("solicitado"),
("cancelado"),
("recusado"),
("visita_agendada"),
("nova_data_sugerida_cliente"),
("nova_data_sugerida_prestador"),
("visita_confirmada"),
("visita_realizada"),
("servico_realizado"),
("servico_finalizado"),
("servico_avaliado"),

-- Notification types
INSERT INTO notificationTypes (name) VALUES
("orcamento_solicitacao"),
("orcamento_resposta"),
("visita_confirmacao"),
("orcamento_aceito"),
("orcamento_recusado"),
("avaliacao"),
("visita_pendente_confirmacao"),
("visita_remarcada"),
("visita_realizada"),
("nova_data_sugerida"),
("visita_agendada"),
("confirmacao_visita_cliente"),
("data_sugerida_cliente"),
("visita_confirmada"),
("servico_iniciado"),
("servico_concluido");

-- Image types
INSERT INTO imageTypes (name) VALUES
("post"),
("orcamento_antes"),
("orcamento_depois");

-- Specialties
INSERT INTO specialties (description) VALUES
("diarista"),
("montador"),
("designer"),
("pedreiro"),
("pintor"),
("decorador"),
("faxineiro"),
("marceneiro"),
("vidraceiro"),
("limpeza de piscina"),
("desentupidor"),
("outros");