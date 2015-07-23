CREATE PROCEDURE 1_2_1_Carga_DIM_FECHA ()
BEGIN
  /* Si es 1 de Noviembre, deberá hacerse una carga anual con todos los registros del próximo año */
  IF (MONTH(CURRENT_DATE)=11 AND DAY(CURRENT_DATE)=1) THEN /* Carga anual */
    DECLARE ano_actual int;
	DECLARE inicio_str varchar(10);
	DECLARE fin_str varchar(10);
	DECLARE ano_fin int;
	DECLARE inicio_date date;
	DECLARE fin_date date;
	DECLARE vfecha date;
    DECLARE fecha_ins date;
	
	SET @ano_actual=year(current_date);
	SET @ano_fin=@ano_actual+2;
	SET @inicio_str=concat('31-12-',@ano_actual);
	SET @inicio_date=CSAT(@inicio_str AS DATE);
	SET @fin_str=concat('01-01-',@ano_fin);
	SET @fin_date=CAST(@inicio_str AS DATE);
    SET @vfecha=@inicio_date;
	
    bucle: LOOP
	  SET @vfecha=DATEADD(@vfecha, interval 1 day);
	  IF @vfecha < @fin_date THEN
	  	SELECT @fecha_ins:= ID_FECHA FROM MAESTROS.DIM_FECHA WHERE ID_FECHA=@vfecha;
		IF @vfecha<>@fecha_ins THEN 
		  INSERT INTO MAESTROS.DIM_FECHA(ID_FECHA, FECHA_ALTA, USUARIO_ALTA) values (@fecha, current_timestamp, current_user);
		END IF;
	    ITERATE bucle;
	  END IF;
	  LEAVE bucle;
	END LOOP bucle;
  END IF;
  COMMIT;
  
  /* Se comprueba si todas las fechas de las ventas que se van a procesar están en DIM_FECHA, y si no es así, se añaden */
  INSERT INTO MAESTROS.DIM_FECHA (ID_FECHA, FECHA_ALTA, USUARIO_ALTA)
    SELECT A.FECHA, current_timestamp, current_user 
	FROM MAESTROS.DIM_FECHA F
    RIGHT JOIN (SELECT DISTINCT CAST(FECHA_HORA AS DATE) FECHA FROM STAGING.AUX_FACT_VENTA) A
    ON F.ID_FECHA=A.FECHA
    WHERE F.ID_FECHA IS NULL;
  COMMIT;
  
END;