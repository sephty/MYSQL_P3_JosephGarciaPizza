**Hecho por: Joseph Garcia Jimenez**
**Grupo : P3**
**sala: APOLO**
**profesor: PEDRO FELIPE GÓMEZ BONILLA**



## PROBLEMATICA

La pizzería actualmente no tiene un sistema centralizado para gestionar sus productos y pedidos, lo que genera confusión al manejar inventarios, combos y opciones de pedidos. También resulta difícil hacer un seguimiento de los productos más vendidos o personalizar pedidos. Por lo tanto, se requiere un sistema que permita gestionar de manera eficiente el menú, las combinaciones de productos, las ventas, y los pedidos

#### Caracteristicas

- **Gestión de Productos:** Registro completo de pizzas, panzarottis, bebidas, postres y otros productos no elaborados. Se debe tener en cuenta los ingredientes que poseen los productos.
- **Gestión de Adiciones:** Permitir a los clientes agregar adiciones (extra queso, salsas, etc.) a sus productos.
- **Gestión de Combos:** Manejar combos que incluyen múltiples productos a un precio especial.
- **Gestión de Pedidos:** Registro de pedidos para consumir en la pizzería o para recoger, con opción de personalización mediante adiciones.
- **Gestión del Menú:** Definir y actualizar el menú con las opciones disponibles.



## DESARROLLO

* LINK estructura y parte logica del EXAMEN: **https://dbdiagram.io/d/690e5dae6735e11170cbbeb5**

* Explicacion Estructura[Hecho en DBEAVER]
  * entra a **DBeaver** o cualquier aplicacion. entrando a tu localhost o servidor
  * haz click derecho en el navegador, en "Localhost" o el nombre de tu servidor, en la opcion EDITOR SQL 
  * Presiona en la opcion Nuevo Script SQL
  * en el editor de texto, haz click derecho y selecciona archivo y archivo sql
  * selecciona el archivo [Pizzeria_Estructura.sql](/pizzeria_Estructura.sql)
  * ejecuta el archivo completo, y ve a consola
  * en consola entra a mysql y haz SHOW Databases; y USE pizzeria;
  * haz show table; para ver lo creado.

* Explicacion DATOS FALSOS
  * haz un nuevo script sql en tu aplicacion de SQL o sigue los pasos en archivo
  * selecciona el archivo [Pizzeria_datosFalsos.sql](/pizzeria_datosFalsos.sql)
  * Ejecuta el archivo completo y en la consola haz 
  * show tables;
  * despues  SELECT * FROM (tabla);

### DESARROLLO: query o Consultas a realizar 

```mysql
CREATE VIEW v_productos_mas_vendidos AS
SELECT p.nombre, SUM(dp.cantidad) AS total_vendido, SUM(dp.subtotal) AS ingresos
FROM detalle_pedidos dp
JOIN productos p ON dp.id_producto = p.id_producto
GROUP BY p.id_producto
ORDER BY total_vendido DESC;
```



- Esta vista calcula los productos más vendidos en términos de cantidad (`total_vendido`) y los ingresos generados (`ingresos`). Se relaciona con las tablas `detalle_pedidos` (que registra las ventas de productos) y `productos` (que contiene información sobre cada producto). La relación se establece mediante `id_producto`.

```mysql
CREATE VIEW v_ingresos_por_combo AS
SELECT c.nombre AS combo, SUM(dp.cantidad) AS cantidad, SUM(dp.subtotal) AS ingresos
FROM detalle_pedidos dp
JOIN combos c ON dp.id_combo = c.id_combo
GROUP BY c.id_combo;
```



- Esta vista calcula los ingresos y la cantidad total de ventas para cada combo. Se relaciona con las tablas `detalle_pedidos` (que registra las ventas de combos) y `combos` (que contiene información sobre cada combo). La relación se establece mediante `id_combo`.

```mysql
CREATE VIEW v_pedidos_recoger_vs_consumir AS
SELECT o.opcion, COUNT(*) AS total_pedidos, SUM(p.total_pedido) AS ingresos
FROM pedidos p
JOIN opciones o ON p.id_opcion = o.id_opcion
GROUP BY o.id_opcion;
```



- Esta vista compara el número total de pedidos y los ingresos generados según la opción de consumo (`Para recoger` o `Para consumir`). Se relaciona con las tablas `pedidos` (que registra los pedidos) y `opciones` (que define las opciones disponibles). La relación se establece mediante `id_opcion`.

```mysql
CREATE VIEW v_adiciones_mas_solicitadas AS
SELECT a.nombre, SUM(pa.cantidad) AS total
FROM pedidos_adiciones pa
JOIN adiciones a ON pa.id_adicion = a.id_adicion
GROUP BY a.id_adicion
ORDER BY total DESC;
```



- Esta vista muestra las adiciones más solicitadas, calculando la cantidad total de cada adición y ordenándolas en orden descendente. Se relaciona con las tablas `pedidos_adiciones` (que registra las adiciones solicitadas) y `adiciones` (que contiene información sobre cada adición). La relación se establece mediante `id_adicion`.

```mysql
CREATE VIEW v_cantidad_por_categoria AS
SELECT t.tipoProducto, SUM(dp.cantidad) AS cantidad
FROM detalle_pedidos dp
JOIN productos p ON dp.id_producto = p.id_producto
JOIN tipoProducto t ON p.id_tipoProducto = t.id_tipoProducto
GROUP BY t.id_tipoProducto;
```



- Esta vista calcula la cantidad total de productos vendidos por cada categoría (e.g., "Pizza", "Bebida"). Se relaciona con las tablas `detalle_pedidos` (que registra las ventas de productos), `productos` (que contiene información sobre los productos) y `tipoProducto` (que define las categorías). La relación se establece mediante `id_tipoProducto`.

```mysql
CREATE VIEW v_total_ventas_por_dia AS
SELECT DATE(p.fecha_pedido) AS fecha, SUM(p.total_pedido) AS ingresos
FROM pedidos p
GROUP BY DATE(p.fecha_pedido);
```



- Esta vista muestra los ingresos totales generados por día. Se relaciona con la tabla `pedidos`, que almacena la fecha de cada pedido (`fecha_pedido`) y el total del pedido (`total_pedido`). Los datos se agrupan por la fecha del pedido.

```
CREATE VIEW v_panzarottis_extra_queso AS
SELECT SUM(pa.cantidad) AS total_panzarottis_extra_queso
FROM detalle_pedidos dp
JOIN productos p ON dp.id_producto = p.id_producto
JOIN pedidos_adiciones pa ON dp.id_detalle = pa.id_detalle
JOIN adiciones a ON pa.id_adicion = a.id_adicion
WHERE p.nombre LIKE '%Panzarotti%' AND a.nombre = 'Extra Queso';
```



- Esta vista calcula la cantidad total de panzarottis vendidos que incluyen la adición de extra queso. Se relaciona con las tablas detalle_pedidos, productos, pedidos_adiciones y adiciones.

```mysql
CREATE VIEW v_pedidos_con_bebidas_en_combo AS
SELECT COUNT(DISTINCT dp.id_pedido) AS total_pedidos_con_bebidas
FROM detalle_pedidos dp
JOIN combos c ON dp.id_combo = c.id_combo
JOIN combo_detalle cd ON c.id_combo = cd.id_combo
JOIN productos p ON cd.id_producto = p.id_producto
WHERE p.nombre LIKE '%Bebida%';
```



- Esta vista cuenta los pedidos que incluyen bebidas como parte de un combo. Se relaciona con las tablas detalle_pedidos, combos, combo_detalle y productos

```mysql
CREATE VIEW v_clientes_mas_de_5_pedidos AS
SELECT c.nombre, COUNT(p.id_pedido) AS total_pedidos
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
WHERE p.fecha_pedido >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY c.id_cliente
HAVING total_pedidos > 5;
```

Esta vista muestra los clientes que han realizado más de 5 pedidos en el último mes. Se relaciona con las tablas pedidos y clientes.

```mysql
CREATE VIEW v_ingresos_no_elaborados AS
SELECT SUM(dp.subtotal) AS ingresos_no_elaborados
FROM detalle_pedidos dp
JOIN productos p ON dp.id_producto = p.id_producto
WHERE p.es_no_elaborado = TRUE;
```

Esta vista calcula los ingresos totales generados por productos no elaborados (como bebidas y postres). Se relaciona con las tablas detalle_pedidos y productos.

```mysql
CREATE VIEW v_promedio_adiciones_por_pedido AS
SELECT AVG(total_adiciones) AS promedio_adiciones
FROM (
SELECT dp.id_pedido, COUNT(pa.id_adicion) AS total_adiciones
FROM detalle_pedidos dp
LEFT JOIN pedidos_adiciones pa ON dp.id_detalle = pa.id_detalle
GROUP BY dp.id_pedido
) subquery;
```

Esta vista calcula el promedio de adiciones por pedido. Se relaciona con las tablas detalle_pedidos y pedidos_adiciones.

```mysql
CREATE VIEW v_combos_vendidos_ultimo_mes AS
SELECT SUM(dp.cantidad) AS total_combos_vendidos
FROM detalle_pedidos dp
WHERE dp.id_combo IS NOT NULL AND dp.fecha_pedido >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);
```

Esta vista calcula el total de combos vendidos en el último mes. Se relaciona con la tabla detalle_pedidos.

```mysql
CREATE VIEW v_clientes_recoger_y_consumir AS
SELECT c.nombre
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente
HAVING SUM(p.id_opcion = 1) > 0 AND SUM(p.id_opcion = 2) > 0;
```

Esta vista muestra los clientes que han realizado pedidos tanto para recoger como para consumir en el lugar. Se relaciona con las tablas clientes y pedidos.

```mysql
CREATE VIEW v_productos_con_adiciones AS
SELECT COUNT(DISTINCT dp.id_detalle) AS total_productos_con_adiciones
FROM detalle_pedidos dp
JOIN pedidos_adiciones pa ON dp.id_detalle = pa.id_detalle;
```

Esta vista calcula el total de productos personalizados con adiciones. Se relaciona con las tablas detalle_pedidos y pedidos_adiciones.

```mysql
CREATE VIEW v_pedidos_con_mas_de_3_productos AS
SELECT p.id_pedido, COUNT(DISTINCT dp.id_producto) AS total_productos
FROM pedidos p
JOIN detalle_pedidos dp ON p.id_pedido = dp.id_pedido
GROUP BY p.id_pedido
HAVING total_productos > 3;
```

Esta vista muestra los pedidos que incluyen más de 3 productos diferentes. Se relaciona con las tablas pedidos y detalle_pedidos.

```mysql
CREATE VIEW v_promedio_ingresos_por_dia AS
SELECT AVG(ingresos_diarios) AS promedio_ingresos
FROM (
SELECT DATE(p.fecha_pedido) AS fecha, SUM(p.total_pedido) AS ingresos_diarios
FROM pedidos p
GROUP BY DATE(p.fecha_pedido)
) subquery;
```

Esta vista calcula el promedio de ingresos generados por día. Se relaciona con la tabla pedidos.

```mysql
CREATE VIEW v_porcentaje_ventas_no_elaborados AS
SELECT (SUM(CASE WHEN p.es_no_elaborado = TRUE THEN dp.subtotal ELSE 0 END) / SUM(dp.subtotal)) * 100 AS porcentaje_no_elaborados
FROM detalle_pedidos dp
JOIN productos p ON dp.id_producto = p.id_producto;
```

Esta vista calcula el porcentaje de ventas provenientes de productos no elaborados. Se relaciona con las tablas detalle_pedidos y productos.
