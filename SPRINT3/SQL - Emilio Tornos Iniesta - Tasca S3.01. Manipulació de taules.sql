#NIVELL 1

#Exercici 1
#La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de crèdit. 
#La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres dues taules 
#("transaction" i "company"). Després de crear la taula serà necessari que ingressis la informació del document 
#denominat "dades_introduir_credit". Recorda mostrar el diagrama i realitzar una breu descripció d'aquest.


CREATE TABLE IF NOT EXISTS credit_card (
	id VARCHAR(20) PRIMARY KEY,
	iban CHAR(34),
	pan VARCHAR(19),
	pin CHAR(4),
	cvv CHAR(4), 
	expiring_date CHAR(10)
);

# Siguiendo la sintonía de la longitud de los ID en los datos a introducir, VARCHAR(20) es más flexible.
# El iban más largo conocido es de 34 caracteres de longitud, por eso escojo CHAR(34)
# El pan (número de la tarjeta) generalmente está entre los 16 y los 19 caracteres de longitud, por eso escojo VARCHAR(19)
# No usamos INT en pin o cvv para preservar los 0 y conservar el formato exacto, por eso escojo CHAR, y 4 de longitud porque he visto que también existen cvv de esa longitud, además usando CHAR le indicamos a la base de datos que no son valores númericos para cálculo, lo que mejora la seguridad y la velocidad de indexación.
# En el caso de expiring_date utilizo CHAR(10) para facilitar la carga provisionalmente para evitar problemas en la carga, 
#posteriormente definiré el tipo de dato como DATE.

UPDATE credit_card
SET expiring_date = STR_TO_DATE(expiring_date, '%m/%d/%y');

#Una vez cargados los datos utilizo STR_TO_DATE() en expiring_date,
#para convertir la cadena de texto que representa una fecha en un valor de tipo fecha (DATE).

ALTER TABLE transaction
ADD FOREIGN KEY (credit_card_id) REFERENCES credit_card(id);

#Defino la relación entre transaction y credit_card,
#donde la transaction.credit_card_id es la FK y hace referencia a la PK credit_card.id.

ALTER TABLE transaction
ADD FOREIGN KEY (user_id) REFERENCES user(id);

#Intento definir la relación entre transaction y user, donde la transaction.user_id es la FK y hace referencia a la PK user.id.
#Me devuelve un error 3780: que significa que hay incompatibilidad entre los tipos de datos y no puede crear la relación.

ALTER TABLE transaction
MODIFY COLUMN user_id INT;

ALTER TABLE user
MODIFY COLUMN id INT;

#Antes de definir la relación me aseguro de definir los tipos de dato de esas columnas de ambas tablas como INT.

ALTER TABLE transaction
ADD FOREIGN KEY (user_id) REFERENCES user(id);



#Exercici 2
#El departament de Recursos Humans ha identificat un error en el número de compte associat a la targeta de crèdit amb ID CcU-2938.
#La informació que ha de mostrar-se per a aquest registre és: TR323456312213576817699999.
#Recorda mostrar que el canvi es va realitzar.


SELECT *
FROM credit_card
WHERE id = "CcU-2938";


UPDATE credit_card
SET iban = "TR323456312213576817699999"
WHERE id = "Ccu-2938";


SELECT *
FROM credit_card
WHERE id = "CcU-2938";

#Exercici 3
#En la taula "transaction" ingressa una nova transacció amb la següent informació:

--------------------------------------------
"Id	108B1D1D-5B23-A76C-55EF-C568E49A99DD
credit_card_id	CcU-9999
company_id	b-9999
user_id	9999
lat	829.999
longitude	-117.999
amount	111.11
declined	0";
--------------------------------------------

INSERT INTO transaction(id, credit_card_id, company_id, user_id, lat, longitude, timestamp, amount, declined)
VALUES('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', 9999, 829.999, -117.999, NOW(), 111.11, 0);


-- “Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails 
-- (`transactions`.`transaction`, CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `company` (`id`))”

INSERT INTO company(id, company_name, phone, email, country, website)
VALUES('b-9999', NULL, NULL, NULL, NULL, NULL);

#Creo el registro correspondiente en la tabla company 
#añadiendo en la columna id, el company_id al que hace referencia el ejercicio,
#dejando el resto de campos como NULL por ahora, hasta recibir nuevas ordenes.

SELECT *
FROM company
WHERE id = "b-9999";

#Verifico que se ha añadido correctamente.

INSERT INTO user(id, name, surname, phone, email, birth_date, country, city, postal_code, address)
VALUES(9999, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

#Creo el registro correspondiente en la tabla user 
#añadiendo en la columna id, el user_id al que hace referencia el ejercicio, 
#dejando el resto de campos como NULL por ahora, hasta recibir nuevas ordenes.

SELECT *
FROM user
WHERE id = 9999;

#Verifico que se ha añadido correctamente.


INSERT INTO credit_card(id, iban, pan, pin, cvv)
VALUES('CcU-9999', NULL, NULL, NULL, NULL);

#Creo el registro correspondiente en la tabla credit_card 
#añadiendo en la columna id, el credit_card_id al que hace referencia el ejercicio, 
#dejando el resto de campos como NULL por ahora, hasta recibir nuevas ordenes.

SELECT *
FROM credit_card
WHERE id = "CcU-9999";

#Verifico que se ha añadido correctamente.


INSERT INTO transaction(id, credit_card_id, company_id, user_id, lat, longitude, timestamp, amount, declined)
VALUES('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', 9999, 829.999, -117.999, NOW(), 111.11, 0);

#Vuelvo a ejecutar el código para insertar la nueva transacción y esta vez funciona sin problemas.

SELECT *
FROM transaction
WHERE company_id = "b-9999";

#Muestro la transacción filtrando por el company_id que indica el ejercicio 
#y verifico que la nueva transacción se ha añadido correctamente.

#Exercici 4
#Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. Recorda mostrar el canvi realitzat.

SELECT *
FROM credit_card;

#Muestro la tabla credit_card, previos a cualquier modificación.

ALTER TABLE credit_card
DROP COLUMN pan;

#Utilizo ALTER TABLE para modificar la estructura de la tabla credit_card y DROP COLUMN para eliminar la columna pan.

SELECT *
FROM credit_card;

#Muestro la tabla credit_card, después de la modificación.

#Nivell 2

#Exercici 1
#Elimina de la taula transaction el registre amb ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de dades.

SELECT *
FROM transaction
WHERE id = "000447FE-B650-4DCF-85DE-C7ED0EE1CAAD";

#Muestro la transacción que corresponde al ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD, previos a cualquier modificación.

DELETE FROM transaction
WHERE id = "000447FE-B650-4DCF-85DE-C7ED0EE1CAAD";

#Utilizo DELETE FROM y el WHERE para eliminar los registros filtrados por ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD.

SELECT *
FROM transaction
WHERE id = "000447FE-B650-4DCF-85DE-C7ED0EE1CAAD";

#Muestro la transacción que corresponde al ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD, después de eliminarla y devuelve NULL.


#Exercici 2
#La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. 
#S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. 
#Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: 
#Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. 
#Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.

CREATE VIEW VistaMarketing AS
SELECT company_name AS Nom, phone AS TelefonDeContacte, Country AS PaisDeResidencia, ROUND(AVG(transaction.amount), 2) AS MitjanaDeCompra
FROM company
INNER JOIN transaction
ON company.id = transaction.company_id
AND declined = 0
GROUP BY Nom, TelefonDeContacte, PaisDeResidencia
ORDER BY 4 DESC;

#Escribo mi consulta con los datos solicitados
#y los guardo en una vista llamada VistaMarketing añadiendo al inicio la instrucción CREATE VIEW para definir la vista.


SELECT *
FROM VistaMarketing;

#Hago SELECT de todos los datos en la vista VistaMarketing.

#Exercici 3
#Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"

SELECT *
FROM VistaMarketing
WHERE PaisDeResidencia = "Germany";

#Hago SELECT de todos los datos en la vista VistaMarketing aplicando el WHERE filtrando donde el país = Germany para mostrar solo esas empresas.

#Nivell 3

#Exercici 1
#La setmana vinent tindràs una nova reunió amb els gerents de màrqueting.
#Un company del teu equip va realitzar modificacions en la base de dades, però no recorda com les va realitzar.
#Et demana que l'ajudis a deixar els comandos executats per a obtenir el següent diagrama:

-- Cambio el nombre de la tabla de user a data_user

ALTER TABLE user
RENAME TO data_user;

-- Cambio el tipo de dato de la columna credit_card_id: De VARCHAR(15) a VARCHAR(20)

ALTER TABLE transaction
MODIFY COLUMN credit_card_id VARCHAR(20);

-- Creo la columna fecha_actual en la tabla credit_card con el tipo de dato DATE que solo almacenará fechas.

ALTER TABLE credit_card ADD fecha_actual DATE;

-- Aplico un UPDATE para sustituir los NULL de la nueva columna fecha_actual, usando CURDATE()
-- para que almacene la fecha actual en el momento de la ejecución del UPDATE.

UPDATE credit_card
SET fecha_actual = CURDATE();

-- Modifico los tipos de dato de iban, pin, cvv y expiring_date a los mostrados en el diagrama del ejercicio.

ALTER TABLE credit_card 
	MODIFY COLUMN iban VARCHAR(50),
    MODIFY COLUMN pin VARCHAR(4),
    MODIFY COLUMN  cvv INT,
    MODIFY COLUMN expiring_date VARCHAR(20);

-- Elimino la columna website de la tabla company, ya que no aparece en el diagrama.

ALTER TABLE company
DROP COLUMN website;

#Exercici 3
#L'empresa també us demana crear una vista anomenada "InformeTecnico" que contingui la següent informació:

"ID de la transacció
Nom de l'usuari/ària
Cognom de l'usuari/ària
IBAN de la targeta de crèdit usada.
Nom de la companyia de la transacció realitzada.";

#Assegureu-vos d'incloure informació rellevant de les taules que coneixereu i utilitzeu àlies per canviar de nom columnes segons calgui.
#Mostra els resultats de la vista, ordena els resultats de forma descendent en funció de la variable ID de transacció.

CREATE VIEW InformeTecnico AS
SELECT transaction.id AS IdTransaccio,
	   data_user.name AS NomUsuari, 
       data_user.surname AS CognomUsuari, 
       credit_card.iban AS IbanTarjeta,
       company.company_name AS NomCompanyia
FROM transaction
INNER JOIN data_user
ON transaction.user_id = data_user.id
INNER JOIN credit_card
ON transaction.credit_card_id = credit_card.id
INNER JOIN company
ON transaction.company_id = company.id
ORDER BY transaction.id DESC;

SELECT *
FROM InformeTecnico;