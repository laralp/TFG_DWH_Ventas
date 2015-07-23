CREATE PROCEDURE 1_2_12_Carga_DIM_PERIODO ()
BEGIN
  /* Se actualizan los registros que coinciden en la tabla operacional con la dimensión */
  UPDATE COMERCIAL.DIM_PERIODO 
  INNER JOIN PERIODO@operacional P
  ON COD_PERIODO=P.ID_PERIODO
  SET DESC_PERIODO=P.DESCRIPCION,
	  FECHA_MODIFICACION=current_timestamp,
	  USUARIO_MODIFICACION=current_user;
  COMMIT;
  /* Se insertan los registros nuevos */
  INSERT INTO COMERCIAL.DIM_PERIODO (COD_PERIODO, DESC_PERIODO, FECHA_ALTA, USUARIO_ALTA)
    SELECT P.ID_PERIODO, P.DESCRIPCION, current_timestamp, current_user
    FROM PERIODO@operacional P
    LEFT JOIN COMERCIAL.DIM_PERIODO DP
    ON P.ID_PERIODO=DP.COD_PERIODO
    WHERE DP.ID_PERIODO IS NULL;
  COMMIT;
END;