<?php
// Incluir el archivo de configuración
require 'ini.php';

// Configurar opciones de sesión antes de iniciarla
session_set_cookie_params([
    'lifetime' => 1800, // 30 minutos de vida de la cookie
    'secure' => true,   // Solo enviar cookies sobre HTTPS
    'httponly' => true, // Evitar acceso a la cookie desde JavaScript
    'samesite' => 'Strict' // Evitar ataques CSRF
]);

// Iniciar la sesión
session_start();

// Verificar IP y agente de usuario
if (isset($_SESSION['ip']) && isset($_SESSION['user_agent'])) {
    if ($_SESSION['ip'] !== $_SERVER['REMOTE_ADDR'] || $_SESSION['user_agent'] !== $_SERVER['HTTP_USER_AGENT']) {
        // Destruir la sesión si hay un cambio en la IP o el agente de usuario
        session_destroy();
        die("Sesión inválida. Por seguridad, se ha cerrado la sesión.");
    }
} else {
    // Almacenar IP y agente de usuario en la sesión
    $_SESSION['ip'] = $_SERVER['REMOTE_ADDR'];
    $_SESSION['user_agent'] = $_SERVER['HTTP_USER_AGENT'];
}

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");

$host = "localhost";
$dbname = "agencia_viajes";
$username = "root";
$password = "";

try {
    $conn = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $conn->exec("SET NAMES utf8");
    $conn->exec("SET CHARACTER SET utf8");

    // 🔹 Definición de la clase FiltroViajes
    class FiltroViajes {
        private $conn;

        public function __construct($db) {
            $this->conn = $db;
        }

        public function obtenerHoteles($destino) {
            $stmt = $this->conn->prepare("SELECT nombre, precio FROM hoteles WHERE destino = :destino");
            $stmt->bindParam(":destino", $destino);
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        }

        public function obtenerVuelos($destino) {
            $stmt = $this->conn->prepare("SELECT aerolinea, precio, DATE_FORMAT(fecha, '%d-%m-%Y') AS fecha FROM vuelos WHERE destino = :destino");
            $stmt->bindParam(":destino", $destino);
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        }
    }

    // ✅ Instancia de la clase FiltroViajes
    $filtro = new FiltroViajes($conn);

    // ✅ Verificar si se solicita una oferta especial
    if (isset($_GET['ofertas'])) {
        $stmt = $conn->query("SELECT mensaje, enlace FROM ofertas_especiales");
        $ofertas = $stmt->fetchAll(PDO::FETCH_ASSOC);

        if (empty($ofertas)) {
            echo json_encode([
                ["mensaje" => "¡No hay ofertas en este momento!", "enlace" => "#"],
                ["mensaje" => "¡Prueba más tarde para ver ofertas nuevas!", "enlace" => "#"]
            ], JSON_UNESCAPED_UNICODE);
        } else {
            echo json_encode($ofertas, JSON_UNESCAPED_UNICODE);
        }
        exit;
    }

    // ✅ Obtener sugerencias de destinos en base al input del usuario
    if (isset($_GET['sugerencias']) && isset($_GET['query'])) {
        $query = $_GET['query'];
        $stmt = $conn->prepare("SELECT destino FROM destinos WHERE destino LIKE :query ORDER BY destino");
        $query = "%$query%";
        $stmt->bindParam(":query", $query);
        $stmt->execute();
        $sugerencias = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode($sugerencias, JSON_UNESCAPED_UNICODE);
        exit;
    }

    // ✅ Obtener lista de destinos
    if (isset($_GET['destinos'])) {
        $stmt = $conn->query("SELECT destino FROM destinos");
        echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC), JSON_UNESCAPED_UNICODE);
        exit;
    }

    // ✅ Obtener información de vuelos y hoteles usando la clase FiltroViajes
    if (isset($_GET['buscar']) && isset($_GET['destino'])) {
        $destino = $_GET['destino'];

        // Verificar si los resultados ya están en la sesión
        if (isset($_SESSION['resultados'][$destino])) {
            $vuelos = $_SESSION['resultados'][$destino]['vuelos'];
            $hoteles = $_SESSION['resultados'][$destino]['hoteles'];
        } else {
            // Si no están en la sesión, hacer la consulta a la base de datos
            $vuelos = $filtro->obtenerVuelos($destino);
            $hoteles = $filtro->obtenerHoteles($destino);

            // Almacenar los resultados en la sesión
            $_SESSION['resultados'][$destino] = [
                'vuelos' => $vuelos,
                'hoteles' => $hoteles
            ];
        }

        echo json_encode(["vuelos" => $vuelos, "hoteles" => $hoteles], JSON_UNESCAPED_UNICODE);
        exit;
    }

    // ✅ Guardar registros de viajes en la base de datos
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $destino = $_POST["destino"] ?? "";
        $fecha = $_POST["fecha"] ?? "";

        $stmt = $conn->prepare("INSERT INTO registros_viajes (destino, fecha) VALUES (:destino, :fecha)");
        $stmt->bindParam(":destino", $destino);
        $stmt->bindParam(":fecha", $fecha);
        $stmt->execute();

        echo json_encode(["mensaje" => "Registro exitoso"]);
        exit;
    }

} catch (PDOException $e) {
    echo json_encode(["error" => "Error en la conexión: " . $e->getMessage()]);
    exit;
}
?>