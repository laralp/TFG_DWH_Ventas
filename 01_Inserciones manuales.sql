/* --------------------------------------------------------------- */
/* INSERCIONES EN TABLAS DE DIMENSIÓN QUE SE ALIMENTAN MANUALMENTE */
/* --------------------------------------------------------------- */

/* MAESTROS.DIM_MES */
insert into MAESTROS.DIM_MES (ID_MES, DESC_MES, FECHA_ALTA, USUARIO_ALTA) values (1, 'Enero', current_timestamp, current_user);
insert into MAESTROS.DIM_MES (ID_MES, DESC_MES, FECHA_ALTA, USUARIO_ALTA) values (2, 'Febrero', current_timestamp, current_user);
insert into MAESTROS.DIM_MES (ID_MES, DESC_MES, FECHA_ALTA, USUARIO_ALTA) values (3, 'Marzo', current_timestamp, current_user);
insert into MAESTROS.DIM_MES (ID_MES, DESC_MES, FECHA_ALTA, USUARIO_ALTA) values (4, 'Abril', current_timestamp, current_user);
insert into MAESTROS.DIM_MES (ID_MES, DESC_MES, FECHA_ALTA, USUARIO_ALTA) values (5, 'Mayo', current_timestamp, current_user);
insert into MAESTROS.DIM_MES (ID_MES, DESC_MES, FECHA_ALTA, USUARIO_ALTA) values (6, 'Junio', current_timestamp, current_user);
insert into MAESTROS.DIM_MES (ID_MES, DESC_MES, FECHA_ALTA, USUARIO_ALTA) values (7, 'Julio', current_timestamp, current_user);
insert into MAESTROS.DIM_MES (ID_MES, DESC_MES, FECHA_ALTA, USUARIO_ALTA) values (8, 'Agosto', current_timestamp, current_user);
insert into MAESTROS.DIM_MES (ID_MES, DESC_MES, FECHA_ALTA, USUARIO_ALTA) values (9, 'Septiembre', current_timestamp, current_user);
insert into MAESTROS.DIM_MES (ID_MES, DESC_MES, FECHA_ALTA, USUARIO_ALTA) values (10, 'Octubre', current_timestamp, current_user);
insert into MAESTROS.DIM_MES (ID_MES, DESC_MES, FECHA_ALTA, USUARIO_ALTA) values (11, 'Noviembre', current_timestamp, current_user);
insert into MAESTROS.DIM_MES (ID_MES, DESC_MES, FECHA_ALTA, USUARIO_ALTA) values (12, 'Diciembre', current_timestamp, current_user);

/* MAESTROS.DIM_TRIMESTRE */
insert into MAESTROS.DIM_TRIMESTRE (ID_TRIMESTRE, DESC_TRIMESTRE, FECHA_ALTA, USUARIO_ALTA) values (1, 'Primer trimestre', current_timestamp, current_user);
insert into MAESTROS.DIM_TRIMESTRE (ID_TRIMESTRE, DESC_TRIMESTRE, FECHA_ALTA, USUARIO_ALTA) values (2, 'Segundo trimestre', current_timestamp, current_user);
insert into MAESTROS.DIM_TRIMESTRE (ID_TRIMESTRE, DESC_TRIMESTRE, FECHA_ALTA, USUARIO_ALTA) values (3, 'Tercer trimestre', current_timestamp, current_user);
insert into MAESTROS.DIM_TRIMESTRE (ID_TRIMESTRE, DESC_TRIMESTRE, FECHA_ALTA, USUARIO_ALTA) values (4, 'Cuarto trimestre', current_timestamp, current_user);

/* MAESTROS.DIM_SEMESTRE */
insert into MAESTROS.DIM_SEMESTRE (ID_SEMESTRE, DESC_SEMESTRE, FECHA_ALTA, USUARIO_ALTA) values (1, 'Primer semestre', current_timestamp, current_user);
insert into MAESTROS.DIM_SEMESTRE (ID_SEMESTRE, DESC_SEMESTRE, FECHA_ALTA, USUARIO_ALTA) values (2, 'Segundo semestre', current_timestamp, current_user);

/* ------------------------------------------------------ */
/* INSERCIONES DE VALORES GENÉRICOS EN TABLAS DE DIMENSIÓN */
/* ------------------------------------------------------ */

/* Valores genéricos de MAESTROS.DIM_TIENDA) */
insert into MAESTROS.DIM_TIENDA (ID_TIENDA, DESC_TIENDA, FECHA_ALTA, USUARIO_ALTA) values (0, 'No documentado', current_timestamp, current_user);
insert into MAESTROS.DIM_TIENDA (ID_TIENDA, DESC_TIENDA, FECHA_ALTA, USUARIO_ALTA) values (-1, 'No existe', current_timestamp, current_user);

/* Valores genéricos de MAESTROS.DIM_PROVINCIA) */
insert into MAESTROS.DIM_PROVINCIA (ID_PROVINCIA, DESC_PROVINCIA, FECHA_ALTA, USUARIO_ALTA) values (0, 'No documentado', current_timestamp, current_user);
insert into MAESTROS.DIM_PROVINCIA (ID_PROVINCIA, DESC_PROVINCIA, FECHA_ALTA, USUARIO_ALTA) values (-1, 'No existe', current_timestamp, current_user);

/* Valores genéricos de MAESTROS.DIM_PAIS) */
insert into MAESTROS.DIM_PAIS (ID_PAIS, DESC_PAIS, FECHA_ALTA, USUARIO_ALTA) values (0, 'No documentado', current_timestamp, current_user);
insert into MAESTROS.DIM_PAIS (ID_PAIS, DESC_PAIS, FECHA_ALTA, USUARIO_ALTA) values (-1, 'No existe', current_timestamp, current_user);

/* Valores genéricos de MAESTROS.DIM_ZONA) */
insert into MAESTROS.DIM_ZONA (ID_ZONA, DESC_ZONA, COD_RESPONSABLE, DESC_RESPONSABLE, FECHA_ALTA, USUARIO_ALTA) values (0, 'No documentado', 0, 'No documentado', current_timestamp, current_user);
insert into MAESTROS.DIM_ZONA (ID_ZONA, DESC_ZONA, COD_RESPONSABLE, DESC_RESPONSABLE, FECHA_ALTA, USUARIO_ALTA) values (-1, 'No existe', -1, 'No existe', current_timestamp, current_user);

/* Valores genéricos de MAESTROS.DIM_PERIODO) */
insert into MAESTROS.DIM_PERIODO (ID_PERIODO, DESC_PERIODO, FECHA_ALTA, USUARIO_ALTA) values (0, 'No documentado', current_timestamp, current_user);
insert into MAESTROS.DIM_PERIODO (ID_PERIODO, DESC_PERIODO, FECHA_ALTA, USUARIO_ALTA) values (-1, 'No existe', current_timestamp, current_user);

/* Valores genéricos de MAESTROS.DIM_CAMPANA) */
insert into MAESTROS.DIM_CAMPANA (ID_CAMPANA, DESC_CAMPANA, COD_TIPO_CAMPANA, DESC_TIPO_CAMPANA, FECHA_ALTA, USUARIO_ALTA) values (0, 'No documentado', 0, 'No documentado', current_timestamp, current_user);
insert into MAESTROS.DIM_CAMPANA (ID_CAMPANA, DESC_CAMPANA, COD_TIPO_CAMPANA, DESC_TIPO_CAMPANA, FECHA_ALTA, USUARIO_ALTA) values (-1, 'No existe', -1, 'No existe', current_timestamp, current_user);

/* Valores genéricos de MAESTROS.DIM_SECCION) */
insert into MAESTROS.DIM_SECCION (ID_SECCION, DESC_SECCION, FECHA_ALTA, USUARIO_ALTA) values (0, 'No documentado', current_timestamp, current_user);
insert into MAESTROS.DIM_SECCION (ID_SECCION, DESC_SECCION, FECHA_ALTA, USUARIO_ALTA) values (-1, 'No existe', current_timestamp, current_user);

/* Valores genéricos de MAESTROS.DIM_ARTICULO) */
insert into MAESTROS.DIM_ARTICULO (ID_ARTICULO, DESC_ARTICULO, COD_MODELO, DESC_MODELO, COD_COLOR, DESC_COLOR, COD_TALLA, DESC_TALLA, FECHA_ALTA, USUARIO_ALTA) values (0, 'No documentado', 0, 'No documentado', 0, 'No documentado', 0, 'No documentado', current_timestamp, current_user);
insert into MAESTROS.DIM_ARTICULO (ID_ARTICULO, DESC_ARTICULO, COD_MODELO, DESC_MODELO, COD_COLOR, DESC_COLOR, COD_TALLA, DESC_TALLA, FECHA_ALTA, USUARIO_ALTA) values (-1, 'No existe', -1, 'No existe', -1, 'No existe', -1, 'No existe', current_timestamp, current_user);

/* Valores genéricos de MAESTROS.DIM_TIPO_PRODUCTO) */
insert into MAESTROS.DIM_TIPO_PRODUCTO (ID_TIPO_PRODUCTO, DESC_TIPO_PRODUCTO, FECHA_ALTA, USUARIO_ALTA) values (0, 'No documentado', current_timestamp, current_user);
insert into MAESTROS.DIM_TIPO_PRODUCTO (ID_TIPO_PRODUCTO, DESC_TIPO_PRODUCTO, FECHA_ALTA, USUARIO_ALTA) values (-1, 'No existe', current_timestamp, current_user);

/* Valores genéricos de MAESTROS.DIM_MARCA) */
insert into MAESTROS.DIM_MARCA (ID_MARCA, DESC_MARCA, FECHA_ALTA, USUARIO_ALTA) values (0, 'No documentado', current_timestamp, current_user);
insert into MAESTROS.DIM_MARCA (ID_MARCA, DESC_MARCA, FECHA_ALTA, USUARIO_ALTA) values (-1, 'No existe', current_timestamp, current_user);

commit;