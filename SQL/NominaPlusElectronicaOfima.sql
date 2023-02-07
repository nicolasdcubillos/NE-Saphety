USE AJOVECO_NE

DROP FUNCTION [dbo].[X_NOMINAELECTRONICAG]
DROP FUNCTION [dbo].[X_EMPLEADODEVDED]
DROP VIEW [dbo].[V_CONSULTAGLOBAL]
DROP FUNCTION [dbo].[X_MEDIOELECTRONICONE]
DROP FUNCTION [dbo].[X_DETALLEEMPLEADOSNE]
DROP FUNCTION [dbo].[X_REPORTENOMINAELECTRONICA]
DROP FUNCTION [dbo].[X_CALCULODIFERENCIADIAS]

GO

-- FUNCIÓN X_CALCULODIFERENCIADIAS(FECHAINICIAL, FECHAFINAL, AÑO, PERIODO)

-- ESTA FUNCIÓN CALCULA LOS DÍAS QUE HAY DENTRO DE UN MES, DADO UN RANGO DE 
-- FECHA INICIAL Y FECHA FINAL.

-- SELECT dbo.X_CALCULODIFERENCIADIAS(CONVERT(date,CONVERT(varchar(50),('2020'*10000 + '01'*100 + '16')),112), CONVERT(date,CONVERT(varchar(50),('2020'*10000 + '03'*100 + '15')),112), '2020', '01')

CREATE FUNCTION [dbo].[X_CALCULODIFERENCIADIAS]
(
@fechainicial date,
@fechafinal date,
@pano int,
@pperiodo int
)
Returns int
as
BEGIN

DECLARE @fechafinalperiodo date
DECLARE @fechainicialperiodo date
DECLARE @fechaperiodo date

SET @fechaperiodo = CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '15')),112)
SET @fechafinalperiodo = EOMONTH(@fechaperiodo)
SET @fechainicialperiodo = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@fechaperiodo)-1),@fechaperiodo),101)

IF @fechainicial < @fechainicialperiodo
SET @fechainicial = @fechainicialperiodo

IF @fechafinal > @fechafinalperiodo
SET @fechafinal = @fechafinalperiodo

RETURN DATEDIFF(DAY, @fechainicial, @fechafinal)

END

-- FUNCIÓN X_EMPLEADODEVDED(AÑO, PERIODO)
-- RETORNA EL DEVENGADO, DEDUCIDO Y TOTAL DE TODOS LOS EMPLEADOS EN UN PERIODO.

--SELECT * FROM X_EMPLEADODEVDED(2021, 1)
GO

CREATE FUNCTION [dbo].[X_EMPLEADODEVDED]
(
@pano int,
@pperiodo int
)
Returns Table
as
Return
(
SELECT TIPODCTO, NRODCTO, SUM(DEVENGADO) DEVENGADO, SUM(ABS(DEDUCIDO)) DEDUCIDO, SUM(DEVENGADO) - SUM(ABS(DEDUCIDO)) TOTAL
FROM 
(
SELECT
MTLIQ.TIPODCTO,
MTLIQ.NRODCTO,
CASE WHEN MTCON.DEVDED = 'S' THEN MVLIQ.VALOR ELSE 0 END DEVENGADO,
CASE WHEN MTCON.DEVDED = 'N' THEN MVLIQ.VALOR ELSE 0 END DEDUCIDO
--MTCON.DESCRIPCIO,
--MTCON.DEVDED,
--SUM (MVLIQ.VALOR),
FROM 
MVLIQNOMNE AS MVLIQ,
MTLIQNOMNE AS MTLIQ,
MTCONCEP AS MTCON
WHERE
MVLIQ.TIPODCTO = MTLIQ.TIPODCTO AND
MVLIQ.NRODCTO = MTLIQ.NRODCTO AND
MTCON.CONCEP = MVLIQ.CONCEP AND
MTLIQ.PERIODO = @pperiodo AND
MTLIQ.ANO = @pano
) DEVDED
GROUP BY TIPODCTO, NRODCTO
)
GO
-- FUNCIÓN X_NOMINAELECTRONICAG(AÑO, PERIODO)
-- RETORNA LOS EMPLEADOS CON NÓMINA CARGADA EN MTLIQNOMNE PARA UN PERIODO DETERMINADO

--SELECT * FROM (SELECT * FROM X_NOMINAELECTRONICAG(2021,2)) P
--WHERE S_GRUPO IN ('01', '02')

CREATE FUNCTION [dbo].[X_NOMINAELECTRONICAG]
(
@pano int,
@pperiodo int
)
Returns Table
As
Return (
SELECT
1 CHKENVIOS,
MTLIQ.ANO S_AÑO,
MTLIQ.PERIODO S_PERIODO,
RTRIM(MTEM.NOMBRE) + ' ' + RTRIM(MTEM.NOMBRE2) + ' ' + RTRIM(MTEM.APELLIDO) + ' ' + RTRIM(MTEM.APELLIDO2) S_NOMBRE,
MTEM.CEDULA S_CEDULA,
MTLIQ.CODIGO S_CODIGO,
X_DEVDED.DEVENGADO S_DEVENGADOS,
X_DEVDED.DEDUCIDO S_DEDUCCIONES,
-- Sumar por devengado validando desde mtconcep
SUM(MVLIQ.VALOR) S_TOTAL,
RTRIM(MTLIQ.TIPODCTO) S_TIPODCTO, 
MTLIQ.NRODCTO S_NRODCTO,
MTLIQ.GRUPO S_GRUPO
FROM
MTEMPLEA AS MTEM, 
MTLIQNOMNE AS MTLIQ,
MVLIQNOMNE AS MVLIQ,
MTCONCEP AS MTCON,
X_EMPLEADODEVDED (@pano, @pperiodo) AS X_DEVDED
WHERE
MTEM.CODIGO = MTLIQ.CODIGO AND
MVLIQ.TIPODCTO = MTLIQ.TIPODCTO AND
MVLIQ.NRODCTO = MTLIQ.NRODCTO AND
MVLIQ.CONCEP = MTCON.CONCEP AND
MTLIQ.ANO = @pano AND
MTLIQ.PERIODO = @pperiodo AND
MTLIQ.NECUNE IN ('', NULL) AND
X_DEVDED.TIPODCTO = MTLIQ.TIPODCTO AND
X_DEVDED.NRODCTO = MVLIQ.NRODCTO
GROUP BY
MTLIQ.ANO, 
MTLIQ.PERIODO, RTRIM(MTEM.NOMBRE) + ' ' + RTRIM(MTEM.NOMBRE2) + ' ' + RTRIM(MTEM.APELLIDO) + ' ' + RTRIM(MTEM.APELLIDO2), 
MTEM.CEDULA,
MTLIQ.CODIGO, 
MTLIQ.TIPODCTO,
MTLIQ.NRODCTO,
MTLIQ.GRUPO,
X_DEVDED.DEVENGADO,
X_DEVDED.DEDUCIDO
)
GO

-- VEW V_CONSULTAGLOBAL
-- VISTA PARA CARGAR LAS CREDENCIALES DESDE MTGLOBAL.
--SELECT * FROM V_CONSULTAGLOBAL


CREATE VIEW V_CONSULTAGLOBAL AS (
	SELECT
	MT1.VALOR S_NITCIA, 
	MT2.VALOR S_PAIS,
	MT3.VALOR S_NOMCIA,
	MT4.VALOR S_DIRECCION,
	'4.00' S_PORCENTAJEPENSION,
	'4.00' S_PORCENTAJESALUD
	FROM 
	MTGLOBAL MT1,
	MTGLOBAL MT2,
	MTGLOBAL MT3,
	MTGLOBAL MT4
	WHERE 
	MT1.CAMPO = 'NITCIA' AND
	MT2.CAMPO = 'PAIS' AND
	MT3.CAMPO = 'NOMCIA' AND
	MT4.CAMPO = 'CABELN1'
)

GO
-- FUNCIÓN X_MEDIOELECTRONICONE(AÑO, PERIODO)
-- RETORNA EL ENCABEZADO DE UN EMPLEADO PARA GENERAR EL MEDIO ELECTRÓNICO XML CARVAJAL.
-- INFORMACIÓN QUE SÓLO SE REPITE UNA VEZ EN EL MEDIO ELECTRÓNICO.
	
-- SELECT * FROM X_MEDIOELECTRONICONE(2021, 1)
--SELECT * FROM MVLIQNOMNE WHERE NRODCTO = '1543' ORDER BY VALOR DESC


CREATE FUNCTION [dbo].[X_MEDIOELECTRONICONE] -- REVISAR PORQUE SE CRUZA CON MVCERRAD
(
@pano int,
@pperiodo int
)
Returns Table
as
Return
(
SELECT
MTLIQ.TIPODCTO S_TIPODCTO,
MTLIQ.NRODCTO S_NRODCTO,
RTRIM(MTLIQ.TIPODCTO) + RTRIM(MTLIQ.NRODCTO) S_CONSECUT,
MTLIQ.CODIGO S_CODIGO,
CAST(FORMAT(MTEM.FECING, 'yyyy-MM-dd') AS CHAR) S_FECHAING,
CAST(FORMAT(MTEM.FECRETIRO, 'yyyy-MM-dd') AS CHAR) S_FECRETIRO,
CAST(FORMAT(GETDATE(), 'yyyy-MM-ddTHH:MM:ss') AS CHAR) S_FECGEN,
MTLIQ.ANO S_ANO,
MTLIQ.PERIODO S_PERIODO,
CAST(FORMAT(MIN(MTL.FECINI), 'yyyy-MM-dd') AS CHAR) S_FECINI,
CAST(FORMAT(MAX(MTL.FECFIN), 'yyyy-MM-dd') AS CHAR) S_FECFIN,
DATEDIFF(DAY, MTEM.FECING, MAX(MTL.FECFIN)) S_TIEMPOLAB,
SUBSTRING(MTEM.CDCIIU,1,2) S_DPTO,
MTEM.CDCIIU S_MCPIO,
CASE
WHEN MTGR.PERIODO = '7' THEN '1'
WHEN MTGR.PERIODO = '10' THEN '2'
WHEN MTGR.PERIODO = '14' THEN '3'
WHEN MTGR.PERIODO = '15' THEN '4'
WHEN MTGR.PERIODO = '30' THEN '5'
ELSE '6'
END S_PERIODOPAGO,
CASE WHEN MTEM.TIPDOC = '' THEN '13' ELSE MTEM.TIPDOC END S_TIPDOC,
MTEM.CEDULA S_CEDULA,
CASE WHEN MTEM.PAIS = '169' THEN 'CO' ELSE '0' END S_PAIS,
MTEM.APELLIDO S_APELLIDO,
MTEM.APELLIDO2 S_APELLIDO2,
MTEM.NOMBRE S_NOMBRE,
MTEM.NOMBRE2 S_NOMBRE2,
MTEM.DIRECCION S_DIRECCION,
CASE WHEN MTEM.SALINTEGR = 'N' THEN 'false ' ELSE 'true ' END S_SALARIOINTEG,
CASE WHEN MTEM.TIPCONTRA = 'FIJO' THEN 1 
WHEN MTEM.TIPCONTRA = 'INDEF' THEN 2 
WHEN MTEM.TIPCONTRA = 'OBRA' THEN 3
WHEN MTEM.TIPCONTRA = 'XDIAS' THEN 0 END S_TIPCONTRA, -- Tabla 5
CAST((MTEM.VALORHORA * MTEM.HORASMES) AS DECIMAL(10,2)) S_SUELDO,
CASE WHEN MTBAN.BANCO <> '99' THEN MTBAN.NOMBRE ELSE '' END S_BANCO, -- Si es pago con cheque, no pasa el nombre del banco.
CASE WHEN MTEM.TIPOCUENTA = '0' THEN 'AHORROS' ELSE 'CORRIENTE' END S_TIPOCUENTA,
MTEM.CTACTE S_CTACTE,
--MTLIQ.DIASPAGO S_DIASPAG,
CAST(ISNULL((SELECT SUM(MVLIQ.NROHORAS)/8 FROM MVLIQNOMNE MVLIQ WHERE MTLIQ.NRODCTO = MVLIQ.NRODCTO AND MTLIQ.TIPODCTO = MVLIQ.TIPODCTO AND MVLIQ.CONCEP IN (SELECT CONCEP FROM MTCONCEP WHERE NECONCDIAN IN ('101', '108')) GROUP BY MVLIQ.NRODCTO, MVLIQ.TIPODCTO), 0) -
ISNULL((
SELECT (CASE WHEN P.S_DIFERENCIADIAS > 30 THEN 30 ELSE P.S_DIFERENCIADIAS END) S_DIFERENCIADIAS FROM
(
SELECT SUM(S_DIFERENCIADIAS) S_DIFERENCIADIAS FROM (
SELECT CODIGO, LICNOREMU, dbo.X_CALCULODIFERENCIADIAS(MVFA.FECINI, MVFA.FECFIN, @pano, @pperiodo) + 1 S_DIFERENCIADIAS
FROM MVFALTA MVFA WHERE (EOMONTH((CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112))) BETWEEN MVFA.FECINI AND MVFA.FECFIN) OR (CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112) BETWEEN MVFA.FECINI AND MVFA.FECFIN) OR (MVFA.FECINI BETWEEN CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112) AND EOMONTH(CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112))) OR (MVFA.FECFIN BETWEEN CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112) AND EOMONTH(CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112)))
GROUP BY MVFA.CODIGO, MVFA.FECINI, MVFA.FECFIN, LICNOREMU
) T WHERE LICNOREMU = '1' AND T.CODIGO = MTLIQ.CODIGO GROUP BY CODIGO) P), 0) AS INT)
S_DIASPAG,
MTEM.TIPOCOTIZA S_TIPOEMPLEADO,
MTEM.MEDIOPAG S_METODOPAG,
CASE WHEN MTEM.PENSIONADO = 1 THEN '01' ELSE '00' END S_SUBTIPOEMPLEADO,/*
CASE WHEN (SELECT COUNT(*) FROM X_DETALLEEMPLEADOSNE (@pano, @pperiodo)
WHERE CODIGO = MTEM.CODIGO AND S_CONCEPDIAN = '202') > 0 THEN '4.00' ELSE '0.00' END S_PENSIONPORCENTAJE,
'0' S_PENSIONVALOR,
CASE WHEN (SELECT COUNT(*) FROM X_DETALLEEMPLEADOSNE (@pano, @pperiodo)
WHERE CODIGO = MTEM.CODIGO AND S_CONCEPDIAN = '201') > 0 THEN '4.00' ELSE '0.00' END S_SALUDPORCENTAJE,
'0' S_SALUDVALOR,*/
X_DEVDED.DEVENGADO S_DEVENGADOS,
X_DEVDED.DEDUCIDO S_DEDUCCIONES,
X_DEVDED.TOTAL S_TOTAL
FROM
MTLIQNOMNE AS MTLIQ,
MTEMPLEA AS MTEM,
MTLIQNOM AS MTL,
MTGRUPO AS MTGR,
MTBANEMP AS MTBAN,
(SELECT * FROM X_EMPLEADODEVDED(@pano, @pperiodo)) X_DEVDED
WHERE
MTLIQ.CODIGO = MTEM.CODIGO AND
MTLIQ.CODIGO = MTL.CODIGO AND
MTLIQ.GRUPO = MTGR.GRUPO AND
MTEM.BANCO = MTBAN.BANCO AND
MTLIQ.TIPODCTO = X_DEVDED.TIPODCTO AND
MTLIQ.NRODCTO = X_DEVDED.NRODCTO AND

MTLIQ.ANO = @pano AND
MTLIQ.PERIODO = @pperiodo AND
YEAR(MTL.FECINI) = @pano AND
MONTH(MTL.FECINI) = @pperiodo

GROUP BY 
MTLIQ.TIPODCTO, 
MTLIQ.NRODCTO, 
MTLIQ.CODIGO,
MTLIQ.ANO, 
MTLIQ.PERIODO,
MTEM.FECING,
MTEM.FECRETIRO,
MTEM.CDCIIU,
MTGR.PERIODO,
MTEM.TIPDOC,
MTEM.CEDULA,
MTEM.CODIGO,
MTEM.APELLIDO,
MTEM.APELLIDO2,
MTEM.NOMBRE,
MTEM.NOMBRE2,
MTEM.DIRECCION,
MTEM.SALINTEGR,
MTEM.TIPCONTRA,
MTEM.VALORHORA,
MTEM.HORASMES,
MTBAN.BANCO,
MTBAN.NOMBRE,
MTEM.TIPOCUENTA,
MTEM.CTACTE,
MTEM.MEDIOPAG,
--MTLIQ.DIASPAGO,
MTEM.TIPOCOTIZA,
MTEM.PENSIONADO,
MTEM.PAIS,
X_DEVDED.DEVENGADO,
X_DEVDED.DEDUCIDO,
X_DEVDED.TOTAL
--ORDER BY MTLIQ.NRODCTO
)

GO

-- FUNCIÓN X_DETALLEEMPLEADOSNE (AÑO, PERIODO)
-- RETORNA EL DETALLE DE TODOS LOS EMPLEADOS PARA UN AÑO Y PERIODO, DESDE MVLIQNOMNE Y LO CRUZA
-- CON CONCEPTOS DIAN.

-- SE USA PARA GENERAR EL REPORTE DESDE EL ERP Y VALIDAR QUE LA INFORMACIÓN GENERADA EN EL MEDIO
-- COINCIDA CON LA DE NÓMINA CERRADA PARA UN PERIODO.

GO

--SELECT * FROM MTLIQNOMNE WHERE CODIGO = '04932'
--UPDATE MTLIQNOMNE SET NETRANSACID = ''
--UPDATE MTLIQNOMNE SET NECUNE = ''

--SELECT * FROM LIBINCAP WHERE CODIGO =  ORDER BY FECINI DESC
-- CODIGO ERA 1505
--SELECT * FROM MTLIQNOMNE WHERE NRODCTO = 
--UPDATE MTLIQNOMNE SET NRODCTO = '1505' WHERE NRODCTO = '5678'
--UPDATE MVLIQNOMNE SET NRODCTO = '1505' WHERE NRODCTO = '5678'


--SELECT * FROM X_DETALLEEMPLEADOSNE (2022, 1)  WHERE NRODCTO = '3000000260' ORDER BY NRODCTO
--WHERE CODIGO = '1003914027-1'

CREATE FUNCTION [dbo].[X_DETALLEEMPLEADOSNE]
(
@pano int,
@pperiodo int
)
Returns Table
as
Return
(
SELECT
MTLIQ.ANO AÑO,
MTLIQ.PERIODO PERIODO,
RTRIM(MTEM.NOMBRE) + ' ' + RTRIM(MTEM.NOMBRE2) NOMBRE,
RTRIM(MTEM.APELLIDO) + ' ' +  RTRIM(MTEM.APELLIDO2) APELLIDO,
MTLIQ.TIPODCTO TIPODCTO, 
MTLIQ.NRODCTO NRODCTO,
MTLIQ.CODIGO CODIGO,
MVLIQ.CONCEP S_NUMCONCEP,
MTCON.DESCRIPCIO S_OFIMA_DESCRIPCION,
MTCON.NECONCDIAN S_CONCEPDIAN,
(SELECT DESCRIPCION FROM NE_CONCEPTOSDIAN NEDIAN WHERE NEDIAN.CODIGO = MTCON.NECONCDIAN) S_DIAN_DESCRIPCION,
ABS(MVLIQ.VALOR) S_VALOR,
CASE
WHEN MVLIQ.CONCEP IN (SELECT CONCEP FROM NE_CLASIFHORASEXTRAS) 
THEN (SELECT NECLASIF.TIPO + ' ' FROM NE_CLASIFHORASEXTRAS NECLASIF WHERE NECLASIF.CONCEP = MVLIQ.CONCEP)
ELSE 0
END S_TIPOHE,
ISNULL (
CASE
WHEN MVLIQ.CONCEP IN (SELECT MTCON.CONCEP FROM MTCONCEP MTCON WHERE MTCON.CONCEP = MVLIQ.CONCEP AND MTCON.NECONCDIAN = '106')  -- VACACIONES CONCEPTO DIAN
THEN (SELECT SUM(DATEDIFF(DAY, FECHAV, FECHAR)) FROM LIBROVAC WHERE YEAR(FECHAV) = @pano AND MONTH(FECHAV) = @pperiodo AND CODEMP = MTLIQ.CODIGO GROUP BY CODEMP)
WHEN MVLIQ.CONCEP IN (SELECT MTCON.CONCEP FROM MTCONCEP MTCON WHERE MTCON.CONCEP = MVLIQ.CONCEP AND MTCON.NECONCDIAN = '112') -- INCAPACIDADES CONCEPTO DIAN
THEN 
(
SELECT (CASE WHEN P.S_DIFERENCIADIAS > 30 THEN 30 ELSE P.S_DIFERENCIADIAS END) S_DIFERENCIADIAS FROM
(
SELECT SUM(S_DIFERENCIADIAS) S_DIFERENCIADIAS FROM (
SELECT LIBIN.CODIGO, LIBIN.TIPNOVEDAD, LIBIN.CONCEPTO, dbo.X_CALCULODIFERENCIADIAS(LIBIN.FECINI, LIBIN.FECFIN, @pano, @pperiodo) + 1 S_DIFERENCIADIAS
FROM LIBINCAP LIBIN WHERE (EOMONTH((CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112))) BETWEEN LIBIN.FECINI AND LIBIN.FECFIN) OR (CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112) BETWEEN LIBIN.FECINI AND LIBIN.FECFIN) OR  (LIBIN.FECINI BETWEEN CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112) AND EOMONTH(CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112))) OR (LIBIN.FECFIN BETWEEN CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112) AND EOMONTH(CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112)))
) T WHERE (TIPNOVEDAD <> 'MAT' OR T.CONCEPTO = '196') AND T.CODIGO = MTLIQ.CODIGO GROUP BY CODIGO) P
)
WHEN MVLIQ.CONCEP IN (SELECT MTCON.CONCEP FROM MTCONCEP MTCON WHERE MTCON.CONCEP = MVLIQ.CONCEP AND MTCON.NECONCDIAN = '113') -- MATERNIDAD CONCEPTO DIAN
THEN 
(
SELECT (CASE WHEN P.S_DIFERENCIADIAS > 30 THEN 30 ELSE P.S_DIFERENCIADIAS END) S_DIFERENCIADIAS FROM
(
SELECT SUM(S_DIFERENCIADIAS) S_DIFERENCIADIAS FROM (
SELECT LIBIN.CODIGO, LIBIN.TIPNOVEDAD, dbo.X_CALCULODIFERENCIADIAS(LIBIN.FECINI, LIBIN.FECFIN, @pano, @pperiodo) + 1 S_DIFERENCIADIAS
FROM LIBINCAP LIBIN WHERE (EOMONTH((CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112))) BETWEEN LIBIN.FECINI AND LIBIN.FECFIN) OR (CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112) BETWEEN LIBIN.FECINI AND LIBIN.FECFIN) OR (LIBIN.FECINI BETWEEN CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112) AND EOMONTH(CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112))) OR (LIBIN.FECFIN BETWEEN CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112) AND EOMONTH(CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112)))
GROUP BY LIBIN.CODIGO, LIBIN.FECINI, LIBIN.FECFIN, LIBIN.TIPNOVEDAD
) T WHERE TIPNOVEDAD = 'MAT' AND T.CODIGO = MTLIQ.CODIGO GROUP BY CODIGO) P
)
WHEN MVLIQ.CONCEP IN (SELECT MTCON.CONCEP FROM MTCONCEP MTCON WHERE MTCON.CONCEP = MVLIQ.CONCEP AND MTCON.NECONCDIAN = '114') -- LICENCIA REMUNERADA CONCEPTO DIAN
THEN  
(
SELECT (CASE WHEN P.S_DIFERENCIADIAS > 30 THEN 30 ELSE P.S_DIFERENCIADIAS END) S_DIFERENCIADIAS FROM
(
SELECT SUM(S_DIFERENCIADIAS) S_DIFERENCIADIAS FROM (
SELECT CODIGO, LICNOREMU, dbo.X_CALCULODIFERENCIADIAS(MVFA.FECINI, MVFA.FECFIN, @pano, @pperiodo) + 1 S_DIFERENCIADIAS
FROM MVFALTA MVFA WHERE (EOMONTH((CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112))) BETWEEN MVFA.FECINI AND MVFA.FECFIN) OR (CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112) BETWEEN MVFA.FECINI AND MVFA.FECFIN) OR (MVFA.FECINI BETWEEN CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112) AND EOMONTH(CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112))) OR (MVFA.FECFIN BETWEEN CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112) AND EOMONTH(CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112)))
GROUP BY MVFA.CODIGO, MVFA.FECINI, MVFA.FECFIN, LICNOREMU
) T WHERE LICNOREMU = '0' AND T.CODIGO = MTLIQ.CODIGO GROUP BY CODIGO) P
)
WHEN MVLIQ.CONCEP IN (SELECT MTCON.CONCEP FROM MTCONCEP MTCON WHERE MTCON.CONCEP = MVLIQ.CONCEP AND MTCON.NECONCDIAN = '210') -- LICENCIA NO REMUNERADA CONCEPTO DIAN
THEN 
(
SELECT (CASE WHEN P.S_DIFERENCIADIAS > 30 THEN 30 ELSE P.S_DIFERENCIADIAS END) S_DIFERENCIADIAS FROM
(
SELECT SUM(S_DIFERENCIADIAS) S_DIFERENCIADIAS FROM (
SELECT CODIGO, LICNOREMU, dbo.X_CALCULODIFERENCIADIAS(MVFA.FECINI, MVFA.FECFIN, @pano, @pperiodo) + 1 S_DIFERENCIADIAS
FROM MVFALTA MVFA WHERE (EOMONTH((CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112))) BETWEEN MVFA.FECINI AND MVFA.FECFIN) OR (CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112) BETWEEN MVFA.FECINI AND MVFA.FECFIN) OR (MVFA.FECINI BETWEEN CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112) AND EOMONTH(CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112))) OR (MVFA.FECFIN BETWEEN CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112) AND EOMONTH(CONVERT(date,CONVERT(varchar(50),(@pano*10000 + @pperiodo*100 + '01')),112)))
GROUP BY MVFA.CODIGO, MVFA.FECINI, MVFA.FECFIN, LICNOREMU
) T WHERE LICNOREMU = '1' AND T.CODIGO = MTLIQ.CODIGO GROUP BY CODIGO) P
)
ELSE MVLIQ.NROHORAS
END, 0) S_NROHORAS,
CASE
WHEN MVLIQ.CONCEP IN (SELECT CONCEP FROM NE_CLASIFHORASEXTRAS)
THEN (SELECT PORCENTAJE FROM NE_CLASIFHORASEXTRAS NECLASIF, NE_MTHORASEXTRAS NEMT WHERE NECLASIF.CONCEP = MVLIQ.CONCEP AND NECLASIF.TIPO = NEMT.CODIGO)
ELSE 0
END S_PORCENTAJEHE
FROM 
MTLIQNOMNE MTLIQ,
MVLIQNOMNE MVLIQ,
MTEMPLEA MTEM,
MTCONCEP MTCON
WHERE 
MTLIQ.TIPODCTO = MVLIQ.TIPODCTO AND
MTLIQ.NRODCTO = MVLIQ.NRODCTO AND
MTLIQ.ANO = @pano AND
MTLIQ.PERIODO = @pperiodo AND
MTLIQ.CODIGO = MTEM.CODIGO AND
MVLIQ.CONCEP = MTCON.CONCEP
)
-----
GO

-- FUNCIÓN X_REPORTENOMINAELECTRONICA(AÑO, PERIODO)

-- ESTA FUNCIÓN MUESTRA EL DETALLE DE TODOS LOS EMPLEADOS CON LA INFORMACIÓN QUE SERÁ UTILIZADA
-- PARA LA GENERACIÓN Y ENVÍO DEL MEDIO ELECTRÓNICO.

CREATE FUNCTION [dbo].[X_REPORTENOMINAELECTRONICA]
(
@pano int,
@pperiodo int
)
Returns Table
as
Return
(
SELECT
DETALLE.AÑO AÑO,
DETALLE.PERIODO PERIODO,
DETALLE.TIPODCTO _TIPODCTO,
DETALLE.NRODCTO _NRODCTO,
DETALLE.NOMBRE NOMBRE,
DETALLE.APELLIDO APELLIDO,
DETALLE.CODIGO CODIGO,
DETALLE.S_NUMCONCEP CONCEPTO,
DETALLE.S_OFIMA_DESCRIPCION DESCRIPCION,
DETALLE.S_CONCEPDIAN CONCEPTO_DIAN,
DETALLE.S_DIAN_DESCRIPCION DESCRIPCION_DIAN,
--DETALLE.S_VALOR VALOR,
DETALLE.S_TIPOHE TIPO_HORAEXTRA,
DETALLE.S_NROHORAS NUMERO_HORAS,
DETALLE.S_PORCENTAJEHE PORCENTAJE_HORAEXTRA,
CASE WHEN DEVDED = 'S' THEN (DETALLE.S_VALOR) ELSE 0 END DEVENGADO,
CASE WHEN DEVDED = 'N' THEN (DETALLE.S_VALOR)*-1 ELSE 0 END DEDUCIDO,
CASE WHEN DEVDED = 'S' THEN (DETALLE.S_VALOR) ELSE (DETALLE.S_VALOR)*-1 END VALOR
FROM
X_DETALLEEMPLEADOSNE(@pano, @pperiodo) DETALLE,
X_EMPLEADODEVDED(@pano, @pperiodo) DEVDED,
MTCONCEP MTCON
WHERE
DETALLE.TIPODCTO = DEVDED.TIPODCTO AND
DETALLE.NRODCTO = DEVDED.NRODCTO AND
MTCON.CONCEP = DETALLE.S_NUMCONCEP
)
GO