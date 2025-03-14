-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 31-01-2025 a las 13:29:09
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `agencia_viajes`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `destinos`
--

CREATE TABLE `destinos` (
  `id` int(11) NOT NULL,
  `destino` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `destinos`
--

INSERT INTO `destinos` (`id`, `destino`) VALUES
(1, 'Dubái'),
(2, 'Londres'),
(3, 'Nueva York'),
(4, 'París'),
(5, 'Roma'),
(6, 'Sídney'),
(7, 'Tokio');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `hoteles`
--

CREATE TABLE `hoteles` (
  `id` int(11) NOT NULL,
  `destino` varchar(100) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `precio` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `hoteles`
--

INSERT INTO `hoteles` (`id`, `destino`, `nombre`, `precio`) VALUES
(1, 'Nueva York', 'Hotel Manhattan', 120.00),
(2, 'París', 'Le Grand Paris', 150.00),
(3, 'Londres', 'The London Palace', 130.00),
(4, 'Roma', 'Roma Imperial', 110.00),
(5, 'Tokio', 'Tokyo Grand Hotel', 200.00),
(6, 'Sídney', 'Sydney Bay Resort', 180.00),
(7, 'Dubái', 'Dubai Luxury Inn', 170.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ofertas_especiales`
--

CREATE TABLE `ofertas_especiales` (
  `id` int(11) NOT NULL,
  `mensaje` varchar(255) NOT NULL,
  `creado` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ofertas_especiales`
--

INSERT INTO `ofertas_especiales` (`id`, `mensaje`, `creado`) VALUES
(1, '¡30% de descuento en vuelos a Barcelona!', '2025-01-30 17:44:36'),
(2, 'Reserva en París y recibe una noche gratis', '2025-01-30 17:44:36'),
(3, 'Ofertas exclusivas en vuelos a Tokio', '2025-01-30 17:44:36'),
(4, 'Descuento especial en hoteles de Dubái', '2025-01-30 17:44:36'),
(5, 'Promoción 2x1 en vuelos a Londres', '2025-01-30 17:44:36'),
(6, 'Vuelos a Roma con hasta 40% de descuento', '2025-01-30 17:44:36'),
(7, 'Singapur: paquetes con estadía y tour incluido', '2025-01-30 17:44:36');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reservas`
--

CREATE TABLE `reservas` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `vuelo_id` int(11) NOT NULL,
  `hotel_id` int(11) DEFAULT NULL,
  `fecha_reserva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `reservas`
--

INSERT INTO `reservas` (`id`, `usuario_id`, `vuelo_id`, `hotel_id`, `fecha_reserva`) VALUES
(1, 1, 2, 1, '2025-01-30 17:44:36'),
(2, 2, 3, 2, '2025-01-30 17:44:36'),
(3, 3, 1, NULL, '2025-01-30 17:44:36'),
(4, 4, 5, 5, '2025-01-30 17:44:36'),
(5, 5, 6, NULL, '2025-01-30 17:44:36'),
(6, 6, 7, 6, '2025-01-30 17:44:36'),
(7, 7, 4, 4, '2025-01-30 17:44:36');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `contrasena` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `correo`, `contrasena`) VALUES
(1, 'Juan Pérez', 'juan@example.com', 'clave123'),
(2, 'María González', 'maria@example.com', 'pass456'),
(3, 'Carlos Herrera', 'carlos@example.com', 'qwerty789'),
(4, 'Ana López', 'ana@example.com', 'seguro123'),
(5, 'Pedro Sánchez', 'pedro@example.com', 'admin999'),
(6, 'Sofía Torres', 'sofia@example.com', 'sofia2025'),
(7, 'Luis Ramírez', 'luis@example.com', 'claveABC');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vuelos`
--

CREATE TABLE `vuelos` (
  `id` int(11) NOT NULL,
  `destino` varchar(100) NOT NULL,
  `aerolinea` varchar(50) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `fecha` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `vuelos`
--

INSERT INTO `vuelos` (`id`, `destino`, `aerolinea`, `precio`, `fecha`) VALUES
(1, 'Nueva York', 'American Airlines', 350.00, '2025-07-15'),
(2, 'París', 'Air France', 450.00, '2025-08-10'),
(3, 'Londres', 'British Airways', 400.00, '2025-09-05'),
(4, 'Roma', 'Alitalia', 380.00, '2025-07-20'),
(5, 'Tokio', 'Japan Airlines', 700.00, '2025-10-12'),
(6, 'Sídney', 'Qantas', 850.00, '2025-11-01'),
(7, 'Dubái', 'Emirates', 600.00, '2025-12-25');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `destinos`
--
ALTER TABLE `destinos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `hoteles`
--
ALTER TABLE `hoteles`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `ofertas_especiales`
--
ALTER TABLE `ofertas_especiales`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `reservas`
--
ALTER TABLE `reservas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `vuelo_id` (`vuelo_id`),
  ADD KEY `hotel_id` (`hotel_id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `correo` (`correo`);

--
-- Indices de la tabla `vuelos`
--
ALTER TABLE `vuelos`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `destinos`
--
ALTER TABLE `destinos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `hoteles`
--
ALTER TABLE `hoteles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `ofertas_especiales`
--
ALTER TABLE `ofertas_especiales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `reservas`
--
ALTER TABLE `reservas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `vuelos`
--
ALTER TABLE `vuelos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `reservas`
--
ALTER TABLE `reservas`
  ADD CONSTRAINT `reservas_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `reservas_ibfk_2` FOREIGN KEY (`vuelo_id`) REFERENCES `vuelos` (`id`),
  ADD CONSTRAINT `reservas_ibfk_3` FOREIGN KEY (`hotel_id`) REFERENCES `hoteles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
