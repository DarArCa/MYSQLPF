/*1 Como analista, quiero obtener el promedio de calificación por producto.*/
DELIMITER //
CREATE FUNCTION promedio_calificacion_por_producto(pid INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
  DECLARE resultado DECIMAL(5,2);
  SELECT AVG(rating) INTO resultado FROM quality_products WHERE product_id = pid;
  RETURN resultado;
END;//
DELIMITER ;
SELECT promedio_calificacion_por_producto(1);

/*2 Como gerente, desea contar cuántos productos ha calificado cada cliente.*/
DELIMITER //
CREATE FUNCTION productos_calificados_por_cliente(cid INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM quality_products WHERE customer_id = cid;
  RETURN total;
END;//
DELIMITER ;
SELECT productos_calificados_por_cliente(1);

/*3 Como auditor, quiere sumar el total de beneficios asignados por audiencia.*/
DELIMITER //
CREATE FUNCTION beneficios_por_audiencia(aid INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM audiencebenefits WHERE audience_id = aid;
  RETURN total;
END;//
DELIMITER ;
SELECT beneficios_por_audiencia(1);

/*4 Como administrador, desea conocer la media de productos por empresa.*/
DELIMITER //
CREATE FUNCTION media_productos_por_empresa()
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
  DECLARE media DECIMAL(5,2);
  SELECT AVG(cantidad) INTO media FROM (
    SELECT COUNT(*) AS cantidad FROM companyproducts GROUP BY company_id
  ) AS sub;
  RETURN media;
END;//
DELIMITER ;
SELECT media_productos_por_empresa();

/*5 Como supervisor, quiere ver el total de empresas por ciudad.*/
DELIMITER //
CREATE FUNCTION empresas_por_ciudad(cid INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM companies WHERE city_id = cid;
  RETURN total;
END;//
DELIMITER ;
SELECT empresas_por_ciudad('05001');

/*6 Como técnico, desea obtener el promedio de precios de productos por unidad de medida.*/
DELIMITER //
CREATE FUNCTION promedio_precio_por_unidad(uid INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE resultado DECIMAL(10,2);
  SELECT AVG(price) INTO resultado FROM companyproducts WHERE unitmeasure_id = uid;
  RETURN resultado;
END;//
DELIMITER ;
SELECT promedio_precio_por_unidad(1);

/*7 Como gerente, quiere ver el número de clientes registrados por cada ciudad.*/
DELIMITER //
CREATE FUNCTION clientes_por_ciudad(cid INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM customers WHERE city_id = cid;
  RETURN total;
END;//
DELIMITER ;
SELECT clientes_por_ciudad('05001');

/*8 Como operador, desea contar cuántos planes de membresía existen por periodo.*/
DELIMITER //
CREATE FUNCTION planes_por_periodo(pid INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM membershipperiods WHERE period_id = pid;
  RETURN total;
END;//
DELIMITER ;
SELECT planes_por_periodo(1);

/*9 Como cliente, quiere ver el promedio de calificaciones que ha otorgado a sus productos favoritos.*/
DELIMITER //
CREATE FUNCTION promedio_favoritos_por_cliente(cid INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
  DECLARE promedio DECIMAL(5,2);
  SELECT AVG(qp.rating) INTO promedio
  FROM favorites f
  JOIN details_favorites df ON df.favorite_id = f.id
  JOIN quality_products qp ON qp.product_id = df.product_id AND qp.customer_id = f.customer_id
  WHERE f.customer_id = cid;
  RETURN promedio;
END;//
DELIMITER ;
SELECT promedio_favoritos_por_cliente(1);

/*10 Como auditor, desea obtener la fecha más reciente en la que se calificó un producto.*/
DELIMITER //
CREATE FUNCTION ultima_fecha_calificacion(pid INT)
RETURNS DATE
DETERMINISTIC
BEGIN
  DECLARE fecha DATE;
  SELECT MAX(daterating) INTO fecha FROM quality_products WHERE product_id = pid;
  RETURN fecha;
END;//
DELIMITER ;
SELECT ultima_fecha_calificacion(1);

/*11 Como desarrollador, quiere conocer la variación de precios por categoría de producto.*/
DELIMITER //
CREATE FUNCTION desviacion_precio_por_categoria(cid INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE resultado DECIMAL(10,2);
  SELECT STDDEV(cp.price) INTO resultado
  FROM companyproducts cp
  JOIN products p ON cp.product_id = p.id
  WHERE p.category_id = cid;
  RETURN resultado;
END;//
DELIMITER ;
SELECT desviacion_precio_por_categoria(1);

/*12 Como técnico, desea contar cuántas veces un producto fue marcado como favorito.*/
DELIMITER //
CREATE FUNCTION total_favoritos_por_producto(pid INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM details_favorites WHERE product_id = pid;
  RETURN total;
END;//
DELIMITER ;
SELECT total_favoritos_por_producto(1);

/*13 Como director, quiere saber qué porcentaje de productos han sido calificados al menos una vez.*/
DELIMITER //
CREATE FUNCTION porcentaje_productos_calificados()
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
  DECLARE total INT;
  DECLARE calificados INT;
  DECLARE porcentaje DECIMAL(5,2);
  SELECT COUNT(*) INTO total FROM products;
  SELECT COUNT(DISTINCT product_id) INTO calificados FROM quality_products;
  SET porcentaje = (calificados / total) * 100;
  RETURN porcentaje;
END;//
DELIMITER ;
SELECT porcentaje_productos_calificados();

/*14 Como analista, desea conocer el promedio de rating por encuesta.*/
DELIMITER //
CREATE FUNCTION promedio_rating_por_encuesta(pid INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
  DECLARE promedio DECIMAL(5,2);
  SELECT AVG(rating) INTO promedio FROM rates WHERE poll_id = pid;
  RETURN promedio;
END;//
DELIMITER ;
SELECT promedio_rating_por_encuesta(1);

/*15 Como gestor, quiere obtener el promedio y el total de beneficios asignados a cada plan de membresía.*/
DELIMITER //
CREATE FUNCTION total_beneficios_por_plan(mid INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM membershipbenefits WHERE membership_id = mid;
  RETURN total;
END;//
DELIMITER ;
SELECT total_beneficios_por_plan(1);

/*16 Como gerente, desea obtener la media y la varianza del precio de productos por empresa.*/
DELIMITER //
CREATE FUNCTION promedio_precio_por_empresa(cid VARCHAR(20))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE media DECIMAL(10,2);
  SELECT AVG(price) INTO media FROM companyproducts WHERE company_id = cid;
  RETURN media;
END;//
DELIMITER ;
SELECT promedio_precio_por_empresa('900100001');

/*17 Como cliente, quiere ver cuántos productos están disponibles en su ciudad.*/
DELIMITER //
CREATE FUNCTION productos_disponibles_por_ciudad(cid VARCHAR(10))
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(DISTINCT cp.product_id) INTO total
  FROM companies c
  JOIN companyproducts cp ON cp.company_id = c.id
  WHERE c.city_id = cid;
  RETURN total;
END;//
DELIMITER ;
SELECT productos_disponibles_por_ciudad('05001');

/*18 Como administrador, desea contar los productos únicos por tipo de empresa.*/
DELIMITER //
CREATE FUNCTION productos_por_tipo_empresa(type_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(DISTINCT cp.product_id) INTO total
  FROM companies c
  JOIN companyproducts cp ON cp.company_id = c.id
  WHERE c.type_id = type_id;
  RETURN total;
END;//
DELIMITER ;
SELECT productos_por_tipo_empresa(1);

/*19 Como operador, quiere saber cuántos clientes no han registrado su correo.*/
DELIMITER //
CREATE FUNCTION clientes_sin_correo()
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM customers WHERE email IS NULL OR email = '';
  RETURN total;
END;//
DELIMITER ;
SELECT clientes_sin_correo();

/*20 Como especialista, desea obtener la empresa con el mayor número de productos calificados.*/
DELIMITER //
CREATE FUNCTION empresa_mas_calificada()
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
  DECLARE nombre VARCHAR(50);
  SELECT c.name INTO nombre
  FROM quality_products qp
  JOIN companies c ON qp.company_id = c.id
  GROUP BY c.id, c.name
  ORDER BY COUNT(DISTINCT qp.product_id) DESC
  LIMIT 1;
  RETURN nombre;
END;//
DELIMITER ;
SELECT empresa_mas_calificada();
