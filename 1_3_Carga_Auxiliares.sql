CREATE PROCEDURE 1_3_Carga_Auxiliares ()
BEGIN

  /* Carga de AUX_MMTT */
  CALL 1_3_1_Carga_AUX_MMTT();
  
  /* Carga de AUX_MMTT_MES */
  CALL 1_3_2_Carga_AUX_MMTT_MES();

  /* Carga de AUX_MMTT_TRIMESTRE */
  CALL 1_3_3_Carga_AUX_MMTT_TRIMESTRE();

END;