#NOM: Emilio Tornos Iniesta - Data Analytics

# NIVELL 1
#Exercici 1
#Company.id es la Primary Key, y transaction.company_id es la Foreign Key.
#Amount es el valor de la venta realizada por cada empresa, se ve reflejado en cada transacción


#Descubriendo la tabla company.

SELECT COUNT(id)
FROM company; 
#Cuento los id de las empresas y me devuelve 100.

SELECT COUNT(company_name)
FROM company; 
#Cuento los nombres de las empresas y me sigue devolviendo 100,
#cada id pertenece a una empresa distinta.

SELECT DISTINCT COUNT(company_name)
FROM company; 
#Repito con DISTINCT para ver si hay duplicados, 
#me sigue devolviendo 100 empresas, 
#no hay duplicados.

#Descubriendo la tabla transaction.

SELECT COUNT(id)
FROM transaction; 
#Cuento los id de las transacciones y me devuelve 100.000

SELECT company_id
FROM transaction;
#Reviso cuantas empresas aparecen y me devuelve 100.000 registros

SELECT DISTINCT company_id
FROM transaction;
#Repito con DISTINCT para eliminar posibles duplicados y me devuelve 100 únicas empresas, 
#coincide con las 100 de la tabla company.

SELECT COUNT(declined)
FROM transaction
WHERE declined = 1;
#Cuento cuantas transacciones rechazadas hay y me devuelve 237.

SELECT company_name, COUNT(transaction.declined)
FROM company
INNER JOIN transaction
ON company.id = transaction.company_id
AND declined = 1
GROUP BY company_name;
#Reviso que empresas tienen por lo menos 1 transacción rechazada y la cantidad,
#el resultado son 86 empresas, las otras 14 empresas solo tienen transacciones aprobadas.

SELECT company.id
FROM company
LEFT JOIN transaction
ON company.id = transaction.company_id
WHERE transaction.company_id IS NULL;
#Hago un left join para que me muestre todas las empresas de company
#filtrando las que sean NULL en transaction,
#me devuelve 0 resultados,
#todas las empresas tienen alguna transacción aprobada o rechazada.

#Conclusión; una empresa puede aparecer en muchas transacciones, 
#pero cada transacción pertenece a una única empresa.

#Exercici 2
#Utilitzant JOIN realitzaràs les següents consultes:

#Llistat dels països que estan generant vendes.

SELECT DISTINCT(country) as LlistatPaisos 
FROM company
INNER JOIN transaction 
ON company.id = transaction.company_id; 

#Des de quants països es generen les vendes.

SELECT COUNT(DISTINCT country) as NumPaisos 
FROM company
INNER JOIN transaction 
ON company.id = transaction.company_id; 

#Identifica la companyia amb la mitjana més gran de vendes.

SELECT company.company_name AS Nom, ROUND(AVG(transaction.amount), 2) as MitjanaVendes
FROM company
INNER JOIN transaction
ON company.id = transaction.company_id
AND transaction.declined = 0
GROUP BY company.id
HAVING ROUND(AVG(transaction.amount) >= (
			SELECT ROUND(AVG(amount), 2) as MitjanaVendesMaxima
			FROM transaction
			WHERE transaction.declined = 0
			GROUP BY company_id
			ORDER BY MitjanaVendesMaxima DESC
			LIMIT 1));


#Exercici 3
#Utilitzant només subconsultes (sense utilitzar JOIN):

#Mostra totes les transaccions realitzades per empreses d'Alemanya.

SELECT *
FROM transaction
WHERE company_id IN (
                     SELECT id
                     FROM company
                     WHERE country = "Germany")
AND transaction.declined = 0;

#Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.

SELECT company_name
FROM company
WHERE id IN (
             SELECT company_id
             FROM transaction
             WHERE amount > (
                             SELECT AVG(amount)
                             FROM transaction
                             WHERE transaction.declined = 0)
			 AND transaction.declined = 0)
ORDER BY company_name;

#Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.

-- Consulta con subquery para sacar el listado de empresas que no tienen transacciones
SELECT id
FROM company
WHERE id NOT IN (
				 SELECT company_id
                 FROM transaction);

-- Si quisiera eliminarlas solo debería cambiar el SELECT por un DELETE y ponerlo detrás del FROM
DELETE FROM company
WHERE id NOT IN (
				 SELECT company_id
                 FROM transaction);

#NIVEL 2

#Exercici 1
#Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. Mostra la data de cada transacció juntament amb el total de les vendes.

SELECT DATE(timestamp) as Dia, SUM(amount) as TotalAmount
FROM transaction
GROUP BY 1
ORDER BY TotalAmount DESC
LIMIT 5;

#Exercici 2
#Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.

SELECT company.country, ROUND(AVG(transaction.amount), 2) as MitjanaVendes
FROM transaction
INNER JOIN company
ON company.id = transaction.company_id
WHERE transaction.declined = 0
GROUP BY company.country
ORDER BY MitjanaVendes DESC;

#Exercici 3
#En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia "Non Institute". 
#Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.

-- listado de empresas del mismo pais que Non Institute
SELECT DISTINCT company.company_name
FROM transaction
INNER JOIN company
ON company.id = transaction.company_id
WHERE company.country = (
                         SELECT company.country 
                         FROM company 
                         WHERE company.company_name = "Non Institute")
ORDER BY company.company_name;

#Mostra el llistat aplicant JOIN i subconsultes.
SELECT *
FROM transaction
INNER JOIN company
ON company.id = transaction.company_id
WHERE company.country = (
						 SELECT company.country 
						 FROM company 
					     WHERE company.company_name = "Non Institute")
AND company.company_name != "Non Institute"
ORDER BY transaction.timestamp DESC;

#Mostra el llistat aplicant solament subconsultes.

SELECT *
FROM transaction
WHERE transaction.company_id IN (
                                 SELECT company.id
                                 FROM company
                                 WHERE company.country = (
                                                          SELECT company.country
                                                          FROM company 
                                                          WHERE company.company_name = "Non Institute")
								 AND company.company_name != "Non Institute")
ORDER BY transaction.timestamp DESC;

#NIVELL 3
#Exercici 1
#Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès entre 350 i 400 euros i en alguna d'aquestes dates: 
#29 d'abril del 2015, 20 de juliol del 2018 i 13 de març del 2024. Ordena els resultats de major a menor quantitat.

SELECT  company.company_name AS Nom, 
		company.phone AS Telefon, 
        company.country AS Pais, 
        DATE(transaction.timestamp) AS Data, 
        transaction.amount
FROM transaction
INNER JOIN company
ON transaction.company_id = company.id
AND amount between 350 and 400
AND DATE(transaction.timestamp) IN ("2015-04-29", "2018-07-20", "2024-03-13")
ORDER BY amount DESC;

#Exercici 2
#Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, 
#per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses,
#però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de 400 transaccions o menys.

SELECT company.company_name AS Empresa, COUNT(transaction.id) AS NumTransaccions, 
		CASE
			WHEN COUNT(transaction.id) > 400 THEN "Tenen més de 400 transaccions."
			ELSE "No tenen més de 400 transaccions."
			END AS Resultat
FROM transaction
INNER JOIN company
ON company.id = transaction.company_id
GROUP BY company.company_name;
