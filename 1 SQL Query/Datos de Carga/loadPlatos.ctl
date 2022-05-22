LOAD DATA 
INFILE 'platos.txt' 
APPEND 
INTO TABLE Platos 
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS

	(
	restaurante,
	nombre,
	precio,
	descripcion,
	categoria
	)
 
 
  