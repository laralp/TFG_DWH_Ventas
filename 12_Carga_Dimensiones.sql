CREATE PROCEDURE 12_Carga_Dimensiones ()
BEGIN

  /* ------------------ */
  /* Carga de DIM_FECHA */
  /* ------------------ */
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

  /* ---------------- */
  /* Carga de DIM_ANO */
  /* ---------------- */
  /* Se comprueba si todos los años de las ventas que se van a procesar están en DIM_ANO, y si no es así, se añaden */
  INSERT INTO MAESTROS.DIM_ANO (ID_ANO, FECHA_ALTA, USUARIO_ALTA)
    SELECT A.ANO, current_timestamp, current_user 
	FROM MAESTROS.DIM_ANO DA
    RIGHT JOIN (SELECT DISTINCT YEAR(FECHA_HORA) ANO FROM STAGING.AUX_FACT_VENTA) A
    ON DA.ID_FECHA=A.ANO
    WHERE DA.ID_ANO IS NULL;
  COMMIT;
  
  /* ------------------- */
  /* Carga de DIM_TIENDA */
  /* ------------------- */
  /* Se actualizan los registros que coinciden en la tabla operacional con la dimensión */
  UPDATE MAESTROS.DIM_TIENDA 
  INNER JOIN TIENDA@operacional T
  ON COD_TIENDA=T.ID_TIENDA
  SET DESC_TIENDA=T.DESCRIPCION,
      DIRECCION=T.DIRECCION,
	  LATITUD=T.LATITUD,
	  LONGITUD=T.LONGITUD,
	  FECHA_APERTURA=T.FECHA_AP,
	  FECHA_CIERRE=T.FECHA_CI,
	  FECHA_ULT_REF=T.FECHA_UR,
	  FECHA_MODIFICACION=current_timestamp,
	  USUARIO_MODIFICACION=current_user;
  COMMIT; 
  /* Se insertan los registros nuevos */
  INSERT INTO MAESTROS.DIM_TIENDA (COD_TIENDA, DESC_TIENDA, DIRECCION, LATITUD, LONGITUD, FECHA_APERTURA, FECHA_CIERRE, FECHA_ULT_REF, FECHA_ALTA, USUARIO_ALTA)
    SELECT T.ID_TIENDA, T.DESCRIPCION, T.DIRECCION, T.LATITUD, T.LONGITUD, T.FECHA_AP, T.FECHA_CI, T.FECHA_UR, current_timestamp, current_user
    FROM TIENDA@operacional T
    LEFT JOIN MAESTROS.DIM_TIENDA DT
    ON T.ID_TIENDA=DT.COD_TIENDA
    WHERE DT.ID_TIENDA IS NULL;
  COMMIT;
  
  /* ---------------------- */
  /* Carga de DIM_PROVINCIA */
  /* ---------------------- */
  /* Se actualizan los registros que coinciden en la tabla operacional con la dimensión */
  UPDATE MAESTROS.DIM_PROVINCIA 
  INNER JOIN PROVINCIA@operacional P
  ON COD_PROVINCIA=P.ID_PROVINCIA
  SET DESC_PROVINCIA=P.DESCRIPCION,
	  FECHA_MODIFICACION=current_timestamp,
	  USUARIO_MODIFICACION=current_user;
  COMMIT;
  /* Se insertan los registros nuevos */
  INSERT INTO MAESTROS.DIM_PROVINCIA (COD_PROVINCIA, DESC_PROVINCIA, FECHA_ALTA, USUARIO_ALTA)
    SELECT P.ID_PROVINCIA, P.DESCRIPCION, current_timestamp, current_user
    FROM PROVINCIA@operacional P
    LEFT JOIN MAESTROS.DIM_PROVINCIA DP
    ON P.ID_PROVINCIA=DP.COD_PROVINCIA
    WHERE DP.ID_PROVINCIA IS NULL;
  COMMIT;
  
  /* ----------------- */
  /* Carga de DIM_PAIS */
  /* ----------------- */
  /* Se actualizan los registros que coinciden en la tabla operacional con la dimensión */
  UPDATE MAESTROS.DIM_PAIS 
  INNER JOIN PAIS@operacional P
  ON COD_PAIS=P.ID_PAIS
  SET DESC_PAIS=P.DESCRIPCION,
      CODIGO_ISO=P.CODIGO_ISO,
	  FECHA_MODIFICACION=current_timestamp,
	  USUARIO_MODIFICACION=current_user;
  COMMIT;
  /* Se insertan los registros nuevos */
  INSERT INTO MAESTROS.DIM_PAIS (COD_PAIS, DESC_PAIS, CODIGO_ISO, FECHA_ALTA, USUARIO_ALTA)
    SELECT P.ID_PAIS, P.DESCRIPCION, P.CODIGO_ISO, current_timestamp, current_user
    FROM PAIS@operacional P
    LEFT JOIN MAESTROS.DIM_PAIS DP
    ON P.ID_PAIS=DP.COD_PAIS
    WHERE DP.ID_PAIS IS NULL;
  COMMIT;
  
  /* ----------------- */
  /* Carga de DIM_ZONA */
  /* ----------------- */
  /* Se crea una tabla temporal con la información de las tablas ZONA, ZONA_RESPONSABLE Y EMPLEADO del operacional, puesto que se desnormalizan en su paso al DWH */
  CREATE TEMPORARY TABLE temp_zona_resp (
  ID_ZONA int,
  DESCRIPCION varchar(20),
  ID_RESPONSABLE int,
  FECHA_DESDE date,
  NOMBRE varchar(20),
  APELLIDO1 varchar(20),
  APELLIDO2 varchar(20),
  DNI varchar(15)
  );
  INSERT INTO temp_zona_resp (ID_ZONA, DESCRIPCION, ID_RESPONSABLE, FECHA_HASTA, NOMBRE, APELLIDO1, APELLIDO2, DNI)
    SELECT Z.ID_ZONA, Z.DESCRIPCION, ZR.ID_RESPONSABLE, ZR.FECHA_DESDE, E.NOMBRE, E.APELLIDO1, E.APELLIDO2, DNI
    FROM ZONA@operacional Z
    LEFT JOIN ZONA_RESPONSABLE@operacional ZR ON (Z.ID_ZONA=ZR.ID_ZONA AND ZR.FECHA_HASTA is null)
    LEFT JOIN EMPLEADO@operacional E ON (ZR.ID_RESPONSABLE=E.ID_EMPLEADO);
  /* Se actualizan los registros que coinciden en la tabla operacional con la tabla temporal */
  UPDATE MAESTROS.DIM_ZONA 
  INNER JOIN temp_zona_resp Z
  ON COD_ZONA=Z.ID_ZONA
  SET DESC_ZONA=Z.DESCRIPCION,
      COD_RESPONSABLE=Z.ID_RESPONSABLE,
	  NOMBRE_RESPONSABLE=Z.NOMBRE,
	  APELLIDO1_RESPONSABLE=Z.APELLIDO1,
	  APELLIDO2_RESPONSABLE=Z.APELLIDO2,
	  DNI_RESPONSABLE=Z.DNI,
	  FECHA_DESDE=Z.FECHA_DESDE,
	  FECHA_MODIFICACION=current_timestamp,
	  USUARIO_MODIFICACION=current_user;
  COMMIT;
  /* Se insertan los registros nuevos */
  INSERT INTO MAESTROS.DIM_ZONA (COD_ZONA, DESC_ZONA, COD_RESPONSABLE, NOMBRE_RESPONSABLE, APELLIDO1_RESPONSABLE, APELLIDO2_RESPONSABLE, DNI_RESPONSABLE, FECHA_DESDE, FECHA_ALTA, USUARIO_ALTA)
    SELECT Z.ID_ZONA, Z.DESCRIPCION, Z.ID_RESPONSABLE, Z.NOMBRE, Z.APELLIDO1, Z.APELLIDO2, Z.DNI, Z.FECHA_DESDE, current_timestamp, current_user
    FROM temp_zona_resp Z
    LEFT JOIN MAESTROS.DIM_ZONA DZ
    ON Z.ID_ZONA=DZ.COD_ZONA
    WHERE DZ.ID_ZONA IS NULL;
  COMMIT;
  
  /* ------------------ */
  /* Carga de DIM_MARCA */
  /* ------------------ */
  /* Se actualizan los registros que coinciden en la tabla operacional con la dimensión */
  UPDATE COMERCIAL.DIM_MARCA 
  INNER JOIN MARCA@operacional M
  ON COD_MARCA=M.ID_MARCA
  SET DESC_MARCA=M.DESCRIPCION,
	  FECHA_MODIFICACION=current_timestamp,
	  USUARIO_MODIFICACION=current_user;
  COMMIT;
  /* Se insertan los registros nuevos */
  INSERT INTO COMERCIAL.DIM_MARCA (COD_MARCA, DESC_MARCA, FECHA_ALTA, USUARIO_ALTA)
    SELECT M.ID_MARCA, M.DESCRIPCION, current_timestamp, current_user
    FROM MARCA@operacional M
    LEFT JOIN COMERCIAL.DIM_MARCA DM
    ON M.ID_MARCA=DM.COD_MARCA
    WHERE DM.ID_MARCA IS NULL;  
  COMMIT;
  
  /* -------------------------- */
  /* Carga de DIM_TIPO_PRODUCTO */
  /* -------------------------- */
  /* Se actualizan los registros que coinciden en la tabla operacional con la dimensión */
  UPDATE COMERCIAL.DIM_TIPO_PRODUCTO 
  INNER JOIN TIPO_PRODUCTO@operacional TP
  ON COD_TIPO_PRODUCTO=TP.ID_TIPO_PRODUCTO
  SET DESC_TIPO_PRODUCTO=TP.DESCRIPCION,
	  FECHA_MODIFICACION=current_timestamp,
	  USUARIO_MODIFICACION=current_user;
  COMMIT;
  /* Se insertan los registros nuevos */
  INSERT INTO COMERCIAL.DIM_TIPO_PRODUCTO (COD_TIPO_PRODUCTO, DESC_TIPO_PRODUCTO, FECHA_ALTA, USUARIO_ALTA)
    SELECT TP.ID_TIPO_PRODUCTO, TP.DESCRIPCION, current_timestamp, current_user
    FROM TIPO_PRODUCTO@operacional TP
    LEFT JOIN COMERCIAL.DIM_TIPO_PRODUCTO DTP
    ON TP.ID_TIPO_PRODUCTO=DTP.COD_TIPO_PRODUCTO
    WHERE DTP.ID_TIPO_PRODUCTO IS NULL;  
  COMMIT;
  
  /* --------------------- */
  /* Carga de DIM_ARTICULO */
  /* --------------------- */
  /* Se crea una tabla temporal con aquellos artículos que se han modificado desde la última carga */
  DECLARE fecha_desde_art datetime;
  SET @fecha_desde_art:= SELECT INICIO FROM STAGING.AUX_CARGA_DW WHERE ID_CARGA=1 AND FIN is not null ORDER BY ID_FECHA desc LIMIT 1;
  CREATE TEMPORARY TABLE temp_art_new (
  ID_ARTICULO int,
  DESCRIPCION varchar(50),
  ID_MODELO int,
  ID_COLOR int,
  ID_TALLA int);
  INSERT INTO temp_art_new (ID_ARTICULO, DESCRIPCION, ID_MODELO, ID_COLOR, ID_TALLA)
    SELECT ID_ARTICULO, DESCRIPCION, ID_MODELO, ID_COLOR, ID_TALLA 
	FROM ARTICULO@operacional 
	WHERE FECHA_ALTA=>@fecha_desde_art
	OR FECHA_MODIFICACION>=@fecha_desde_art;

  /* Se cruza la información de los artículos que figuran en la tabla temporal con las tablas operacionales de Modelo, Color y Talla, para obtener sus descripciones */
  CREATE TEMPORARY TABLE temp_art_m_c_t (
  ID_ARTICULO int,
  DESC_ARTICULO varchar(50),
  ID_MODELO int,
  DESC_MODELO varchar(50),
  ID_COLOR int,
  DESC_COLOR varchar(20),
  ID_TALLA int,
  DESC_TALLA varchar(20)
  ); 
  INSERT INTO temp_art_m_c_t (ID_ARTICULO, DESC_ARTICULO, ID_MODELO, DESC_MODELO, ID_COLOR, DESC_COLOR, ID_TALLA, DESC_TALLA)
    SELECT A.ID_ARTICULO, A.DESCRIPCION, A.ID_MODELO, M.DESCRIPCION, A.ID_COLOR, C.DESCRIPCION, A.ID_TALLA, T.DESCRIPCION
	FROM temp_art_new A
	INNER JOIN MODELO@operacional M ON A.ID_MODELO=M.ID_MODELO
	INNER JOIN COLOR@operacional C ON A.ID_COLOR=C.ID_COLOR
	INNER JOIN TALLA@operacional T ON A.ID_TALLA=T.ID_TALLA;

  /* Se actualizan los registros que coinciden en la tabla operacional con la temporal */
  UPDATE COMERCIAL.DIM_ARTICULO 
  INNER JOIN temp_art_m_c_t A
  ON COD_ARTICULO=A.ID_ARTICULO
  SET DESC_ARTICULO=A.DESCRIPCION,
      COD_MODELO=A.ID_MODELO,
	  DESC_MODELO=A.DESC_MODELO,
	  COD_COLOR=A.ID_COLOR,
	  DESC_COLOR=A.DESC_COLOR,
	  COD_TALLA=A.ID_TALLA,
	  DESC_TALLA=A.DESC_TALLA,
	  FECHA_MODIFICACION=current_timestamp,
	  USUARIO_MODIFICACION=current_user;
  COMMIT;
  /* Se insertan los registros nuevos */
  INSERT INTO COMERCIAL.DIM_ARTICULO (COD_ARTICULO, DESC_ARTICULO, COD_MODELO, DESC_MODELO, COD_COLOR, DESC_COLOR, COD_TALLA, DESC_TALLA, FECHA_ALTA, USUARIO_ALTA)
    SELECT A.ID_ARTICULO, A.DESCRIPCION, A.ID_MODELO, A.DESC_MODELO, A.ID_COLOR, A.DESC_COLOR, A.ID_TALLA, A.DESC_TALLA, current_timestamp, current_user
    FROM temp_art_m_c_t A
    LEFT JOIN COMERCIAL.DIM_ARTICULO DA
    ON A.ID_ARTICULO=DA.COD_ARTICULO
    WHERE DA.ID_ARTICULO IS NULL;
  COMMIT;  
  
  /* -------------------- */
  /* Carga de DIM_SECCION */
  /* -------------------- */
  /* Se actualizan los registros que coinciden en la tabla operacional con la dimensión */
  UPDATE COMERCIAL.DIM_SECCION 
  INNER JOIN SECCION@operacional S
  ON COD_SECCION=S.ID_SECCION
  SET DESC_SECCION=S.DESCRIPCION,
	  FECHA_MODIFICACION=current_timestamp,
	  USUARIO_MODIFICACION=current_user;
  COMMIT;
  /* Se insertan los registros nuevos */
  INSERT INTO COMERCIAL.DIM_SECCION (COD_SECCION, DESC_SECCION, FECHA_ALTA, USUARIO_ALTA)
    SELECT S.ID_SECCION, S.DESCRIPCION, current_timestamp, current_user
    FROM SECCION@operacional S
    LEFT JOIN COMERCIAL.DIM_SECCION DS
    ON S.ID_SECCION=DS.COD_SECCION
    WHERE DS.ID_SECCION IS NULL;   
  COMMIT;
  
  /* -------------------- */
  /* Carga de DIM_CAMPANA */
  /* -------------------- */
  /* Se crea una tabla temporal con la información de Campaña y Tipo Campaña del operacional */
  CREATE TEMPORARY TABLE temp_camp_tcamp (
  ID_CAMPANA int,
  DESC_CAMPANA varchar(5), 
  ID_TIPO_CAMPANA int,
  DESC_TIPO_CAMPANA varchar(20),
  ANO_CAMPANA int);
  INSERT INTO temp_camp_tcamp (ID_CAMPANA, DESC_CAMPANA, ID_TIPO_CAMPANA, DESC_TIPO_CAMPANA, ANO_CAMPANA)
    SELECT C.ID_CAMPANA, C.DESCRIPCION, C.ID_TIPO_CAMPANA, TC.DESCRIPCION, CAST(SUBSTRING(TC.DESCRIPCION,2,4) AS INT)
	FROM CAMPANA@operacional C
	INNER JOIN TIPO_CAMPANA@operacional TC
	ON C.ID_TIPO_CAMPANA=TC.ID_TIPO_CAMPANA;
	
  /* Se actualizan los registros que coinciden en la tabla operacional con la temporal */
  UPDATE COMERCIAL.DIM_CAMPANA 
  INNER JOIN temp_camp_tcamp T
  ON COD_CAMPANA=T.ID_CAMPANA
  SET DESC_CAMPANA=T.DESC_CAMPANA,
      COD_TIPO_CAMPANA=T.ID_TIPO_CAMPANA,
	  DESC_TIPO_CAMPANA=T.DESC_TIPO_CAMPANA,
	  ANO_CAMPANA=T.ANO_CAMPANA,
	  FECHA_MODIFICACION=current_timestamp,
	  USUARIO_MODIFICACION=current_user;
  COMMIT;
  /* Se insertan los registros nuevos */
  INSERT INTO COMERCIAL.DIM_CAMPANA (COD_CAMPANA, DESC_CAMPANA, COD_TIPO_CAMPANA, DESC_TIPO_CAMPANA, ANO_CAMPANA, FECHA_ALTA, USUARIO_ALTA)
    SELECT T.ID_CAMPANA, T.DESC_CAMPANA, T.ID_TIPO_CAMPANA, T.DESC_TIPO_CAMPANA, T.ANO_CAMPANA, current_timestamp, current_user
    FROM temp_camp_tcamp T
    LEFT JOIN COMERCIAL.DIM_CAMPANA DC
    ON T.ID_CAMPANA=DC.COD_CAMPANA
    WHERE DC.ID_CAMPANA IS NULL;   	
  COMMIT;
   
  /* -------------------- */
  /* Carga de DIM_PERIODO */
  /* -------------------- */
  /* Se actualizan los registros que coinciden en la tabla operacional con la dimensión */
  UPDATE COMERCIAL.DIM_PERIODO 
  INNER JOIN PERIODO@operacional P
  ON COD_PERIODO=P.ID_PERIODO
  SET DESC_PERIODO=P.DESCRIPCION,
	  FECHA_MODIFICACION=current_timestamp,
	  USUARIO_MODIFICACION=current_user;
  COMMIT;
  /* Se insertan los registros nuevos */
  INSERT INTO COMERCIAL.DIM_PERIODO (COD_PERIODO, DESC_PERIODO, FECHA_ALTA, USUARIO_ALTA)
    SELECT P.ID_PERIODO, P.DESCRIPCION, current_timestamp, current_user
    FROM PERIODO@operacional P
    LEFT JOIN COMERCIAL.DIM_PERIODO DP
    ON P.ID_PERIODO=DP.COD_PERIODO
    WHERE DP.ID_PERIODO IS NULL;
  COMMIT;
  
END;