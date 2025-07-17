/*1. calcular_promedio_ponderado(product_id)*/
DELIMITER //
CREATE FUNCTION calcular_promedio_ponderado(id_producto INT) RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
    DECLARE promedio DECIMAL(5,2);
    SELECT SUM(rating * (DATEDIFF(CURDATE(), daterating) + 1) / 100.0) / COUNT(*)
    INTO promedio
    FROM quality_products
    WHERE product_id = id_producto;
    RETURN promedio;
END;//
DELIMITER ;

SELECT calcular_promedio_ponderado(1);

/*2. es_calificacion_reciente(fecha)*/
DELIMITER //
CREATE FUNCTION es_calificacion_reciente(fecha DATE) RETURNS BOOLEAN
READS SQL DATA
BEGIN
    RETURN DATEDIFF(CURDATE(), fecha) <= 30;
END;//
DELIMITER ;

SELECT es_calificacion_reciente('2025-07-01');

/*3. obtener_empresa_producto(product_id)*/
DELIMITER //
CREATE FUNCTION obtener_empresa_producto(id_producto INT) RETURNS VARCHAR(100)
READS SQL DATA
BEGIN
    DECLARE nombre_empresa VARCHAR(100);
    SELECT c.name INTO nombre_empresa
    FROM companyproducts cp
    JOIN companies c ON cp.company_id = c.id
    WHERE cp.product_id = id_producto
    LIMIT 1;
    RETURN nombre_empresa;
END;//
DELIMITER ;

SELECT obtener_empresa_producto(1);

/*4. tiene_membresia_activa(customer_id)*/
DELIMITER //
CREATE FUNCTION tiene_membresia_activa(id_cliente INT) RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE activo BOOLEAN;

    SELECT COUNT(*) > 0 INTO activo
    FROM customers cu
    JOIN memberships m ON cu.id = m.customer_id
    JOIN membershipperiods mp ON mp.membership_id = m.id
    JOIN periods p ON mp.period_id = p.id
    WHERE CURDATE() BETWEEN p.name AND DATE_ADD(p.name, INTERVAL 30 DAY); -- Ajusta si "name" es fecha

    RETURN activo;
END;//
DELIMITER ;


SELECT tiene_membresia_activa(1);

/*5. ciudad_supera_empresas(city_id, limite)*/
DELIMITER //
CREATE FUNCTION ciudad_supera_empresas(id_ciudad INT, limite INT) RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE resultado BOOLEAN;
    SELECT COUNT(*) > limite INTO resultado
    FROM companies
    WHERE city_id = id_ciudad;
    RETURN resultado;
END;//
DELIMITER ;

SELECT ciudad_supera_empresas(2, 3);

/*6. descripcion_calificacion(valor)*/
DELIMITER //
CREATE FUNCTION descripcion_calificacion(valor INT) RETURNS VARCHAR(20)
READS SQL DATA
BEGIN
    RETURN CASE
        WHEN valor = 5 THEN 'Excelente'
        WHEN valor = 4 THEN 'Bueno'
        WHEN valor = 3 THEN 'Regular'
        WHEN valor = 2 THEN 'Malo'
        ELSE 'Pésimo'
    END;
END;//
DELIMITER ;
SELECT descripcion_calificacion(4);


/*7. estado_producto(product_id)*/
DELIMITER //
CREATE FUNCTION estado_producto(id_producto INT) RETURNS VARCHAR(20)
READS SQL DATA
BEGIN
    DECLARE promedio DECIMAL(5,2);
    SELECT AVG(rating) INTO promedio
    FROM quality_products
    WHERE product_id = id_producto;
    RETURN CASE
        WHEN promedio >= 4 THEN 'Óptimo'
        WHEN promedio >= 2 THEN 'Aceptable'
        ELSE 'Crítico'
    END;
END;//
DELIMITER ;

SELECT estado_producto(1);
/*8. es_favorito(customer_id, product_id)*/
DELIMITER //
CREATE FUNCTION es_favorito(id_cliente INT, id_producto INT) RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM favorites f
    JOIN details_favorites df ON f.id = df.favorite_id
    WHERE f.customer_id = id_cliente AND df.product_id = id_producto;
    RETURN existe;
END;//
DELIMITER ;

SELECT es_favorito(1, 1);

/*9. beneficio_asignado_audiencia(benefit_id, audience_id)*/
DELIMITER //
CREATE FUNCTION beneficio_asignado_audiencia(id_beneficio INT, id_audiencia INT) RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO existe
    FROM audiencebenefits
    WHERE benefit_id = id_beneficio AND audience_id = id_audiencia;
    RETURN existe;
END;//
DELIMITER ;

SELECT beneficio_asignado_audiencia(1, 1);


/*10. fecha_en_membresia(fecha, customer_id)*/
DELIMITER //
CREATE FUNCTION fecha_en_membresia(fecha DATE, id_cliente INT) RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE esta BOOLEAN;
    SELECT COUNT(*) > 0 INTO esta
    FROM membershipperiods mp
    WHERE mp.customer_id = id_cliente
    AND fecha BETWEEN mp.start_date AND mp.end_date;
    RETURN esta;
END;//
DELIMITER ;
SELECT fecha_en_membresia('2025-07-10', 1);

/*11. porcentaje_positivas(product_id)*/
DELIMITER //
CREATE FUNCTION porcentaje_positivas(id_producto INT) RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
    DECLARE total INT;
    DECLARE positivas INT;
    SELECT COUNT(*) INTO total FROM quality_products WHERE product_id = id_producto;
    SELECT COUNT(*) INTO positivas FROM quality_products WHERE product_id = id_producto AND rating >= 4;
    IF total = 0 THEN RETURN 0;
    ELSE RETURN (positivas / total) * 100;
    END IF;
END;//
DELIMITER ;

SELECT porcentaje_positivas(1);


/*12. edad_calificacion(daterating)*/
DELIMITER //
CREATE FUNCTION edad_calificacion(fecha DATE) RETURNS INT
READS SQL DATA
BEGIN
    RETURN DATEDIFF(CURDATE(), fecha);
END;//
DELIMITER ;
SELECT edad_calificacion('2025-06-01');
/*13. productos_por_empresa(company_id)*/
DELIMITER //
CREATE FUNCTION productos_por_empresa(id_empresa INT) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total INT;
    SELECT COUNT(DISTINCT product_id) INTO total FROM companyproducts WHERE company_id = id_empresa;
    RETURN total;
END;//
DELIMITER ;
SELECT productos_por_empresa(1);
/*14. nivel_actividad_cliente(customer_id)*/
DELIMITER //
CREATE FUNCTION nivel_actividad_cliente(id_cliente INT) RETURNS VARCHAR(20)
READS SQL DATA
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM quality_products WHERE customer_id = id_cliente;
    RETURN CASE
        WHEN total >= 20 THEN 'Frecuente'
        WHEN total >= 5 THEN 'Esporádico'
        ELSE 'Inactivo'
    END;
END;//
DELIMITER ;
SELECT nivel_actividad_cliente(1);
/*15. promedio_ponderado_favoritos(product_id)*/
DELIMITER //
CREATE FUNCTION promedio_ponderado_favoritos(id_producto INT) RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
    DECLARE total INT;
    DECLARE suma DECIMAL(10,2);
    SELECT COUNT(*) INTO total FROM details_favorites WHERE product_id = id_producto;
    SELECT AVG(rating) * total INTO suma FROM quality_products WHERE product_id = id_producto;
    RETURN suma;
END;//
DELIMITER ;

SELECT promedio_ponderado_favoritos(1);
/*16. benefit_es_compartido(benefit_id)*/
DELIMITER //
CREATE FUNCTION benefit_es_compartido(id_beneficio INT) RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE cantidad INT;
    SELECT COUNT(DISTINCT audience_id) INTO cantidad
    FROM audiencebenefits
    WHERE benefit_id = id_beneficio;
    RETURN cantidad > 1;
END;//
DELIMITER ;
SELECT benefit_es_compartido(1);
/*17. indice_variedad_ciudad(city_id)*/
DELIMITER //
CREATE FUNCTION indice_variedad_ciudad(id_ciudad INT) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE empresas INT;
    DECLARE productos INT;
    SELECT COUNT(*) INTO empresas FROM companies WHERE city_id = id_ciudad;
    SELECT COUNT(DISTINCT cp.product_id) INTO productos
    FROM companies c
    JOIN companyproducts cp ON c.id = cp.company_id
    WHERE c.city_id = id_ciudad;
    RETURN empresas * productos;
END;//
DELIMITER ;
SELECT indice_variedad_ciudad(1);

/*18. producto_debe_deshabilitarse(product_id)*/
DELIMITER //
CREATE FUNCTION producto_debe_deshabilitarse(id_producto INT) RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE promedio DECIMAL(5,2);
    SELECT AVG(rating) INTO promedio FROM quality_products WHERE product_id = id_producto;
    RETURN promedio < 2.0;
END;//
DELIMITER ;


SELECT producto_debe_deshabilitarse(1);
/*19. indice_popularidad(product_id)*/
DELIMITER //
CREATE FUNCTION indice_popularidad(id_producto INT) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE f INT;
    DECLARE r INT;
    SELECT COUNT(*) INTO f FROM details_favorites WHERE product_id = id_producto;
    SELECT COUNT(*) INTO r FROM quality_products WHERE product_id = id_producto;
    RETURN f + r;
END;//
DELIMITER ;
SELECT indice_popularidad(1);


/*20. generar_codigo_producto(product_id)*/
DELIMITER //
CREATE FUNCTION generar_codigo_producto(id_producto INT) RETURNS VARCHAR(100)
READS SQL DATA
BEGIN
    DECLARE nombre VARCHAR(50);
    DECLARE fecha DATE;
    DECLARE codigo VARCHAR(100);
    SELECT name INTO nombre FROM products WHERE id = id_producto;
    SELECT created_at INTO fecha FROM products WHERE id = id_producto;
    SET codigo = CONCAT(UCASE(LEFT(nombre, 3)), '-', DATE_FORMAT(fecha, '%Y%m%d'));
    RETURN codigo;
END;//
DELIMITER ;
SELECT generar_codigo_producto(1);
