CREATE PROCEDURE 1_2_5_Carga_DIM_PAIS ()
BEGIN
  /* Se actualizan los registros que coinciden en la tabla operacional con la dimensión */
  UPDATE MAESTROS.DIM_PAIS 
  INNER JOIN PAIS@operacional P
  ON COD_PAIS=P.ID_PAIS
  SET DESC_PAIS=P.DESCRIPCION,
      CODIGO_ISO=P.CODIGO_ISO,
	  FECHA_MODIFICACION=current_timestamp,
	  USUARIO_MODIFICACION=current_user;
  COMMIT;
  /* Se insertan los registros nuevos */
  INSERT INTO MAESTROS.DIM_PAIS (COD_PAIS, DESC_PAIS, CODIGO_ISO, FECHA_ALTA, USUARIO_ALTA)
    SELECT P.ID_PAIS, P.DESCRIPCION, P.CODIGO_ISO, current_timestamp, current_user
    FROM PAIS@operacional P
    LEFT JOIN MAESTROS.DIM_PAIS DP
    ON P.ID_PAIS=DP.COD_PAIS
    WHERE DP.ID_PAIS IS NULL;
  COMMIT;
END;