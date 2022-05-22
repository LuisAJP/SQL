
CREATE TABLE REGISTRO_VENTAS (
	
	COD_REST NUMBER(8) PRIMARY KEY REFERENCES Restaurantes,
	TOTAL_PEDIDOS NUMBER, -- precio con comision * unidades
	FECHA_ULT_PEDIDO DATE

);

CREATE OR REPLACE TRIGGER control_registro_ventas

	AFTER INSERT OR UPDATE OR DELETE ON Contiene

	FOR EACH ROW

	DECLARE
		
		v_date Pedidos.fecha_hora_pedido%TYPE;

	BEGIN

		IF DELETING THEN

			UPDATE 	REGISTRO_VENTAS
			SET 	TOTAL_PEDIDOS = TOTAL_PEDIDOS - ( :OLD."precio con comisión" * :OLD.unidades )
			WHERE	COD_REST = :OLD.restaurante;

		ELSIF INSERTING THEN
		
			SELECT 	fecha_hora_pedido 
			INTO 	v_date 
			FROM	Pedidos 
			WHERE	:NEW.pedido = codigo; 

			UPDATE 	REGISTRO_VENTAS
			SET 	TOTAL_PEDIDOS = TOTAL_PEDIDOS + ( :NEW."precio con comisión" * :NEW.unidades ),
					FECHA_ULT_PEDIDO = v_date
			WHERE	COD_REST = :NEW.restaurante;
		
		ELSE

			UPDATE 	REGISTRO_VENTAS
			SET 	TOTAL_PEDIDOS = TOTAL_PEDIDOS - ( :OLD."precio con comisión" * :OLD.unidades ) + ( :NEW."precio con comisión" * :NEW.unidades)
			WHERE	COD_REST = :OLD.restaurante;

		END IF;

	END;





CREATE OR REPLACE TRIGGER control_detalles_pedido

	AFTER INSERT OR UPDATE OR DELETE ON Contiene

	FOR EACH ROW 


	BEGIN

		IF DELETING THEN

			UPDATE 	Pedidos
			SET 	"importe total" = "importe total" - ( :OLD."precio con comisión" * :OLD.unidades )
			WHERE	codigo = :OLD.pedido;

		ELSIF INSERTING THEN

			UPDATE 	Pedidos
			SET 	"importe total" = "importe total" + ( :NEW."precio con comisión" * :NEW.unidades )
			WHERE	codigo = :NEW.pedido;
		
		ELSE

			UPDATE 	Pedidos
			SET 	"importe total" = "importe total" - ( :OLD."precio con comisión" * :OLD.unidades ) + ( :NEW."precio con comisión" * :NEW.unidades)
			WHERE	codigo = :OLD.pedido;

		END IF;

	END;