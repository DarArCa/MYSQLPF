/*1.Como analista, quiero listar todos los productos con su empresa asociada y el precio más bajo por ciudad. */

SELECT 
    p.id AS product_id,
    p.name AS product_name,
    c.id AS company_id,
    c.name AS company_name,
    cm.name AS city_name,
    cp.price
FROM 
    companyproducts cp
JOIN products p ON cp.product_id = p.id
JOIN companies c ON cp.company_id = c.id
JOIN citiesormunicipalities cm ON c.city_id = cm.code
JOIN (
    SELECT 
        product_id,
        city_id,
        MIN(price) AS min_price
    FROM 
        companyproducts cp
    JOIN companies c ON cp.company_id = c.id
    GROUP BY 
        product_id, city_id
) AS min_prices
ON cp.product_id = min_prices.product_id
AND c.city_id = min_prices.city_id
AND cp.price = min_prices.min_price
ORDER BY 
    cm.name, p.name;
/*2.Como administrador, deseo obtener el top 5 de clientes que más productos han calificado en los últimos 6 meses.*/
SELECT 
    c.id AS customer_id,
    c.name AS customer_name,
    COUNT(*) AS total_rated_products
FROM 
    quality_products qp
JOIN customers c ON qp.customer_id = c.id
WHERE 
    qp.daterating >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
GROUP BY 
    c.id, c.name
ORDER BY 
    total_rated_products DESC
LIMIT 5;

/*3Como gerente de ventas, quiero ver la distribución de productos por categoría y unidad de medida.*/
SELECT 
    cat.description AS category,
    um.description AS unit_of_measure,
    COUNT(DISTINCT cp.product_id) AS total_products
FROM 
    companyproducts cp
JOIN products p ON cp.product_id = p.id
JOIN categories cat ON p.category_id = cat.id
JOIN unitofmeasure um ON cp.unitmeasure_id = um.id
GROUP BY 
    cat.description, um.description
ORDER BY 
    cat.description, total_products DESC;

/*4Como cliente, quiero saber qué productos tienen calificaciones superiores al promedio general.*/
WITH global_avg AS (
    SELECT AVG(rating) AS avg_rating FROM quality_products
)
SELECT 
    p.id AS product_id,
    p.name AS product_name,
    AVG(qp.rating) AS avg_product_rating
FROM 
    quality_products qp
JOIN products p ON qp.product_id = p.id
GROUP BY 
    p.id, p.name
HAVING 
    AVG(qp.rating) > (SELECT avg_rating FROM global_avg)
ORDER BY 
    avg_product_rating DESC;

/*5Como auditor, quiero conocer todas las empresas que no han recibido ninguna calificación.*/
SELECT 
    c.id AS company_id,
    c.name AS company_name,
    cm.name AS city_name,
    cat.description AS category
FROM 
    companies c
JOIN citiesormunicipalities cm ON c.city_id = cm.code
JOIN categories cat ON c.category_id = cat.id
WHERE 
    c.id NOT IN (
        SELECT DISTINCT company_id FROM rates
    )
ORDER BY 
    company_name;

/*6Como operador, deseo obtener los productos que han sido añadidos como favoritos por más de 10 clientes distintos.*/
SELECT 
    p.id AS product_id,
    p.name AS product_name,
    COUNT(DISTINCT f.customer_id) AS total_customers
FROM 
    details_favorites df
JOIN favorites f ON df.favorite_id = f.id
JOIN products p ON df.product_id = p.id
GROUP BY 
    p.id, p.name
HAVING 
    COUNT(DISTINCT f.customer_id) > 10
ORDER BY 
    total_customers DESC;

/*7Como gerente regional, quiero obtener todas las empresas activas por ciudad y categoría.*/
SELECT 
    cm.name AS city_name,
    cat.description AS category,
    c.id AS company_id,
    c.name AS company_name,
    COUNT(cp.product_id) AS total_products
FROM 
    companies c
JOIN citiesormunicipalities cm ON c.city_id = cm.code
JOIN categories cat ON c.category_id = cat.id
JOIN companyproducts cp ON c.id = cp.company_id
GROUP BY 
    cm.name, cat.description, c.id, c.name
ORDER BY 
    cm.name, cat.description, company_name;

/*8Como especialista en marketing, deseo obtener los 10 productos más calificados en cada ciudad.*/
WITH product_ratings AS (
    SELECT 
        qp.product_id,
        p.name AS product_name,
        c.city_id,
        cm.name AS city_name,
        AVG(qp.rating) AS avg_rating
    FROM 
        quality_products qp
    JOIN products p ON qp.product_id = p.id
    JOIN companies c ON qp.company_id = c.id
    JOIN citiesormunicipalities cm ON c.city_id = cm.code
    GROUP BY 
        qp.product_id, p.name, c.city_id, cm.name
),
ranked_products AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY city_id ORDER BY avg_rating DESC) AS ranking
    FROM product_ratings
)
SELECT 
    product_id,
    product_name,
    city_name,
    avg_rating
FROM 
    ranked_products
WHERE 
    ranking <= 10
ORDER BY 
    city_name, ranking;

/*9Como técnico, quiero identificar productos sin unidad de medida asignada.*/
SELECT p.id, p.name
FROM products p
WHERE p.id NOT IN (
    SELECT DISTINCT product_id FROM companyproducts
);
/*10Como gestor de beneficios, deseo ver los planes de membresía sin beneficios registrados.*/
SELECT mp.membership_id, m.name, mp.period_id, p.name AS period
FROM membershipperiods mp
JOIN memberships m ON mp.membership_id = m.id
JOIN periods p ON mp.period_id = p.id
WHERE (mp.membership_id, mp.period_id) NOT IN (
    SELECT membership_id, period_id FROM membershipbenefits
);
/*11Como supervisor, quiero obtener los productos de una categoría específica con su promedio de calificación.*/
SELECT 
    p.id, 
    p.name, 
    c.description AS category, 
    AVG(qp.rating) AS avg_rating
FROM 
    products p
JOIN categories c ON p.category_id = c.id
LEFT JOIN quality_products qp ON qp.product_id = p.id
WHERE 
    c.id = 1
GROUP BY 
    p.id, p.name, c.description;

/*12Como asesor, deseo obtener los clientes que han comprado productos de más de una empresa.*/
SELECT 
    c.id AS customer_id,
    c.name AS customer_name,
    COUNT(DISTINCT qp.company_id) AS empresas_diferentes
FROM 
    quality_products qp
JOIN customers c ON qp.customer_id = c.id
GROUP BY 
    c.id, c.name
HAVING 
    COUNT(DISTINCT qp.company_id) > 1;

/*13Como director, quiero identificar las ciudades con más clientes activos.*/
SELECT cm.name AS city_name, COUNT(c.id) AS total_customers
FROM customers c
JOIN citiesormunicipalities cm ON c.city_id = cm.code
GROUP BY cm.name
ORDER BY total_customers DESC;

/*14Como analista de calidad, deseo obtener el ranking de productos por empresa basado en la media de quality_products.*/
SELECT 
    qp.company_id, 
    c.name AS company_name,
    p.id AS product_id, 
    p.name AS product_name,
    AVG(qp.rating) AS avg_rating,
    RANK() OVER (PARTITION BY qp.company_id ORDER BY AVG(qp.rating) DESC) AS ranking
FROM quality_products qp
JOIN products p ON qp.product_id = p.id
JOIN companies c ON qp.company_id = c.id
GROUP BY qp.company_id, c.name, p.id, p.name;
/*15Como administrador, quiero listar empresas que ofrecen más de cinco productos distintos.*/
SELECT c.id AS company_id, c.name AS company_name, COUNT(DISTINCT cp.product_id) AS total_products
FROM companyproducts cp
JOIN companies c ON cp.company_id = c.id
GROUP BY c.id, c.name
HAVING COUNT(DISTINCT cp.product_id) > 5;
/*16Como cliente, deseo visualizar los productos favoritos que aún no han sido calificados.*/
SELECT DISTINCT p.id, p.name
FROM details_favorites df
JOIN favorites f ON df.favorite_id = f.id
JOIN products p ON df.product_id = p.id
WHERE NOT EXISTS (
    SELECT 1 FROM quality_products qp
    WHERE qp.product_id = p.id AND qp.customer_id = f.customer_id
);
/*17Como desarrollador, deseo consultar los beneficios asignados a cada audiencia junto con su descripción.*/
SELECT 
    a.description AS audience,
    b.description AS benefit,
    b.detail
FROM audiencebenefits ab
JOIN audiences a ON ab.audience_id = a.id
JOIN benefits b ON ab.benefit_id = b.id;
/*18Como operador logístico, quiero saber en qué ciudades hay empresas sin productos asociados.*/
SELECT DISTINCT cm.name AS city_name, c.name AS company_name
FROM companies c
JOIN citiesormunicipalities cm ON c.city_id = cm.code
LEFT JOIN companyproducts cp ON c.id = cp.company_id
WHERE cp.product_id IS NULL
/*19Como técnico, deseo obtener todas las empresas con productos duplicados por nombre.*/
SELECT c.id AS company_id, c.name AS company_name, p.name AS product_name, COUNT(*) AS veces
FROM companyproducts cp
JOIN companies c ON cp.company_id = c.id
JOIN products p ON cp.product_id = p.id
GROUP BY c.id, c.name, p.name
HAVING COUNT(*) > 1;
/*20Como analista, quiero una vista resumen de clientes, productos favoritos y promedio de calificación recibido.*/
SELECT 
    cu.id AS customer_id,
    cu.name AS customer_name,
    p.id AS product_id,
    p.name AS product_name,
    ROUND(AVG(qp.rating), 2) AS avg_rating
FROM customers cu
LEFT JOIN favorites f ON f.customer_id = cu.id
LEFT JOIN details_favorites df ON df.favorite_id = f.id
LEFT JOIN products p ON df.product_id = p.id
LEFT JOIN quality_products qp 
    ON qp.customer_id = cu.id AND qp.product_id = p.id
GROUP BY 
    cu.id, cu.name, p.id, p.name
ORDER BY 
    cu.name, product_name;

