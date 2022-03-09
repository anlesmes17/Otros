WITH
  AVERIAS AS(
  SELECT
    NODO,
    EXTRACT( MONTH
    FROM
      CAST(LEFT(Fecha_inicio,10) AS DATE)) AS MES,
    Ticket_ID,
    Clientes_Afectados
  FROM
    `gcp-bia-tmps-vtr-dev-01.gcp_temp_cr_dev_01.2022-01-13_CR_AVERIAS_NODOS_2020-12_A_2021-12_T`
  WHERE
    Ticket_Type IS NOT NULL
    AND (Ticket_Type ="Averia Planta Externa"
      OR Ticket_Type ="Averia Fibra")
  GROUP BY
    1,
    2,
    3,
    4 ),
  GEOUSUARIOS AS (
  SELECT
    ID_NODO,
    PROVINCIA,
    Cant__n,
    DISTRITO,
    CANTIDAD_DE_USUARIOS
  FROM
    `gcp-bia-tmps-vtr-dev-01.gcp_temp_cr_dev_01.2022-02-28_ACCESO_GEO_D`
  GROUP BY
    1,
    2,
    3,
    4,
    5),
  USUARIOSAVERIAS AS(
  SELECT
    a.NODO,
    a.MES,
    a.Ticket_ID,
    A.Clientes_Afectados,
    g.ID_NODO,
    g.PROVINCIA,
    g.Cant__n,
    g.DISTRITO,
    g.CANTIDAD_DE_USUARIOS
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
    9),
  TABLAFINAL AS(
  SELECT
    DISTINCT MES,
    Ticket_iD,
    NODO,
    PROVINCIA,
    Cant__n,
    DISTRITO,
    CANTIDAD_DE_USUARIOS,
    Clientes_Afectados
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
    8)
SELECT
  Ticket_ID,
  MES,
  NODO,
  PROVINCIA,
  Cant__n,
  DISTRITO,
  CANTIDAD_DE_USUARIOS,
  Clientes_Afectados
FROM
  TABLAFINAL
ORDER BY
  MES
