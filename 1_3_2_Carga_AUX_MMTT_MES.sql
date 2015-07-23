CREATE PROCEDURE 1_3_2_Carga_AUX_MMTT_MES ()
BEGIN
  CREATE TEMPORARY TABLE temp_mmtt_mes (
  MMTT_MES bit,
  MMTT_MES_POST bit,
  ID_ANO int,
  ID_MES int,
  ID_TIENDA int);
  INSERT INTO temp_mmtt_mes (MMTT_MES, MMTT_MES_POST, ID_ANO, ID_MES, ID_TIENDA)
    SELECT IF(COUNT(MMTT_DIA)=SUM(MMTT_DIA),1,0),
	       IF(COUNT(MMTT_DIA)=SUM(MMTT_DIA_POST),1,0),
		   YEAR(ID_FECHA),
		   MONTH(ID_FECHA),
		   ID_TIENDA
	FROM STAGING.AUX_MMTT
	GROUP BY YEAR(ID_FECHA), MONTH(ID_FECHA), ID_TIENDA;
  /* Se actualizan los registros que ya existen */
  UPDATE STAGING.AUX_MMTT_MES A
  INNER JOIN temp_mmtt_mes T
  ON (A.ID_ANO=T.ID_ANO AND A.ID_MES=T.ID_MES AND A.ID_TIENDA=T.ID_TIENDA)
  SET MMTT_MES=T.MMTT_MES,
      MMTT_MES_POST=T.MMTT_MES_POST,
	  FECHA_MODIFICACION=current_timestamp,
	  USUARIO_MODIFICACION=current_user;
  COMMIT;
  /* Se insertan los registros nuevos */
  INSERT INTO STAGING.AUX_MMTT_MES (ID_TIENDA, ID_MES, ID_ANO, MMTT_MES, MMTT_MES_POST, FECHA_ALTA, USUARIO_ALTA)
    SELECT T.ID_TIENDA, T.ID_MES, T.ID_ANO, T.MMTT_MES, T.MMTT_MES_POST, current_timestamp, current_user
    FROM temp_mmtt_mes T
    LEFT JOIN STAGING.AUX_MMTT A
    ON (A.ID_ANO=T.ID_ANO AND A.ID_MES=T.ID_MES AND A.ID_TIENDA=T.ID_TIENDA)
    WHERE A.ID_ANO IS NULL;
  COMMIT;
END;
