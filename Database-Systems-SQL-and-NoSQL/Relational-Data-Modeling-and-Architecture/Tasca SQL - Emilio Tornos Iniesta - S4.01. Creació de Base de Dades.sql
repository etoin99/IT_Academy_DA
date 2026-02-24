#Creo la base de datos y añado un USE para seleccionarla por defecto.

CREATE DATABASE IF NOT EXISTS transactionsSPRINT4;
USE transactionsSPRINT4;

#Creo las tablas asegurando que se creen en el orden correcto, las tablas padres deben existir antes que las tablas hijas.
#Primero user, company y products y después las tablas que dependen de ellas credit_card y transaction

#Creo la tabla users

CREATE TABLE IF NOT EXISTS user (
	id CHAR(10) PRIMARY KEY,
	name VARCHAR(100),
	surname VARCHAR(100),
	phone VARCHAR(50),
	email VARCHAR(255),
	birth_date DATE,
	country VARCHAR(150),
	city VARCHAR(150),
	postal_code VARCHAR(100),
	address VARCHAR(255)    
);

#Para ID escojo VARCHAR(20) para mayor flexibilidad y seguridad.
#Para EMAIL escojo VARCHAR(255) porque los estándares técnicos para emails permiten hasta 254 caracteres.
#Para BIRTH_DATE escojo DATE para permitir validación, ordenación y cálculo.
#Para PHONE escojo VARCHAR(50) que considero que ya es suficiente para cubrir todas las posibles casuísticas en formatos internacionales.

#Creamos la tabla company

CREATE TABLE IF NOT EXISTS company (
	company_id VARCHAR(15) PRIMARY KEY,
	company_name VARCHAR(255),
	phone VARCHAR(15),
	email VARCHAR(100),
	country VARCHAR(100),
	website VARCHAR(255)
);

#Creo la tabla products

CREATE TABLE IF NOT EXISTS products (
	id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(100),
	price DECIMAL(10, 2),
	colour VARCHAR(50),
	weight DECIMAL(6, 2),
    warehouse_id VARCHAR(10)
);

#Para ID escojo VARCHAR(20) para mayor flexibilidad y seguridad.
#En product_name, como el nombre de un producto es texto, uso un VARCHAR adecuado.
#Para price escojo DECIMAL(10, 2), 10 digitos totales y 2 decimales por ser una cantidad monetaria.
#En weight, siendo el peso una cantidad que puede contener decimales, escojo DECIMAL(6, 2) en vez de FLOAT para mejor precisión.

#Creo la tabla credit_card

CREATE TABLE IF NOT EXISTS credit_card (
	id VARCHAR(20) PRIMARY KEY,
    user_id CHAR(10),
	iban CHAR(34),
	pan VARCHAR(19),
	pin CHAR(4),
	cvv CHAR(4),
    track1 VARCHAR(100),
    track2 VARCHAR(100),
	expiring_date CHAR(10)
);

# Siguiendo la sintonía de la longitud de los ID en los datos a introducir, VARCHAR(20) es más flexible.
# El user_id VARCHAR(20) coincidiendo con el user.id
# El iban más largo conocido es de 34 caracteres de longitud, por eso escojo CHAR(34)
# El pan (número de la tarjeta) generalmente está entre los 16 y los 19 caracteres de longitud, por eso escojo VARCHAR(19)
# No usamos INT en pin o cvv para preservar los 0 y conservar el formato exacto, por eso escojo CHAR, y 4 de longitud 
# porque he visto que también existen cvv de esa longitud, además usando CHAR,
# le indicamos a la base de datos que no son valores numéricos para cálculo, lo que mejora la seguridad y la velocidad de indexación.
# En el caso de expiring_date utilizo CHAR(10) provisionalmente para evitar problemas en la carga,
# posteriormente definiré el tipo de dato como DATE.


#Creo la tabla transaction

CREATE TABLE IF NOT EXISTS transaction (
	id VARCHAR(255) PRIMARY KEY,
	card_id VARCHAR(20),
	business_id VARCHAR(15),
	timestamp TIMESTAMP,
	amount DECIMAL(10, 2),
	declined TINYINT,
    product_ids VARCHAR(255),
	user_id CHAR(10),
	lat DECIMAL(10, 7),
	longitude DECIMAL(10, 7)
);

#Para card_id escojo VARCHAR(20) coincidiendo con credit_card.id
#Para business_id escojo VARCHAR(15) coincidiendo con company.company_id
#Para timestamp escojo TIMESTAMP que es el tipo estándar para la hora exacta de la transacción.
#Para amount escojo DECIMAL(10, 2) que es el tipo estándar para cantidades monetarias.
#Para declined escojo TINYINT que es la representación estándar de BOOLEAN en MySQL, 
#que se necesita almacenar valores booleanos (verdadero o falso).
#En el caso de product_ids utilizo VARCHAR(255) porque se almacenan multiples IDs como en una lista.
#Para user_id escojo CHAR(10) coincidiendo con users.id
#Para lat y longitude, escojo DECIMAL(10, 7) en vez de FLOAT porque es más preciso para coordenadas geográficas,
#10 dígitos totales, 7 decimales es un estándar común.

LOAD DATA INFILE '/Users/etornos99/Documents/IT_ACADEMY_ESPECIALIZACIÓN/SPRINT4/CSV_originales/American_users.csv'
INTO TABLE user;

#Al querer cargar el csv me devuelve un error que básicamente me dice que por un tema de configuración del servidor,
#solo puedo cargar archivos que estén en una ruta específica y segura.

SHOW VARIABLES LIKE 'secure_file_priv';

#Ejecutando este comando veo que el servidor en vez de devolverme una tabla con el valor de la ruta me devuelve NULL, 
#eso significa que no tengo ninguna ruta segura designada.
#La funcionalidad de carga de archivos externos está completamente deshabilitada en el servidor MySQL por defecto.
#No existe el archivo de configuración (my.cnf) en las rutas esperadas, lo que impide cambiar la configuración directamente.

-- DESPUÉS DE VARIOS INTENTOS DOCUMENTADOS EN EL PDF;
#Llego a esta solución final: Para resolver el problema de permisos de manera definitiva,
#muevo los archivos CSV a la carpeta temporal universal /tmp/ del sistema operativo, 
#que tiene permisos de lectura abiertos para todos los procesos, incluido el servidor MySQL.

LOAD DATA INFILE '/private/tmp/CSV_originales/American_users.csv' 
INTO TABLE user
FIELDS TERMINATED BY ','  -- Indico que los campos están separados por comas
LINES TERMINATED BY '\n'  -- Indico que cada línea termina con un salto de línea
IGNORE 1 ROWS             -- Ignoro la primera fila (los encabezados del CSV)
(
	@id, @name, @surname, @phone, @email, @birth_date_str, 
    @country, @city, @postal_code, @address
) 
SET 
    id = @id,
    name = @name,
    surname = @surname,
    phone = @phone,
    email = @email,
    birth_date = STR_TO_DATE(@birth_date_str, '%b %d, %Y'), 
    country = @country,
    city = @city,
    postal_code = @postal_code,
    address = @address;
#Intento cargar los datos del csv american_users.csv en la tabla user.
#Me da error porque el CSV está usando comillas dobles " para encerrar los valores de los campos

LOAD DATA INFILE '/private/tmp/CSV_originales/American_users.csv' 
INTO TABLE user
FIELDS TERMINATED BY ','  -- Indico que los campos están separados por comas
ENCLOSED BY '"'           -- Indico que debe ignorar las dobles comillas " al leer los campos.
LINES TERMINATED BY '\n'  -- Indico que cada línea termina con un salto de línea
IGNORE 1 ROWS             -- Ignoro la primera fila (los encabezados del CSV)
(
	@id, @name, @surname, @phone, @email, @birth_date_str, 
    @country, @city, @postal_code, @address
) 
SET 
    id = @id,
    name = @name,
    surname = @surname,
    phone = @phone,
    email = @email,
    birth_date = STR_TO_DATE(@birth_date_str, '%b %d, %Y'), 
    country = @country,
    city = @city,
    postal_code = @postal_code,
    address = @address;

#Utilizando STR_TO_DATE() para convertir la cadena de texto en una fecha, en este caso con;
#%b: Que se utiliza para un nombre abreviado del mes (por ejemplo, Ene)
#%d: Que se utiliza para el día del mes (01 a 31), añadiendo la , que tiene a su derecha
#%Y: Que se utiliza para el año con 4 dígitos
#Ahora se cargan los datos del CSV American_users en la tabla user correctamente

LOAD DATA INFILE '/private/tmp/CSV_originales/European_users.csv' 
INTO TABLE user
FIELDS TERMINATED BY ','  -- Indico que los campos están separados por comas
ENCLOSED BY '"'           -- Indico que debe ignorar las dobles comillas " al leer los campos.
LINES TERMINATED BY '\n'  -- Indico que cada línea termina con un salto de línea
IGNORE 1 ROWS             -- Ignoro la primera fila (los encabezados del CSV)
(
	@id, @name, @surname, @phone, @email, @birth_date_str, 
    @country, @city, @postal_code, @address
) 
SET 
    id = @id,
    name = @name,
    surname = @surname,
    phone = @phone,
    email = @email,
    birth_date = STR_TO_DATE(@birth_date_str, '%b %d, %Y'), 
    country = @country,
    city = @city,
    postal_code = @postal_code,
    address = @address;

#Repito el proceso con los datos del CSV European_users en la tabla user para unificarlo todo en una sola tabla.

#Ahora vuelvo a crear una tabla temporal que se llame European_users solamente para usarla de filtro en mi tabla user,
#y poder añadir una columna que se llame continent, con el valor europe o america según corresponda.

CREATE TABLE IF NOT EXISTS european_users (
	id CHAR(10) PRIMARY KEY,
	name VARCHAR(100),
	surname VARCHAR(100),
	phone VARCHAR(50),
	email VARCHAR(255),
	birth_date DATE,
	country VARCHAR(150),
	city VARCHAR(150),
	postal_code VARCHAR(100),
	address VARCHAR(255)    
);

#Uso una estructura idéntica a mi tabla user para crear la tabla european_users

LOAD DATA INFILE '/private/tmp/CSV_originales/European_users.csv' 
INTO TABLE european_users
FIELDS TERMINATED BY ','  -- Indico que los campos están separados por comas
ENCLOSED BY '"'           -- Indico que debe ignorar las dobles comillas " al leer los campos.
LINES TERMINATED BY '\n'  -- Indico que cada línea termina con un salto de línea
IGNORE 1 ROWS             -- Ignoro la primera fila (los encabezados del CSV)
(
	@id, @name, @surname, @phone, @email, @birth_date_str, 
    @country, @city, @postal_code, @address
) 
SET 
    id = @id,
    name = @name,
    surname = @surname,
    phone = @phone,
    email = @email,
    birth_date = STR_TO_DATE(@birth_date_str, '%b %d, %Y'), 
    country = @country,
    city = @city,
    postal_code = @postal_code,
    address = @address;

#Cargo los datos del csv european_users en esta nueva tabla european_users

SELECT european_users.id
FROM european_users;

#Hago una select a la nueva tabla temporal european_users que acabo de crear para posteriormente añadir la nueva columna llamada continent.

ALTER TABLE user
ADD COLUMN continent VARCHAR(50);

#Creo la nueva columna en la tabla user llamada 'Continent'

#Completo los valores de la columna user.continent con europe o america según corresponda.

UPDATE user
SET user.continent = "Europe"
WHERE user.id IN (
	SELECT european_users.id
	FROM european_users);

#En este caso utilizo UPDATE para añadir Europe en la columna continent de la tabla user,
#si los user.id son el mismo que los de european_users.id

UPDATE user
SET user.continent = "America"
WHERE user.id NOT IN (
	SELECT european_users.id
	FROM european_users);

#En este caso utilizo UPDATE para añadir America en la columna continent de la tabla user,
#si los user.id son diferentes a los de european_users.id

DROP TABLE european_users;

#Una vez hecho esto, vuelvo a eliminar la tabla temporal european_users

LOAD DATA INFILE '/private/tmp/CSV_originales/companies.csv' 
INTO TABLE company
FIELDS TERMINATED BY ','  -- Indico que los campos están separados por comas
ENCLOSED BY '"'           -- Indico que debe ignorar las dobles comillas " al leer los campos.
LINES TERMINATED BY '\n'  -- Indico que cada línea termina con un salto de línea
IGNORE 1 ROWS             -- Ignoro la primera fila (los encabezados del CSV)
(
	@company_id, @company_name, @phone, @email, @country, @website
) 
SET 
    company_id = @company_id,
    company_name = @company_name,
    phone = @phone,
    email = @email,
    country = @country,
    website = @website;

#Cargo los datos del CSV companies en la tabla company correctamente

LOAD DATA INFILE '/private/tmp/CSV_originales/credit_cards.csv' 
INTO TABLE credit_card
FIELDS TERMINATED BY ','  -- Indico que los campos están separados por comas
ENCLOSED BY '"'           -- Indico que debe ignorar las dobles comillas " al leer los campos.
LINES TERMINATED BY '\n'  -- Indico que cada línea termina con un salto de línea
IGNORE 1 ROWS             -- Ignoro la primera fila (los encabezados del CSV)
(
	@id, @user_id, @iban, @pan, @pin, @cvv, @track1, @track2, @expiring_date
) 
SET 
    id = @id,
    user_id = @user_id,
    iban = @iban,
    pan = @pan,
    pin = @pin,
    cvv = @cvv,
    track1 = @track1,
    track2 = @track2,
    expiring_date = STR_TO_DATE(@expiring_date, '%m/%d/%y');

#Utilizando STR_TO_DATE() para convertir la cadena de texto en una fecha, en este caso con;
#%m: Que se utiliza para el mes (01 a 12)
#%d: Que se utiliza para el día del mes (01 a 31), añadiendo la , que tiene a su derecha
#%y: Que se utiliza para el año con 2 dígitos
#Cargo los datos del CSV credit_cards en la tabla credit_card correctamente
    
LOAD DATA INFILE '/private/tmp/CSV_originales/products.csv' 
INTO TABLE products
FIELDS TERMINATED BY ','  -- Indico que los campos están separados por comas
ENCLOSED BY '"'           -- Indico que debe ignorar las dobles comillas " al leer los campos.
LINES TERMINATED BY '\n'  -- Indico que cada línea termina con un salto de línea
IGNORE 1 ROWS             -- Ignoro la primera fila (los encabezados del CSV)
(
	@id, @product_name, @price, @colour, @weight, @warehouse_id
) 
SET 
    id = @id,
    product_name = @product_name,
    price = @price,
    colour = @colour,
    weight = @weight,
    warehouse_id = @warehouse_id;

#Intento cargar los datos del CSV products en la tabla products.
#Devuelve un error porque el simbolo $ al inicio lo convierte a una cadena de texto y no lo detecta como un decimal válido.

LOAD DATA INFILE '/private/tmp/CSV_originales/products.csv' 
INTO TABLE products
FIELDS TERMINATED BY ','  -- Indico que los campos están separados por comas
ENCLOSED BY '"'           -- Indico que debe ignorar las dobles comillas " al leer los campos.
LINES TERMINATED BY '\n'  -- Indico que cada línea termina con un salto de línea
IGNORE 1 ROWS             -- Ignoro la primera fila (los encabezados del CSV)
(
	@id, @product_name, @price, @colour, @weight, @warehouse_id
) 
SET 
    id = @id,
    product_name = @product_name,
    price = REPLACE(@price, '$', ''),
    colour = @colour,
    weight = @weight,
    warehouse_id = @warehouse_id;

#Utilizo REPLACE() para sustituir $ por '' nada, para que el valor se convierta en un decimal válido.
#Cargo los datos del CSV products en la tabla products correctamente.

LOAD DATA INFILE '/private/tmp/CSV_originales/transactions.csv' 
INTO TABLE transaction
FIELDS TERMINATED BY ';'  -- Indico que los campos están separados por comas
ENCLOSED BY '"'           -- Indico que debe ignorar las dobles comillas " al leer los campos.
LINES TERMINATED BY '\n'  -- Indico que cada línea termina con un salto de línea
IGNORE 1 ROWS             -- Ignoro la primera fila (los encabezados del CSV)
(
	@id, @card_id, @business_id, @timestamp, @amount, @declined, @product_ids, @user_id, @lat, @longitude
) 
SET 
    id = @id,
    card_id = @card_id,
    business_id = @business_id,
    timestamp = @timestamp,
    amount = @amount,
    declined = @declined,
    product_ids = @product_ids,
    user_id = @user_id,
    lat = @lat,
    longitude = @longitude;

#Intento cargar los datos del CSV transaction en la tabla transaction correctamente.
#Me devuelve un error en el que me dice que el valor introducido en lat y longitude es demasiado preciso para el tipo de dato actual de la columna,
#en este caso DECIMAL(10, 7) está cortando los decimales.

DROP TABLE transaction;

#Elimino la tabla para volver a añadirla después de modificar el tipo de dato de lat y longitude a DOUBLE.

CREATE TABLE IF NOT EXISTS transaction (
	id VARCHAR(255) PRIMARY KEY,
	card_id VARCHAR(20),
	business_id VARCHAR(15),
	timestamp TIMESTAMP,
	amount DECIMAL(10, 2),
	declined TINYINT,
    product_ids VARCHAR(255),
	user_id CHAR(10),
	lat DOUBLE,
	longitude DOUBLE
);

#Vuelvo a crear la tabla con el tipo de dato de lat y longitude modificado a DOUBLE.
#El tipo de dato DOUBLE utiliza el doble de memoria para almacenar el tipo decimal.

LOAD DATA INFILE '/private/tmp/CSV_originales/transactions.csv' 
INTO TABLE transaction
FIELDS TERMINATED BY ';'  -- Indico que los campos están separados por comas
ENCLOSED BY '"'           -- Indico que debe ignorar las dobles comillas " al leer los campos.
LINES TERMINATED BY '\n'  -- Indico que cada línea termina con un salto de línea
IGNORE 1 ROWS             -- Ignoro la primera fila (los encabezados del CSV)
(
	@id, @card_id, @business_id, @timestamp, @amount, @declined, @product_ids, @user_id, @lat, @longitude
) 
SET 
    id = @id,
    card_id = @card_id,
    business_id = @business_id,
    timestamp = @timestamp,
    amount = @amount,
    declined = @declined,
    product_ids = @product_ids,
    user_id = @user_id,
    lat = @lat,
    longitude = @longitude;

#Cargo los datos del CSV transactions en la tabla transaction correctamente.

ALTER TABLE transaction
ADD FOREIGN KEY (card_id) REFERENCES credit_card(id);

#Defino la relación entre transaction y credit_card, donde la transaction.card_id es la FK y hace referencia a la PK credit_card.id.

ALTER TABLE transaction
ADD FOREIGN KEY (business_id) REFERENCES company(company_id);

#Defino la relación entre transaction y company, donde la transaction.business_id es la FK y hace referencia a la PK company.company_id.

ALTER TABLE transaction
ADD FOREIGN KEY (user_id) REFERENCES user(id);

#Defino la relación entre transaction y user, donde la transaction.user_id es la FK y hace referencia a la PK user.id.

ALTER TABLE transaction
CHANGE COLUMN business_id company_id VARCHAR(15);

#Cambio el nombre de la columna transaction.business_id por company_id conservando el tipo de dato VARCHAR(15).

ALTER TABLE transaction
CHANGE COLUMN product_ids products_id VARCHAR(20);

#Cambio el nombre de la columna transaction.product_ids por products_id conservando el tipo de dato VARCHAR(20).

ALTER TABLE company
CHANGE COLUMN company_id id VARCHAR(15);

#Cambio el nombre de la columna company.company_id por id conservando el tipo de dato VARCHAR(15)

ALTER TABLE company
CHANGE COLUMN company_name name VARCHAR(255);

#Cambio el nombre de la columna company.company_name por name conservando el tipo de dato VARCHAR(255)

ALTER TABLE products
CHANGE COLUMN product_name name VARCHAR(100);

#Cambio el nombre de la columna products.product_name por name conservando el tipo de dato VARCHAR(100)

#Exercici 1
#Realitza una subconsulta que mostri tots els usuaris amb més de 80 transaccions utilitzant almenys 2 taules.

SELECT *
FROM user
WHERE user.id IN (
	SELECT transaction.user_id
	FROM transaction
	GROUP BY transaction.user_id
	HAVING COUNT(transaction.user_id) >= 80);

#En mi consulta de dos niveles;
#La subquery: Identifica a los user_id que cumplen con el criterio de tener 80 o más transacciones.
#La query principal: Usa esos id filtrados para mostrar todos los datos de la tabla user.

#Exercici 2
#Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.

SELECT company.name, credit_card.iban, ROUND(AVG(transaction.amount), 2) AS MitjanaAmountPerIban
FROM transaction
INNER JOIN credit_card
ON transaction.card_id = credit_card.id
INNER JOIN company
ON transaction.company_id = company.id
WHERE transaction.declined = 0
AND  company.name = "Donec Ltd"
GROUP BY company.name, credit_card.iban
ORDER BY MitjanaAmountPerIban DESC;

#En esta consulta he hecho JOIN entre las 3 tablas para mostrar el nombre de la compañía, 
#el iban de la tarjeta de crédito y un average del amount de cada iban
#Utilizo el WHERE para filtrar que solo se base en las transacciones que no fueron declinadas.

#Nivell 2
#Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en
#si les tres últimes transaccions han estat declinades aleshores és inactiu, 
#si almenys una no és rebutjada aleshores és actiu. Partint d’aquesta taula respon:

SELECT transaction.card_id, transaction.declined, ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) as num_filas
FROM transaction;

#Utilizo ROW_NUMBER() sobre la tabla transaction, particionando por card_id para resetear el recuento, 
#ordenando por timestamp descendente, es decir, de más reciente a más antiguo.

WITH ClasificacionTransaccion AS (
	SELECT transaction.card_id, transaction.declined, ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) as num_filas
    FROM transaction)
SELECT card_id, SUM(declined) AS TotalDeclinedUltimos3
FROM ClasificacionTransaccion
WHERE num_filas <= 3
GROUP BY card_id;

#Utilizo el WITH para crear una tabla temporal denominada ClasificacionTransaccion a la que poder hacer referencia a lo largo de mi consulta.
#Sobre esa tabla temporal ClasificacionTransaccion, muestro los card_id y la SUM() de declined de las últimas 3 transacciones, 
#filtrando el num_filas, previamente ordenado de más reciente a más antiguas, por menor o igual a 3 para que solo muestre las 3 últimas.

WITH ClasificacionTransaccion AS (
    SELECT card_id, declined, ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) as num_filas
    FROM transaction)
SELECT card_id, CASE 
	WHEN SUM(declined) = 3 THEN 'Inactiu'
	ELSE 'Actiu'
    END AS estat
FROM ClasificacionTransaccion
WHERE num_filas <= 3
GROUP BY card_id;

#Ahora para mostrar el estado de cada tarjeta como “Inactiu” si tiene 3 declined o “Actiu” si no, 
#incluyo el SUM() de la query anterior en un CASE.

CREATE TABLE IF NOT EXISTS estado_tarjeta (
	card_id VARCHAR(20),
    estat CHAR(10)
);

#Creo la tabla estado_tarjeta asignando a card_id el mismo tipo de dato VARCHAR(20) original que tiene asignado en la tabla transaction 
#y en credit_card y asigno a estat un tipo de dato CHAR(10) que es más que suficiente para el valor que tiene que almacenar.

INSERT INTO estado_tarjeta (card_id, estat)
WITH ClasificacionTransaccion AS (
    SELECT card_id, declined, ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) as num_filas
    FROM transaction)
SELECT card_id, CASE 
	WHEN SUM(declined) = 3 THEN 'Inactiu'
	ELSE 'Actiu'
    END AS estat
FROM ClasificacionTransaccion
WHERE num_filas <= 3
GROUP BY card_id;

#Inserto los datos obtenidos en la nueva tabla estado_tarjeta

SELECT *
FROM estado_tarjeta;

#Muestro todos los datos de la nueva tabla estado_tarjeta

#Exercici 1
#Quantes targetes estan actives?

SELECT COUNT(estado_tarjeta.estat) AS NumTargetesActives
FROM estado_tarjeta
WHERE estat = "Actiu";

#Nivell 3
#Crea una taula amb la qual puguem unir les dades del nou arxiu products.csv amb la base de dades creada,
#tenint en compte que des de transaction tens product_ids. Genera la següent consulta:

CREATE TABLE IF NOT EXISTS ProductosPorTransaccion (
    transaction_id VARCHAR(255),
    product_id VARCHAR(20),
    PRIMARY KEY (transaction_id, product_id),
    FOREIGN KEY (transaction_id) REFERENCES transaction(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

#Creo una nueva tabla llamada ProductosPorTransaccion, con la siguiente estructura;
#transaction_id con el tipo de dato VARCHAR(255) siendo el mismo tipo de dato asignado en la tabla transaction.
#product_id con el tipo de dato VARCHAR(20) siendo el mismo tipo de dato asignado en la tabla products.
#Asigno ambas columnas transaction_id y product_id como Primary Key.
#Defino la Foreign Key de transaction_id que hace referencia a transaction(id).
#Defino la Foreign Key de product_id que hace referencia a products(id).


ALTER TABLE transaction
MODIFY COLUMN products_id JSON;

#Para poder extraer cada producto por separado de la columna products_id en transaction, intento cambiar el tipo de dato a JSON.
#Me devuelve error porque los datos dentro de esa columna “12, 34, 56” no parecen JSON —> [“12”, “34”, “56”], 
#y MYSQL no permite cambiar directamente una cadena de texto a objeto JSON

ALTER TABLE transaction
ADD COLUMN products_id_json JSON;

#Decido añadir una columna temporal nueva, para posteriormente transformar esos datos.

UPDATE transaction 
SET products_id_json = CAST(CONCAT('[', products_id, ']') AS JSON);

#Añado los datos de la columna original products_id a la nueva columna products_id_json con las siguientes modificaciones:
#CONCAT('["', ..., '"]'): Añade [" al principio y "] al final. El resultado es [“12”,”34,”56”].
#CAST(... AS JSON): Le dice a MYSQL: "Esto que parece texto es en realidad un objeto JSON, guárdalo como tal".

SELECT products_id, products_id_json
FROM transaction;

##Muestro ambas columnas con una SELECT.
#Pero me doy cuenta de que el resultado no es [“12”,”34,”56”] sino [12, 34, 56] y entiendo que como tienen un espacio después de la coma, 
#debo cambiar el formato para que JSON no se confunda al leer los datos.

UPDATE transaction
SET products_id_json = CAST(CONCAT('["', REPLACE(products_id, ', ', '","'), '"]') AS JSON);

#Añado al código anterior un REPLACE() para solucionar lo del espacio después de la coma
#REPLACE(products_id, ', ', '","'): Cambia cada “,  “ por ",". Así, 12, 34 se convierte en 12”,”34.

SELECT products_id, products_id_json
FROM transaction;

#Vuelvo a mostrar las dos columnas con una SELECT y esta vez todo ha salido correctamente.
#Ahora para insertar los datos en la tabla de unión ProductosPorTransaccion, 
#necesito desglosar ese arreglo JSON para que cada product_id se convierta en una fila individual.

SELECT transaction.id AS transaction_id, tabla_jason.product_id
FROM transaction, JSON_TABLE(
	transaction.products_id_json,'$[*]' COLUMNS (product_id VARCHAR(20) PATH '$')) AS tabla_jason;

#Usaré la función JSON_TABLE, que actúa como un "traductor" que convierte los datos de un JSON en una tabla temporal con filas y columnas.
#$[*]: Le dice a MySQL que recorra todos los elementos del arreglo.
#COLUMNS : Define cómo se llamará la columna.
#PATH '$' : Indica que coja el valor directo del elemento actual del JSON.


INSERT INTO ProductosPorTransaccion (transaction_id, product_id)
SELECT transaction.id AS transaction_id, jason.product_id
FROM transaction, JSON_TABLE(
	transaction.products_id_json,'$[*]' COLUMNS (product_id VARCHAR(20) PATH '$')) AS jason;

#Inserto los datos obtenidos en la consulta anterior, a la nueva tabla de unión ProductosPorTransaccion.

SELECT *
FROM ProductosPorTransaccion;

#Muestro todos los datos de la tabla ProductosPorTransaccion y veo que se han cargado correctamente donde cada fila es una transacción por producto


#Exercici 1
#Necessitem conèixer el nombre de vegades que s'ha venut cada producte.

SELECT products.id AS idProducte, products.name NomProducte, COUNT(ProductosPorTransaccion.product_id) AS NumVegadesVenut
FROM ProductosPorTransaccion
INNER JOIN products
ON ProductosPorTransaccion.product_id = products.id
INNER JOIN transaction
ON transaction.id = ProductosPorTransaccion.transaction_id
WHERE transaction.declined = 0
GROUP BY idProducte, NomProducte
ORDER BY idProducte;

#Hago JOIN entre las tablas products, ProductosPorTransaccion y transaction para mostrar el ID y nombre desde la tabla products, 
#el recuento de las veces que se ha vendido cada producto desde la tabla ProductosPorTransaccion, 
#y poder filtrar desde la tabla transaction por declined.
#Utilizo el WHERE para filtrar que solo se base en las transacciones que no fueron declinadas.
#En el GROUP BY añado el ID de la tabla products, 
#porque hay varios nombres de producto repetidos con diferente ID 
#y así no se pierde ningún producto en mi query.

#Aunque no lo pide el enunciado, si quisiera ordenar por idProducte me encontraría por el siguiente problema.
#Al ordenarlo por ID me daría cuenta de que no me lo está haciendo bien, en vez de ordenar por orden numérico,
#está haciéndolo de manera alfabetico ya que lo interpreta como VARCHAR y no como un INT.

SELECT CAST(products.id AS UNSIGNED) AS idProducte, products.name NomProducte, COUNT(ProductosPorTransaccion.product_id) AS NumVegadesVenut
FROM ProductosPorTransaccion
INNER JOIN products
ON ProductosPorTransaccion.product_id = products.id
INNER JOIN transaction
ON transaction.id = ProductosPorTransaccion.transaction_id
WHERE transaction.declined = 0
GROUP BY idProducte, NomProducte
ORDER BY idProducte;

#En este punto usaría un CAST() AS UNSIGNED para solucionarlo, 
#escojo UNSIGNED por la naturaleza de los IDs que suelen ser números enteros y positivos, 
#así podría ordenarlo correctamente.

