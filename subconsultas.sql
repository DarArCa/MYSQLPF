/*1 Como gerente, quiero ver los productos cuyo precio esté por encima del promedio de su categoría.*/
SELECT p.id, p.name, c.description AS category, cp.price
FROM companyproducts cp
JOIN products p ON cp.product_id = p.id
JOIN categories c ON p.category_id = c.id
WHERE cp.price > (
    SELECT AVG(cp2.price)
    FROM companyproducts cp2
    JOIN products p2 ON cp2.product_id = p2.id
    WHERE p2.category_id = p.category_id
);

/*2 Como administrador, deseo listar las empresas que tienen más productos que la media de empresas.*/
SELECT c.id, c.name, COUNT(DISTINCT cp.product_id) AS total_products
FROM companies c
JOIN companyproducts cp ON cp.company_id = c.id
GROUP BY c.id, c.name
HAVING COUNT(DISTINCT cp.product_id) > (
    SELECT AVG(product_count) FROM (
        SELECT COUNT(DISTINCT cp2.product_id) AS product_count
        FROM companies c2
        JOIN companyproducts cp2 ON c2.id = cp2.company_id
        GROUP BY c2.id
    ) AS sub
);

/*3 Como cliente, quiero ver mis productos favoritos que han sido calificados por otros clientes.*/
SELECT DISTINCT p.id, p.name
FROM favorites f
JOIN details_favorites df ON df.favorite_id = f.id
JOIN products p ON df.product_id = p.id
WHERE EXISTS (
    SELECT 1 FROM quality_products qp
    WHERE qp.product_id = p.id AND qp.customer_id != f.customer_id
);

/*4 Como supervisor, deseo obtener los productos con el mayor número de veces añadidos como favoritos.*/
SELECT p.id, p.name, COUNT(*) AS total_favorited
FROM details_favorites df
JOIN products p ON df.product_id = p.id
GROUP BY p.id, p.name
ORDER BY total_favorited DESC;

/*5 Como técnico, quiero listar los clientes cuyo correo no aparece en la tabla rates ni en quality_products.*/
SELECT c.id, c.name, c.email
FROM customers c
WHERE c.id NOT IN (SELECT DISTINCT customer_id FROM rates)
  AND c.id NOT IN (SELECT DISTINCT customer_id FROM quality_products);

/*6 Como gestor de calidad, quiero obtener los productos con una calificación inferior al mínimo de su categoría.*/
SELECT p.id, p.name, c.description AS category, AVG(qp.rating) AS avg_rating
FROM products p
JOIN categories c ON p.category_id = c.id
JOIN quality_products qp ON qp.product_id = p.id
GROUP BY p.id, p.name, c.description
HAVING AVG(qp.rating) < (
    SELECT MIN(avg_cat) FROM (
        SELECT p2.category_id, AVG(qp2.rating) AS avg_cat
        FROM products p2
        JOIN quality_products qp2 ON qp2.product_id = p2.id
        GROUP BY p2.category_id
    ) AS cat_avg
);

/*7 Como desarrollador, deseo listar las ciudades que no tienen clientes registrados.*/
SELECT cm.code, cm.name
FROM citiesormunicipalities cm
WHERE cm.code NOT IN (
    SELECT DISTINCT city_id FROM customers
);

/*8 Como administrador, quiero ver los productos que no han sido evaluados en ninguna encuesta.*/
SELECT p.id, p.name
FROM products p
WHERE p.id NOT IN (
    SELECT DISTINCT product_id FROM quality_products
);

/*9 Como auditor, quiero listar los beneficios que no están asignados a ninguna audiencia.*/
SELECT b.id, b.description
FROM benefits b
WHERE b.id NOT IN (
    SELECT DISTINCT benefit_id FROM audiencebenefits
);

/*10 Como cliente, deseo obtener mis productos favoritos que no están disponibles actualmente en ninguna empresa.*/
SELECT DISTINCT p.id, p.name
FROM favorites f
JOIN details_favorites df ON df.favorite_id = f.id
JOIN products p ON df.product_id = p.id
WHERE p.id NOT IN (
    SELECT DISTINCT product_id FROM companyproducts
);

/*11 Como director, deseo consultar los productos vendidos en empresas cuya ciudad tenga menos de tres empresas registradas.*/
SELECT DISTINCT p.id, p.name, c.name AS company_name, cm.name AS city_name
FROM products p
JOIN companyproducts cp ON cp.product_id = p.id
JOIN companies c ON cp.company_id = c.id
JOIN citiesormunicipalities cm ON c.city_id = cm.code
WHERE c.city_id IN (
    SELECT city_id FROM companies
    GROUP BY city_id
    HAVING COUNT(*) < 3
);

/*12 Como analista, quiero ver los productos con calidad superior al promedio de todos los productos.*/
SELECT p.id, p.name, AVG(qp.rating) AS avg_rating
FROM products p
JOIN quality_products qp ON p.id = qp.product_id
GROUP BY p.id, p.name
HAVING AVG(qp.rating) > (
    SELECT AVG(rating) FROM quality_products
);

/*13 Como gestor, quiero ver empresas que sólo venden productos de una única categoría.*/
SELECT c.id, c.name
FROM companies c
JOIN companyproducts cp ON c.id = cp.company_id
JOIN products p ON cp.product_id = p.id
GROUP BY c.id, c.name
HAVING COUNT(DISTINCT p.category_id) = 1;

/*14 Como gerente comercial, quiero consultar los productos con el mayor precio entre todas las empresas.*/
SELECT p.id, p.name, MAX(cp.price) AS max_price
FROM companyproducts cp
JOIN products p ON cp.product_id = p.id
GROUP BY p.id, p.name
ORDER BY max_price DESC;

/*15 Como cliente, quiero saber si algún producto de mis favoritos ha sido calificado por otro cliente con más de 4 estrellas.*/
SELECT DISTINCT p.id, p.name
FROM favorites f
JOIN details_favorites df ON df.favorite_id = f.id
JOIN products p ON df.product_id = p.id
WHERE EXISTS (
    SELECT 1 FROM quality_products qp
    WHERE qp.product_id = p.id AND qp.customer_id != f.customer_id AND qp.rating > 4
);

/*16 Como operador, quiero saber qué productos no tienen imagen asignada pero sí han sido calificados.*/
SELECT DISTINCT p.id, p.name
FROM products p
JOIN quality_products qp ON qp.product_id = p.id
WHERE (p.image IS NULL OR p.image = '');

/*17 Como auditor, quiero ver los planes de membresía sin periodo vigente.*/
SELECT mp.membership_id, mp.period_id
FROM membershipperiods mp
LEFT JOIN periods p ON mp.period_id = p.id
WHERE p.id IS NULL;

/*18 Como especialista, quiero identificar los beneficios compartidos por más de una audiencia.*/
SELECT b.id, b.description, COUNT(ab.audience_id) AS total_audiences
FROM audiencebenefits ab
JOIN benefits b ON ab.benefit_id = b.id
GROUP BY b.id, b.description
HAVING COUNT(ab.audience_id) > 1;

/*19 Como técnico, quiero encontrar empresas cuyos productos no tengan unidad de medida definida.*/
SELECT DISTINCT c.id, c.name
FROM companies c
JOIN companyproducts cp ON c.id = cp.company_id
WHERE cp.unitmeasure_id IS NULL;

/*20 Como gestor de campañas, deseo obtener los clientes con membresía activa y sin productos favoritos*/
SELECT DISTINCT c.id, c.name
FROM customers c
JOIN memberships m ON m.audience_id = c.audience_id
WHERE c.id NOT IN (
    SELECT customer_id FROM favorites
);
