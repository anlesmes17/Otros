WITH
  AVERIAS AS(
  SELECT
  FECHA_DE_INICIO,
  FECHA_DE_FINAL,
    NODO,
    EXTRACT( MONTH
    FROM
      FECHA_DE_INICIO) AS MES,
      EXTRACT( HOUR FROM FECHA_DE_INICIO) AS HORA,
    Ticket_ID,
    Clientes_Afectados,
    DIFERENCIA_FECHAS_HORAS
  FROM
    `gcp-bia-tmps-vtr-dev-01.gcp_temp_cr_dev_01.2022-02-07_CR_AVERIAS_NODOS_2020-12_A_2021-12_D`
  WHERE
    Ticket_Type IS NOT NULL
    AND (Ticket_Type ="Averia Planta Externa"
      OR Ticket_Type ="Averia Fibra")
      AND NOT (EXTRACT( HOUR FROM FECHA_DE_INICIO)=22 AND DIFERENCIA_FECHAS_HORAS <=8)
      AND NOT (EXTRACT( HOUR FROM FECHA_DE_INICIO)=23 AND DIFERENCIA_FECHAS_HORAS <=7)
      AND NOT (EXTRACT( HOUR FROM FECHA_DE_INICIO)=0 AND DIFERENCIA_FECHAS_HORAS <=6)
      AND NOT (EXTRACT( HOUR FROM FECHA_DE_INICIO)=1 AND DIFERENCIA_FECHAS_HORAS <=5)
      AND NOT (EXTRACT( HOUR FROM FECHA_DE_INICIO)=2 AND DIFERENCIA_FECHAS_HORAS <=4)
      AND NOT (EXTRACT( HOUR FROM FECHA_DE_INICIO)=3 AND DIFERENCIA_FECHAS_HORAS <=3)
      AND NOT (EXTRACT( HOUR FROM FECHA_DE_INICIO)=4 AND DIFERENCIA_FECHAS_HORAS <=2)
      AND NOT (EXTRACT( HOUR FROM FECHA_DE_INICIO)=5 AND DIFERENCIA_FECHAS_HORAS <=1)
      AND DIFERENCIA_FECHAS_HORAS IS NOT NULL
  GROUP BY
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8 ),
  GEOUSUARIOS AS (
  SELECT
    ID_NODO,
    PROVINCIA,
    Cant__n,
    DISTRITO,
    Latitud,
    Longitud,
    CANTIDAD_DE_USUARIOS
  FROM
    `gcp-bia-tmps-vtr-dev-01.gcp_temp_cr_dev_01.2022-02-28_ACCESO_GEO_D`
  GROUP BY
    1,
    2,
    3,
    4,
    5,
    6,
    7),
  USUARIOSAVERIAS AS(
  SELECT
    a.NODO,
    a.FECHA_DE_INICIO,
    a.FECHA_DE_FINAL,
    a.MES,
    a.Ticket_ID,
    A.Clientes_Afectados,
    a.DIFERENCIA_FECHAS_HORAS,
    g.ID_NODO,
    g.PROVINCIA,
    g.Cant__n,
    g.DISTRITO,
    g.CANTIDAD_DE_USUARIOS,
    g.Latitud,
    g.Longitud
  FROM
    AVERIAS a
  LEFT JOIN
    GEOUSUARIOS g
  ON
    a.NODO = g.ID_NODO
  GROUP BY
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14),
  TABLAFINAL AS(
  SELECT
    DISTINCT MES,
    Ticket_iD,
    FECHA_DE_INICIO,
    FECHA_DE_FINAL,
    NODO,
    PROVINCIA,
    Cant__n,
    DISTRITO,
    CANTIDAD_DE_USUARIOS,
    Clientes_Afectados,
    DIFERENCIA_FECHAS_HORAS,
    latitud,
    longitud
  FROM
    USUARIOSAVERIAS
  GROUP BY
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13)
SELECT
  Ticket_ID,
  MES,
  FECHA_DE_INICIO,
  FECHA_DE_FINAL,
  Latitud,
  longitud,
  NODO,
  PROVINCIA,
  Cant__n,
  DISTRITO,
  CANTIDAD_DE_USUARIOS,
  Clientes_Afectados,
  DIFERENCIA_FECHAS_HORAS
FROM
  TABLAFINAL
ORDER BY
  MES
