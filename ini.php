<?php
// Configuración de la base de datos
define('DB_HOST', 'localhost');
define('DB_NAME', 'agencia_viajes');
define('DB_USER', 'root');
define('DB_PASSWORD', '');

// Configurar opciones de sesión antes de iniciarla
ini_set('session.gc_maxlifetime', 1800); // 30 minutos de vida de la sesión
ini_set('session.cookie_lifetime', 1800); // 30 minutos de vida de la cookie
ini_set('session.cookie_secure', 1); // Solo enviar cookies sobre HTTPS
ini_set('session.cookie_httponly', 1); // Evitar acceso a la cookie desde JavaScript
ini_set('session.use_strict_mode', 1); // Evitar la fijación de sesión
?>