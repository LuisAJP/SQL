
-- GRUPO C02 - RAYNER TAN LUC LUIS - JARAMILLO PULIDO


-- CONSULTA 1

SELECT * FROM Clientes ORDER BY apellido;

-- CONSULTA 2

SELECT Restaurante, CASE "dia semana"
	WHEN 'L' THEN 'Lunes'
	WHEN 'M' THEN 'Martes'
	WHEN 'X' THEN 'Miercoles'
	WHEN 'J' THEN 'Jueves'
	WHEN 'V' THEN 'Viernes'
	WHEN 'S' THEN 'Sabado'
	WHEN 'D' THEN 'Domingo'
END AS Dia_semana,
TO_CHAR(hora_apertura, 'HH24:MI'),
TO_CHAR(hora_cierre, 'HH24:MI')
FROM Horarios ORDER BY Restaurante;

-- CONSULTA 3

SELECT Cl.DNI, Cl.nombre, Cl.apellido
FROM Clientes Cl, Pedidos Ped, Contiene Cont, Platos Plat
WHERE Cl.DNI = Ped.Cliente AND 
	  Cont.pedido = Ped.codigo AND
	  Plat.nombre = Cont.plato AND
	  Plat.categoria = 'picante';

 -- CONSULTA 4

SELECT Cl.DNI, Cl.nombre, Cl.apellido
FROM Clientes Cl, Pedidos Ped, Contiene Cont, Restaurantes Res
WHERE Cl.DNI = Ped.cliente AND
	  Ped.codigo = Cont.restaurante AND
	  Cont.Restaurante = Res.codigo;

-- CONSULTA 5
    
SELECT Cl.DNI, Cl.nombre, Cl.apellido
FROM Clientes Cl, Pedidos Ped
WHERE Cl.DNI = Ped.cliente AND
	  Ped.estado != 'ENTREGADO';

-- CONSULTA 6
    
SELECT * FROM Pedidos WHERE "importe total" = (SELECT MAX("importe total") FROM Pedidos);

-- CONSULTA 7

SELECT AVG("importe total"), DNI, nombre
FROM Clientes Cl, Pedidos Ped
WHERE Cl.DNI = Ped.cliente
GROUP BY DNI, nombre;

-- CONSULTA 8

SELECT DISTINCT Res.codigo, Res.nombre, SUM(Cont.unidades), SUM(Ped."importe total")
FROM Restaurantes Res, Contiene Cont, Pedidos ped
WHERE Res.codigo = Cont.Restaurante AND
	  Ped.codigo = Cont.pedido 
GROUP BY Res.codigo, Res.nombre;

-- CONSULTA 9

SELECT DISTINCT Cl.nombre, Cl.apellido
FROM Clientes Cl, Platos Plat, Pedidos Ped, Contiene Cont
WHERE Cont.plato = Plat.nombre AND
	  Ped.cliente = Cl.DNI AND
	  Plat.precio > 15;
 
-- CONSULTA 10

SELECT Cl.DNI, Cl.nombre, COUNT(codigo)
FROM Clientes Cl, "Áreas Cobertura" Ar, Restaurantes Res
WHERE Ar."código postal" = Cl."código postal" AND
	  Ar.Restaurante = Res.codigo
GROUP BY Cl.DNI, Cl.nombre
SELECT COUNT(codigo)
FROM Clientes Cl, "Áreas Cobertura" Ar, Restaurantes Res
WHERE Ar."código postal" = Cl."código postal" AND
	  Ar.restaurante = Res.codigo;
