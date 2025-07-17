/*1. Ver productos con la empresa que los vende*/
SELECT c.name AS empresa, p.name AS producto, cp.price
FROM companyproducts cp
JOIN companies c ON cp.company_id = c.id
JOIN products p ON cp.product_id = p.id;

/*2. Mostrar productos favoritos con su empresa y categoría*/
SELECT cu.name AS cliente, p.name AS producto, cat.description AS categoria, c.name AS empresa
FROM favorites f
JOIN details_favorites df ON f.id = df.favorite_id
JOIN customers cu ON f.customer_id = cu.id
JOIN products p ON df.product_id = p.id
JOIN categories cat ON p.category_id = cat.id
JOIN companyproducts cp ON p.id = cp.product_id
JOIN companies c ON cp.company_id = c.id;

/*3. Ver empresas aunque no tengan productos*/
SELECT c.name AS empresa, cp.product_id
FROM companies c
LEFT JOIN companyproducts cp ON c.id = cp.company_id;

/*4. Ver productos que fueron calificados (o no)*/
SELECT p.name AS producto, qp.rating
FROM products p
LEFT JOIN quality_products qp ON p.id = qp.product_id;

/*5. Ver productos con promedio de calificación y empresa*/
SELECT p.name AS producto, c.name AS empresa, ROUND(AVG(qp.rating),2) AS promedio
FROM products p
JOIN companyproducts cp ON p.id = cp.product_id
JOIN companies c ON cp.company_id = c.id
JOIN quality_products qp ON p.id = qp.product_id AND c.id = qp.company_id
GROUP BY p.name, c.name;

/*6. Ver clientes y sus calificaciones (si las tienen)*/
SELECT cu.name AS cliente, qp.product_id, qp.rating
FROM customers cu
LEFT JOIN quality_products qp ON cu.id = qp.customer_id;

/*7. Ver favoritos con la última calificación del cliente*/
SELECT cu.name AS cliente, p.name AS producto, qp.rating, qp.daterating
FROM favorites f
JOIN details_favorites df ON f.id = df.favorite_id
JOIN customers cu ON f.customer_id = cu.id
JOIN products p ON df.product_id = p.id
LEFT JOIN quality_products qp ON qp.product_id = p.id AND qp.customer_id = cu.id
WHERE qp.daterating = (
  SELECT MAX(q2.daterating)
  FROM quality_products q2
  WHERE q2.customer_id = cu.id AND q2.product_id = p.id
);

/*8. Ver beneficios incluidos en cada plan de membresía*/
SELECT m.name AS membresia, b.description AS beneficio
FROM membershipbenefits mb
JOIN memberships m ON mb.membership_id = m.id
JOIN benefits b ON mb.benefit_id = b.id;

/*9. Ver clientes con membresía activa y sus beneficios*/
SELECT cu.name AS cliente, b.description AS beneficio
FROM customers cu
JOIN memberships m ON cu.membership_id = m.id
JOIN membershipbenefits mb ON m.id = mb.membership_id
JOIN benefits b ON mb.benefit_id = b.id
JOIN membershipperiods mp ON m.id = mp.membership_id
WHERE mp.start_date <= NOW() AND mp.end_date >= NOW();

/*10. Ver ciudades con cantidad de empresas*/
SELECT cm.name AS ciudad, COUNT(c.id) AS total_empresas
FROM citiesormunicipalities cm
LEFT JOIN companies c ON cm.code = c.city_id
GROUP BY cm.name;

/*11. Ver encuestas con calificaciones*/
SELECT p.title AS encuesta, r.rating
FROM polls p
JOIN rates r ON p.id = r.poll_id;

/*12. Ver productos evaluados con datos del cliente*/
SELECT p.name AS producto, cu.name AS cliente, qp.daterating AS fecha
FROM quality_products qp
JOIN products p ON qp.product_id = p.id
JOIN customers cu ON qp.customer_id = cu.id;

/*13. Ver productos con audiencia de la empresa*/
SELECT p.name AS producto, a.description AS audiencia
FROM products p
JOIN companyproducts cp ON p.id = cp.product_id
JOIN companies c ON cp.company_id = c.id
JOIN audiences a ON c.audience_id = a.id;

/*14. Ver clientes con sus productos favoritos*/
SELECT cu.name AS cliente, p.name AS producto_favorito
FROM customers cu
JOIN favorites f ON cu.id = f.customer_id
JOIN details_favorites df ON f.id = df.favorite_id
JOIN products p ON df.product_id = p.id;

/*15. Ver planes, periodos, precios y beneficios*/
SELECT m.name AS plan, p.name AS periodo, mp.price, b.description AS beneficio
FROM memberships m
JOIN membershipperiods mp ON m.id = mp.membership_id
JOIN periods p ON mp.period_id = p.id
JOIN membershipbenefits mb ON mp.membership_id = mb.membership_id
JOIN benefits b ON mb.benefit_id = b.id;

/*16. Ver combinaciones empresa-producto-cliente calificados*/
SELECT c.name AS empresa, p.name AS producto, cu.name AS cliente, qp.rating
FROM quality_products qp
JOIN products p ON qp.product_id = p.id
JOIN companies c ON qp.company_id = c.id
JOIN customers cu ON qp.customer_id = cu.id;

/*17. Comparar favoritos con productos calificados*/
SELECT p.name AS producto, qp.rating
FROM details_favorites df
JOIN favorites f ON df.favorite_id = f.id
JOIN quality_products qp ON df.product_id = qp.product_id
WHERE f.customer_id = qp.customer_id;

/*18. Ver productos ordenados por categoría*/
SELECT cat.description AS categoria, p.name AS producto
FROM products p
JOIN categories cat ON p.category_id = cat.id
ORDER BY cat.description;

/*19. Ver beneficios por audiencia, incluso vacíos*/
SELECT a.description AS audiencia, b.description AS beneficio
FROM audiences a
LEFT JOIN audiencebenefits ab ON a.id = ab.audience_id
LEFT JOIN benefits b ON ab.benefit_id = b.id;

/*20. Ver datos cruzados entre calificaciones, encuestas, productos y clientes*/
SELECT cu.name AS cliente, p.name AS producto, qp.rating, pol.title AS encuesta
FROM quality_products qp
JOIN customers cu ON qp.customer_id = cu.id
JOIN products p ON qp.product_id = p.id
JOIN polls pol ON qp.poll_id = pol.id;

