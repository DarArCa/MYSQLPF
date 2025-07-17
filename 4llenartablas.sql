INSERT INTO typesofidentifications (id, description, suffix) VALUES
(1, 'Cédula de Ciudadanía', 'CC'),
(2, 'Cédula de Extranjería', 'CE'),
(3, 'Pasaporte', 'PA'),
(4, 'NIT', 'NIT'),
(5, 'Tarjeta de Identidad', 'TI'),
(6, 'Documento Extranjero', 'DE'),
(7, 'Registro Civil', 'RC'),
(8, 'Permiso Especial', 'PEP'),
(9, 'Carné Diplomático', 'CD'),
(10, 'Sin Documento', 'SD'),
(11, 'DNI', 'DNI'),
(12, 'RUN', 'RUN'),
(13, 'CURP', 'CURP'),
(14, 'CPF', 'CPF'),
(15, 'RFC', 'RFC'),
(16, 'SSN', 'SSN'),
(17, 'Número de Residente', 'NR'),
(18, 'Green Card', 'GC'),
(19, 'Visa Temporal', 'VT'),
(20, 'Visa Permanente', 'VP');

INSERT INTO audiences (id, description) VALUES
(1, 'Jóvenes'),
(2, 'Adultos'),
(3, 'Empresarios'),
(4, 'Estudiantes'),
(5, 'Profesionales'),
(6, 'Hogares'),
(7, 'Emprendedores'),
(8, 'Turistas'),
(9, 'Padres de Familia'),
(10, 'Adultos Mayores'),
(11, 'Deportistas'),
(12, 'Docentes'),
(13, 'Funcionarios Públicos'),
(14, 'Mujeres Emprendedoras'),
(15, 'Público General'),
(16, 'Niños'),
(17, 'Adolescentes'),
(18, 'Clientes Premium'),
(19, 'Viajeros'),
(20, 'Personas con Discapacidad');

INSERT INTO categories (id, description) VALUES
(1, 'Tecnología'),
(2, 'Alimentos'),
(3, 'Educación'),
(4, 'Salud'),
(5, 'Moda'),
(6, 'Electrodomésticos'),
(7, 'Vehículos'),
(8, 'Belleza'),
(9, 'Juguetes'),
(10, 'Hogar'),
(11, 'Servicios Profesionales'),
(12, 'Restaurantes'),
(13, 'Turismo'),
(14, 'Entretenimiento'),
(15, 'Software'),
(16, 'Muebles'),
(17, 'Construcción'),
(18, 'Agricultura'),
(19, 'Seguros'),
(20, 'Finanzas');

INSERT INTO unitofmeasure (id, description) VALUES
(1, 'Unidad'),
(2, 'Litro'),
(3, 'Metro'),
(4, 'Kilogramo'),
(5, 'Gramo'),
(6, 'Centímetro'),
(7, 'Caja'),
(8, 'Paquete'),
(9, 'Galón'),
(10, 'Docena'),
(11, 'Par'),
(12, 'Bolsa'),
(13, 'Botella'),
(14, 'Metro Cuadrado'),
(15, 'Litro por Minuto'),
(16, 'Tonelada'),
(17, 'Tarro'),
(18, 'Sobre'),
(19, 'Rollo'),
(20, 'Blister');

INSERT INTO periods (id, name) VALUES
(1, '1 mes'),
(2, '2 meses'),
(3, '3 meses'),
(4, '4 meses'),
(5, '5 meses'),
(6, '6 meses'),
(7, '7 meses'),
(8, '8 meses'),
(9, '9 meses'),
(10, '10 meses'),
(11, '11 meses'),
(12, '12 meses'),
(13, '1 semana'),
(14, '15 días'),
(15, 'Trimestre'),
(16, 'Cuatrimestre'),
(17, 'Semestre'),
(18, 'Anual'),
(19, 'Bimestral'),
(20, 'Diario');

INSERT INTO memberships (id, name, description) VALUES
(1, 'Bronce', 'Membresía básica con acceso limitado a servicios'),
(2, 'Plata', 'Membresía con beneficios adicionales'),
(3, 'Oro', 'Membresía premium con todos los beneficios'),
(4, 'Diamante', 'Membresía exclusiva con atención personalizada'),
(5, 'StartUp', 'Ideal para emprendedores'),
(6, 'Profesional', 'Pensada para trabajadores independientes'),
(7, 'Empresarial', 'Para medianas y grandes empresas'),
(8, 'Básica', 'Acceso limitado sin costo'),
(9, 'Plus', 'Acceso extendido con beneficios especiales'),
(10, 'Familiar', 'Para varios miembros del mismo hogar'),
(11, 'Estudiante', 'Membresía para educación y aprendizaje'),
(12, 'Temporal', 'Acceso corto a servicios'),
(13, 'Anual Premium', 'Acceso completo durante un año'),
(14, 'Trial', 'Versión de prueba gratuita'),
(15, 'Gold Estudiante', 'Estudiantes con acceso premium'),
(16, 'Profesional Internacional', 'Para freelancers y consultores globales'),
(17, 'Comunidad', 'Apoyo a usuarios de zonas rurales'),
(18, 'Sin Membresía', 'Solo observador'),
(19, 'Aliado Comercial', 'Asociado a convenios comerciales'),
(20, 'VIP', 'Usuarios frecuentes con beneficios máximos');

INSERT INTO benefits (id, description, detail) VALUES
(1, 'Envíos Gratis', 'Recibe tus productos sin costo de transporte'),
(2, 'Soporte 24/7', 'Atención al cliente permanente'),
(3, 'Descuentos Exclusivos', 'Acceso a promociones únicas'),
(4, 'Acceso a Eventos', 'Participa en ferias y encuentros especiales'),
(5, 'Newsletter Prioritaria', 'Recibe noticias antes que nadie'),
(6, 'Atención Personalizada', 'Agentes exclusivos para ayudarte'),
(7, 'Prioridad en Entrega', 'Tus pedidos llegan antes que otros'),
(8, 'Garantía Extendida', 'Más cobertura para tus productos'),
(9, 'Acceso a Cursos', 'Educación continua incluida'),
(10, 'Consultoría Gratuita', 'Asesorías profesionales sin costo'),
(11, 'Acceso API', 'Integración directa con nuestros servicios'),
(12, 'Publicidad Destacada', 'Mejora tu visibilidad en la plataforma'),
(13, 'Gestor de Cuenta', 'Una persona encargada de ayudarte'),
(14, 'Certificados Digitales', 'Recibe constancias de tu participación'),
(15, 'Backup Automático', 'Tus datos siempre seguros'),
(16, 'Atención Preferente', 'Sin filas, sin esperas'),
(17, 'Bonos de Regalo', 'Recibe cupones canjeables'),
(18, 'Beta Access', 'Usa nuevas funciones antes que otros'),
(19, 'Puntos de Fidelidad', 'Canjea por productos o descuentos'),
(20, 'Acceso Multicuenta', 'Comparte beneficios con tu equipo');

INSERT INTO categories_polls (id, name) VALUES
(1, 'Satisfacción del cliente'),
(2, 'Calidad del producto'),
(3, 'Atención al cliente'),
(4, 'Entrega y logística'),
(5, 'Soporte técnico'),
(6, 'Facilidad de uso'),
(7, 'Variedad de productos'),
(8, 'Recomendación'),
(9, 'Comparación con la competencia'),
(10, 'Imagen de marca'),
(11, 'Experiencia general'),
(12, 'Proceso de compra'),
(13, 'Tiempo de respuesta'),
(14, 'Precios y promociones'),
(15, 'Accesibilidad'),
(16, 'Navegación en la app'),
(17, 'Métodos de pago'),
(18, 'Disponibilidad de stock'),
(19, 'Relación calidad/precio'),
(20, 'Confianza en la marca');


INSERT INTO membershipperiods (membership_id, period_id, price) VALUES
(1, 1, 9.99),
(2, 1, 14.99),
(3, 1, 24.99),
(4, 1, 49.99),
(5, 2, 19.99),
(6, 3, 29.99),
(7, 6, 59.99),
(8, 1, 0.00),
(9, 3, 34.99),
(10, 3, 39.99),
(11, 6, 9.99),
(12, 2, 4.99),
(13, 12, 89.99),
(14, 1, 0.00),
(15, 6, 19.99),
(16, 12, 109.99),
(17, 6, 14.99),
(18, 1, 0.00),
(19, 4, 29.99),
(20, 12, 149.99);

INSERT INTO audiencebenefits (audience_id, benefit_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 9),
(5, 6),
(6, 7),
(7, 10),
(8, 4),
(9, 17),
(10, 5),
(11, 8),
(12, 6),
(13, 12),
(14, 13),
(15, 3),
(16, 1),
(17, 5),
(18, 19),
(19, 18),
(20, 20);

INSERT INTO membershipbenefits (membership_id, period_id, audience_id, benefit_id) VALUES
(1, 1, 1, 1),
(2, 1, 2, 2),
(3, 1, 3, 3),
(4, 1, 5, 4),
(5, 2, 7, 10),
(6, 3, 5, 6),
(7, 6, 3, 8),
(8, 1, 15, 3),
(9, 3, 4, 11),
(10, 3, 6, 17),
(11, 6, 4, 9),
(12, 2, 12, 5),
(13, 12, 3, 19),
(14, 1, 16, 1),
(15, 6, 17, 2),
(16, 12, 18, 20),
(17, 6, 19, 14),
(18, 1, 20, 6),
(19, 4, 8, 7),
(20, 12, 11, 18);

INSERT INTO polls (id, name, description, isactive, categorypoll_id) VALUES
(1, 'Satisfacción general', 'Medir el nivel de satisfacción de los clientes', TRUE, 1),
(2, 'Calidad del producto', 'Evaluación de la calidad percibida', TRUE, 2),
(3, 'Tiempo de entrega', 'Puntualidad en la entrega del producto', TRUE, 4),
(4, 'Atención al cliente', 'Valoración del trato recibido', TRUE, 3),
(5, 'Recomendación', '¿Recomendaría este servicio?', TRUE, 8),
(6, 'Variedad de productos', '¿Siente que hay suficiente oferta?', TRUE, 7),
(7, 'Imagen de marca', 'Percepción general de la empresa', FALSE, 10),
(8, 'Navegación web', 'Facilidad de uso del sitio o app', FALSE, 16),
(9, 'Relación calidad/precio', 'Valoración del precio según calidad', TRUE, 19),
(10, 'Accesibilidad', '¿Es fácil acceder al servicio o tienda?', FALSE, 15),
(11, 'Métodos de pago', 'Disponibilidad y comodidad de pagos', TRUE, 17),
(12, 'Stock', 'Frecuencia de productos agotados', FALSE, 18),
(13, 'Soporte técnico', 'Respuesta a problemas técnicos', TRUE, 5),
(14, 'Proceso de compra', 'Simplicidad en la compra', TRUE, 12),
(15, 'Experiencia general', 'Evaluación global del cliente', TRUE, 11),
(16, 'Tiempo de respuesta', 'Velocidad de atención al cliente', TRUE, 13),
(17, 'Descuentos', 'Interés por promociones', FALSE, 14),
(18, 'Fidelidad', '¿Volverías a comprar?', TRUE, 8),
(19, 'Servicio postventa', 'Ayuda después de la compra', TRUE, 5),
(20, 'Confiabilidad', 'Confianza en el servicio ofrecido', TRUE, 20);


INSERT INTO customers (id, name, city_id, audience_id, cellphone, email, address) VALUES
(1, 'Carlos Pérez', '05001', 1, '3001234567', 'carlos.perez@example.com', 'Calle 10 #20-30'),
(2, 'Ana Torres', '05001', 2, '3012345678', 'ana.torres@example.com', 'Cra 15 #45-67'),
(3, 'Luis Gómez', '05001', 1, '3023456789', 'luis.gomez@example.com', 'Diagonal 23 #12-45'),
(4, 'Marta Rodríguez', '11001', 4, '3034567890', 'marta.rodriguez@example.com', 'Av 68 #34-56'),
(5, 'Esteban Ruiz', '11001', 5, '3045678901', 'esteban.ruiz@example.com', 'Transv 45 #10-22'),
(6, 'Diana López', '05034', 6, '3056789012', 'diana.lopez@example.com', 'Calle 22 #33-44'),
(7, 'Camila Herrera', '05034', 7, '3067890123', 'camila.herrera@example.com', 'Cra 50 #10-50'),
(8, 'Mateo Castro', '05042', 1, '3078901234', 'mateo.castro@example.com', 'Cl 18 #22-60'),
(9, 'Laura Romero', '05042', 2, '3089012345', 'laura.romero@example.com', 'Diagonal 76 #11-33'),
(10, 'Julián Vargas', '05042', 3, '3090123456', 'julian.vargas@example.com', 'Av El Poblado #100'),
(11, 'Sandra Gil', '11001', 4, '3101234567', 'sandra.gil@example.com', 'Calle 8 #12-30'),
(12, 'Andrés Salazar', '05001', 5, '3112345678', 'andres.salazar@example.com', 'Cra 20 #56-78'),
(13, 'Vanessa Gómez', '05001', 6, '3123456789', 'vanessa.gomez@example.com', 'Diagonal 45 #34-78'),
(14, 'Ricardo Morales', '05034', 7, '3134567890', 'ricardo.morales@example.com', 'Calle 60 #90-23'),
(15, 'Lucía Díaz', '05042', 3, '3145678901', 'lucia.diaz@example.com', 'Av Nutibara #10'),
(16, 'Juan Ríos', '11001', 8, '3156789012', 'juan.rios@example.com', 'Cra 90 #10-40'),
(17, 'Sofía Cardona', '05001', 9, '3167890123', 'sofia.cardona@example.com', 'Cl 7 #44-56'),
(18, 'Diego Bermúdez', '05034', 10, '3178901234', 'diego.bermudez@example.com', 'Cra 33 #50-70'),
(19, 'Valentina Ruiz', '11001', 1, '3189012345', 'valentina.ruiz@example.com', 'Transv 5 #20-80'),
(20, 'Samuel Pérez', '11001', 2, '3190123456', 'samuel.perez@example.com', 'Calle 72 #15-20');


INSERT INTO companies (id, type_id, name, category_id, city_id, audience_id, cellphone, email) VALUES
('900100001', 4, 'TechCol S.A.S', 1, '05001', 1, '3501234567', 'contacto@techcol.com'),
('900100002', 4, 'FrescoVida Ltda.', 2, '05001', 2, '3502345678', 'ventas@frescovida.com'),
('900100003', 1, 'EducAndo S.A.', 3, '05034', 1, '3503456789', 'info@educando.com'),
('900100004', 4, 'Farmamed S.A.S', 4, '05034', 2, '3504567890', 'contacto@farmamed.com'),
('900100005', 4, 'ModaXpress', 5, '05042', 3, '3505678901', 'ventas@modaxpress.com'),
('900100006', 4, 'ElectroHogar', 1, '05042', 1, '3506789012', 'info@electrohogar.com'),
('900100007', 4, 'SoftBuilders', 1, '11001', 4, '3507890123', 'dev@softbuilders.com'),
('900100008', 4, 'CasaLinda', 10, '11001', 3, '3508901234', 'ventas@casalinda.com'),
('900100009', 4, 'Delicias Andinas', 2, '11001', 2, '3509012345', 'comida@delicias.com'),
('900100010', 4, 'ConsultoresPlus', 11, '05001', 5, '3510123456', 'contacto@consultoresplus.com');


INSERT INTO products (id, name, detail, price, category_id, image) VALUES
(1, 'Laptop Pro', 'Alto rendimiento para profesionales', 3500000, 1, 'laptop.jpg'),
(2, 'Queso Artesanal', 'Producto natural campesino', 18000, 2, 'queso.jpg'),
(3, 'Curso Python', 'Curso online intensivo', 120000, 3, 'curso_python.jpg'),
(4, 'Multivitamínico Plus', 'Refuerza defensas', 40000, 4, 'vitaminas.jpg'),
(5, 'Camisa casual', 'Para uso diario', 65000, 5, 'camisa.jpg'),
(6, 'Asesoría contable', '1 hora con contador', 100000, 11, 'asesoria.jpg'),
(7, 'Silla ergonómica', 'Oficina, color negro', 320000, 10, 'silla.jpg'),
(8, 'Software de gestión', 'CRM para empresas pequeñas', 250000, 1, 'crm.jpg'),
(9, 'Poliza Básica', 'Seguro contra robos', 199000, 19, 'poliza.jpg'),
(10, 'Hamburguesa BBQ', 'Combo con papas y bebida', 30000, 2, 'hamburguesa.jpg');

INSERT INTO favorites (id, customer_id, company_id) VALUES
(1, 1, '900100001'),
(2, 2, '900100001'),
(3, 3, '900100001'),
(4, 4, '900100001'),
(5, 5, '900100001'),
(6, 6, '900100002'),
(7, 7, '900100002'),
(8, 8, '900100002'),
(9, 9, '900100002'),
(10,10, '900100002'),
(11,11, '900100003'),
(12,12, '900100003'),
(13,13, '900100003'),
(14,14, '900100003'),
(15,15, '900100003'),
(16,16, '900100004'),
(17,17, '900100004'),
(18,18, '900100004'),
(19,19, '900100004'),
(20,20, '900100004');

INSERT INTO details_favorites (id, favorite_id, product_id) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 1),
(4, 3, 2),
(5, 3, 3),
(6, 4, 4),
(7, 5, 1),
(8, 6, 2),
(9, 6, 5),
(10,7, 1),
(11,8, 3),
(12,9, 4),
(13,10, 2),
(14,11, 6),
(15,11, 7),
(16,12, 6),
(17,13, 8),
(18,14, 6),
(19,15, 10),
(20,16, 8),
(21,17, 9),
(22,18, 6),
(23,18, 10),
(24,19, 8),
(25,20, 7),
(26,20, 6),
(27,12, 7),
(28,7, 3),
(29,14, 9),
(30,15, 8);

INSERT INTO companyproducts (company_id, product_id, price, unitmeasure_id) VALUES
('900100001', 1, 3450000, 1),
('900100001', 2, 18000, 2),
('900100001', 3, 125000, 1),
('900100002', 1, 3490000, 1),
('900100002', 4, 40000, 2),
('900100002', 5, 63000, 1),
('900100003', 6, 100000, 1),
('900100003', 7, 315000, 1),
('900100003', 8, 249000, 1),
('900100004', 6, 95000, 1),
('900100004', 9, 199000, 1),
('900100004', 10, 28000, 1);

INSERT INTO rates (customer_id, company_id, poll_id, daterating, rating) VALUES
(1, '900100001', 1, NOW(), 4.5),
(2, '900100001', 1, NOW(), 4.2),
(3, '900100001', 2, NOW(), 3.8),
(4, '900100001', 3, NOW(), 5.0),
(5, '900100001', 1, NOW(), 4.7),
(6, '900100002', 1, NOW(), 4.1),
(7, '900100002', 2, NOW(), 3.9),
(8, '900100002', 3, NOW(), 4.4),
(9, '900100002', 1, NOW(), 4.0),
(10,'900100002', 4, NOW(), 4.3),
(11,'900100003', 1, NOW(), 5.0),
(12,'900100003', 3, NOW(), 4.8),
(13,'900100003', 2, NOW(), 4.2),
(14,'900100003', 1, NOW(), 4.9),
(15,'900100003', 5, NOW(), 4.7),
(16,'900100004', 1, NOW(), 4.0),
(17,'900100004', 3, NOW(), 4.1),
(18,'900100004', 2, NOW(), 3.9),
(19,'900100004', 5, NOW(), 4.2),
(20,'900100004', 4, NOW(), 4.3);

INSERT INTO quality_products (product_id, customer_id, poll_id, company_id, daterating, rating) VALUES
(1, 1, 2, '900100001', NOW(), 4.6),
(2, 2, 2, '900100001', NOW(), 4.3),
(3, 3, 2, '900100001', NOW(), 4.1),
(4, 4, 2, '900100001', NOW(), 5.0),
(5, 5, 2, '900100001', NOW(), 4.2),
(1, 6, 2, '900100002', NOW(), 4.1),
(3, 7, 2, '900100002', NOW(), 4.0),
(4, 8, 2, '900100002', NOW(), 3.9),
(5, 9, 2, '900100002', NOW(), 4.3),
(2, 10, 2, '900100002', NOW(), 4.2),
(6, 11, 2, '900100003', NOW(), 5.0),
(7, 12, 2, '900100003', NOW(), 4.8),
(8, 13, 2, '900100003', NOW(), 4.7),
(6, 14, 2, '900100003', NOW(), 4.9),
(10,15, 2, '900100003', NOW(), 4.3),
(6, 16, 2, '900100004', NOW(), 4.2),
(9, 17, 2, '900100004', NOW(), 4.1),
(10,18, 2, '900100004', NOW(), 4.0),
(8, 19, 2, '900100004', NOW(), 4.4),
(7, 20, 2, '900100004', NOW(), 4.5);


INSERT INTO companyproducts VALUES ('900100005', 5, 64000, 1), ('900100005', 7, 320000, 1);

INSERT INTO companyproducts VALUES ('900100006', 1, 3480000, 1), ('900100006', 8, 250000, 1);

INSERT INTO companyproducts VALUES ('900100007', 8, 240000, 1), ('900100007', 6, 95000, 1);

INSERT INTO companyproducts VALUES ('900100009', 2, 18500, 2), ('900100009', 10, 31000, 1);

INSERT INTO companyproducts VALUES ('900100010', 6, 105000, 1), ('900100010', 9, 198000, 1);


INSERT INTO quality_products VALUES (5, 15, 2, '900100005', NOW(), 4.2), (7, 16, 2, '900100005', NOW(), 4.4);

INSERT INTO quality_products VALUES (1, 17, 2, '900100006', NOW(), 4.3), (8, 18, 2, '900100006', NOW(), 4.1);

INSERT INTO quality_products VALUES (8, 19, 2, '900100007', NOW(), 4.6), (6, 20, 2, '900100007', NOW(), 4.7);

INSERT INTO quality_products VALUES (2, 11, 2, '900100009', NOW(), 4.4), (10, 12, 2, '900100009', NOW(), 4.5);

INSERT INTO quality_products VALUES (6, 13, 2, '900100010', NOW(), 4.8), (9, 14, 2, '900100010', NOW(), 4.3);


INSERT INTO favorites VALUES (21, 15, '900100005');

INSERT INTO favorites VALUES (22, 16, '900100006');

INSERT INTO favorites VALUES (23, 17, '900100007');

INSERT INTO favorites VALUES (24, 18, '900100009');

INSERT INTO favorites VALUES (25, 19, '900100010');

INSERT INTO details_favorites VALUES (31, 21, 5), (32, 21, 7);
INSERT INTO details_favorites VALUES (33, 22, 1), (34, 22, 8);
INSERT INTO details_favorites VALUES (35, 23, 8);
INSERT INTO details_favorites VALUES (36, 24, 10);
INSERT INTO details_favorites VALUES (37, 25, 6);

INSERT INTO rates VALUES (15, '900100005', 1, NOW(), 4.5);
INSERT INTO rates VALUES (16, '900100006', 1, NOW(), 4.6);
INSERT INTO rates VALUES (17, '900100007', 1, NOW(), 4.8);
INSERT INTO rates VALUES (18, '900100009', 1, NOW(), 4.3);
INSERT INTO rates VALUES (19, '900100010', 1, NOW(), 4.9);
