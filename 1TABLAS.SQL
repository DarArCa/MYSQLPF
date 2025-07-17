CREATE DATABASE IF NOT EXISTS ProyectoF;
USE ProyectoF;

-- 1. countries
CREATE TABLE countries (
    isocode VARCHAR(6) PRIMARY KEY,
    name VARCHAR(50) UNIQUE,
    alfasitwo VARCHAR(2) UNIQUE,
    alfasithree VARCHAR(4) UNIQUE
);

-- 2. subdivisioncategories
CREATE TABLE subdivisioncategories (
    id INT PRIMARY KEY,
    description VARCHAR(40)
);

-- 3. stateregions
CREATE TABLE stateregions (
    code VARCHAR(6) PRIMARY KEY,
    name VARCHAR(60),
    countrycode VARCHAR(6),
    isocode3166 VARCHAR(6),
    subdivision_id INT,
    FOREIGN KEY (countrycode) REFERENCES countries(isocode),
    FOREIGN KEY (subdivision_id) REFERENCES subdivisioncategories(id)
);

-- 4. citiesormunicipalities
CREATE TABLE citiesormunicipalities (
    code VARCHAR(6) PRIMARY KEY,
    name VARCHAR(60),
    statereg_id VARCHAR(6),
    FOREIGN KEY (statereg_id) REFERENCES stateregions(code)
);

-- 5. typesofidentifications
CREATE TABLE typesofidentifications (
    id INT PRIMARY KEY,
    description VARCHAR(60),
    suffix VARCHAR(5)
);

-- 6. audiences
CREATE TABLE audiences (
    id INT PRIMARY KEY,
    description VARCHAR(60)
);

-- 7. customers
CREATE TABLE customers (
    id INT PRIMARY KEY,
    name VARCHAR(80),
    city_id VARCHAR(6),
    audience_id INT,
    cellphone VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(120),
    FOREIGN KEY (city_id)    REFERENCES citiesormunicipalities(code),
    FOREIGN KEY (audience_id) REFERENCES audiences(id)
);

-- 8. categories
CREATE TABLE categories (
    id INT PRIMARY KEY,
    description VARCHAR(60)
);

-- 9. companies
CREATE TABLE companies (
    id VARCHAR(20) PRIMARY KEY,
    type_id INT,
    name VARCHAR(80),
    category_id INT,
    city_id VARCHAR(6),
    audience_id INT,
    cellphone VARCHAR(15),
    email VARCHAR(80),
    FOREIGN KEY (type_id)     REFERENCES typesofidentifications(id),
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (city_id)     REFERENCES citiesormunicipalities(code),
    FOREIGN KEY (audience_id) REFERENCES audiences(id)
);

-- 10. favorites
CREATE TABLE favorites (
    id INT PRIMARY KEY,
    customer_id INT,
    company_id VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (company_id)  REFERENCES companies(id)
);

-- 11. products
CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(60),
    detail TEXT,
    price DOUBLE,
    category_id INT,
    image VARCHAR(80),
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- 12. details_favorites
CREATE TABLE details_favorites (
    id INT PRIMARY KEY,
    favorite_id INT,
    product_id INT,
    FOREIGN KEY (favorite_id) REFERENCES favorites(id),
    FOREIGN KEY (product_id)  REFERENCES products(id)
);

-- 13. unitofmeasure
CREATE TABLE unitofmeasure (
    id INT PRIMARY KEY,
    description VARCHAR(60)
);

-- 14. companyproducts
CREATE TABLE companyproducts (
    company_id VARCHAR(20),
    product_id INT,
    price DOUBLE,
    unitmeasure_id INT,
    PRIMARY KEY (company_id, product_id),
    FOREIGN KEY (company_id)     REFERENCES companies(id),
    FOREIGN KEY (product_id)     REFERENCES products(id),
    FOREIGN KEY (unitmeasure_id) REFERENCES unitofmeasure(id)
);

-- 15. categories_polls
CREATE TABLE categories_polls (
    id INT PRIMARY KEY,
    name VARCHAR(80)
);

-- 16. polls
CREATE TABLE polls (
    id INT PRIMARY KEY,
    name VARCHAR(80),
    description TEXT,
    isactive BOOLEAN,
    categorypoll_id INT,
    FOREIGN KEY (categorypoll_id) REFERENCES categories_polls(id)
);

-- 17. rates
CREATE TABLE rates (
    customer_id INT,
    company_id VARCHAR(20),
    poll_id INT,
    daterating DATETIME,
    rating DOUBLE,
    PRIMARY KEY (customer_id, company_id, poll_id),
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (company_id)  REFERENCES companies(id),
    FOREIGN KEY (poll_id)     REFERENCES polls(id)
);

-- 18. quality_products
CREATE TABLE quality_products (
    product_id INT,
    customer_id INT,
    poll_id INT,
    company_id VARCHAR(20),
    daterating DATETIME,
    rating DOUBLE,
    PRIMARY KEY (product_id, customer_id, poll_id, company_id),
    FOREIGN KEY (product_id)  REFERENCES products(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (poll_id)     REFERENCES polls(id),
    FOREIGN KEY (company_id)  REFERENCES companies(id)
);

-- 19. memberships
CREATE TABLE memberships (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    description TEXT
);

-- 20. periods
CREATE TABLE periods (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

-- 21. membershipperiods
CREATE TABLE membershipperiods (
    membership_id INT,
    period_id INT,
    price DOUBLE,
    PRIMARY KEY (membership_id, period_id),
    FOREIGN KEY (membership_id) REFERENCES memberships(id),
    FOREIGN KEY (period_id)     REFERENCES periods(id)
);

-- 22. benefits
CREATE TABLE benefits (
    id INT PRIMARY KEY,
    description VARCHAR(80),
    detail TEXT
);

-- 23. membershipbenefits
CREATE TABLE membershipbenefits (
    membership_id INT,
    period_id INT,
    audience_id INT,
    benefit_id INT,
    PRIMARY KEY (membership_id, period_id, audience_id, benefit_id),
    FOREIGN KEY (membership_id, period_id) REFERENCES membershipperiods(membership_id, period_id),
    FOREIGN KEY (audience_id)              REFERENCES audiences(id),
    FOREIGN KEY (benefit_id)               REFERENCES benefits(id)
);

-- 24. audiencebenefits
CREATE TABLE audiencebenefits (
    audience_id INT,
    benefit_id INT,
    PRIMARY KEY (audience_id, benefit_id),
    FOREIGN KEY (audience_id) REFERENCES audiences(id),
    FOREIGN KEY (benefit_id)    REFERENCES benefits(id)
);

CREATE TABLE phone_codes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    country_isocode VARCHAR(6) NOT NULL,
    area_code VARCHAR(10),
    full_code VARCHAR(10),
    description VARCHAR(100),
    FOREIGN KEY (country_isocode) REFERENCES countries(isocode)
);

CREATE TABLE country_alt_codes (
    alt_code INT PRIMARY KEY,
    country_name VARCHAR(100),
    isocode VARCHAR(6),
    FOREIGN KEY (isocode) REFERENCES countries(isocode)
);

