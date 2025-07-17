/*1 Como desarrollador, deseo un trigger que actualice la fecha de modificación cuando se actualice un producto.*/
DELIMITER //
CREATE TRIGGER actualizar_fecha_producto
BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
  SET NEW.updated_at = NOW();
END;//
DELIMITER ;

/*2 Como administrador, quiero un trigger que registre en log cuando un cliente califica un producto.*/
DELIMITER //
CREATE TRIGGER log_calificacion_producto
AFTER INSERT ON rates
FOR EACH ROW
BEGIN
  INSERT INTO log_acciones(usuario, accion, fecha)
  VALUES (NEW.customer_id, CONCAT('Calificó producto ', NEW.product_id), NOW());
END;//
DELIMITER ;

/*3 Como técnico, deseo un trigger que impida insertar productos sin unidad de medida.*/
DELIMITER //
CREATE TRIGGER validar_unidad_producto
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
  IF NEW.unit_id IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No se puede insertar un producto sin unidad de medida';
  END IF;
END;//
DELIMITER ;

/*4 Como auditor, quiero un trigger que verifique que las calificaciones no superen el valor máximo permitido.*/
DELIMITER //
CREATE TRIGGER validar_calificacion_maxima
BEFORE INSERT ON rates
FOR EACH ROW
BEGIN
  IF NEW.rating > 5 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'La calificación no puede superar 5';
  END IF;
END;//
DELIMITER ;

/*5 Como supervisor, deseo un trigger que actualice automáticamente el estado de membresía al vencer el periodo.*/
DELIMITER //
CREATE TRIGGER actualizar_estado_membresia
BEFORE UPDATE ON membershipperiods
FOR EACH ROW
BEGIN
  IF NEW.end_date < CURDATE() THEN
    SET NEW.status = 'INACTIVA';
  END IF;
END;//
DELIMITER ;

/*6 Como operador, quiero un trigger que evite duplicar productos por nombre dentro de una misma empresa.*/
DELIMITER //
CREATE TRIGGER evitar_producto_duplicado_empresa
BEFORE INSERT ON companyproducts
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM companyproducts
    WHERE company_id = NEW.company_id AND product_id = NEW.product_id
  ) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Producto ya registrado en esta empresa';
  END IF;
END;//
DELIMITER ;

/*7 Como cliente, deseo un trigger que envíe notificación cuando añado un producto como favorito.*/
DELIMITER //
CREATE TRIGGER notificar_favorito
AFTER INSERT ON details_favorites
FOR EACH ROW
BEGIN
  INSERT INTO notificaciones(mensaje, fecha)
  VALUES (CONCAT('Producto ', NEW.product_id, ' añadido como favorito'), NOW());
END;//
DELIMITER ;

/*8 Como técnico, quiero un trigger que inserte una fila en quality_products cuando se registra una calificación.*/
DELIMITER //
CREATE TRIGGER insertar_en_quality_products
AFTER INSERT ON rates
FOR EACH ROW
BEGIN
  INSERT INTO quality_products(customer_id, company_id, product_id, rating, daterating)
  VALUES (NEW.customer_id, NEW.company_id, NEW.product_id, NEW.rating, NEW.created_at);
END;//
DELIMITER ;

/*9 Como desarrollador, deseo un trigger que elimine los favoritos si se elimina el producto.*/
DELIMITER //
CREATE TRIGGER eliminar_favoritos_con_producto
AFTER DELETE ON products
FOR EACH ROW
BEGIN
  DELETE FROM details_favorites WHERE product_id = OLD.id;
END;//
DELIMITER ;

/*10 Como administrador, quiero un trigger que bloquee la modificación de audiencias activas.*/
DELIMITER //
CREATE TRIGGER bloquear_modificacion_audiencias
BEFORE UPDATE ON audiences
FOR EACH ROW
BEGIN
  IF OLD.status = 'activa' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No se puede modificar una audiencia activa';
  END IF;
END;//
DELIMITER ;

/*11 Como gestor, deseo un trigger que actualice el promedio de calidad del producto tras una nueva evaluación.*/
DELIMITER //
CREATE TRIGGER actualizar_promedio_quality
AFTER INSERT ON rates
FOR EACH ROW
BEGIN
  UPDATE products
  SET average_rating = (
    SELECT AVG(rating)
    FROM quality_products
    WHERE product_id = NEW.product_id
  )
  WHERE id = NEW.product_id;
END;//
DELIMITER ;

/*12 Como auditor, quiero un trigger que registre cada vez que se asigna un nuevo beneficio.*/
DELIMITER //
CREATE TRIGGER registrar_beneficio_membership
AFTER INSERT ON membershipbenefits
FOR EACH ROW
BEGIN
  INSERT INTO bitacora(accion, fecha)
  VALUES (CONCAT('Asignado beneficio ', NEW.benefit_id, ' a plan ', NEW.membership_id), NOW());
END;//
DELIMITER ;

DELIMITER //
CREATE TRIGGER registrar_beneficio_audience
AFTER INSERT ON audiencebenefits
FOR EACH ROW
BEGIN
  INSERT INTO bitacora(accion, fecha)
  VALUES (CONCAT('Asignado beneficio ', NEW.benefit_id, ' a audiencia ', NEW.audience_id), NOW());
END;//
DELIMITER ;

/*13 Como cliente, deseo un trigger que me impida calificar el mismo producto dos veces seguidas.*/
DELIMITER //
CREATE TRIGGER evitar_calificacion_duplicada
BEFORE INSERT ON rates
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM rates
    WHERE customer_id = NEW.customer_id AND product_id = NEW.product_id
  ) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ya has calificado este producto';
  END IF;
END;//
DELIMITER ;

/*14 Como técnico, quiero un trigger que valide que el email del cliente no se repita.*/
DELIMITER //
CREATE TRIGGER validar_email_cliente
BEFORE INSERT ON customers
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM customers WHERE email = NEW.email
  ) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'El email ya está registrado';
  END IF;
END;//
DELIMITER ;

/*15 Como operador, deseo un trigger que elimine registros huérfanos de details_favorites.*/
DELIMITER //
CREATE TRIGGER eliminar_detalles_huerfanos
AFTER DELETE ON favorites
FOR EACH ROW
BEGIN
  DELETE FROM details_favorites WHERE favorite_id = OLD.id;
END;//
DELIMITER ;

/*16 Como administrador, quiero un trigger que actualice el campo updated_at en companies.*/
DELIMITER //
CREATE TRIGGER actualizar_fecha_empresa
BEFORE UPDATE ON companies
FOR EACH ROW
BEGIN
  SET NEW.updated_at = NOW();
END;//
DELIMITER ;

/*17 Como desarrollador, deseo un trigger que impida borrar una ciudad si hay empresas activas en ella.*/
DELIMITER //
CREATE TRIGGER validar_ciudad_sin_empresas
BEFORE DELETE ON citiesormunicipalities
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM companies WHERE city_id = OLD.code
  ) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No se puede eliminar la ciudad con empresas registradas';
  END IF;
END;//
DELIMITER ;

/*18 Como auditor, quiero un trigger que registre cambios de estado de encuestas.*/
DELIMITER //
CREATE TRIGGER registrar_cambio_estado_encuesta
AFTER UPDATE ON polls
FOR EACH ROW
BEGIN
  IF OLD.status != NEW.status THEN
    INSERT INTO log_acciones(usuario, accion, fecha)
    VALUES ('sistema', CONCAT('Cambio de estado de encuesta ', OLD.id, ' de ', OLD.status, ' a ', NEW.status), NOW());
  END IF;
END;//
DELIMITER ;

/*19 Como supervisor, deseo un trigger que sincronice rates con quality_products al calificar.*/
DELIMITER //
CREATE TRIGGER sincronizar_quality_products
AFTER INSERT ON rates
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM quality_products
    WHERE customer_id = NEW.customer_id AND product_id = NEW.product_id
  ) THEN
    UPDATE quality_products
    SET rating = NEW.rating, daterating = NEW.created_at
    WHERE customer_id = NEW.customer_id AND product_id = NEW.product_id;
  ELSE
    INSERT INTO quality_products(customer_id, company_id, product_id, rating, daterating)
    VALUES (NEW.customer_id, NEW.company_id, NEW.product_id, NEW.rating, NEW.created_at);
  END IF;
END;//
DELIMITER ;

/*20 Como operador, quiero un trigger que elimine automáticamente productos sin relación a empresas.*/
DELIMITER //
CREATE TRIGGER eliminar_producto_sin_empresa
AFTER DELETE ON companyproducts
FOR EACH ROW
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM companyproducts WHERE product_id = OLD.product_id
  ) THEN
    DELETE FROM products WHERE id = OLD.product_id;
  END IF;
END;//
DELIMITER ;
