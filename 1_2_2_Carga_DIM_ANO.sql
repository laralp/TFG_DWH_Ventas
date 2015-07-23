CREATE PROCEDURE 1_2_1_Carga_DIM_ANO ()
BEGIN
  /* Se comprueba si todos los años de las ventas que se van a procesar están en DIM_ANO, y si no es así, se añaden */
  INSERT INTO MAESTROS.DIM_ANO (ID_ANO, FECHA_ALTA, USUARIO_ALTA)
    SELECT A.ANO, current_timestamp, current_user 
	FROM MAESTROS.DIM_ANO DA
    RIGHT JOIN (SELECT DISTINCT YEAR(FECHA_HORA) ANO FROM STAGING.AUX_FACT_VENTA) A
    ON DA.ID_FECHA=A.ANO
    WHERE DA.ID_ANO IS NULL;
  COMMIT;
END;