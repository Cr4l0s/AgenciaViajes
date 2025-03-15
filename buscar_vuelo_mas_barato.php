<?php
include 'ini.php';

$origen = isset($_POST['origen']) ? $_POST['origen'] : '';
$destino = isset($_POST['destino']) ? $_POST['destino'] : '';

if (!empty($origen) && !empty($destino)) {
    // Buscar el vuelo más barato para un origen y destino específicos
    $sql = "SELECT * FROM VUELO WHERE origen = ? AND destino = ? ORDER BY precio ASC LIMIT 1";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ss", $origen, $destino);
} else {
    // Buscar el vuelo más barato en general
    $sql = "SELECT * FROM VUELO ORDER BY precio ASC LIMIT 1";
    $stmt = $conn->prepare($sql);
}

$stmt->execute();
$result = $stmt->get_result();

?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TravelNOW! - Vuelo Más Barato</title>
</head>
<body>
    <h1>TravelNOW! - Resultado de Búsqueda</h1>
    <table border="1">
        <tr>
            <th>Origen</th>
            <th>Destino</th>
            <th>Fecha</th>
            <th>Plazas Disponibles</th>
            <th>Precio</th>
        </tr>
        <?php
        if ($result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
                echo "<tr>
                        <td>" . $row["origen"] . "</td>
                        <td>" . $row["destino"] . "</td>
                        <td>" . $row["fecha"] . "</td>
                        <td>" . $row["plazas_disponibles"] . "</td>
                        <td>$" . number_format($row["precio"], 2) . "</td>
                      </tr>";
            }
        } else {
            echo "<tr><td colspan='5'>No se encontraron vuelos disponibles.</td></tr>";
        }
        ?>
    </table>
</body>
</html>

<?php
$stmt->close();
$conn->close();
?>
