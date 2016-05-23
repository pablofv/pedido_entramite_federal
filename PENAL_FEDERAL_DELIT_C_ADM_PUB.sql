/*
PROGRAMA.: PENAL_FEDERAL_DELIT_C_ADM_PUB.sql
UBICACI�N:PROYECTO Proyecto Litigiosidad\LEX100\GitLex100\Algoritmos Estadisticas\SQL Varios\
ENTORNO..: MCENTRA
USUARIO..: LEX100MAESTRAS

DESCRIPCI�N: Calcula los expedientes en tr�mite de la C�mara Criminal y Correccional Federal de la Capital Federal (ID_CAMARA_ACTUAL = 8),
(a partir de la tabla EXPEDIENTE) para los delitos Contra la Administraci�n P�blica (Tabla DELITO, campo TITULO = 11).


FILTROS:	EXPEDIENTES EN TR�MITE 	(EXPEDIENTE.EN_TRAMITE = 1)
	DE LA CAMARA 8	(EXPEDIENTE.ID_CAMARA_ACTUAL = 8)
	CON ESTADO V�LIDO	(EXPEDIENTE.STATUS <> -1)
	QUE SEAN PRINCIPALES	(EXPEDIENTE.NATURALEZA_EXPEDIENTE IN ('P')
	DELITOS CONTRA LA ADMINISTRACI�N P�BLICA	(DELITO.TITULO = 11)
	
JOINS: LA RELACI�N ES ENTRE LAS TABLAS "EXPEDIENTE" Y "DELITO_EXPEDIENTE" PARA SABER LOS DELITOS QUE TIENE CADA CAUSA
Y CON LA TABLA "DELITO" PARA SABER LOS QUE SON DE T�TULO 11 (SON CONTRA LA ADMINISTRACI�N P�BLICA)		


RESULTADO: 1183 Expedientes y 1860 registros (Expedientes con sus delitos - SUB-SELECT en FROM principal denominado CAU)

*/



SELECT CAU.NUMERO_EXPEDIENTE, CAU.ANIO_EXPEDIENTE, cau.CARATULA_EXPEDIENTE
FROM (select  e.anio_expediente,
              e.numero_expediente,
              e.id_expediente,
              nvl(e.CARATULA_EXPEDIENTE, 'sin car�tula') caratula_expediente,
              e.naturaleza_expediente,
              e.id_tipo_causa,
              E.SITUACION_EXPEDIENTE,
              D.ID_DELITO, D.CODIGO_DELITO, D.DESCRIPCION_DELITO, d.status estado_delito
      from lex100maestras.expediente e
                    join lex100maestras.delito_expediente de on e.id_expediente = de.id_expediente
                    join lex100maestras.delito d on de.id_delito = d.id_delito
      where   E.EN_TRAMITE = 1
      and     e.id_camara_actual = 8
      and     e.status <> -1                     
      and     d.titulo = 11
      and     e.naturaleza_expediente in ('P')
      order by e.anio_expediente, e.numero_expediente, e.naturaleza_expediente) CAU
group by CAU.NUMERO_EXPEDIENTE, CAU.ANIO_EXPEDIENTE, cau.CARATULA_EXPEDIENTE
;