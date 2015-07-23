CREATE PROCEDURE 1_4_0_Carga_Hechos ()
BEGIN
  /* Carga de la tabla auxiliar AUX_INSERTA_FACT_VENTA */
  CALL 1_4_1_Carga_AUX_INSERTA_FACT_VENTA();
  
  /* Carga de la tabla de hechos FACT_VENTA */
  CALL 1_4_2_Carga_FACT_VENTA();
  
  /* Se actualiza la tabla de control para marcar como "procesados" (CARGA_DW=1) aquellos que estaban "en proceso" (CARGA_DW=2) */
  CALL 1_1_1_Actualiza_Control(1,2);
  
END;