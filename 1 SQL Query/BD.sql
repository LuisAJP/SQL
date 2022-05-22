DELETE FROM Restaurantes;
DELETE FROM "Áreas Cobertura";
DELETE FROM Horarios;
DELETE FROM Platos;
DELETE FROM Clientes;
DELETE FROM Descuentos;
DELETE FROM Pedidos;
DELETE FROM Contiene;

DROP TABLE Restaurantes;
DROP TABLE clientes;
DROP TABLE "Áreas Cobertura";
DROP TABLE Horarios;
DROP TABLE Platos;
DROP TABLE Descuentos;
DROP TABLE Pedidos;
DROP TABLE Contiene;

CREATE TABLE Restaurantes(
   codigo NUMBER(8) NOT NULL,
   nombre CHAR(20) NOT NULL,
   calle CHAR(30) NOT NULL,
   "código postal" CHAR(5) NOT NULL,
   comision NUMBER(8,2),
   PRIMARY KEY(codigo)
);

CREATE TABLE "Áreas Cobertura"(
  restaurante NUMBER(8) NOT NULL REFERENCES Restaurantes(codigo),
  "código postal" CHAR(5),
  PRIMARY KEY (restaurante)
);

CREATE TABLE Horarios (
  restaurante NUMBER(8) NOT NULL REFERENCES Restaurantes(codigo) ON DELETE CASCADE,
  "dia semana" CHAR(1) NOT NULL,
  hora_apertura DATE NOT NULL,
  hora_cierre DATE NOT NULL,
  PRIMARY KEY (restaurante, "dia semana")
);

CREATE TABLE Platos(
  restaurante NUMBER(8) NOT NULL REFERENCES Restaurantes(codigo) ON DELETE CASCADE,
  nombre CHAR(20) NOT NULL,
  precio NUMBER(8,2),
  descripcion CHAR(30),
  categoria CHAR(20),
  PRIMARY KEY(restaurante, nombre)
);

CREATE TABLE Clientes(
  DNI CHAR(9) NOT NULL,
  nombre CHAR(20) NOT NULL,
  apellido CHAR(20) NOT NULL,
  calle CHAR(30) NOT NULL,
  numero NUMBER(4) NOT NULL,
  piso CHAR(5),
  localidad CHAR(15),
  "código postal" CHAR(5),
  telefono CHAR(9),
  usuario CHAR(8),
  contraseña CHAR(8) DEFAULT 'Nopass', 
  PRIMARY KEY (DNI)
  );
  
CREATE INDEX I_CatPlatos ON Platos(categoria);

CREATE SEQUENCE Seq_CodPedidos INCREMENT BY 1 START WITH 1
NOMAXVALUE;

CREATE TABLE Descuentos(
   codigo NUMBER(8) NOT NULL
   , fecha_caducidad DATE 
   , "porcentaje descuento" NUMBER(3) CHECK ("porcentaje descuento" >0 AND "porcentaje descuento"<=100)
   , PRIMARY KEY(codigo)
 );

CREATE TABLE Pedidos(
   codigo NUMBER(8) NOT NULL,
   estado CHAR(9) DEFAULT 'REST' NOT NULL,
   fecha_hora_pedido DATE NOT NULL,
   fecha_hora_entrega DATE,
   "importe total" NUMBER(8,2),
   cliente CHAR(9) NOT NULL REFERENCES Clientes(DNI),
   codigoDescuento Number(8) REFERENCES Descuentos(codigo) ON DELETE SET NULL,
   PRIMARY KEY(codigo),
   CHECK (estado IN ('REST', 'CANCEL', 'RUTA', 'ENTREGADO','RECHAZADO'))
);

CREATE TABLE Contiene(
   restaurante NUMBER(8)
   , plato CHAR(20)
   , pedido NUMBER(8) REFERENCES Pedidos(codigo) ON DELETE CASCADE
   , "precio con comisión" NUMBER(8,2)
   , unidades NUMBER(4)NOT NULL
   , PRIMARY KEY(restaurante, plato, pedido)
   , FOREIGN KEY(restaurante, plato) REFERENCES Platos(restaurante, nombre) ON DELETE CASCADE
);

  
INSERT INTO Restaurantes VALUES (1234,'pizzahu','abascal 45','12345',2.0);
INSERT INTO "Áreas Cobertura" VALUES (1234,'12345');
INSERT INTO Horarios VALUES (1234,'X',to_date('12:00','HH24:MI'),
to_date('23:00','HH24:MI'));
INSERT INTO Platos VALUES (1234,'pizza arrabiata',17.50,'pizza de carne y guindilla','picante');
INSERT INTO Clientes VALUES
('12345678N','Pedro','Pérez','Torralba',29,'4B','Madrid','12345','12345612','pedro','pedro');
INSERT INTO Descuentos VALUES (1100,to_date('20-04-09', 'DD-MM-YY'),50);

INSERT INTO Pedidos VALUES (1,'REST',to_date('17-02-09 19:50','DD-MM-YY HH24:MI'),
to_date('17-02-09 20:50','DD-MM-YY HH24:MI'), 34.25, '12345678N',1100);
INSERT INTO Contiene VALUES (1234,'pizza arrabiata',1,NULL,2);





