-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : mer. 27 nov. 2024 à 09:43
-- Version du serveur : 8.3.0
-- Version de PHP : 8.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `parrainage`
--

-- --------------------------------------------------------

--
-- Structure de la table `options_questions`
--

DROP TABLE IF EXISTS `options_questions`;
CREATE TABLE IF NOT EXISTS `options_questions` (
  `option_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `question_id` smallint UNSIGNED NOT NULL,
  `texte_option` text COLLATE utf8mb4_bin NOT NULL,
  `scores_personnalite` json DEFAULT NULL,
  PRIMARY KEY (`option_id`),
  KEY `idx_question` (`question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Structure de la table `profils_personnalite`
--

DROP TABLE IF EXISTS `profils_personnalite`;
CREATE TABLE IF NOT EXISTS `profils_personnalite` (
  `profil_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `utilisateur_id` int UNSIGNED NOT NULL,
  `type_id` smallint UNSIGNED NOT NULL,
  `derniere_maj` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`profil_id`),
  UNIQUE KEY `idx_utilisateur` (`utilisateur_id`),
  KEY `idx_type` (`type_id`),
  KEY `idx_derniere_maj` (`derniere_maj`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Structure de la table `questionnaire`
--

DROP TABLE IF EXISTS `questionnaire`;
CREATE TABLE IF NOT EXISTS `questionnaire` (
  `question_id` smallint UNSIGNED NOT NULL AUTO_INCREMENT,
  `texte_question` text COLLATE utf8mb4_bin NOT NULL,
  `categorie` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `est_actif` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`question_id`),
  KEY `idx_categorie` (`categorie`),
  KEY `idx_est_actif` (`est_actif`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Structure de la table `regles_compatibilite`
--

DROP TABLE IF EXISTS `regles_compatibilite`;
CREATE TABLE IF NOT EXISTS `regles_compatibilite` (
  `regle_id` smallint UNSIGNED NOT NULL AUTO_INCREMENT,
  `type_id` smallint UNSIGNED NOT NULL,
  `seuil_compatibilite` tinyint UNSIGNED NOT NULL,
  `description` text COLLATE utf8mb4_bin,
  PRIMARY KEY (`regle_id`),
  UNIQUE KEY `idx_type` (`type_id`),
  KEY `idx_seuil` (`seuil_compatibilite`)
) ENGINE=InnoDB;

-- --------------------------------------------------------

--
-- Structure de la table `relations_parrainage`
--

DROP TABLE IF EXISTS `relations_parrainage`;
CREATE TABLE IF NOT EXISTS `relations_parrainage` (
  `relation_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `parrain_id` int UNSIGNED NOT NULL,
  `filleul_id` int UNSIGNED NOT NULL,
  `date_debut` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `date_fin` timestamp NULL DEFAULT NULL,
  `statut` enum('ACTIF','TERMINE') COLLATE utf8mb4_bin DEFAULT 'ACTIF',
  `score_compatibilite` tinyint UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`relation_id`),
  KEY `idx_parrain` (`parrain_id`),
  KEY `idx_filleul` (`filleul_id`),
  KEY `idx_statut` (`statut`),
  KEY `idx_dates` (`date_debut`, `date_fin`),
  KEY `idx_score` (`score_compatibilite`)
) ENGINE=InnoDB;

-- --------------------------------------------------------

--
-- Structure de la table `reponses_utilisateurs`
--

DROP TABLE IF EXISTS `reponses_utilisateurs`;
CREATE TABLE IF NOT EXISTS `reponses_utilisateurs` (
  `reponse_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `utilisateur_id` int UNSIGNED NOT NULL,
  `question_id` smallint UNSIGNED NOT NULL,
  `option_id` int UNSIGNED NOT NULL,
  `date_reponse` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`reponse_id`),
  KEY `idx_utilisateur_question` (`utilisateur_id`,`question_id`),
  KEY `question_id` (`question_id`),
  KEY `option_id` (`option_id`),
  KEY `idx_date` (`date_reponse`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Structure de la table `scores_personnalite`
--

DROP TABLE IF EXISTS `scores_personnalite`;
CREATE TABLE IF NOT EXISTS `scores_personnalite` (
  `score_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `profil_id` int UNSIGNED NOT NULL,
  `type_score` varchar(30) COLLATE utf8mb4_bin NOT NULL,
  `valeur_score` tinyint UNSIGNED NOT NULL,
  PRIMARY KEY (`score_id`),
  UNIQUE KEY `idx_profil_type` (`profil_id`,`type_score`),
  KEY `idx_valeur` (`valeur_score`)
) ENGINE=InnoDB;

-- --------------------------------------------------------

--
-- Structure de la table `types_personnalite`
--

DROP TABLE IF EXISTS `types_personnalite`;
CREATE TABLE IF NOT EXISTS `types_personnalite` (
  `type_id` smallint UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom_type` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `description` text COLLATE utf8mb4_bin,
  `est_actif` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`type_id`),
  UNIQUE KEY `idx_nom_type` (`nom_type`),
  KEY `idx_est_actif` (`est_actif`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Structure de la table `utilisateurs`
--

DROP TABLE IF EXISTS `utilisateurs`;
CREATE TABLE IF NOT EXISTS `utilisateurs` (
  `utilisateur_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `prenom` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `nom` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_bin NOT NULL,
  `mot_de_passe_hash` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `date_creation` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `est_actif` tinyint(1) DEFAULT '1',
  `niveau_generation` tinyint UNSIGNED NOT NULL,
  PRIMARY KEY (`utilisateur_id`),
  UNIQUE KEY `idx_email` (`email`),
  KEY `idx_nom_prenom` (`nom`, `prenom`),
  KEY `idx_est_actif` (`est_actif`),
  KEY `idx_niveau` (`niveau_generation`),
  KEY `idx_date_creation` (`date_creation`)
) ENGINE=InnoDB;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `options_questions`
--
ALTER TABLE `options_questions`
  ADD CONSTRAINT `options_questions_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `questionnaire` (`question_id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `profils_personnalite`
--
ALTER TABLE `profils_personnalite`
  ADD CONSTRAINT `profils_personnalite_ibfk_1` FOREIGN KEY (`utilisateur_id`) REFERENCES `utilisateurs` (`utilisateur_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `profils_personnalite_ibfk_2` FOREIGN KEY (`type_id`) REFERENCES `types_personnalite` (`type_id`);

--
-- Contraintes pour la table `regles_compatibilite`
--
ALTER TABLE `regles_compatibilite`
  ADD CONSTRAINT `regles_compatibilite_ibfk_1` FOREIGN KEY (`type_id`) REFERENCES `types_personnalite` (`type_id`);

--
-- Contraintes pour la table `relations_parrainage`
--
ALTER TABLE `relations_parrainage`
  ADD CONSTRAINT `relations_parrainage_ibfk_1` FOREIGN KEY (`parrain_id`) REFERENCES `utilisateurs` (`utilisateur_id`),
  ADD CONSTRAINT `relations_parrainage_ibfk_2` FOREIGN KEY (`filleul_id`) REFERENCES `utilisateurs` (`utilisateur_id`);

--
-- Contraintes pour la table `reponses_utilisateurs`
--
ALTER TABLE `reponses_utilisateurs`
  ADD CONSTRAINT `reponses_utilisateurs_ibfk_1` FOREIGN KEY (`utilisateur_id`) REFERENCES `utilisateurs` (`utilisateur_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reponses_utilisateurs_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `questionnaire` (`question_id`),
  ADD CONSTRAINT `reponses_utilisateurs_ibfk_3` FOREIGN KEY (`option_id`) REFERENCES `options_questions` (`option_id`);

--
-- Contraintes pour la table `scores_personnalite`
--
ALTER TABLE `scores_personnalite`
  ADD CONSTRAINT `scores_personnalite_ibfk_1` FOREIGN KEY (`profil_id`) REFERENCES `profils_personnalite` (`profil_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
