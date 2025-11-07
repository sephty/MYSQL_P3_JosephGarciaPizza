USE pizzeria;

INSERT INTO tipoProducto (tipoProducto) VALUES 
('Pizza'), ('Panzarotti'), ('Bebida'), ('Postre'), ('No elaborado');

INSERT INTO ingredientes (nombre, unidad_medida) VALUES
('Queso', 'g'),
('Tomate', 'g'),
('Harina', 'g'),
('Salsa', 'ml'),
('Azúcar', 'g');

INSERT INTO inventario (id_ingrediente, cantidad_actual, stock_minimo) VALUES
(1, 5000, 1000), (2, 4000, 1000), (3, 10000, 2000), (4, 5000, 1000), (5, 3000, 500);

INSERT INTO productos (nombre, descripcion, precio_base, id_tipoProducto, es_no_elaborado) VALUES
('Pizza Margarita', 'Pizza clásica con queso y tomate', 28000, 1, FALSE),
('Panzarotti Especial', 'Panzarotti relleno con jamón y queso', 22000, 2, FALSE),
('Coca-Cola 1.5L', 'Bebida gaseosa fría', 6000, 3, TRUE),
('Brownie', 'Postre de chocolate', 8000, 4, TRUE);

INSERT INTO recetas (id_producto, id_ingrediente, cantidad_requerida) VALUES
(1,1,150),(1,2,100),(1,3,200),(2,1,100),(2,3,150);

INSERT INTO adiciones (nombre, precio_adicion, id_ingrediente) VALUES
('Extra Queso', 3000, 1),
('Salsa BBQ', 2000, 4);

INSERT INTO combos (nombre, descripcion, precio_total) VALUES
('Combo Familiar', 'Pizza + Gaseosa + Postre', 38000),
('Combo Pareja', '2 Pizzas medianas + 1 bebida', 52000);

INSERT INTO combo_detalle (id_combo, id_producto, cantidad) VALUES
(1,1,1),(1,3,1),(1,4,1),(2,1,2),(2,3,1);

INSERT INTO menu (nombre, fecha_inicio, fecha_fin) VALUES
('Menú Noviembre', '2025-11-01', '2025-11-30');

INSERT INTO menu_items (id_menu, id_producto, disponible) VALUES
(1,1,TRUE),(1,2,TRUE),(1,3,TRUE),(1,4,TRUE);

INSERT INTO opciones (opcion) VALUES ('Para consumir'), ('Para recoger');

INSERT INTO estados (estado) VALUES ('Pendiente'), ('Preparando'), ('Entregado'), ('Cancelado');

INSERT INTO clientes (nombre, telefono, email) VALUES
('Juan Pérez','3001112233','juan@example.com'),
('Ana Gómez','3105556677','ana@example.com'),
('Luis Torres','3159998888','luis@example.com'),
('María Ruiz','3124443322','maria@example.com'),
('Pedro Sánchez','3132224455','pedro@example.com');

-- Pedidos
INSERT INTO pedidos (id_cliente, id_opcion, id_estado, total_pedido, fecha_pedido) VALUES
(1,1,3,40000,'2025-11-03 18:30:00'),
(2,2,3,26000,'2025-11-05 13:00:00'),
(3,1,3,38000,'2025-11-06 20:10:00'),
(1,2,3,22000,'2025-10-20 12:00:00'),
(4,1,2,52000,'2025-11-02 19:00:00'),
(5,2,3,6000,'2025-11-07 14:15:00');

-- Detalles (productos and combos)
INSERT INTO detalle_pedidos (id_pedido, id_producto, cantidad, precio_unitario_momento, subtotal) VALUES
(1,1,1,28000,28000),
(1,3,1,6000,6000),
(2,2,1,22000,22000),
(2,4,1,8000,8000),
(4,2,1,22000,22000),
(6,3,1,6000,6000);

INSERT INTO detalle_pedidos (id_pedido, id_combo, cantidad, precio_unitario_momento, subtotal) VALUES
(3,1,1,38000,38000),
(5,2,1,52000,52000);

-- Adiciones de pedidos
INSERT INTO pedidos_adiciones (id_detalle, id_adicion, cantidad) VALUES
(1,1,1),
(2,2,1),
(5,1,1);

