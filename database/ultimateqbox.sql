
SET FOREIGN_KEY_CHECKS=0;

-- Dumping structure for table qbox_bec08f.bank_accounts_new
CREATE TABLE IF NOT EXISTS `bank_accounts_new` (
  `id` varchar(50) NOT NULL,
  `amount` int(11) DEFAULT 0,
  `transactions` longtext DEFAULT NULL,
  `auth` longtext DEFAULT NULL,
  `isFrozen` int(11) DEFAULT 0,
  `creator` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.bans
CREATE TABLE IF NOT EXISTS `bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `discord` varchar(50) DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `expire` int(11) DEFAULT NULL,
  `bannedby` varchar(255) NOT NULL DEFAULT 'LeBanhammer',
  PRIMARY KEY (`id`),
  KEY `license` (`license`),
  KEY `discord` (`discord`),
  KEY `ip` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.bucko_garages
CREATE TABLE IF NOT EXISTS `bucko_garages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'car',
  `coords` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.darkchat_bans
CREATE TABLE IF NOT EXISTS `darkchat_bans` (
  `room_id` varchar(40) NOT NULL,
  `citizenid` varchar(60) NOT NULL,
  `banned_at` bigint(20) NOT NULL,
  PRIMARY KEY (`room_id`,`citizenid`),
  KEY `idx_fk_darkchat_bans_room` (`room_id`),
  CONSTRAINT `fk_darkchat_bans_room` FOREIGN KEY (`room_id`) REFERENCES `darkchat_rooms` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.darkchat_members
CREATE TABLE IF NOT EXISTS `darkchat_members` (
  `room_id` varchar(40) NOT NULL,
  `citizenid` varchar(60) NOT NULL,
  `joined_at` bigint(20) NOT NULL,
  `notifications` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`room_id`,`citizenid`),
  KEY `citizenid` (`citizenid`),
  KEY `idx_fk_darkchat_members_room` (`room_id`),
  CONSTRAINT `fk_darkchat_members_room` FOREIGN KEY (`room_id`) REFERENCES `darkchat_rooms` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.darkchat_messages
CREATE TABLE IF NOT EXISTS `darkchat_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `room_id` varchar(40) NOT NULL,
  `citizenid` varchar(60) DEFAULT NULL,
  `author` varchar(40) NOT NULL,
  `body` text NOT NULL,
  `created_at` bigint(20) NOT NULL,
  `kind` varchar(16) NOT NULL DEFAULT 'text',
  `meta` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `room_id` (`room_id`,`id`),
  KEY `idx_fk_darkchat_messages_room` (`room_id`),
  CONSTRAINT `fk_darkchat_messages_room` FOREIGN KEY (`room_id`) REFERENCES `darkchat_rooms` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.darkchat_nicknames
CREATE TABLE IF NOT EXISTS `darkchat_nicknames` (
  `citizenid` varchar(60) NOT NULL,
  `nickname` varchar(40) NOT NULL,
  PRIMARY KEY (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.darkchat_reactions
CREATE TABLE IF NOT EXISTS `darkchat_reactions` (
  `message_id` int(11) NOT NULL,
  `citizenid` varchar(60) NOT NULL,
  `emoji` varchar(32) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`message_id`,`citizenid`,`emoji`),
  KEY `message_id` (`message_id`),
  KEY `idx_fk_darkchat_reactions_message` (`message_id`),
  CONSTRAINT `fk_darkchat_reactions_message` FOREIGN KEY (`message_id`) REFERENCES `darkchat_messages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.darkchat_rooms
CREATE TABLE IF NOT EXISTS `darkchat_rooms` (
  `id` varchar(40) NOT NULL,
  `code` varchar(16) NOT NULL,
  `name` varchar(60) NOT NULL,
  `owner` varchar(60) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  `code_changed_at` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.dealers
CREATE TABLE IF NOT EXISTS `dealers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '0',
  `coords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `time` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `createdby` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.lapraces
CREATE TABLE IF NOT EXISTS `lapraces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `checkpoints` text DEFAULT NULL,
  `records` text DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `distance` int(11) DEFAULT NULL,
  `raceid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `raceid` (`raceid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.management_outfits
CREATE TABLE IF NOT EXISTS `management_outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_name` varchar(50) NOT NULL,
  `type` varchar(50) NOT NULL,
  `minrank` int(11) NOT NULL DEFAULT 0,
  `name` varchar(50) NOT NULL DEFAULT 'Cool Outfit',
  `gender` varchar(50) NOT NULL DEFAULT 'male',
  `model` varchar(50) DEFAULT NULL,
  `props` text DEFAULT NULL,
  `components` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.marketplace_listings
CREATE TABLE IF NOT EXISTS `marketplace_listings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(60) NOT NULL,
  `title` varchar(80) NOT NULL,
  `body` text NOT NULL,
  `price` bigint(20) DEFAULT NULL,
  `image` varchar(512) DEFAULT NULL,
  `images` text DEFAULT NULL,
  `number` varchar(20) NOT NULL,
  `email` varchar(128) DEFAULT NULL,
  `status` varchar(12) NOT NULL DEFAULT 'published',
  `publish_at` bigint(20) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `created_at` (`created_at`),
  KEY `status_publish_at` (`status`,`publish_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.motel_rooms
CREATE TABLE IF NOT EXISTS `motel_rooms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) NOT NULL,
  `room_bucket` int(11) NOT NULL,
  `entry_door_index` int(11) DEFAULT 1,
  `is_inside` tinyint(1) DEFAULT 0,
  `purchased_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `citizenid` (`citizenid`),
  KEY `idx_citizenid` (`citizenid`),
  KEY `idx_bucket` (`room_bucket`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.npwd_calls
CREATE TABLE IF NOT EXISTS `npwd_calls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `transmitter` varchar(255) NOT NULL,
  `receiver` varchar(255) NOT NULL,
  `is_accepted` tinyint(4) DEFAULT 0,
  `isAnonymous` tinyint(4) NOT NULL DEFAULT 0,
  `start` varchar(255) DEFAULT NULL,
  `end` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.npwd_darkchat_channel_members
CREATE TABLE IF NOT EXISTS `npwd_darkchat_channel_members` (
  `channel_id` int(11) NOT NULL,
  `user_identifier` varchar(255) NOT NULL,
  `is_owner` tinyint(4) NOT NULL DEFAULT 0,
  KEY `npwd_darkchat_channel_members_npwd_darkchat_channels_id_fk` (`channel_id`) USING BTREE,
  CONSTRAINT `npwd_darkchat_channel_members_npwd_darkchat_channels_id_fk` FOREIGN KEY (`channel_id`) REFERENCES `npwd_darkchat_channels` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.npwd_darkchat_channels
CREATE TABLE IF NOT EXISTS `npwd_darkchat_channels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel_identifier` varchar(191) NOT NULL,
  `label` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `darkchat_channels_channel_identifier_uindex` (`channel_identifier`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.npwd_darkchat_messages
CREATE TABLE IF NOT EXISTS `npwd_darkchat_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel_id` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `user_identifier` varchar(255) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_image` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `darkchat_messages_darkchat_channels_id_fk` (`channel_id`) USING BTREE,
  CONSTRAINT `darkchat_messages_darkchat_channels_id_fk` FOREIGN KEY (`channel_id`) REFERENCES `npwd_darkchat_channels` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.npwd_marketplace_listings
CREATE TABLE IF NOT EXISTS `npwd_marketplace_listings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `number` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `description` varchar(255) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `reported` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.npwd_match_profiles
CREATE TABLE IF NOT EXISTS `npwd_match_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(90) NOT NULL,
  `image` varchar(255) NOT NULL,
  `bio` varchar(512) DEFAULT NULL,
  `location` varchar(45) DEFAULT NULL,
  `job` varchar(45) DEFAULT NULL,
  `tags` varchar(255) NOT NULL DEFAULT '',
  `voiceMessage` varchar(512) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier_UNIQUE` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.npwd_match_views
CREATE TABLE IF NOT EXISTS `npwd_match_views` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `profile` int(11) NOT NULL,
  `liked` tinyint(4) DEFAULT 0,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `match_profile_idx` (`profile`),
  KEY `identifier` (`identifier`),
  CONSTRAINT `match_profile` FOREIGN KEY (`profile`) REFERENCES `npwd_match_profiles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.npwd_messages
CREATE TABLE IF NOT EXISTS `npwd_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `user_identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `conversation_id` varchar(512) NOT NULL,
  `isRead` tinyint(4) NOT NULL DEFAULT 0,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `visible` tinyint(4) NOT NULL DEFAULT 1,
  `author` varchar(255) NOT NULL,
  `is_embed` tinyint(4) NOT NULL DEFAULT 0,
  `embed` varchar(512) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `user_identifier` (`user_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.npwd_messages_conversations
CREATE TABLE IF NOT EXISTS `npwd_messages_conversations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `conversation_list` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `label` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '',
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_message_id` int(11) DEFAULT NULL,
  `is_group_chat` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.npwd_messages_participants
CREATE TABLE IF NOT EXISTS `npwd_messages_participants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `conversation_id` int(11) NOT NULL,
  `participant` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `unread_count` int(11) DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `message_participants_npwd_messages_conversations_id_fk` (`conversation_id`) USING BTREE,
  CONSTRAINT `message_participants_npwd_messages_conversations_id_fk` FOREIGN KEY (`conversation_id`) REFERENCES `npwd_messages_conversations` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.npwd_notes
CREATE TABLE IF NOT EXISTS `npwd_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.npwd_phone_contacts
CREATE TABLE IF NOT EXISTS `npwd_phone_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `number` varchar(20) DEFAULT NULL,
  `display` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.npwd_phone_gallery
CREATE TABLE IF NOT EXISTS `npwd_phone_gallery` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `image` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.npwd_twitter_likes
CREATE TABLE IF NOT EXISTS `npwd_twitter_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) NOT NULL,
  `tweet_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_combination` (`profile_id`,`tweet_id`),
  KEY `profile_idx` (`profile_id`),
  KEY `tweet_idx` (`tweet_id`),
  CONSTRAINT `profile` FOREIGN KEY (`profile_id`) REFERENCES `npwd_twitter_profiles` (`id`),
  CONSTRAINT `tweet` FOREIGN KEY (`tweet_id`) REFERENCES `npwd_twitter_tweets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.npwd_twitter_profiles
CREATE TABLE IF NOT EXISTS `npwd_twitter_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_name` varchar(90) NOT NULL,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `avatar_url` varchar(255) DEFAULT 'https://i.fivemanage.com/images/3ClWwmpwkFhL.png',
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `profile_name_UNIQUE` (`profile_name`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.npwd_twitter_reports
CREATE TABLE IF NOT EXISTS `npwd_twitter_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) NOT NULL,
  `tweet_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_combination` (`profile_id`,`tweet_id`),
  KEY `profile_idx` (`profile_id`),
  KEY `tweet_idx` (`tweet_id`),
  CONSTRAINT `report_profile` FOREIGN KEY (`profile_id`) REFERENCES `npwd_twitter_profiles` (`id`),
  CONSTRAINT `report_tweet` FOREIGN KEY (`tweet_id`) REFERENCES `npwd_twitter_tweets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.npwd_twitter_tweets
CREATE TABLE IF NOT EXISTS `npwd_twitter_tweets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `likes` int(11) NOT NULL DEFAULT 0,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `visible` tinyint(4) NOT NULL DEFAULT 1,
  `images` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '',
  `retweet` int(11) DEFAULT NULL,
  `profile_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `npwd_twitter_tweets_npwd_twitter_profiles_id_fk` (`profile_id`) USING BTREE,
  CONSTRAINT `npwd_twitter_tweets_npwd_twitter_profiles_id_fk` FOREIGN KEY (`profile_id`) REFERENCES `npwd_twitter_profiles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.occasion_vehicles
CREATE TABLE IF NOT EXISTS `occasion_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `seller` varchar(50) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `mods` text DEFAULT NULL,
  `occasionid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `occasionId` (`occasionid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.ox_doorlock
CREATE TABLE IF NOT EXISTS `ox_doorlock` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `data` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.ox_inventory
CREATE TABLE IF NOT EXISTS `ox_inventory` (
  `owner` varchar(60) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `data` longtext DEFAULT NULL,
  `lastupdated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  UNIQUE KEY `owner` (`owner`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.ox_inventory_settings
CREATE TABLE IF NOT EXISTS `ox_inventory_settings` (
  `owner` varchar(60) NOT NULL,
  `settings` longtext DEFAULT NULL,
  PRIMARY KEY (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.pages_posts
CREATE TABLE IF NOT EXISTS `pages_posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(60) NOT NULL,
  `title` varchar(80) NOT NULL,
  `body` text NOT NULL,
  `price` bigint(20) DEFAULT NULL,
  `image` varchar(512) DEFAULT NULL,
  `images` text DEFAULT NULL,
  `number` varchar(20) NOT NULL,
  `email` varchar(128) DEFAULT NULL,
  `status` varchar(12) NOT NULL DEFAULT 'published',
  `publish_at` bigint(20) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `created_at` (`created_at`),
  KEY `status_publish_at` (`status`,`publish_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_admin_audit
CREATE TABLE IF NOT EXISTS `phone_admin_audit` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `admin_cid` varchar(64) NOT NULL,
  `admin_name` varchar(64) NOT NULL DEFAULT '',
  `action` varchar(48) NOT NULL,
  `target_cid` varchar(64) DEFAULT NULL,
  `detail` varchar(512) NOT NULL DEFAULT '',
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_admin_audit_target` (`target_cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_admin_bin
CREATE TABLE IF NOT EXISTS `phone_admin_bin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(32) NOT NULL,
  `target_id` varchar(64) NOT NULL,
  `excerpt` varchar(300) NOT NULL DEFAULT '',
  `lost` varchar(120) NOT NULL DEFAULT '',
  `author_cid` varchar(64) DEFAULT NULL,
  `payload` mediumtext NOT NULL,
  `admin_cid` varchar(64) DEFAULT NULL,
  `admin_name` varchar(80) DEFAULT NULL,
  `restored_at` bigint(20) DEFAULT NULL,
  `restored_by` varchar(80) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_admin_bin_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_admin_flags
CREATE TABLE IF NOT EXISTS `phone_admin_flags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(32) NOT NULL,
  `target_id` varchar(64) NOT NULL,
  `rule_id` varchar(32) NOT NULL,
  `rule_label` varchar(64) NOT NULL,
  `matched` varchar(64) NOT NULL DEFAULT '',
  `author_cid` varchar(64) DEFAULT NULL,
  `excerpt` varchar(500) NOT NULL DEFAULT '',
  `status` varchar(16) NOT NULL DEFAULT 'open',
  `handled_by` varchar(64) DEFAULT NULL,
  `handled_name` varchar(80) DEFAULT NULL,
  `handled_at` bigint(20) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_admin_flag` (`app`,`target_id`,`rule_id`),
  KEY `idx_admin_flags_status` (`status`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_admin_mutes
CREATE TABLE IF NOT EXISTS `phone_admin_mutes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(64) NOT NULL,
  `scope` varchar(24) NOT NULL,
  `reason` varchar(200) NOT NULL DEFAULT '',
  `admin_cid` varchar(64) NOT NULL,
  `admin_name` varchar(64) NOT NULL DEFAULT '',
  `expires_at` bigint(20) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_mute` (`citizenid`,`scope`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_alarms
CREATE TABLE IF NOT EXISTS `phone_alarms` (
  `citizenid` varchar(60) NOT NULL,
  `id` varchar(40) NOT NULL,
  `hour` tinyint(3) unsigned NOT NULL,
  `minute` tinyint(3) unsigned NOT NULL,
  `label` varchar(60) NOT NULL DEFAULT '',
  `days` varchar(40) NOT NULL DEFAULT '',
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `sound` tinyint(1) NOT NULL DEFAULT 1,
  `snooze` tinyint(1) NOT NULL DEFAULT 0,
  `snooze_secs` int(11) NOT NULL DEFAULT 60,
  PRIMARY KEY (`citizenid`,`id`),
  KEY `bytime` (`citizenid`,`hour`,`minute`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_app_accounts
CREATE TABLE IF NOT EXISTS `phone_app_accounts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `app` varchar(24) NOT NULL,
  `username` varchar(64) NOT NULL,
  `display_name` varchar(50) NOT NULL DEFAULT '',
  `password_hash` varchar(255) NOT NULL,
  `email` varchar(120) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_by` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_app_username` (`app`,`username`),
  KEY `idx_app_accounts_creator` (`app`,`created_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_app_sessions
CREATE TABLE IF NOT EXISTS `phone_app_sessions` (
  `app` varchar(24) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `account_id` int(10) unsigned NOT NULL,
  `last_used` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`app`,`citizenid`,`account_id`),
  KEY `idx_app_sessions_active` (`app`,`citizenid`,`last_used`),
  KEY `idx_fk_app_sessions_account` (`account_id`),
  CONSTRAINT `fk_app_sessions_account` FOREIGN KEY (`account_id`) REFERENCES `phone_app_accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_bank_standing_orders
CREATE TABLE IF NOT EXISTS `phone_bank_standing_orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(64) NOT NULL,
  `recipient` varchar(64) NOT NULL,
  `recipient_name` varchar(80) DEFAULT NULL,
  `label` varchar(40) NOT NULL,
  `amount` bigint(20) NOT NULL,
  `run_interval` varchar(16) NOT NULL DEFAULT 'monthly',
  `next_run` bigint(20) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` bigint(20) NOT NULL,
  `last_run` bigint(20) DEFAULT NULL,
  `last_status` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `idx_standing_due` (`active`,`next_run`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_bank_transactions
CREATE TABLE IF NOT EXISTS `phone_bank_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(64) NOT NULL,
  `label` varchar(120) NOT NULL,
  `amount` bigint(20) NOT NULL,
  `category` varchar(32) NOT NULL DEFAULT 'transfer',
  `counterparty` varchar(64) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  `src_id` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_bank_tx_src` (`src_id`),
  KEY `citizenid` (`citizenid`),
  KEY `created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_birdy_dms
CREATE TABLE IF NOT EXISTS `phone_birdy_dms` (
  `id` varchar(16) NOT NULL,
  `from_handle` varchar(32) NOT NULL,
  `to_handle` varchar(32) NOT NULL,
  `body` text NOT NULL,
  `kind` varchar(16) NOT NULL DEFAULT 'text',
  `meta` text DEFAULT NULL,
  `reactions` text DEFAULT NULL,
  `read_flag` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_birdy_dms_from` (`from_handle`),
  KEY `idx_birdy_dms_to` (`to_handle`),
  KEY `idx_birdy_dms_from_created` (`from_handle`,`created_at`),
  KEY `idx_birdy_dms_to_created` (`to_handle`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_birdy_follows
CREATE TABLE IF NOT EXISTS `phone_birdy_follows` (
  `follower` varchar(32) NOT NULL,
  `target` varchar(32) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`follower`,`target`),
  KEY `idx_birdy_follows_target` (`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_birdy_likes
CREATE TABLE IF NOT EXISTS `phone_birdy_likes` (
  `post_id` varchar(16) NOT NULL,
  `handle` varchar(32) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`post_id`,`handle`),
  KEY `idx_birdy_likes_post` (`post_id`),
  KEY `idx_fk_birdy_likes_post` (`post_id`),
  CONSTRAINT `fk_birdy_likes_post` FOREIGN KEY (`post_id`) REFERENCES `phone_birdy_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_birdy_notifications
CREATE TABLE IF NOT EXISTS `phone_birdy_notifications` (
  `id` varchar(16) NOT NULL,
  `recipient` varchar(32) NOT NULL,
  `kind` varchar(16) NOT NULL,
  `actor` varchar(32) NOT NULL,
  `post_id` varchar(16) DEFAULT NULL,
  `seen` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_birdy_notifs_recipient` (`recipient`,`created_at`),
  KEY `idx_birdy_notifs_unseen` (`recipient`,`seen`),
  KEY `idx_birdy_notifs_dedupe` (`recipient`,`kind`,`actor`,`post_id`),
  KEY `idx_fk_birdy_notifications_post` (`post_id`),
  CONSTRAINT `fk_birdy_notifications_post` FOREIGN KEY (`post_id`) REFERENCES `phone_birdy_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_birdy_poll_options
CREATE TABLE IF NOT EXISTS `phone_birdy_poll_options` (
  `post_id` varchar(16) NOT NULL,
  `idx` tinyint(4) NOT NULL,
  `label` varchar(40) NOT NULL,
  PRIMARY KEY (`post_id`,`idx`),
  KEY `idx_fk_birdy_poll_options_post` (`post_id`),
  CONSTRAINT `fk_birdy_poll_options_post` FOREIGN KEY (`post_id`) REFERENCES `phone_birdy_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_birdy_poll_votes
CREATE TABLE IF NOT EXISTS `phone_birdy_poll_votes` (
  `post_id` varchar(16) NOT NULL,
  `handle` varchar(32) NOT NULL,
  `idx` tinyint(4) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`post_id`,`handle`),
  KEY `idx_birdy_poll_votes_option` (`post_id`,`idx`),
  KEY `idx_fk_birdy_poll_votes_post` (`post_id`),
  CONSTRAINT `fk_birdy_poll_votes_post` FOREIGN KEY (`post_id`) REFERENCES `phone_birdy_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_birdy_polls
CREATE TABLE IF NOT EXISTS `phone_birdy_polls` (
  `post_id` varchar(16) NOT NULL,
  `ends_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`post_id`),
  KEY `idx_fk_birdy_polls_post` (`post_id`),
  CONSTRAINT `fk_birdy_polls_post` FOREIGN KEY (`post_id`) REFERENCES `phone_birdy_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_birdy_posts
CREATE TABLE IF NOT EXISTS `phone_birdy_posts` (
  `id` varchar(16) NOT NULL,
  `author` varchar(32) NOT NULL,
  `body` text NOT NULL,
  `parent_id` varchar(16) DEFAULT NULL,
  `images` text DEFAULT NULL,
  `views` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_birdy_posts_author` (`author`),
  KEY `idx_birdy_posts_parent` (`parent_id`),
  KEY `idx_birdy_posts_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_birdy_profiles
CREATE TABLE IF NOT EXISTS `phone_birdy_profiles` (
  `handle` varchar(32) NOT NULL,
  `citizenid` varchar(64) NOT NULL DEFAULT '',
  `display_name` varchar(64) NOT NULL,
  `password` varchar(64) NOT NULL DEFAULT '',
  `bio` varchar(200) NOT NULL DEFAULT '',
  `verified` tinyint(1) NOT NULL DEFAULT 0,
  `verified_type` varchar(8) DEFAULT NULL,
  `logged_in` tinyint(1) NOT NULL DEFAULT 0,
  `join_label` varchar(32) NOT NULL DEFAULT '',
  `protected` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `avatar` varchar(512) DEFAULT NULL,
  `banner` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`handle`),
  KEY `idx_birdy_profiles_creator` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_birdy_reposts
CREATE TABLE IF NOT EXISTS `phone_birdy_reposts` (
  `post_id` varchar(16) NOT NULL,
  `handle` varchar(32) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`post_id`,`handle`),
  KEY `idx_birdy_reposts_post` (`post_id`),
  KEY `idx_fk_birdy_reposts_post` (`post_id`),
  CONSTRAINT `fk_birdy_reposts_post` FOREIGN KEY (`post_id`) REFERENCES `phone_birdy_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_blocked
CREATE TABLE IF NOT EXISTS `phone_blocked` (
  `citizenid` varchar(64) NOT NULL,
  `number` varchar(32) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`citizenid`,`number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_bluetooth
CREATE TABLE IF NOT EXISTS `phone_bluetooth` (
  `citizenid` varchar(64) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `paired` longtext DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_calendar_attendees
CREATE TABLE IF NOT EXISTS `phone_calendar_attendees` (
  `event_id` varchar(40) NOT NULL,
  `citizenid` varchar(60) NOT NULL,
  `number` varchar(24) NOT NULL,
  `name` varchar(80) NOT NULL,
  `status` varchar(10) NOT NULL DEFAULT 'pending',
  `invited_at` int(11) NOT NULL,
  `responded_at` int(11) DEFAULT NULL,
  UNIQUE KEY `uniq_event_attendee` (`event_id`,`citizenid`),
  KEY `idx_attendee_status` (`citizenid`,`status`),
  KEY `idx_fk_calendar_attendee_event` (`event_id`),
  CONSTRAINT `fk_calendar_attendee_event` FOREIGN KEY (`event_id`) REFERENCES `phone_calendar_events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_calendar_events
CREATE TABLE IF NOT EXISTS `phone_calendar_events` (
  `id` varchar(40) NOT NULL,
  `organizer` varchar(60) NOT NULL,
  `organizer_name` varchar(80) NOT NULL,
  `day_key` char(10) NOT NULL,
  `title` varchar(120) NOT NULL,
  `all_day` tinyint(1) NOT NULL DEFAULT 0,
  `start_time` varchar(5) DEFAULT NULL,
  `end_time` varchar(5) DEFAULT NULL,
  `location` varchar(120) NOT NULL DEFAULT '',
  `notes` text DEFAULT NULL,
  `color` varchar(9) NOT NULL,
  `created_at` int(11) NOT NULL,
  `updated_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_organizer_day` (`organizer`,`day_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_call_recordings
CREATE TABLE IF NOT EXISTS `phone_call_recordings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(64) NOT NULL,
  `peer_number` varchar(32) NOT NULL DEFAULT '',
  `peer_name` varchar(80) DEFAULT NULL,
  `direction` varchar(16) NOT NULL DEFAULT 'outgoing',
  `one_sided` tinyint(1) NOT NULL DEFAULT 0,
  `url` varchar(512) NOT NULL,
  `duration` int(11) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL,
  `label` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_calls
CREATE TABLE IF NOT EXISTS `phone_calls` (
  `id` varchar(16) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `number` varchar(32) NOT NULL,
  `name` varchar(64) DEFAULT NULL,
  `direction` varchar(16) NOT NULL,
  `duration` int(11) NOT NULL DEFAULT 0,
  `seen` tinyint(1) NOT NULL DEFAULT 0,
  `called_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_phone_calls_cid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_casino_chips
CREATE TABLE IF NOT EXISTS `phone_casino_chips` (
  `citizenid` varchar(64) NOT NULL,
  `chips` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_cherry_blocks
CREATE TABLE IF NOT EXISTS `phone_cherry_blocks` (
  `blocker` varchar(64) NOT NULL,
  `blocked` varchar(64) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`blocker`,`blocked`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_cherry_matches
CREATE TABLE IF NOT EXISTS `phone_cherry_matches` (
  `id` varchar(16) NOT NULL,
  `a` varchar(64) NOT NULL,
  `b` varchar(64) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_cherry_pair` (`a`,`b`),
  KEY `idx_cherry_match_b` (`b`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_cherry_messages
CREATE TABLE IF NOT EXISTS `phone_cherry_messages` (
  `id` varchar(16) NOT NULL,
  `match_id` varchar(16) NOT NULL,
  `sender` varchar(64) NOT NULL,
  `kind` varchar(16) NOT NULL DEFAULT 'text',
  `body` text DEFAULT NULL,
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`meta`)),
  `reactions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`reactions`)),
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cherry_msgs_thread` (`match_id`,`created_at`),
  KEY `idx_fk_cherry_messages_match` (`match_id`),
  CONSTRAINT `fk_cherry_messages_match` FOREIGN KEY (`match_id`) REFERENCES `phone_cherry_matches` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_cherry_profiles
CREATE TABLE IF NOT EXISTS `phone_cherry_profiles` (
  `username` varchar(64) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT '',
  `age` int(11) NOT NULL DEFAULT 21,
  `about` varchar(300) NOT NULL DEFAULT '',
  `gender` varchar(12) NOT NULL DEFAULT 'Man',
  `interested` varchar(12) NOT NULL DEFAULT 'Everyone',
  `visible` tinyint(1) NOT NULL DEFAULT 1,
  `photos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`photos`)),
  `updated_at` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_cherry_swipes
CREATE TABLE IF NOT EXISTS `phone_cherry_swipes` (
  `swiper` varchar(64) NOT NULL,
  `target` varchar(64) NOT NULL,
  `liked` tinyint(1) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`swiper`,`target`),
  KEY `idx_cherry_swipes_target` (`target`,`liked`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_cloud_accounts
CREATE TABLE IF NOT EXISTS `phone_cloud_accounts` (
  `citizenid` varchar(64) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_cloud_backups
CREATE TABLE IF NOT EXISTS `phone_cloud_backups` (
  `citizenid` varchar(64) NOT NULL,
  `identity` varchar(64) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `password` varchar(64) DEFAULT NULL,
  `device_identity` varchar(64) DEFAULT NULL,
  `auto_sync` tinyint(1) NOT NULL DEFAULT 1,
  `synced_at` bigint(20) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_cloud_profiles
CREATE TABLE IF NOT EXISTS `phone_cloud_profiles` (
  `citizenid` varchar(64) NOT NULL,
  `device_identity` varchar(64) NOT NULL,
  `identity` varchar(64) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `auto_sync` tinyint(1) NOT NULL DEFAULT 1,
  `synced_at` bigint(20) DEFAULT NULL,
  `color` varchar(32) DEFAULT NULL,
  `number` varchar(32) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`citizenid`,`device_identity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_contacts
CREATE TABLE IF NOT EXISTS `phone_contacts` (
  `id` varchar(16) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `name` varchar(64) NOT NULL,
  `phone` varchar(32) NOT NULL,
  `email` varchar(128) DEFAULT NULL,
  `address` varchar(128) DEFAULT NULL,
  `color` varchar(16) NOT NULL,
  `avatar` varchar(512) DEFAULT NULL,
  `favorite` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_phone_contacts_cid` (`citizenid`),
  KEY `idx_phone_contacts_cid_name` (`citizenid`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_cookie
CREATE TABLE IF NOT EXISTS `phone_cookie` (
  `citizenid` varchar(60) NOT NULL,
  `name` varchar(60) DEFAULT NULL,
  `nickname` varchar(40) DEFAULT NULL,
  `cookies` double NOT NULL DEFAULT 0,
  `earned` double NOT NULL DEFAULT 0,
  `owned` text DEFAULT NULL,
  `achievements` text DEFAULT NULL,
  `rain_on` tinyint(1) NOT NULL DEFAULT 1,
  `updated_at` bigint(20) NOT NULL,
  PRIMARY KEY (`citizenid`),
  KEY `earned` (`earned`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_custom_ringtones
CREATE TABLE IF NOT EXISTS `phone_custom_ringtones` (
  `citizenid` varchar(64) NOT NULL,
  `id` varchar(32) NOT NULL,
  `kind` varchar(16) NOT NULL DEFAULT 'ringtone',
  `name` varchar(64) NOT NULL,
  `url` varchar(512) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`citizenid`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_document_folders
CREATE TABLE IF NOT EXISTS `phone_document_folders` (
  `id` varchar(16) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `name` varchar(60) NOT NULL,
  `parent_id` varchar(16) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_phone_document_folders_cid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_document_signatures
CREATE TABLE IF NOT EXISTS `phone_document_signatures` (
  `id` varchar(16) NOT NULL,
  `doc_id` varchar(16) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `signer` varchar(64) NOT NULL,
  `image` mediumtext DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_phone_document_signatures_doc` (`doc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_documents
CREATE TABLE IF NOT EXISTS `phone_documents` (
  `id` varchar(16) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `folder_id` varchar(16) DEFAULT NULL,
  `name` varchar(80) NOT NULL,
  `kind` varchar(16) NOT NULL DEFAULT 'text',
  `content` mediumtext DEFAULT NULL,
  `url` varchar(1024) DEFAULT NULL,
  `size` int(11) NOT NULL DEFAULT 0,
  `locked` tinyint(1) NOT NULL DEFAULT 0,
  `signable` tinyint(1) NOT NULL DEFAULT 1,
  `deletable` tinyint(1) NOT NULL DEFAULT 1,
  `source` varchar(64) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  `updated_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_phone_documents_folder` (`citizenid`,`folder_id`),
  KEY `idx_phone_documents_updated` (`citizenid`,`updated_at`),
  KEY `idx_fk_documents_folder` (`folder_id`),
  CONSTRAINT `fk_documents_folder` FOREIGN KEY (`folder_id`) REFERENCES `phone_document_folders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_friends
CREATE TABLE IF NOT EXISTS `phone_friends` (
  `owner` varchar(60) NOT NULL,
  `friend` varchar(60) NOT NULL,
  `share` tinyint(1) NOT NULL DEFAULT 1,
  `pending` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` varchar(40) NOT NULL,
  PRIMARY KEY (`owner`,`friend`),
  KEY `idx_phone_friends_friend` (`friend`,`share`,`pending`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_game_stats
CREATE TABLE IF NOT EXISTS `phone_game_stats` (
  `citizenid` varchar(64) NOT NULL,
  `game` varchar(32) NOT NULL,
  `name` varchar(64) DEFAULT NULL,
  `cpu_wins` int(11) NOT NULL DEFAULT 0,
  `cpu_losses` int(11) NOT NULL DEFAULT 0,
  `cpu_draws` int(11) NOT NULL DEFAULT 0,
  `online_wins` int(11) NOT NULL DEFAULT 0,
  `online_losses` int(11) NOT NULL DEFAULT 0,
  `online_draws` int(11) NOT NULL DEFAULT 0,
  `chips_won` bigint(20) NOT NULL DEFAULT 0,
  `chips_lost` bigint(20) NOT NULL DEFAULT 0,
  `high_score` bigint(20) NOT NULL DEFAULT 0,
  `plays` int(11) NOT NULL DEFAULT 0,
  `last_score` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`citizenid`,`game`),
  KEY `idx_game_stats_game_high` (`game`,`high_score`),
  KEY `idx_game_stats_game_cpu` (`game`,`cpu_wins`),
  KEY `idx_game_stats_game_online` (`game`,`online_wins`),
  KEY `idx_game_stats_game_chips` (`game`,`chips_won`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_garage_images
CREATE TABLE IF NOT EXISTS `phone_garage_images` (
  `citizenid` varchar(64) NOT NULL,
  `plate` varchar(16) NOT NULL,
  `url` varchar(512) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`citizenid`,`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_group_invites
CREATE TABLE IF NOT EXISTS `phone_group_invites` (
  `id` varchar(16) NOT NULL,
  `group_id` varchar(16) NOT NULL,
  `target_cid` varchar(64) NOT NULL,
  `invited_by` varchar(64) NOT NULL,
  `invited_name` varchar(64) DEFAULT NULL,
  `sent_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_group_invites_target` (`target_cid`),
  KEY `idx_group_invites_group` (`group_id`),
  KEY `idx_fk_group_invites_group` (`group_id`),
  CONSTRAINT `fk_group_invites_group` FOREIGN KEY (`group_id`) REFERENCES `phone_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_groups
CREATE TABLE IF NOT EXISTS `phone_groups` (
  `id` varchar(16) NOT NULL,
  `name` varchar(64) NOT NULL,
  `leader_cid` varchar(64) NOT NULL,
  `color` varchar(16) NOT NULL,
  `avatar` varchar(512) DEFAULT NULL,
  `members` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`members`)),
  `invites` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`invites`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_phone_groups_leader` (`leader_cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_health_daily
CREATE TABLE IF NOT EXISTS `phone_health_daily` (
  `citizenid` varchar(64) NOT NULL,
  `day` date NOT NULL,
  `name` varchar(64) NOT NULL DEFAULT '',
  `steps` int(10) unsigned NOT NULL DEFAULT 0,
  `distance_m` int(10) unsigned NOT NULL DEFAULT 0,
  `active_ms` int(10) unsigned NOT NULL DEFAULT 0,
  `peak_hr` smallint(5) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`citizenid`,`day`),
  KEY `idx_health_day_steps` (`day`,`steps`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_id
CREATE TABLE IF NOT EXISTS `phone_id` (
  `citizenid` varchar(64) NOT NULL,
  `portrait_url` varchar(512) DEFAULT NULL,
  `portrait_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_job_fires
CREATE TABLE IF NOT EXISTS `phone_job_fires` (
  `citizenid` varchar(64) NOT NULL,
  `job` varchar(64) NOT NULL,
  PRIMARY KEY (`citizenid`,`job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_job_invites
CREATE TABLE IF NOT EXISTS `phone_job_invites` (
  `id` varchar(48) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `job` varchar(64) NOT NULL,
  `grade` int(11) NOT NULL DEFAULT 0,
  `invited_by` varchar(128) DEFAULT NULL,
  `created_at` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_invite` (`citizenid`,`job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_mail_accounts
CREATE TABLE IF NOT EXISTS `phone_mail_accounts` (
  `email` varchar(64) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `display_name` varchar(64) NOT NULL,
  `messages` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`messages`)),
  `logged_in_citizens` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`logged_in_citizens`)),
  `created_by_cid` varchar(64) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`email`),
  KEY `idx_phone_mail_accounts_creator` (`created_by_cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_mail_saved_emails
CREATE TABLE IF NOT EXISTS `phone_mail_saved_emails` (
  `citizenid` varchar(64) NOT NULL,
  `email` varchar(128) NOT NULL,
  `declined` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`citizenid`,`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_mail_sessions
CREATE TABLE IF NOT EXISTS `phone_mail_sessions` (
  `citizenid` varchar(64) NOT NULL,
  `email` varchar(64) NOT NULL,
  PRIMARY KEY (`citizenid`,`email`),
  KEY `idx_phone_mail_sessions_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_map_markers
CREATE TABLE IF NOT EXISTS `phone_map_markers` (
  `citizenid` varchar(60) NOT NULL,
  `markers` mediumtext NOT NULL,
  `updated_at` varchar(40) NOT NULL,
  PRIMARY KEY (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_media_urls
CREATE TABLE IF NOT EXISTS `phone_media_urls` (
  `url` varchar(512) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`url`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_medical_id
CREATE TABLE IF NOT EXISTS `phone_medical_id` (
  `citizenid` varchar(64) NOT NULL,
  `allergies` varchar(200) DEFAULT NULL,
  `conditions` varchar(200) DEFAULT NULL,
  `medications` varchar(200) DEFAULT NULL,
  `notes` varchar(300) DEFAULT NULL,
  `organ_donor` tinyint(1) NOT NULL DEFAULT 0,
  `contact_name` varchar(60) DEFAULT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `show_on_lock` tinyint(1) NOT NULL DEFAULT 1,
  `blood_type` varchar(3) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_message_group_members
CREATE TABLE IF NOT EXISTS `phone_message_group_members` (
  `group_id` varchar(16) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `number` varchar(32) NOT NULL,
  `name` varchar(64) NOT NULL,
  PRIMARY KEY (`group_id`,`citizenid`),
  KEY `idx_pmgm_cid` (`citizenid`),
  KEY `idx_fk_message_group_members_group` (`group_id`),
  CONSTRAINT `fk_message_group_members_group` FOREIGN KEY (`group_id`) REFERENCES `phone_message_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_message_groups
CREATE TABLE IF NOT EXISTS `phone_message_groups` (
  `id` varchar(16) NOT NULL,
  `name` varchar(64) NOT NULL,
  `avatar` varchar(512) DEFAULT NULL,
  `owner_cid` varchar(64) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_phone_message_groups_owner` (`owner_cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_message_reactions
CREATE TABLE IF NOT EXISTS `phone_message_reactions` (
  `mid` varchar(16) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `emoji` varchar(32) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`mid`,`citizenid`,`emoji`),
  KEY `idx_phone_message_reactions_mid` (`mid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_messages
CREATE TABLE IF NOT EXISTS `phone_messages` (
  `id` varchar(16) NOT NULL,
  `mid` varchar(16) DEFAULT NULL,
  `citizenid` varchar(64) NOT NULL,
  `conversation` varchar(48) NOT NULL,
  `sender` varchar(32) NOT NULL DEFAULT '',
  `direction` varchar(16) NOT NULL,
  `kind` varchar(16) NOT NULL DEFAULT 'text',
  `body` text DEFAULT NULL,
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`meta`)),
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `withheld` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL,
  `seen_at` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_phone_messages_thread` (`citizenid`,`conversation`,`created_at`),
  KEY `idx_phone_messages_mid` (`mid`),
  KEY `idx_phone_messages_unread` (`citizenid`,`is_read`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_migrations
CREATE TABLE IF NOT EXISTS `phone_migrations` (
  `name` varchar(64) NOT NULL,
  `applied_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `stats` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`stats`)),
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_notes
CREATE TABLE IF NOT EXISTS `phone_notes` (
  `citizenid` varchar(60) NOT NULL,
  `id` varchar(40) NOT NULL,
  `body` mediumtext NOT NULL,
  `sketches` mediumtext NOT NULL,
  `images` mediumtext DEFAULT NULL,
  `created_at` varchar(40) NOT NULL,
  `updated_at` varchar(40) NOT NULL,
  PRIMARY KEY (`citizenid`,`id`),
  KEY `updated` (`citizenid`,`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_notif_prefs
CREATE TABLE IF NOT EXISTS `phone_notif_prefs` (
  `citizenid` varchar(64) NOT NULL,
  `app` varchar(32) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `sounds` tinyint(1) NOT NULL DEFAULT 1,
  `tone` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`citizenid`,`app`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_passwords
CREATE TABLE IF NOT EXISTS `phone_passwords` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(64) NOT NULL,
  `app` varchar(80) NOT NULL,
  `username` varchar(64) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(120) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_vault` (`citizenid`,`app`,`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_payphones
CREATE TABLE IF NOT EXISTS `phone_payphones` (
  `location` varchar(64) NOT NULL,
  `number` varchar(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`location`),
  UNIQUE KEY `uq_phone_payphones_number` (`number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_pending_messages
CREATE TABLE IF NOT EXISTS `phone_pending_messages` (
  `id` varchar(16) NOT NULL,
  `mid` varchar(16) NOT NULL,
  `number` varchar(48) NOT NULL,
  `sender` varchar(32) NOT NULL,
  `kind` varchar(16) NOT NULL DEFAULT 'text',
  `body` text DEFAULT NULL,
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`meta`)),
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_phone_pending_messages_number` (`number`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_photo_album_items
CREATE TABLE IF NOT EXISTS `phone_photo_album_items` (
  `album_id` varchar(16) NOT NULL,
  `photo_id` varchar(16) NOT NULL,
  `added_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`album_id`,`photo_id`),
  KEY `idx_album_items_photo` (`photo_id`),
  KEY `idx_fk_photo_album_items_album` (`album_id`),
  KEY `idx_fk_photo_album_items_photo` (`photo_id`),
  CONSTRAINT `fk_photo_album_items_album` FOREIGN KEY (`album_id`) REFERENCES `phone_photo_albums` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_photo_album_items_photo` FOREIGN KEY (`photo_id`) REFERENCES `phone_photos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_photo_albums
CREATE TABLE IF NOT EXISTS `phone_photo_albums` (
  `id` varchar(16) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `name` varchar(64) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_phone_albums_owner` (`citizenid`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_photogram_comment_likes
CREATE TABLE IF NOT EXISTS `phone_photogram_comment_likes` (
  `comment_id` varchar(16) NOT NULL,
  `username` varchar(64) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`comment_id`,`username`),
  KEY `idx_photogram_comment_likes_c` (`comment_id`),
  KEY `idx_fk_photogram_comment_likes_comment` (`comment_id`),
  CONSTRAINT `fk_photogram_comment_likes_comment` FOREIGN KEY (`comment_id`) REFERENCES `phone_photogram_comments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_photogram_comments
CREATE TABLE IF NOT EXISTS `phone_photogram_comments` (
  `id` varchar(16) NOT NULL,
  `post_id` varchar(16) NOT NULL,
  `author` varchar(64) NOT NULL,
  `body` varchar(1000) DEFAULT NULL,
  `gif_url` varchar(512) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_photogram_comments_post` (`post_id`,`created_at`),
  KEY `idx_fk_photogram_comments_post` (`post_id`),
  CONSTRAINT `fk_photogram_comments_post` FOREIGN KEY (`post_id`) REFERENCES `phone_photogram_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_photogram_dms
CREATE TABLE IF NOT EXISTS `phone_photogram_dms` (
  `id` varchar(16) NOT NULL,
  `from_user` varchar(64) NOT NULL,
  `to_user` varchar(64) NOT NULL,
  `body` text DEFAULT NULL,
  `kind` varchar(16) NOT NULL DEFAULT 'text',
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`meta`)),
  `reactions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`reactions`)),
  `read_flag` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_photogram_dms_from` (`from_user`,`created_at`),
  KEY `idx_photogram_dms_to` (`to_user`,`created_at`),
  KEY `idx_photogram_dms_unread` (`to_user`,`read_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_photogram_follows
CREATE TABLE IF NOT EXISTS `phone_photogram_follows` (
  `follower` varchar(64) NOT NULL,
  `target` varchar(64) NOT NULL,
  `status` varchar(12) NOT NULL DEFAULT 'accepted',
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`follower`,`target`),
  KEY `idx_photogram_follows_target` (`target`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_photogram_likes
CREATE TABLE IF NOT EXISTS `phone_photogram_likes` (
  `post_id` varchar(16) NOT NULL,
  `username` varchar(64) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`post_id`,`username`),
  KEY `idx_photogram_likes_post` (`post_id`),
  KEY `idx_fk_photogram_likes_post` (`post_id`),
  CONSTRAINT `fk_photogram_likes_post` FOREIGN KEY (`post_id`) REFERENCES `phone_photogram_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_photogram_notifications
CREATE TABLE IF NOT EXISTS `phone_photogram_notifications` (
  `id` varchar(16) NOT NULL,
  `recipient` varchar(64) NOT NULL,
  `kind` varchar(16) NOT NULL,
  `actor` varchar(64) NOT NULL,
  `post_id` varchar(16) DEFAULT NULL,
  `preview` varchar(200) DEFAULT NULL,
  `seen` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_photogram_notifs_recipient` (`recipient`,`created_at`),
  KEY `idx_photogram_notifs_unseen` (`recipient`,`seen`),
  KEY `idx_photogram_notifs_dedupe` (`recipient`,`kind`,`actor`,`post_id`),
  KEY `idx_fk_photogram_notifications_post` (`post_id`),
  CONSTRAINT `fk_photogram_notifications_post` FOREIGN KEY (`post_id`) REFERENCES `phone_photogram_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_photogram_posts
CREATE TABLE IF NOT EXISTS `phone_photogram_posts` (
  `id` varchar(16) NOT NULL,
  `author` varchar(64) NOT NULL,
  `images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`images`)),
  `caption` varchar(2200) NOT NULL DEFAULT '',
  `location` varchar(120) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_photogram_posts_author` (`author`,`created_at`),
  KEY `idx_photogram_posts_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_photogram_profiles
CREATE TABLE IF NOT EXISTS `phone_photogram_profiles` (
  `username` varchar(64) NOT NULL,
  `display_name` varchar(64) NOT NULL DEFAULT '',
  `bio` varchar(200) NOT NULL DEFAULT '',
  `avatar` varchar(512) DEFAULT NULL,
  `is_private` tinyint(1) NOT NULL DEFAULT 0,
  `verified` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_photogram_saves
CREATE TABLE IF NOT EXISTS `phone_photogram_saves` (
  `post_id` varchar(16) NOT NULL,
  `username` varchar(64) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`username`,`post_id`),
  KEY `idx_photogram_saves_user` (`username`,`created_at`),
  KEY `idx_fk_photogram_saves_post` (`post_id`),
  CONSTRAINT `fk_photogram_saves_post` FOREIGN KEY (`post_id`) REFERENCES `phone_photogram_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_photogram_stories
CREATE TABLE IF NOT EXISTS `phone_photogram_stories` (
  `id` varchar(16) NOT NULL,
  `author` varchar(64) NOT NULL,
  `image` varchar(512) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_photogram_stories_author` (`author`,`created_at`),
  KEY `idx_photogram_stories_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_photogram_story_views
CREATE TABLE IF NOT EXISTS `phone_photogram_story_views` (
  `story_id` varchar(16) NOT NULL,
  `username` varchar(64) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`story_id`,`username`),
  KEY `idx_photogram_story_views_user` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_photos
CREATE TABLE IF NOT EXISTS `phone_photos` (
  `id` varchar(16) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `url` varchar(512) NOT NULL,
  `trusted` tinyint(1) NOT NULL DEFAULT 0,
  `favorite` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_phone_photos_owner` (`citizenid`,`created_at`),
  KEY `idx_phone_photos_url` (`url`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_racing_notifications
CREATE TABLE IF NOT EXISTS `phone_racing_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(64) NOT NULL,
  `track_id` int(11) NOT NULL,
  `track_name` varchar(60) NOT NULL,
  `notification_type` varchar(20) NOT NULL,
  `rejection_reason` text DEFAULT NULL,
  `delivered` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_racing_notifications_creator` (`citizenid`),
  KEY `idx_racing_notifications_delivered` (`citizenid`,`delivered`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_racing_profiles
CREATE TABLE IF NOT EXISTS `phone_racing_profiles` (
  `citizenid` varchar(64) NOT NULL,
  `name` varchar(64) DEFAULT NULL,
  `alias` varchar(24) DEFAULT NULL,
  `avatar` varchar(500) DEFAULT NULL,
  `mmr` int(11) NOT NULL DEFAULT 1000,
  `hud` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`citizenid`),
  KEY `idx_racing_profiles_mmr` (`mmr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_racing_results
CREATE TABLE IF NOT EXISTS `phone_racing_results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `track_id` int(11) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  `name` varchar(64) NOT NULL DEFAULT '',
  `time_ms` int(11) NOT NULL DEFAULT 0,
  `vehicle` varchar(64) DEFAULT NULL,
  `class` varchar(4) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `racers` int(11) DEFAULT NULL,
  `mmr_delta` int(11) DEFAULT NULL,
  `mmr_after` int(11) DEFAULT NULL,
  `best_lap_ms` int(11) DEFAULT NULL,
  `sectors` varchar(64) DEFAULT NULL,
  `dnf` tinyint(1) NOT NULL DEFAULT 0,
  `ranked` tinyint(1) NOT NULL DEFAULT 0,
  `finished_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_racing_results_board` (`track_id`,`dnf`,`time_ms`),
  KEY `idx_racing_results_recent` (`track_id`,`dnf`,`finished_at`),
  KEY `idx_racing_results_racer` (`citizenid`,`finished_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_racing_tracks
CREATE TABLE IF NOT EXISTS `phone_racing_tracks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `citizenid` varchar(64) DEFAULT NULL,
  `author_name` varchar(64) NOT NULL DEFAULT '',
  `checkpoints` longtext NOT NULL,
  `gate_count` int(11) NOT NULL DEFAULT 0,
  `is_sprint` tinyint(1) NOT NULL DEFAULT 0,
  `published` tinyint(1) NOT NULL DEFAULT 1,
  `verified` tinyint(1) NOT NULL DEFAULT 0,
  `featured` tinyint(1) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `publish_status` varchar(20) NOT NULL DEFAULT 'published',
  `rejection_reason` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_racing_tracks_live` (`deleted`,`published`,`featured`,`name`),
  KEY `idx_racing_tracks_creator` (`citizenid`),
  KEY `idx_racing_tracks_status` (`publish_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_radio
CREATE TABLE IF NOT EXISTS `phone_radio` (
  `citizenid` varchar(64) NOT NULL,
  `frequency` decimal(5,1) NOT NULL DEFAULT 1.0,
  `volume` int(11) NOT NULL DEFAULT 50,
  PRIMARY KEY (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_radio_saved
CREATE TABLE IF NOT EXISTS `phone_radio_saved` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(64) NOT NULL,
  `label` varchar(40) NOT NULL,
  `frequency` decimal(5,1) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_ryde_drivers
CREATE TABLE IF NOT EXISTS `phone_ryde_drivers` (
  `username` varchar(64) NOT NULL,
  `display_name` varchar(64) NOT NULL DEFAULT '',
  `vehicle` varchar(64) NOT NULL DEFAULT '',
  `plate` varchar(16) NOT NULL DEFAULT '',
  `color` varchar(16) NOT NULL DEFAULT '#111111',
  `rating_sum` int(11) NOT NULL DEFAULT 0,
  `rating_count` int(11) NOT NULL DEFAULT 0,
  `trips` int(11) NOT NULL DEFAULT 0,
  `earnings_total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_ryde_rides
CREATE TABLE IF NOT EXISTS `phone_ryde_rides` (
  `id` varchar(16) NOT NULL,
  `rider_username` varchar(64) NOT NULL,
  `rider_name` varchar(64) NOT NULL DEFAULT '',
  `driver_username` varchar(64) DEFAULT NULL,
  `driver_name` varchar(64) NOT NULL DEFAULT '',
  `pickup_label` varchar(96) NOT NULL DEFAULT '',
  `pickup_x` float NOT NULL DEFAULT 0,
  `pickup_y` float NOT NULL DEFAULT 0,
  `dropoff_label` varchar(96) NOT NULL DEFAULT '',
  `dropoff_x` float NOT NULL DEFAULT 0,
  `dropoff_y` float NOT NULL DEFAULT 0,
  `distance` float NOT NULL DEFAULT 0,
  `fare` decimal(10,2) NOT NULL DEFAULT 0.00,
  `payment` varchar(8) NOT NULL DEFAULT 'cash',
  `paid` tinyint(1) NOT NULL DEFAULT 0,
  `status` varchar(16) NOT NULL DEFAULT 'completed',
  `rating` tinyint(4) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `completed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_ryde_rides_rider` (`rider_username`),
  KEY `idx_ryde_rides_driver` (`driver_username`),
  KEY `idx_ryde_rides_rider_recent` (`rider_username`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_saved_jobs
CREATE TABLE IF NOT EXISTS `phone_saved_jobs` (
  `citizenid` varchar(64) NOT NULL,
  `jobs` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`jobs`)),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_secret_apps
CREATE TABLE IF NOT EXISTS `phone_secret_apps` (
  `citizenid` varchar(64) NOT NULL,
  `app_id` varchar(64) NOT NULL,
  `unlocked_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`citizenid`,`app_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_service_invoices
CREATE TABLE IF NOT EXISTS `phone_service_invoices` (
  `id` varchar(48) NOT NULL,
  `job` varchar(64) DEFAULT NULL,
  `label` varchar(128) DEFAULT NULL,
  `sender_cid` varchar(64) NOT NULL,
  `sender_name` varchar(128) DEFAULT NULL,
  `sender_number` varchar(32) DEFAULT NULL,
  `target_cid` varchar(64) NOT NULL,
  `target_name` varchar(128) DEFAULT NULL,
  `target_number` varchar(32) DEFAULT NULL,
  `amount` int(11) NOT NULL,
  `note` varchar(255) DEFAULT NULL,
  `status` varchar(16) NOT NULL DEFAULT 'pending',
  `created_at` int(11) NOT NULL,
  `paid_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_job` (`job`,`created_at`),
  KEY `idx_target` (`target_cid`,`status`,`created_at`),
  KEY `idx_sender` (`sender_cid`,`status`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_service_messages
CREATE TABLE IF NOT EXISTS `phone_service_messages` (
  `id` varchar(64) NOT NULL,
  `job` varchar(64) NOT NULL,
  `citizen_number` varchar(32) NOT NULL,
  `citizen_name` varchar(128) DEFAULT NULL,
  `sender` varchar(8) NOT NULL,
  `staff_cid` varchar(64) DEFAULT NULL,
  `staff_name` varchar(128) DEFAULT NULL,
  `body` text NOT NULL,
  `created_at` int(11) NOT NULL,
  `kind` varchar(16) NOT NULL DEFAULT 'text',
  `meta` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_job` (`job`,`citizen_number`,`created_at`),
  KEY `idx_cit` (`citizen_number`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_service_msg_reads
CREATE TABLE IF NOT EXISTS `phone_service_msg_reads` (
  `viewer` varchar(64) NOT NULL,
  `job` varchar(64) NOT NULL,
  `citizen_number` varchar(32) NOT NULL,
  `last_read` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`viewer`,`job`,`citizen_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_service_prefs
CREATE TABLE IF NOT EXISTS `phone_service_prefs` (
  `citizenid` varchar(64) NOT NULL,
  `job` varchar(64) NOT NULL,
  `duty` tinyint(1) NOT NULL DEFAULT 1,
  `job_calls` tinyint(1) NOT NULL DEFAULT 1,
  `job_messages` tinyint(1) NOT NULL DEFAULT 1,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`citizenid`,`job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_settings
CREATE TABLE IF NOT EXISTS `phone_settings` (
  `citizenid` varchar(64) NOT NULL,
  `device` varchar(16) NOT NULL DEFAULT 'phone',
  `phone_number` varchar(20) DEFAULT NULL,
  `active_group_id` varchar(16) DEFAULT NULL,
  `ringtone` varchar(64) DEFAULT NULL,
  `notification_tone` varchar(64) DEFAULT NULL,
  `airplane_mode` tinyint(1) NOT NULL DEFAULT 0,
  `dnd` tinyint(1) NOT NULL DEFAULT 0,
  `rotation_lock` tinyint(1) NOT NULL DEFAULT 0,
  `card_name` varchar(64) DEFAULT NULL,
  `card_avatar` varchar(512) DEFAULT NULL,
  `card_email` varchar(128) DEFAULT NULL,
  `card_address` varchar(128) DEFAULT NULL,
  `installed_apps` text DEFAULT NULL,
  `home_layout` text DEFAULT NULL,
  `lock_clock` text DEFAULT NULL,
  `card_style` text DEFAULT NULL,
  `wallpaper` varchar(512) DEFAULT NULL,
  `wallpaper_home` varchar(512) DEFAULT NULL,
  `blur_lock` tinyint(1) DEFAULT NULL,
  `blur_home` tinyint(1) DEFAULT NULL,
  `island_pet` varchar(16) DEFAULT NULL,
  `custom_wallpapers` text DEFAULT NULL,
  `passcode` varchar(8) DEFAULT NULL,
  `face_id` tinyint(1) NOT NULL DEFAULT 0,
  `chat_text_scale` decimal(3,2) DEFAULT NULL,
  `reduce_motion` tinyint(4) DEFAULT NULL,
  `bold_text` tinyint(1) DEFAULT NULL,
  `text_scale` decimal(3,2) DEFAULT NULL,
  `app_labels` text DEFAULT NULL,
  `phone_scale` tinyint(3) unsigned DEFAULT NULL,
  `brightness` tinyint(3) unsigned DEFAULT NULL,
  `phone_align` varchar(16) DEFAULT NULL,
  `phone_tilt` varchar(48) DEFAULT NULL,
  `dock_style` varchar(12) DEFAULT NULL,
  `open_anim` varchar(12) DEFAULT NULL,
  `wallpaper_parallax` tinyint(1) DEFAULT NULL,
  `hour24` tinyint(1) DEFAULT NULL,
  `caller_id` tinyint(1) DEFAULT NULL,
  `streamer_mode` tinyint(1) DEFAULT NULL,
  `streamer_hide` varchar(255) DEFAULT NULL,
  `reopen_app` tinyint(1) DEFAULT NULL,
  `setup_done` tinyint(1) DEFAULT NULL,
  `theme` varchar(8) DEFAULT NULL,
  `dark_theme` varchar(16) DEFAULT NULL,
  `light_theme` varchar(16) DEFAULT NULL,
  `accent` varchar(16) DEFAULT NULL,
  `shell` varchar(16) DEFAULT NULL,
  `game_time` tinyint(1) DEFAULT NULL,
  `palette_custom` longtext DEFAULT NULL,
  `icon_theme` varchar(16) DEFAULT NULL,
  `icon_custom` longtext DEFAULT NULL,
  `show_app_names` tinyint(1) NOT NULL DEFAULT 1,
  `home_density` varchar(12) DEFAULT NULL,
  `home_icon_scale` smallint(6) DEFAULT NULL,
  `ringtone_volume` tinyint(3) unsigned DEFAULT NULL,
  `call_volume` tinyint(3) unsigned DEFAULT NULL,
  `locale` varchar(8) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`citizenid`,`device`),
  KEY `idx_phone_settings_number` (`phone_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_signatures
CREATE TABLE IF NOT EXISTS `phone_signatures` (
  `citizenid` varchar(64) NOT NULL,
  `image` mediumtext NOT NULL,
  `updated_at` bigint(20) NOT NULL,
  PRIMARY KEY (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_sim_cards
CREATE TABLE IF NOT EXISTS `phone_sim_cards` (
  `number` varchar(20) NOT NULL,
  `identity` varchar(64) NOT NULL,
  `owner_cid` varchar(64) DEFAULT NULL,
  `adopted_by` varchar(64) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`number`),
  KEY `idx_phone_sim_identity` (`identity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_stock_holdings
CREATE TABLE IF NOT EXISTS `phone_stock_holdings` (
  `citizenid` varchar(64) NOT NULL,
  `symbol` varchar(16) NOT NULL,
  `quantity` decimal(24,8) NOT NULL,
  `avg_cost` decimal(18,6) NOT NULL,
  `updated_at` bigint(20) NOT NULL,
  PRIMARY KEY (`citizenid`,`symbol`),
  KEY `citizenid` (`citizenid`),
  KEY `idx_stock_holdings_symbol` (`symbol`,`quantity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_stock_prices
CREATE TABLE IF NOT EXISTS `phone_stock_prices` (
  `symbol` varchar(16) NOT NULL,
  `price` decimal(24,8) NOT NULL,
  `history` longtext DEFAULT NULL,
  `updated_at` bigint(20) NOT NULL,
  PRIMARY KEY (`symbol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_stock_wallet
CREATE TABLE IF NOT EXISTS `phone_stock_wallet` (
  `citizenid` varchar(64) NOT NULL,
  `cash` decimal(18,2) NOT NULL DEFAULT 0.00,
  `updated_at` bigint(20) NOT NULL,
  PRIMARY KEY (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_streak_likes
CREATE TABLE IF NOT EXISTS `phone_streak_likes` (
  `post_id` int(11) NOT NULL,
  `citizenid` varchar(64) NOT NULL,
  UNIQUE KEY `uniq_like` (`post_id`,`citizenid`),
  KEY `idx_fk_streak_likes_post` (`post_id`),
  CONSTRAINT `fk_streak_likes_post` FOREIGN KEY (`post_id`) REFERENCES `phone_streak_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_streak_posts
CREATE TABLE IF NOT EXISTS `phone_streak_posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(64) NOT NULL,
  `author_name` varchar(80) NOT NULL,
  `image_url` varchar(512) NOT NULL,
  `caption` varchar(160) DEFAULT NULL,
  `day_streak` int(11) NOT NULL,
  `post_date` date NOT NULL,
  `like_count` int(11) NOT NULL DEFAULT 0,
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_player_day` (`citizenid`,`post_date`),
  KEY `idx_created` (`created_at`),
  KEY `idx_cid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_streaks
CREATE TABLE IF NOT EXISTS `phone_streaks` (
  `citizenid` varchar(64) NOT NULL,
  `current_streak` int(11) NOT NULL DEFAULT 0,
  `longest_streak` int(11) NOT NULL DEFAULT 0,
  `last_post_date` date DEFAULT NULL,
  PRIMARY KEY (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_timer_recents
CREATE TABLE IF NOT EXISTS `phone_timer_recents` (
  `citizenid` varchar(60) NOT NULL,
  `seconds` int(10) unsigned NOT NULL,
  `used_at` bigint(20) NOT NULL,
  PRIMARY KEY (`citizenid`,`seconds`),
  KEY `recency` (`citizenid`,`used_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_vibez_comment_likes
CREATE TABLE IF NOT EXISTS `phone_vibez_comment_likes` (
  `comment_id` varchar(16) NOT NULL,
  `username` varchar(64) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`comment_id`,`username`),
  KEY `idx_vibez_comment_likes_c` (`comment_id`),
  KEY `idx_fk_vibez_comment_likes_comment` (`comment_id`),
  CONSTRAINT `fk_vibez_comment_likes_comment` FOREIGN KEY (`comment_id`) REFERENCES `phone_vibez_comments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_vibez_comments
CREATE TABLE IF NOT EXISTS `phone_vibez_comments` (
  `id` varchar(16) NOT NULL,
  `post_id` varchar(16) NOT NULL,
  `author` varchar(64) NOT NULL,
  `body` varchar(500) NOT NULL,
  `gif_url` varchar(512) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_vibez_comments_post` (`post_id`,`created_at`),
  KEY `idx_fk_vibez_comments_post` (`post_id`),
  CONSTRAINT `fk_vibez_comments_post` FOREIGN KEY (`post_id`) REFERENCES `phone_vibez_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_vibez_follows
CREATE TABLE IF NOT EXISTS `phone_vibez_follows` (
  `follower` varchar(64) NOT NULL,
  `target` varchar(64) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`follower`,`target`),
  KEY `idx_vibez_follows_target` (`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_vibez_likes
CREATE TABLE IF NOT EXISTS `phone_vibez_likes` (
  `post_id` varchar(16) NOT NULL,
  `username` varchar(64) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`post_id`,`username`),
  KEY `idx_vibez_likes_user` (`username`,`created_at`),
  KEY `idx_fk_vibez_likes_post` (`post_id`),
  CONSTRAINT `fk_vibez_likes_post` FOREIGN KEY (`post_id`) REFERENCES `phone_vibez_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_vibez_notifications
CREATE TABLE IF NOT EXISTS `phone_vibez_notifications` (
  `id` varchar(16) NOT NULL,
  `recipient` varchar(64) NOT NULL,
  `kind` varchar(16) NOT NULL,
  `actor` varchar(64) NOT NULL,
  `post_id` varchar(16) DEFAULT NULL,
  `preview` varchar(200) DEFAULT NULL,
  `seen` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_vibez_notifs_recipient` (`recipient`,`created_at`),
  KEY `idx_vibez_notifs_unseen` (`recipient`,`seen`),
  KEY `idx_vibez_notifs_dedupe` (`recipient`,`kind`,`actor`,`post_id`),
  KEY `idx_fk_vibez_notifications_post` (`post_id`),
  CONSTRAINT `fk_vibez_notifications_post` FOREIGN KEY (`post_id`) REFERENCES `phone_vibez_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_vibez_posts
CREATE TABLE IF NOT EXISTS `phone_vibez_posts` (
  `id` varchar(16) NOT NULL,
  `author` varchar(64) NOT NULL,
  `video` varchar(512) NOT NULL,
  `thumb` varchar(512) DEFAULT NULL,
  `caption` varchar(300) NOT NULL DEFAULT '',
  `sound` varchar(120) NOT NULL DEFAULT '',
  `views` int(10) unsigned NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL,
  `tts_url` varchar(512) DEFAULT NULL,
  `tts_voice` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_vibez_posts_author` (`author`,`created_at`),
  KEY `idx_vibez_posts_created` (`created_at`),
  KEY `idx_vibez_posts_views` (`views`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_vibez_profiles
CREATE TABLE IF NOT EXISTS `phone_vibez_profiles` (
  `username` varchar(64) NOT NULL,
  `display_name` varchar(64) NOT NULL DEFAULT '',
  `bio` varchar(160) NOT NULL DEFAULT '',
  `avatar` varchar(512) DEFAULT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_vibez_saves
CREATE TABLE IF NOT EXISTS `phone_vibez_saves` (
  `post_id` varchar(16) NOT NULL,
  `username` varchar(64) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`username`,`post_id`),
  KEY `idx_vibez_saves_user` (`username`,`created_at`),
  KEY `idx_fk_vibez_saves_post` (`post_id`),
  CONSTRAINT `fk_vibez_saves_post` FOREIGN KEY (`post_id`) REFERENCES `phone_vibez_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_voice_memos
CREATE TABLE IF NOT EXISTS `phone_voice_memos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(64) NOT NULL,
  `name` varchar(120) NOT NULL,
  `url` varchar(512) NOT NULL,
  `duration` int(11) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL,
  `src_id` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_voice_memos_src` (`src_id`),
  KEY `citizenid` (`citizenid`),
  KEY `created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_voicemails
CREATE TABLE IF NOT EXISTS `phone_voicemails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_cid` varchar(64) NOT NULL,
  `from_number` varchar(32) NOT NULL DEFAULT '',
  `from_name` varchar(80) DEFAULT NULL,
  `url` varchar(512) NOT NULL,
  `duration` int(11) NOT NULL DEFAULT 0,
  `listened` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `owner_cid` (`owner_cid`),
  KEY `owner_created` (`owner_cid`,`created_at`),
  KEY `owner_listened` (`owner_cid`,`listened`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_weazel_articles
CREATE TABLE IF NOT EXISTS `phone_weazel_articles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(24) NOT NULL,
  `headline` varchar(160) NOT NULL,
  `dek` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `author` varchar(80) NOT NULL,
  `author_cid` varchar(60) NOT NULL,
  `image` varchar(512) DEFAULT NULL,
  `featured` tinyint(1) NOT NULL DEFAULT 0,
  `views` int(11) NOT NULL DEFAULT 0,
  `status` varchar(12) NOT NULL DEFAULT 'published',
  `publish_at` bigint(20) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  `updated_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `created_at` (`created_at`),
  KEY `featured` (`featured`),
  KEY `status_publish_at` (`status`,`publish_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_weazel_breaking
CREATE TABLE IF NOT EXISTS `phone_weazel_breaking` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(220) NOT NULL,
  `pos` int(11) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pos` (`pos`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.phone_wifi
CREATE TABLE IF NOT EXISTS `phone_wifi` (
  `citizenid` varchar(64) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `known` longtext DEFAULT NULL,
  `declined` longtext DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.player_groups
CREATE TABLE IF NOT EXISTS `player_groups` (
  `citizenid` varchar(50) NOT NULL,
  `group` varchar(50) NOT NULL,
  `type` varchar(50) NOT NULL,
  `grade` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`citizenid`,`type`,`group`),
  CONSTRAINT `fk_citizenid` FOREIGN KEY (`citizenid`) REFERENCES `players` (`citizenid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.player_jobs_activity
CREATE TABLE IF NOT EXISTS `player_jobs_activity` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `job` varchar(255) NOT NULL,
  `last_checkin` int(11) NOT NULL,
  `last_checkout` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id` DESC) USING BTREE,
  KEY `last_checkout` (`last_checkout`) USING BTREE,
  KEY `citizenid_job` (`citizenid`,`job`) USING BTREE,
  CONSTRAINT `1` FOREIGN KEY (`citizenid`) REFERENCES `players` (`citizenid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.player_mails
CREATE TABLE IF NOT EXISTS `player_mails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `subject` varchar(50) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `read` tinyint(4) DEFAULT 0,
  `mailid` int(11) DEFAULT NULL,
  `date` timestamp NULL DEFAULT current_timestamp(),
  `button` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.player_outfit_codes
CREATE TABLE IF NOT EXISTS `player_outfit_codes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `outfitid` int(11) NOT NULL,
  `code` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `FK_player_outfit_codes_player_outfits` (`outfitid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.player_outfits
CREATE TABLE IF NOT EXISTS `player_outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `outfitname` varchar(50) NOT NULL DEFAULT '0',
  `model` varchar(50) DEFAULT NULL,
  `props` text DEFAULT NULL,
  `components` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `citizenid_outfitname_model` (`citizenid`,`outfitname`,`model`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.player_transactions
CREATE TABLE IF NOT EXISTS `player_transactions` (
  `id` varchar(50) NOT NULL,
  `isFrozen` int(11) DEFAULT 0,
  `transactions` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.player_vehicles
CREATE TABLE IF NOT EXISTS `player_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(50) DEFAULT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `vehicle` varchar(50) DEFAULT NULL,
  `hash` varchar(50) DEFAULT NULL,
  `mods` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `plate` varchar(15) NOT NULL,
  `fakeplate` varchar(50) DEFAULT NULL,
  `garage` varchar(50) DEFAULT NULL,
  `fuel` int(11) DEFAULT 100,
  `engine` float DEFAULT 1000,
  `body` float DEFAULT 1000,
  `state` int(11) DEFAULT 1,
  `depotprice` int(11) NOT NULL DEFAULT 0,
  `drivingdistance` int(50) DEFAULT NULL,
  `status` text DEFAULT NULL,
  `coords` text DEFAULT NULL,
  `glovebox` longtext DEFAULT NULL,
  `trunk` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate` (`plate`),
  KEY `citizenid` (`citizenid`),
  CONSTRAINT `1` FOREIGN KEY (`citizenid`) REFERENCES `players` (`citizenid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.players
CREATE TABLE IF NOT EXISTS `players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(10) unsigned DEFAULT NULL,
  `citizenid` varchar(50) NOT NULL,
  `cid` int(11) DEFAULT NULL,
  `license` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `money` text NOT NULL,
  `charinfo` text DEFAULT NULL,
  `job` text NOT NULL,
  `gang` text DEFAULT NULL,
  `position` text NOT NULL,
  `metadata` text NOT NULL,
  `inventory` longtext DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `last_logged_out` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`citizenid`),
  KEY `id` (`id`),
  KEY `last_updated` (`last_updated`),
  KEY `license` (`license`)
) ENGINE=InnoDB AUTO_INCREMENT=266 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.playerskins
CREATE TABLE IF NOT EXISTS `playerskins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `skin` text NOT NULL,
  `active` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `active` (`active`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.properties
CREATE TABLE IF NOT EXISTS `properties` (
  `property_id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_citizenid` varchar(50) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `has_access` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT json_array() CHECK (json_valid(`has_access`)),
  `extra_imgs` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT json_array() CHECK (json_valid(`extra_imgs`)),
  `furnitures` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT json_array() CHECK (json_valid(`furnitures`)),
  `for_sale` tinyint(1) NOT NULL DEFAULT 1,
  `price` int(11) NOT NULL DEFAULT 0,
  `shell` varchar(50) NOT NULL,
  `apartment` varchar(50) DEFAULT NULL,
  `door_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`door_data`)),
  `garage_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`garage_data`)),
  `zone_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`zone_data`)),
  PRIMARY KEY (`property_id`),
  UNIQUE KEY `UQ_owner_apartment` (`owner_citizenid`,`apartment`),
  CONSTRAINT `FK_owner_citizenid` FOREIGN KEY (`owner_citizenid`) REFERENCES `players` (`citizenid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.properties_decorations
CREATE TABLE IF NOT EXISTS `properties_decorations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `property_id` int(11) NOT NULL,
  `model` varchar(255) NOT NULL,
  `coords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`coords`)),
  `rotation` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`rotation`)),
  PRIMARY KEY (`id`),
  KEY `property_id` (`property_id`),
  CONSTRAINT `1` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.tb_gang_custom
CREATE TABLE IF NOT EXISTS `tb_gang_custom` (
  `gang` varchar(50) NOT NULL,
  `label` varchar(100) NOT NULL,
  `color` int(11) NOT NULL DEFAULT 1,
  `grades` longtext NOT NULL,
  PRIMARY KEY (`gang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.tb_gang_rep
CREATE TABLE IF NOT EXISTS `tb_gang_rep` (
  `gang` varchar(50) NOT NULL,
  `rep` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`gang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.tb_gang_sprays
CREATE TABLE IF NOT EXISTS `tb_gang_sprays` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gang` varchar(50) NOT NULL,
  `image` varchar(255) NOT NULL,
  `coords` longtext NOT NULL,
  `normal` longtext NOT NULL,
  `size` float NOT NULL DEFAULT 1.8,
  `zone_id` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.tb_gang_stashes
CREATE TABLE IF NOT EXISTS `tb_gang_stashes` (
  `gang` varchar(50) NOT NULL,
  `coords` longtext NOT NULL,
  `heading` float NOT NULL DEFAULT 0,
  `min_grade` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`gang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.tb_gang_turfs
CREATE TABLE IF NOT EXISTS `tb_gang_turfs` (
  `zone_id` varchar(50) NOT NULL,
  `label` varchar(100) NOT NULL,
  `coords` longtext NOT NULL,
  `radius` float NOT NULL DEFAULT 110,
  `owner` varchar(50) NOT NULL DEFAULT 'none',
  `points` int(11) NOT NULL DEFAULT 100,
  `poly_points` longtext DEFAULT NULL,
  PRIMARY KEY (`zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.users
CREATE TABLE IF NOT EXISTS `users` (
  `userId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `license2` varchar(50) DEFAULT NULL,
  `fivem` varchar(20) DEFAULT NULL,
  `discord` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`userId`),
  KEY `idx_users_license2` (`license2`),
  KEY `idx_users_fivem` (`fivem`),
  KEY `idx_users_discord` (`discord`),
  KEY `idx_users_license` (`license`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.vehicle_financing
CREATE TABLE IF NOT EXISTS `vehicle_financing` (
  `vehicleId` int(11) NOT NULL,
  `balance` int(11) DEFAULT NULL,
  `paymentamount` int(11) DEFAULT NULL,
  `paymentsleft` int(11) DEFAULT NULL,
  `financetime` int(11) DEFAULT NULL,
  PRIMARY KEY (`vehicleId`),
  CONSTRAINT `vehicleId` FOREIGN KEY (`vehicleId`) REFERENCES `player_vehicles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.weed_plants
CREATE TABLE IF NOT EXISTS `weed_plants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `property` varchar(30) DEFAULT NULL,
  `stage` tinyint(4) NOT NULL DEFAULT 1,
  `sort` varchar(30) NOT NULL,
  `gender` enum('male','female') NOT NULL,
  `food` tinyint(4) NOT NULL DEFAULT 100,
  `health` tinyint(4) NOT NULL DEFAULT 100,
  `stageProgress` tinyint(4) NOT NULL DEFAULT 0,
  `coords` tinytext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.xt_prison
CREATE TABLE IF NOT EXISTS `xt_prison` (
  `identifier` varchar(100) NOT NULL,
  `jailtime` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table qbox_bec08f.xt_prison_items
CREATE TABLE IF NOT EXISTS `xt_prison_items` (
  `owner` varchar(60) DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  UNIQUE KEY `owner` (`owner`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporting was unselected.

SET FOREIGN_KEY_CHECKS=1;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
