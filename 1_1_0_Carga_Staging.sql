CREATE PROCEDURE 1_1_0_Carga_Staging ()
BEGIN
  /* Actualizacion en la tabla de control */
  CALL 1_1_1_Actualiza_Control(2,0);
  
  /* Borrado e inserción de las ventas en la tabla auxiliar que mantiene la misma estructura del operacional */
  CALL 1_1_2_Carga_AUX_FACT_VENTA();
  
END;