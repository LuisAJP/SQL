
-----Grupo GIIC02    RAYNER TAN LUC                   LUIS ALBERTO JARAMILLO PULIDO



---------------------------------APARTADO_01-------------------------------------------------------------------
SET SERVEROUTPUT ON SIZE 10000; 

CREATE OR REPLACE PROCEDURE PEDIDOS_CLIENTE (p_DNI IN VARCHAR) IS

TB CONSTANT varchar2(1):=CHR(9);
V_DNI CLIENTES.DNI%TYPE;
V_NOMBRE  CLIENTES.NOMBRE%TYPE;
V_APELLIDO  CLIENTES.APELLIDO%TYPE;
V_CALLE CLIENTES.CALLE%TYPE;
V_NUMERO CLIENTES.NUMERO%TYPE;
V_PISO CLIENTES.PISO%TYPE;
V_LOCALIDAD CLIENTES.LOCALIDAD%TYPE;
V_CP  CLIENTES."código postal"%TYPE;
V_TELEFONO CLIENTES.TELEFONO%TYPE;
V_TOTAL PEDIDOS."importe total"%TYPE;
V_CLIENTE PEDIDOS.CLIENTE%TYPE;
CONT_DNI INTEGER;
CONT_PEDIDOS INTEGER;
SUMA INTEGER;

CURSOR Cursor_Pedidos IS
SELECT CODIGO, FECHA_HORA_PEDIDO, FECHA_HORA_ENTREGA, ESTADO, "importe total"
FROM  PEDIDOS P
WHERE P.CLIENTE = p_DNI AND P.estado <> 'CANCEL'
ORDER BY FECHA_HORA_PEDIDO;
rPedidos Cursor_Pedidos%ROWTYPE; 

BEGIN
SELECT COUNT(*) INTO CONT_DNI FROM Clientes WHERE DNI = p_DNI;
IF CONT_DNI = 0 THEN
  DBMS_OUTPUT.PUT_LINE('---ERROR---NO EXISTE CLIENTE');
ELSE
  SELECT COUNT(*) INTO CONT_PEDIDOS FROM PEDIDOS WHERE Cliente = p_DNI;
IF CONT_PEDIDOS = 0 THEN
  DBMS_OUTPUT.PUT_LINE('EL CLIENTE CON DNI: ' || p_DNI || 'NO HA EFECTUADO NINGUN PEDIDO');
ELSE

SELECT DNI, NOMBRE,APELLIDO,CALLE,NUMERO, PISO,LOCALIDAD,"código postal",TELEFONO
INTO V_DNI, V_NOMBRE, V_APELLIDO, V_CALLE, V_NUMERO, V_PISO, V_LOCALIDAD, V_CP, V_TELEFONO
FROM CLIENTES C WHERE C.DNI = p_DNI;

SELECT CLIENTE, SUM("importe total") INTO V_CLIENTE,V_TOTAL
FROM PEDIDOS P
WHERE P.CLIENTE = p_DNI 
GROUP BY CLIENTE;

  DBMS_OUTPUT.PUT_LINE(' DNI:              '|| V_DNI);
  DBMS_OUTPUT.PUT_LINE(' NOMBRE:           '|| V_NOMBRE );
  DBMS_OUTPUT.PUT_LINE(' APELLIDO:         '|| V_APELLIDO);
  DBMS_OUTPUT.PUT_LINE(' DIRECCIÓN:        '|| V_CALLE ||TB||V_Numero||TB|| V_PISO );

OPEN Cursor_Pedidos;
LOOP
  FETCH Cursor_Pedidos INTO rPedidos;
  EXIT WHEN Cursor_Pedidos%NOTFOUND;
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE(' CÓDIGO PEDIDO     '||rPedidos.CODIGO);
  DBMS_OUTPUT.PUT_LINE(' FECHA             '||rPedidos.FECHA_HORA_PEDIDO);
  DBMS_OUTPUT.PUT_LINE(' FECHA DE ENTREGA  '||rPedidos.FECHA_HORA_ENTREGA);
  DBMS_OUTPUT.PUT_LINE(' ESTADO            '||rPedidos.ESTADO);
  DBMS_OUTPUT.PUT_LINE(' IMPORTE PEDIDO    '||rPedidos."importe total");
 END LOOP;
 CLOSE cursor_Pedidos; 
  
  DBMS_OUTPUT.PUT_LINE('            ************************');
  DBMS_OUTPUT.PUT_LINE('            * IMPORTE TOTAL: '||V_TOTAL ||'  *');
  DBMS_OUTPUT.PUT_LINE('            ************************');
  
END IF;
END IF;
END; 

EXEC pedidos_cliente('123456778M');

BEGIN
DECLARE
  BEGIN
  PEDIDOS_CLIENTE('12345678N'); /*NO EXISTE*/
  END;
END;
---------------------------------APARTADO_02-------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE REVISA_PRECIO_CON_COMISION AS

CURSOR C_RPCC IS
SELECT p.precio, r.comision, con.unidades, con."precio con comisión", con.plato 
FROM Platos p,Contiene con, Restaurantes r
WHERE (p.nombre=con.plato and con.restaurante=r.codigo) and p.restaurante=r.codigo;
    
rPedidos c_rpcc%ROWTYPE; 
AUX CONTIENE."precio con comisión"%TYPE;
v_cont INTEGER;

BEGIN
v_cont := 0;

FOR rPedidos IN c_rpcc LOOP

AUX := ((RPEDIDOS.PRECIO * RPEDIDOS.COMISION)/100) + RPEDIDOS.PRECIO;

IF (AUX <> RPEDIDOS."precio con comisión") OR 
(rPedidos."precio con comisión" IS NULL) THEN
      	V_CONT := V_CONT+1;
      		UPDATE Contiene SET Contiene."precio con comisión" = aux 
WHERE Contiene.plato = rPedidos.plato ;
END IF;
 
END LOOP;
		
IF( v_cont > 0 ) THEN
DBMS_OUTPUT.PUT_LINE( 'Numero de filas modificadas = ' || v_cont);	
ELSE
	DBMS_OUTPUT.PUT_LINE( 'Ningun cambio en los datos de Contiene' );
END IF;
		
END REVISA_PRECIO_CON_COMISION;


BEGIN
DECLARE
BEGIN
REVISA_PRECIO_CON_COMISION;
END;
END;

---------------------------------APARTADO_03-------------------------------------------------------------------

CREATE OR REPLACE FUNCTION Calcular_Total_Pedido (NumeroPedido number) RETURN NUMBER IS
 
CURSOR DATOSPEDIDOS IS
  SELECT Con."precio con comisión", Con.unidades
  FROM Contiene Con
  WHERE Con.pedido = NumeroPedido;
   
  v_precioComision  Contiene."precio con comisión"%type;
  V_UNIDADES        CONTIENE.UNIDADES%TYPE;
  v_importeTotal    Pedidos."importe total"%type;
   
BEGIN
    OPEN datosPedidos;
    v_importeTotal := 0;
     
    LOOP
      FETCH datosPedidos INTO v_precioComision, v_unidades;
      EXIT WHEN datosPedidos%notfound;
       
      v_importeTotal := v_importeTotal + v_precioComision * v_unidades;      
    END LOOP;
    CLOSE datosPedidos;
    RETURN V_IMPORTETOTAL;
END Calcular_Total_Pedido;
  
-- Procedimiento del apartado 3 que utiliza la funcion anterior (Calcular_Total_Pedido) y actualiza el importe de los pedidos si no estÃ¡n bien

CREATE OR REPLACE PROCEDURE REVISA_PEDIDOS IS
 
CURSOR DATOSPEDIDOS IS
  SELECT P.codigo, P."importe total" FROM PEDIDOS P
  FOR UPDATE OF P."importe total" NOWAIT;
 
  V_CODIGO          PEDIDOS.CODIGO%TYPE;
  V_IMPORTEPEDIDO   PEDIDOS."importe total"%TYPE;
  v_importe         Pedidos."importe total"%type;
  v_pedidoActual    Pedidos.codigo%type;
  v_contador        integer;
     
  excepcion_codigo_nulo exception;
     
BEGIN
    OPEN datosPedidos;
    v_contador:=0;
    v_pedidoActual := 0;
    v_importe := 0;
    LOOP
        FETCH datosPedidos INTO v_codigo, v_importePedido;
        IF v_codigo IS NULL THEN
            raise excepcion_codigo_nulo;
        ELSE
            EXIT WHEN datosPedidos%notfound;
        v_importe := Calcular_Total_Pedido(v_codigo);
       
        IF V_IMPORTE != V_IMPORTEPEDIDO THEN
          UPDATE Pedidos set "importe total" = v_importe WHERE CURRENT OF datosPedidos;  
          v_contador := v_contador + 1;
        END IF;
        END IF;
    END LOOP;
    if(v_contador = 0) then
        dbms_output.put_line('Ningún cambio en los datos de Pedidos.');
    ELSE
        dbms_output.put_line('Numero de filas modificadas: ' || v_contador);
    END IF;
    CLOSE datosPedidos;
EXCEPTION
        WHEN excepcion_codigo_nulo THEN
            DBMS_OUTPUT.PUT_LINE('Tabla vacía: ' );
END REVISA_PEDIDOS;

BEGIN
DECLARE
BEGIN
REVISA_PEDIDOS;
END;
END;


---------------------------------APARTADO_04-------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE DATOS_CLIENTES  IS

TB CONSTANT varchar2(1):=CHR(9);
v_total PEDIDOS."importe total"%TYPE := 0 ; /*contador*/

CURSOR Cursor_Clientes IS
SELECT DNI, NOMBRE,APELLIDO,CALLE,NUMERO, PISO,LOCALIDAD,"código postal",TELEFONO, SUM("importe total") AS TOTAL
FROM CLIENTES C, PEDIDOS P
WHERE C.DNI = P.CLIENTE
GROUP BY DNI, NOMBRE,APELLIDO,CALLE,NUMERO, PISO,LOCALIDAD,"código postal",TELEFONO;

BEGIN

  FOR rClientes IN Cursor_Clientes LOOP
    DBMS_OUTPUT.PUT_LINE(' DNI:       '|| rClientes.DNI );
    DBMS_OUTPUT.PUT_LINE(' NOMBRE:    '|| rClientes.NOMBRE );
    DBMS_OUTPUT.PUT_LINE(' APELLIDO:  '|| rClientes.APELLIDO );
    DBMS_OUTPUT.PUT_LINE(' DIRECCION: '|| rClientes.CALLE  ||' '||rClientes.Numero||' '||rClientes.PISO );
    DBMS_OUTPUT.PUT_LINE(' LOCALIDAD: '|| rClientes.LOCALIDAD||' '||rClientes."código postal" );
    DBMS_OUTPUT.PUT_LINE(' TELEFONO:  '|| rClientes.TELEFONO);
    DBMS_OUTPUT.PUT_LINE(' ************************');
    DBMS_OUTPUT.PUT_LINE(' * IMPORTE TOTAL: '||rClientes.TOTAL ||'  *');
    DBMS_OUTPUT.PUT_LINE(' ************************');
    DBMS_OUTPUT.PUT_LINE('                                            ');
    v_total := v_total + rClientes.TOTAL;
  END LOOP;
    DBMS_OUTPUT.PUT_LINE('            ************************');
    DBMS_OUTPUT.PUT_LINE('            * CONSUMO TOTAL: '||v_total ||'  *');
    DBMS_OUTPUT.PUT_LINE('            ************************');
END;

BEGIN
DECLARE 
  BEGIN
  DATOS_CLIENTES;
  END;
END;

---------------------------------APARTADO_05-------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE apartado5 IS
BEGIN
  PEDIDOS_CLIENTE('12345678N');
  REVISA_PRECIO_CON_COMISION;
  REVISA_PEDIDOS;
END APARTADO5;

BEGIN
DECLARE 
  BEGIN
   apartado5;
  END;
END;
