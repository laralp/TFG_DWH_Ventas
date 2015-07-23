CREATE PROCEDURE 1_1_1_Actualiza_Control (
IN que INT, 
IN donde INT)
BEGIN
  /* Se marcan los registros como "en proceso" (CARGA_DW=2) */
  UPDATE CONTROL_VENTAS@operacional set CARGA_DW=que where CARGA_DW=donde;
END;