CREATE PROCEDURE 1_2_0_Carga_Dimensiones ()
BEGIN

  /* Carga de DIM_FECHA */
  CALL 1_2_1_Carga_DIM_FECHA();

  /* Carga de DIM_ANO */
  CALL 1_2_2_Carga_DIM_ANO();
  
  /* Carga de DIM_TIENDA */
  CALL 1_2_3_Carga_DIM_TIENDA();

  /* Carga de DIM_PROVINCIA */
  CALL 1_2_4_Carga_DIM_PROVINCIA();

  /* Carga de DIM_PAIS */
  CALL 1_2_5_Carga_DIM_PAIS();

  /* Carga de DIM_ZONA */
  CALL 1_2_6_Carga_DIM_ZONA();

  /* Carga de DIM_MARCA */
  CALL 1_2_7_Carga_DIM_MARCA();

  /* Carga de DIM_TIPO_PRODUCTO */
  CALL 1_2_8_Carga_DIM_TIPO_PRODUCTO();

  /* Carga de DIM_ARTICULO */
  CALL 1_2_9_Carga_DIM_ARTICULO();

  /* Carga de DIM_SECCION */
  CALL 1_2_10_Carga_DIM_SECCION();
  
  /* Carga de DIM_CAMPANA */
  CALL 1_2_11_Carga_DIM_CAMPANA();
   
  /* Carga de DIM_PERIODO */
  CALL 1_2_12_Carga_DIM_PERIODO();

  
END;