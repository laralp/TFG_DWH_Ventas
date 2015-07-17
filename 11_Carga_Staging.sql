CREATE PROCEDURE 11_Carga_Staging ()
BEGIN
  /* 1. Actualizacion en la tabla de control, para marcar los registros como "en proceso" (CARGA_DW=2) */
  UPDATE CONTROL_VENTAS@operacional set CARGA_DW=2 where CARGA_DW=0;
  
  /* 2. Borrado e inserción de las ventas en la tabla auxiliar que mantiene la misma estructura del operacional */
  TRUNCATE TABLE STAGING.AUX_FACT_VENTA;
  
  INSERT INTO STAGING.AUX_FACT_VENTA
    SELECT (ID_VENTA, FECHA_HORA, NUM_TICKET, ID_ARTICULO, ID_TIPO_PRODUCTO, ID_MARCA, ID_TIENDA,ID_SECCION, ID_PERIODO, ID_CAMPANA, PRECIO_UNITARIO, UNIDADES, PRECIO, FECHA_ALTA, USUARIO_ALTA)
    FROM CONTROL_VENTAS@operacional CV 
    INNER JOIN VENTA@operacional V ON (CV.ID_VENTA=V.ID_VENTA AND CV.CARGA_DW=2);
  COMMIT;
  
END;