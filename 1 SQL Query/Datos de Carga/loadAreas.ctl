LOAD DATA 
INFILE 'areas.txt' 
APPEND 
INTO TABLE "Áreas Cobertura"
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS

	(
	restaurante,
	"código postal"
	)

