/*1 Como desarrollador, quiero un procedimiento que registre una calificación y actualice el promedio del producto.*/
DELIMITER //
CREATE PROCEDURE registrar_calificacion(IN pid INT, IN cid INT, IN cal DECIMAL(3,2))
BEGIN
  INSERT INTO rates(customer_id, product_id, rating, created_at)
  VALUES (cid, pid, cal, NOW());

  UPDATE products
  SET average_rating = (
    SELECT AVG(rating) FROM rates WHERE product_id = pid
  )
  WHERE id = pid;
END;//
DELIMITER ;
CALL registrar_calificacion(1, 1, 4.5);

/*2 Como administrador, deseo un procedimiento para insertar una empresa y asociar productos por defecto.*/
DELIMITER //
CREATE PROCEDURE insertar_empresa_con_productos(
  IN id_empresa VARCHAR(20),
  IN nombre_empresa VARCHAR(100),
  IN ciudad_id VARCHAR(10),
  IN categoria_id INT,
  IN tipo_id INT
)
BEGIN
  INSERT INTO companies(id, name, city_id, category_id, type_id)
  VALUES (id_empresa, nombre_empresa, ciudad_id, categoria_id, tipo_id);

  INSERT INTO companyproducts(company_id, product_id, price, unitmeasure_id)
  SELECT id_empresa, id, 10000, 1 FROM products LIMIT 3;
END;//
DELIMITER ;
CALL insertar_empresa_con_productos('900100099', 'NuevaEmpresa S.A.S', '05001', 1, 1);

/*3 Como cliente, quiero un procedimiento que añada un producto favorito y verifique duplicados.*/
DELIMITER //
CREATE PROCEDURE agregar_favorito(IN cliente_id INT, IN producto_id INT)
BEGIN
  DECLARE fav_id INT;
  SELECT id INTO fav_id FROM favorites WHERE customer_id = cliente_id LIMIT 1;

  IF fav_id IS NULL THEN
    INSERT INTO favorites(customer_id) VALUES (cliente_id);
    SET fav_id = LAST_INSERT_ID();
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM details_favorites WHERE favorite_id = fav_id AND product_id = producto_id
  ) THEN
    INSERT INTO details_favorites(favorite_id, product_id) VALUES (fav_id, producto_id);
  END IF;
END;//
DELIMITER ;
CALL agregar_favorito(1, 2);

/*4 Como gestor, deseo un procedimiento que genere un resumen mensual de calificaciones por empresa.*/
DELIMITER //
CREATE PROCEDURE generar_resumen_mensual()
BEGIN
  INSERT INTO resumen_calificaciones (empresa_id, mes, promedio)
  SELECT company_id, DATE_FORMAT(daterating, '%Y-%m'), AVG(rating)
  FROM quality_products
  GROUP BY company_id, DATE_FORMAT(daterating, '%Y-%m');
END;//
DELIMITER ;
CALL generar_resumen_mensual();

/*5 Como supervisor, quiero un procedimiento que calcule beneficios activos por membresía.*/
DELIMITER //
CREATE PROCEDURE beneficios_activos_por_membresia()
BEGIN
  SELECT mb.membership_id, b.description
  FROM membershipbenefits mb
  JOIN membershipperiods mp ON mb.membership_id = mp.membership_id AND mb.period_id = mp.period_id
  JOIN benefits b ON mb.benefit_id = b.id
  WHERE NOW() BETWEEN mp.start_date AND mp.end_date;
END;//
DELIMITER ;
CALL beneficios_activos_por_membresia();

/*6 Como técnico, deseo un procedimiento que elimine productos sin calificación ni empresa asociada.*/
DELIMITER //
CREATE PROCEDURE eliminar_productos_huerfanos()
BEGIN
  DELETE FROM products
  WHERE id NOT IN (SELECT DISTINCT product_id FROM companyproducts)
    AND id NOT IN (SELECT DISTINCT product_id FROM quality_products);
END;//
DELIMITER ;
CALL eliminar_productos_huerfanos();

/*7 Como operador, quiero un procedimiento que actualice precios de productos por categoría.*/
DELIMITER //
CREATE PROCEDURE actualizar_precios_categoria(IN categoria_id INT, IN factor DECIMAL(5,2))
BEGIN
  UPDATE companyproducts cp
  JOIN products p ON cp.product_id = p.id
  SET cp.price = cp.price * factor
  WHERE p.category_id = categoria_id;
END;//
DELIMITER ;
CALL actualizar_precios_categoria(1, 1.05);

/*8 Como auditor, deseo un procedimiento que liste inconsistencias entre rates y quality_products.*/
DELIMITER //
CREATE PROCEDURE validar_inconsistencias()
BEGIN
  INSERT INTO errores_log(descripcion, fecha)
  SELECT CONCAT('Sin match: rate ID ', r.id), NOW()
  FROM rates r
  WHERE NOT EXISTS (
    SELECT 1 FROM quality_products qp
    WHERE qp.customer_id = r.customer_id AND qp.product_id = r.product_id
  );
END;//
DELIMITER ;
CALL validar_inconsistencias();

/*9 Como desarrollador, quiero un procedimiento que asigne beneficios a nuevas audiencias.*/
DELIMITER //
CREATE PROCEDURE asignar_beneficio_a_audiencia(IN aid INT, IN bid INT)
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM audiencebenefits WHERE audience_id = aid AND benefit_id = bid
  ) THEN
    INSERT INTO audiencebenefits(audience_id, benefit_id) VALUES (aid, bid);
  END IF;
END;//
DELIMITER ;
CALL asignar_beneficio_a_audiencia(1, 2);

/*10 Como administrador, deseo un procedimiento que active planes de membresía vencidos si el pago fue confirmado.*/
DELIMITER //
CREATE PROCEDURE activar_planes_vencidos()
BEGIN
  UPDATE membershipperiods
  SET status = 'ACTIVA'
  WHERE end_date < CURDATE() AND pago_confirmado = TRUE;
END;//
DELIMITER ;
CALL activar_planes_vencidos();
/*11 Como cliente, deseo un procedimiento que me devuelva todos mis productos favoritos con su promedio de rating.*/
DELIMITER //
CREATE PROCEDURE favoritos_con_rating(IN cid INT)
BEGIN
  SELECT p.id AS producto_id, p.name AS producto,
         ROUND(AVG(qp.rating), 2) AS promedio_rating
  FROM favorites f
  JOIN details_favorites df ON df.favorite_id = f.id
  JOIN products p ON df.product_id = p.id
  LEFT JOIN quality_products qp ON qp.product_id = p.id
  WHERE f.customer_id = cid
  GROUP BY p.id, p.name;
END;//
DELIMITER ;
CALL favoritos_con_rating(1);

/*12 Como gestor, quiero un procedimiento que registre una encuesta y sus preguntas asociadas.*/
DELIMITER //
CREATE PROCEDURE registrar_encuesta_con_preguntas(
  IN titulo VARCHAR(100),
  IN descripcion TEXT,
  IN estado VARCHAR(20),
  IN preguntas TEXT
)
BEGIN
  DECLARE nueva_encuesta_id INT;
  INSERT INTO polls(title, description, status, created_at) VALUES (titulo, descripcion, estado, NOW());
  SET nueva_encuesta_id = LAST_INSERT_ID();

  -- Se espera que las preguntas estén separadas por ';'
  WHILE LOCATE(';', preguntas) > 0 DO
    INSERT INTO poll_questions(poll_id, question)
    VALUES (nueva_encuesta_id, SUBSTRING_INDEX(preguntas, ';', 1));
    SET preguntas = SUBSTRING(preguntas FROM LOCATE(';', preguntas) + 1);
  END WHILE;

  IF LENGTH(TRIM(preguntas)) > 0 THEN
    INSERT INTO poll_questions(poll_id, question) VALUES (nueva_encuesta_id, preguntas);
  END IF;
END;//
DELIMITER ;
CALL registrar_encuesta_con_preguntas('Satisfacción', 'Encuesta general', 'activa', '¿Te gustó el producto?;¿Lo recomendarías?');

/*13 Como técnico, deseo un procedimiento que borre favoritos antiguos no calificados en más de un año.*/
DELIMITER //
CREATE PROCEDURE eliminar_favoritos_sin_rating()
BEGIN
  DELETE df FROM details_favorites df
  JOIN favorites f ON df.favorite_id = f.id
  LEFT JOIN quality_products qp ON df.product_id = qp.product_id AND f.customer_id = qp.customer_id
  WHERE qp.id IS NULL
    AND f.created_at < DATE_SUB(NOW(), INTERVAL 12 MONTH);
END;//
DELIMITER ;
CALL eliminar_favoritos_sin_rating();

/*14 Como operador, quiero un procedimiento que asocie automáticamente beneficios por audiencia.*/
DELIMITER //
CREATE PROCEDURE asociar_beneficios_por_audiencia()
BEGIN
  INSERT IGNORE INTO audiencebenefits(audience_id, benefit_id)
  SELECT a.id, b.id
  FROM audiences a, benefits b
  WHERE b.detail LIKE CONCAT('%', a.description, '%');
END;//
DELIMITER ;
CALL asociar_beneficios_por_audiencia();

/*15 Como administrador, deseo un procedimiento para generar un historial de cambios de precio.*/
DELIMITER //
CREATE PROCEDURE historial_cambios_precio(
  IN producto_id INT,
  IN empresa_id VARCHAR(20),
  IN nuevo_precio DECIMAL(10,2)
)
BEGIN
  DECLARE precio_anterior DECIMAL(10,2);
  SELECT price INTO precio_anterior FROM companyproducts WHERE company_id = empresa_id AND product_id = producto_id;
  
  IF precio_anterior != nuevo_precio THEN
    UPDATE companyproducts SET price = nuevo_precio
    WHERE company_id = empresa_id AND product_id = producto_id;

    INSERT INTO historial_precios(product_id, company_id, precio_anterior, nuevo_precio, fecha)
    VALUES (producto_id, empresa_id, precio_anterior, nuevo_precio, NOW());
  END IF;
END;//
DELIMITER ;
CALL historial_cambios_precio(1, '900100001', 15000);

/*16 Como desarrollador, quiero un procedimiento que registre automáticamente una nueva encuesta activa.*/
DELIMITER //
CREATE PROCEDURE registrar_encuesta_activa(
  IN titulo VARCHAR(100),
  IN descripcion TEXT
)
BEGIN
  INSERT INTO polls(title, description, status, created_at)
  VALUES (titulo, descripcion, 'activa', NOW());
END;//
DELIMITER ;
CALL registrar_encuesta_activa('Opinión General', 'Encuesta creada automáticamente');

/*17 Como técnico, deseo un procedimiento que actualice la unidad de medida de productos sin afectar si hay ventas.*/
DELIMITER //
CREATE PROCEDURE actualizar_unidad_medida_si_no_vendido(
  IN pid INT, IN nueva_unidad INT
)
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM quality_products WHERE product_id = pid
  ) THEN
    UPDATE companyproducts SET unitmeasure_id = nueva_unidad WHERE product_id = pid;
  END IF;
END;//
DELIMITER ;
CALL actualizar_unidad_medida_si_no_vendido(1, 2);

/*18 Como supervisor, quiero un procedimiento que recalcule todos los promedios de calidad cada semana.*/
DELIMITER //
CREATE PROCEDURE recalcular_promedios_calidad()
BEGIN
  UPDATE products p
  SET average_rating = (
    SELECT AVG(rating)
    FROM quality_products qp
    WHERE qp.product_id = p.id
  );
END;//
DELIMITER ;
CALL recalcular_promedios_calidad();

/*19 Como auditor, deseo un procedimiento que valide claves foráneas cruzadas entre calificaciones y encuestas.*/
DELIMITER //
CREATE PROCEDURE validar_claves_foreign()
BEGIN
  INSERT INTO errores_log(descripcion, fecha)
  SELECT CONCAT('Encuesta inválida: rate ID ', r.id), NOW()
  FROM rates r
  WHERE r.poll_id NOT IN (SELECT id FROM polls);
END;//
DELIMITER ;
CALL validar_claves_foreign();

/*20 Como gerente, quiero un procedimiento que genere el top 10 de productos más calificados por ciudad.*/
DELIMITER //
CREATE PROCEDURE top_10_productos_ciudad()
BEGIN
  SELECT cm.name AS ciudad, p.name AS producto, AVG(qp.rating) AS promedio
  FROM quality_products qp
  JOIN products p ON qp.product_id = p.id
  JOIN companies c ON qp.company_id = c.id
  JOIN citiesormunicipalities cm ON c.city_id = cm.code
  GROUP BY cm.name, p.name
  ORDER BY cm.name, promedio DESC
  LIMIT 10;
END;//
DELIMITER ;
CALL top_10_productos_ciudad();
