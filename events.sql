/*1. Borrar productos sin actividad cada 6 meses*/
CREATE EVENT IF NOT EXISTS borrar_productos_sin_actividad
ON SCHEDULE EVERY 6 MONTH
DO
  DELETE FROM products
  WHERE id NOT IN (SELECT product_id FROM quality_products)
    AND id NOT IN (SELECT product_id FROM details_favorites)
    AND id NOT IN (SELECT product_id FROM companyproducts);

/*2. Recalcular el promedio de calificaciones semanalmente*/
CREATE EVENT IF NOT EXISTS actualizar_promedio_semanal
ON SCHEDULE EVERY 1 WEEK
DO
  UPDATE products p
  SET average_rating = (
    SELECT AVG(rating) FROM quality_products qp WHERE qp.product_id = p.id
  );

/*3. Actualizar precios por inflación cada mes*/
CREATE EVENT IF NOT EXISTS ajustar_precios_inflacion
ON SCHEDULE EVERY 1 MONTH
DO
  UPDATE companyproducts SET price = price * 1.03;

/*4. Crear backups diarios*/
CREATE EVENT IF NOT EXISTS backup_diario
ON SCHEDULE EVERY 1 DAY STARTS CURRENT_DATE + INTERVAL 0 HOUR
DO
BEGIN
  INSERT INTO products_backup SELECT * FROM products;
  INSERT INTO rates_backup SELECT * FROM rates;
END;

/*5. Recordatorios de favoritos sin calificación*/
CREATE EVENT IF NOT EXISTS recordar_favoritos_no_calificados
ON SCHEDULE EVERY 1 WEEK
DO
  INSERT INTO user_reminders(customer_id, product_id, fecha)
  SELECT f.customer_id, df.product_id, NOW()
  FROM favorites f
  JOIN details_favorites df ON f.id = df.favorite_id
  LEFT JOIN quality_products qp ON qp.customer_id = f.customer_id AND qp.product_id = df.product_id
  WHERE qp.id IS NULL;

/*6. Revisar inconsistencias empresa-producto*/
CREATE EVENT IF NOT EXISTS revisar_inconsistencias
ON SCHEDULE EVERY 1 WEEK STARTS CURRENT_DATE + INTERVAL (7 - DAYOFWEEK(CURRENT_DATE)) DAY
DO
BEGIN
  INSERT INTO errores_log(descripcion, fecha)
  SELECT 'Producto sin empresa', NOW()
  FROM products p
  WHERE NOT EXISTS (
    SELECT 1 FROM companyproducts cp WHERE cp.product_id = p.id
  );
END;

/*7. Archivar membresías vencidas*/
CREATE EVENT IF NOT EXISTS archivar_membresias_vencidas
ON SCHEDULE EVERY 1 DAY
DO
  UPDATE membershipperiods
  SET status = 'INACTIVA'
  WHERE end_date < CURDATE();

/*8. Notificar beneficios recientes*/
CREATE EVENT IF NOT EXISTS notificar_beneficios_nuevos
ON SCHEDULE EVERY 1 WEEK
DO
  INSERT INTO notificaciones(mensaje, fecha)
  SELECT CONCAT('Nuevo beneficio: ', description), NOW()
  FROM benefits
  WHERE created_at >= NOW() - INTERVAL 7 DAY;

/*9. Resumen mensual de favoritos*/
CREATE EVENT IF NOT EXISTS resumen_favoritos_mensual
ON SCHEDULE EVERY 1 MONTH
DO
  INSERT INTO favoritos_resumen(customer_id, total, fecha)
  SELECT f.customer_id, COUNT(df.product_id), NOW()
  FROM favorites f
  JOIN details_favorites df ON f.id = df.favorite_id
  GROUP BY f.customer_id;

/*10. Validar claves foráneas*/
CREATE EVENT IF NOT EXISTS validar_foreign_keys
ON SCHEDULE EVERY 1 WEEK
DO
BEGIN
  INSERT INTO inconsistencias_fk(tipo, id_afectado, fecha)
  SELECT 'Producto sin cliente', r.id, NOW()
  FROM rates r
  WHERE r.customer_id NOT IN (SELECT id FROM customers);
END;

/*11. Eliminar calificaciones inválidas antiguas*/
CREATE EVENT IF NOT EXISTS eliminar_rates_invalidos
ON SCHEDULE EVERY 1 MONTH
DO
  DELETE FROM rates
  WHERE (rating IS NULL OR rating < 0)
    AND created_at < NOW() - INTERVAL 3 MONTH;

/*12. Inactivar encuestas sin uso reciente*/
CREATE EVENT IF NOT EXISTS inactivar_encuestas_antiguas
ON SCHEDULE EVERY 1 WEEK
DO
  UPDATE polls
  SET status = 'inactiva'
  WHERE id NOT IN (
    SELECT DISTINCT poll_id FROM rates
    WHERE created_at >= NOW() - INTERVAL 6 MONTH
  );

/*13. Registrar conteo de auditoría diario*/
CREATE EVENT IF NOT EXISTS registrar_auditoria_diaria
ON SCHEDULE EVERY 1 DAY
DO
  INSERT INTO auditorias_diarias(productos, usuarios, fecha)
  SELECT (SELECT COUNT(*) FROM products), (SELECT COUNT(*) FROM customers), NOW();

/*14. Notificar métricas de calidad*/
CREATE EVENT IF NOT EXISTS notificar_metricas_calidad
ON SCHEDULE EVERY 1 WEEK STARTS CURRENT_DATE + INTERVAL (8 - DAYOFWEEK(CURRENT_DATE)) DAY
DO
  INSERT INTO notificaciones_empresa(empresa_id, mensaje, fecha)
  SELECT c.id, CONCAT('Promedio de calidad: ', ROUND(AVG(qp.rating),2)), NOW()
  FROM quality_products qp
  JOIN companies c ON qp.company_id = c.id
  GROUP BY c.id;

/*15. Recordar renovación de membresías*/
CREATE EVENT IF NOT EXISTS recordar_renovacion_membresia
ON SCHEDULE EVERY 1 DAY
DO
  INSERT INTO recordatorios(membership_id, mensaje, fecha)
  SELECT mp.membership_id, 'Tu membresía está por vencer', NOW()
  FROM membershipperiods mp
  WHERE mp.end_date BETWEEN CURDATE() AND CURDATE() + INTERVAL 7 DAY;

/*16. Reordenar estadísticas generales semanalmente*/
CREATE EVENT IF NOT EXISTS actualizar_estadisticas
ON SCHEDULE EVERY 1 WEEK
DO
  UPDATE estadisticas
  SET total_productos = (SELECT COUNT(*) FROM products),
      total_clientes = (SELECT COUNT(*) FROM customers),
      fecha = NOW();

/*17. Crear resumen temporal por categoría*/
CREATE EVENT IF NOT EXISTS resumen_uso_categoria
ON SCHEDULE EVERY 1 MONTH
DO
  INSERT INTO resumen_categoria(categoria_id, cantidad, fecha)
  SELECT p.category_id, COUNT(DISTINCT qp.product_id), NOW()
  FROM quality_products qp
  JOIN products p ON qp.product_id = p.id
  GROUP BY p.category_id;

/*18. Desactivar beneficios expirados*/
CREATE EVENT IF NOT EXISTS desactivar_beneficios_caducados
ON SCHEDULE EVERY 1 DAY
DO
  UPDATE benefits
  SET status = 'inactivo'
  WHERE expires_at IS NOT NULL AND expires_at < CURDATE();

/*19. Alertar productos sin evaluación anual*/
CREATE EVENT IF NOT EXISTS alertar_productos_sin_evaluacion
ON SCHEDULE EVERY 1 MONTH
DO
  INSERT INTO alertas_productos(product_id, mensaje, fecha)
  SELECT p.id, 'Este producto no ha sido evaluado en el último año', NOW()
  FROM products p
  WHERE NOT EXISTS (
    SELECT 1 FROM quality_products qp
    WHERE qp.product_id = p.id AND qp.daterating >= NOW() - INTERVAL 1 YEAR
  );

/*20. Actualizar precios con índice externo*/
CREATE EVENT IF NOT EXISTS actualizar_precios_con_indice
ON SCHEDULE EVERY 1 MONTH
DO
  UPDATE companyproducts cp
  JOIN inflacion_indice ii ON MONTH(ii.fecha) = MONTH(CURDATE()) AND YEAR(ii.fecha) = YEAR(CURDATE())
  SET cp.price = cp.price * ii.indice;
