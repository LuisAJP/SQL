LOAD DATA 
INFILE 'descuentos.txt' 
APPEND 
INTO TABLE Descuentos 
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS

	(
	codigo,
	fecha_caducidad,
	"porcentaje descuento"
	)
 








 