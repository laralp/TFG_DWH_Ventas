CREATE PROCEDURE 1_2_7_Carga_DIM_MARCA ()
BEGIN
  /* Se actualizan los registros que coinciden en la tabla operacional con la dimensión */
  UPDATE COMERCIAL.DIM_MARCA 
  INNER JOIN MARCA@operacional M
  ON COD_MARCA=M.ID_MARCA
  SET DESC_MARCA=M.DESCRIPCION,
	  FECHA_MODIFICACION=current_timestamp,
	  USUARIO_MODIFICACION=current_user;
  COMMIT;
  /* Se insertan los registros nuevos */
  INSERT INTO COMERCIAL.DIM_MARCA (COD_MARCA, DESC_MARCA, FECHA_ALTA, USUARIO_ALTA)
    SELECT M.ID_MARCA, M.DESCRIPCION, current_timestamp, current_user
    FROM MARCA@operacional M
    LEFT JOIN COMERCIAL.DIM_MARCA DM
    ON M.ID_MARCA=DM.COD_MARCA
    WHERE DM.ID_MARCA IS NULL;  
  COMMIT;
END;