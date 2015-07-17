CREATE PROCEDURE 20_Borrado_Historicos ()
BEGIN
  /* Se borran de AUX_CARGA_DW los registros anteriores a 30 días */
  DELETE FROM STAGING.AUX_CARGA_DW WHERE ID_FECHA<DATEADD(current_date, interval -30 day);
  COMMIT;
  
  /* Se borran de AUX_MMTT los registros anteriores a 5 años */
  DELETE FROM STAGING.AUX_MMTT WHERE ID_FECHA<DATEADD(current_date, interval -5 year);
  COMMIT;
  
  /* Se borran de AUX_MMTT_MES los datos anteriores a 5 años */
  DELETE FROM STAGING.AUX_MMTT_MES WHERE ID_ANO<YEAR(current_date)-5;
  COMMIT;
  
  /* Se borran de AUX_MMTT_TRIMESTRE los datos anteriores a 5 años */  
  DELETE FROM STAGING.AUX_MMTT_TRIMESTRE WHERE ID_ANO<YEAR(current_date)-5;
  COMMIT;

  /* Se borran de DIM_FECHA los datos anteriores a 5 años */
  DELETE FROM MAESTROS.DIM_FECHA WHERE ID_FECHA<DATEADD(current_date, interval -5 year);
  COMMIT;
  
  /* Se borran de DIM_ANO los datos anteriores a 5 años */
  DELETE FROM MAESTROS.DIM_ANO WHERE ID_ANO<YEAR(current_date)-5;
  COMMIT;
  
  /* Se borran de FACT_VENTA los datos anteriores a  años */
  DELETE FROM COMERCIAL.FACT_VENTA WHERE ID_FECHA<DATEADD(current_date, interval -3 year);
  COMMIT;
  
  /* Se borran de la tabla de CONTROL los registros anteriores a 30 días */
  DELETE FROM CONTROL_VENTAS@operacional WHERE fecha_alta<DATEADD(current_date, interval -30 day);
  COMMIT;
END;
