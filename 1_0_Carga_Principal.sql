CREATE PROCEDURE 1_0_Carga_Principal ()
BEGIN
  /* Registro de inicio de carga */ 
  DECLARE cargando int unsigned default 0;
  SELECT @cargando:= ID_CARGA FROM STAGING.AUX_CARGA_DW WHERE ID_FECHA=current_date AND ID_CARGA=1;
  IF @cargando=0 THEN /*actualizar*/
    UPDATE STAGING.AUX_CARGA_DW SET INICIO=current_timestamp,FIN=null WHERE ID_FECHA=current_date AND ID_CARGA=1;
  ELSE /*insertar*/
    INSERT INTO STAGING.AUX_CARGA_DW (ID_FECHA, ID_CARGA_DW, INICIO, USUARIO_ALTA) VALUES (current_date, 1, current_timestamp, current_user);
  END IF;
  COMMIT;
  
  /* Carga de Staging */
  CALL 1_1_0_Carga_Staging();
  
  /* Carga de Dimensiones */
  CALL 1_2_0_Carga_Dimensiones();
  
  /* Carga de Auxiliares */
  CALL 1_3_0_Carga_Auxiliares();
  
  /* Carga de Hechos */
  call 1_4_0_Carga_Hechos();
  
  /* Registro de fin de carga */
  UPDATE STAGING.AUX_CARGA_DW SET FIN=current_timestamp WHERE ID_FECHA=current_date AND ID_CARGA=1;
  COMMIT;
  
END
