LOAD DATA 
INFILE 'pedidos.txt' 
APPEND 
INTO TABLE Pedidos 
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
  (
  codigo,
  estado,
  fecha_hora_pedido "to_date(:fecha_hora_pedido,'DD-MM-YY:HH24:MI')",
  fecha_hora_entrega "to_date(:fecha_hora_entrega,'DD-MM-YY:HH24:MI')",
  "importe total",
  cliente,
  codigoDescuento
  )
  
  
  
 