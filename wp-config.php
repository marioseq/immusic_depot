<?php
/**
 * The base configurations of the WordPress.
 *
 * This file has the following configurations: MySQL settings, Table Prefix,
 * Secret Keys, WordPress Language, and ABSPATH. You can find more information
 * by visiting {@link http://codex.wordpress.org/Editing_wp-config.php Editing
 * wp-config.php} Codex page. You can get the MySQL settings from your web host.
 *
 * This file is used by the wp-config.php creation script during the
 * installation. You don't have to use the web site, you can just copy this file
 * to "wp-config.php" and fill in the values.
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'imstudio_imstudio');

/** MySQL database username */
define('DB_USER', 'imstudio_imuser');

/** MySQL database password */
define('DB_PASSWORD', 'imuser$');

/** MySQL hostname */
define('DB_HOST', 'localhost');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '4K2zva3oN0d99ASLVBr0QBtpZdtrmViJcfydNUmanLk93hjeIYmlE8wJAEpaPQfJ');
define('SECURE_AUTH_KEY',  'H44QXNJ3EYikfzjW4wbzEtekFrVQLqrRZgwDt3ZNX7yO5SPMijMHODGjXODQ4TUb');
define('LOGGED_IN_KEY',    'LBs7bEZsaOGoZ8fXwFdqCdVbN7Ek8dlSipoc9YvvmeP5qIJclt4wrLTh5qW4gJkp');
define('NONCE_KEY',        'omDh1279sRtdpdEfrXZlmf4rD9shh2w0Hu2ihVoWEW55JEkgIDhJcgpSQMjpkuPa');
define('AUTH_SALT',        'uzLCXBdzFunI3vpIY5TAGlea8qKIbpfoqVBCNMAJao2VvzQ0KtpJbcxeHKbG1bDt');
define('SECURE_AUTH_SALT', 'eJPePEHQ88PKZuc4l5NUhMwNLpAsEx3lvx8Qi9AHjO0U2y9bNAYLJAlVG6nPiLVO');
define('LOGGED_IN_SALT',   'wKgQvqsalGkS01Cw8vBc9D0EuRNsFEfQfh4JGlNlnb2XLEJqQEOGJUtbMs6HqLsX');
define('NONCE_SALT',       'nKF9abhYwqqtyQiFgAn4fzCtwCRfOlgIxJqxoow5YkYKOx3yoKfkL7lp4D0NJtFB');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each a unique
 * prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * WordPress Localized Language, defaults to English.
 *
 * Change this to localize WordPress. A corresponding MO file for the chosen
 * language must be installed to wp-content/languages. For example, install
 * de_DE.mo to wp-content/languages and set WPLANG to 'de_DE' to enable German
 * language support.
 */
define('WPLANG', '');

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
