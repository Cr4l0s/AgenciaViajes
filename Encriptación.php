<?php
class Encriptacion {
    private static $clave_secreta = "clave_secreta_123"; // Clave secreta para encriptación

    public static function encriptar($datos) {
        return openssl_encrypt($datos, "AES-128-ECB", self::$clave_secreta);
    }

    public static function desencriptar($datos_cifrados) {
        return openssl_decrypt($datos_cifrados, "AES-128-ECB", self::$clave_secreta);
    }
}
?>