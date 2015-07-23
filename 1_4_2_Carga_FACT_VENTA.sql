CREATE PROCEDURE 1_4_2_Carga_FACT_VENTA ()
BEGIN
  /* 1. Se borran de FACT_VENTA aquellos registros cuyo COD_VENTA esté incluido en los registros que están en proceso según la tabla de control*/
  DELETE FROM COMERCIAL.FACT_VENTA FV
  INNER JOIN CONTROL_VENTA@operacional V 
  ON FV.COD_VENTA=V.ID_VENTA
  WHERE CARGA_DW=2;
  COMMIT;
  
  /* 2.  Se insertan en FACT_VENTA todos los registros que ya se han preparado en AUX_INSERTA_FACT_VENTA */
  INSERT INTO COMERCIAL.FACT_VENTA (COD_VENTA, FECHA_HORA, ID_FECHA, ID_MES, ID_TRIMESTRE, ID_SEMESTRE, ID_ANO, ID_ARTICULO, ID_TIPO_PRODUCTO, ID_MARCA, ID_TIENDA, ID_PROVINCIA, ID_PAIS, ID_ZONA, ID_SECCION, ID_PERIODO, ID_CAMPANA, PRECIO_UNITARIO, UNIDADES, PRECIO, FECHA_ALTA, USUARIO_ALTA)
    SELECT COD_VENTA, FECHA_HORA, ID_FECHA, ID_MES, ID_TRIMESTRE, ID_SEMESTRE, ID_ANO, ID_ARTICULO, ID_TIPO_PRODUCTO, ID_MARCA, ID_TIENDA, ID_PROVINCIA, ID_PAIS, ID_ZONA, ID_SECCION, ID_PERIODO, ID_CAMPANA, PRECIO_UNITARIO, UNIDADES, PRECIO, current_timestamp, current_user
    FROM STAGING.AUX_INSERTA_FACT_VENTA;
  COMMIT;
  
  /* 3. Se trunca la tabla AUX_INSERTA_FACT_VENTA para evitar que ocupe volumen */
  TRUNCATE TABLE STAGING.AUX_INSERTA_FACT_VENTA;
END;