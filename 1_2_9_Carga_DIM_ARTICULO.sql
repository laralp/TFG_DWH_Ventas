CREATE PROCEDURE 1_2_9_Carga_DIM_ARTICULO ()
BEGIN
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
END;