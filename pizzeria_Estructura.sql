DROP DATABASE IF EXISTS pizzeria;
CREATE DATABASE pizzeria CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE pizzeria;

SET FOREIGN_KEY_CHECKS = 0;


-- Tablas Principal

CREATE TABLE tipoProducto (
    id_tipoProducto INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    tipoProducto VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE ingredientes (
    id_ingrediente INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    unidad_medida VARCHAR(50) NOT NULL
);

CREATE TABLE inventario (
    id_inventario INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_ingrediente INT UNSIGNED NOT NULL,
    cantidad_actual DECIMAL(10,2) NOT NULL DEFAULT 0,
    stock_minimo DECIMAL(10,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (id_ingrediente) REFERENCES ingredientes(id_ingrediente)
);

CREATE TABLE productos (
    id_producto INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    precio_base DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    id_tipoProducto INT UNSIGNED NOT NULL,
    es_no_elaborado BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (id_tipoProducto) REFERENCES tipoProducto(id_tipoProducto)
);

CREATE TABLE recetas (
    id_receta INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_producto INT UNSIGNED NOT NULL,
    id_ingrediente INT UNSIGNED NOT NULL,
    cantidad_requerida DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    FOREIGN KEY (id_ingrediente) REFERENCES ingredientes(id_ingrediente)
);

CREATE TABLE adiciones (
    id_adicion INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    precio_adicion DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    id_ingrediente INT UNSIGNED NULL,
    FOREIGN KEY (id_ingrediente) REFERENCES ingredientes(id_ingrediente)
);

CREATE TABLE combos (
    id_combo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    precio_total DECIMAL(10,2) NOT NULL DEFAULT 0.00
);

CREATE TABLE combo_detalle (
    id_combo INT UNSIGNED NOT NULL,
    id_producto INT UNSIGNED NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    PRIMARY KEY (id_combo, id_producto),
    FOREIGN KEY (id_combo) REFERENCES combos(id_combo),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

CREATE TABLE menu (
    id_menu INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE
);

CREATE TABLE menu_items (
    id_menu_item INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_menu INT UNSIGNED NOT NULL,
    id_producto INT UNSIGNED NOT NULL,
    disponible BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_menu) REFERENCES menu(id_menu),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

CREATE TABLE opciones (
    id_opcion INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    opcion VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE estados (
    id_estado INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    estado VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE clientes (
    id_cliente INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    telefono VARCHAR(50),
    email VARCHAR(255),
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pedidos (
    id_pedido INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT UNSIGNED,
    id_opcion INT UNSIGNED NOT NULL,
    id_estado INT UNSIGNED NOT NULL,
    total_pedido DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_opcion) REFERENCES opciones(id_opcion),
    FOREIGN KEY (id_estado) REFERENCES estados(id_estado)
);

CREATE TABLE detalle_pedidos (
    id_detalle INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT UNSIGNED NOT NULL,
    id_producto INT UNSIGNED NULL,
    id_combo INT UNSIGNED NULL,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario_momento DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    FOREIGN KEY (id_combo) REFERENCES combos(id_combo),
    CHECK ((id_producto IS NOT NULL AND id_combo IS NULL) OR (id_producto IS NULL AND id_combo IS NOT NULL))
);

CREATE TABLE pedidos_adiciones (
    id_pedido_adicion INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_detalle INT UNSIGNED NOT NULL,
    id_adicion INT UNSIGNED NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    FOREIGN KEY (id_detalle) REFERENCES detalle_pedidos(id_detalle),
    FOREIGN KEY (id_adicion) REFERENCES adiciones(id_adicion)
);

SET FOREIGN_KEY_CHECKS = 1;
