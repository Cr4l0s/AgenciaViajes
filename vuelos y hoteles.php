<?php
class VuelosYHoteles {
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
?>