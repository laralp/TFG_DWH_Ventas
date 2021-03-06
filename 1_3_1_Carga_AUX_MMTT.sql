CREATE PROCEDURE 1_3_1_Carga_AUX_MMTT ()
BEGIN
  TRUNCATE TABLE STAGING.AUX_MMTT;
  INSERT INTO STAGING.AUX_MMTT (ID_TIENDA, ID_FECHA, MMTT_DIA, MMTT_DIA_POST, FECHA_ALTA, USUARIO_ALTA)
    SELECT T.ID_TIENDA, 
	       F.ID_FECHA, 
		   IF (   ((T.FECHA_APERTURA>DATEADD(ID_FECHA, interval -1 year)) AND (T.FECHA_APERTURA<ID_FECHA))
               OR ((T.FECHA_CIERRE>DATEADD(ID_FECHA, interval -1 year)) AND (T.FECHA_CIERRE<ID_FECHA))
               OR ((T.FECHA_ULT_REF>DATEADD(ID_FECHA, interval -1 year)) AND (T.FECHA_ULT_REF<ID_FECHA))
			   ,0,1) MMTT_DIA,
		   IF (   ((T.FECHA_APERTURA>ID_FECHA) AND (T.FECHA_APERTURA<DATEADD(ID_FECHA, interval 1 year)))
               OR ((T.FECHA_CIERRE>ID_FECHA) AND (T.FECHA_CIERRE<DATEADD(ID_FECHA, interval -1 year)))
               OR ((T.FECHA_ULT_REF>ID_FECHA) AND (T.FECHA_ULT_REF<DATEADD(ID_FECHA, interval -1 year)))
			   ,0,1) MMTT_DIA_POST,
		   current_timestamp,
		   current_user
    FROM MAESTROS.DIM_TIENDA T CROSS JOIN MAESTROS.DIM_FECHA F
  COMMIT; 
END;