using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;

namespace NE_Saphety_DLL
{
    /*
     * Configuracion DTO
     */

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("ConfiguracionDTO.Class")]
    [ComVisible(true)]
    public class ConfiguracionDTO
    {
        public String PATH { get; set; }
        public String WS_URL_PRUEBAS { get; set; }
        public String WS_URL_PRODUCCION { get; set; }
        public String AMBIENTE { get; set; }
        public String VIRTUAL_OPERATOR { get; set; }
        public String USERNAME { get; set; }
        public String PASSWORD { get; set; }
        public String TIPO_DCTO { get; set; }
        public String NOTA_AJUSTE { get; set; }
    }

    /*
     * Token DTO
     */

    public class TokenRequestDTO
    {
        public String username { get; set; }
        public String password { get; set; }
        public String virtual_operator { get; set; }
    }

    /*
     * Nómina Individual DTO
     */

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("FechaPagoDTO.Class")]
    [ComVisible(true)]
    public class FechaPagoDTO
    {
        public String FechaPago { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("Periodo.Class")]
    [ComVisible(true)]
    public class Periodo
    {
        public String FechaIngreso { get; set; }
        public String FechaLiquidacionInicio { get; set; }
        public String FechaLiquidacionFin { get; set; }
        public String TiempoLaborado { get; set; }
        public String FechaGen { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("NumeroSecuenciaXML.Class")]
    [ComVisible(true)]
    public class NumeroSecuenciaXML 
    {
        public String Prefijo { get; set; }
        public String Consecutivo { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("LugarGeneracionXML.Class")]
    [ComVisible(true)]
    public class LugarGeneracionXML
    {
        public String Pais { get; set; }
        public String DepartamentoEstado { get; set; }
        public String MunicipioCiudad { get; set; }
        public String Idioma { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("InformacionGeneral.Class")]
    [ComVisible(true)]
    public class InformacionGeneral
    {
        public String FechaHoraGen { get; set; }
        public String PeriodoNomina { get; set; }
        public String TipoMoneda { get; set; }
        public String TRM { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("Empleador.Class")]
    [ComVisible(true)]
    public class Empleador
    {
        public String NIT { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("Trabajador.Class")]
    [ComVisible(true)]
    public class Trabajador
    {
        public String TipoTrabajador { get; set; }
        public String SubTipoTrabajador { get; set; }
        public String AltoRiesgoPension { get; set; }
        public String TipoDocumento { get; set; }
        public String NumeroDocumento { get; set; }
        public String PrimerApellido { get; set; }
        public String SegundoApellido { get; set; }
        public String PrimerNombre { get; set; }
        public String OtrosNombres { get; set; }
        public String LugarTrabajoPais { get; set; }
        public String LugarTrabajoDepartamentoEstado { get; set; }
        public String LugarTrabajoMunicipioCiudad { get; set; }
        public String LugarTrabajoDireccion { get; set; }
        public String SalarioIntegral { get; set; }
        public String TipoContrato { get; set; }
        public String Sueldo { get; set; }
        public String CodigoTrabajador { get; set; }
        public String CorreoElectronico { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("Pago.Class")]
    [ComVisible(true)]
    public class Pago
    {
        public String Forma { get; set; }
        public String Metodo { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("Basico.Class")]
    [ComVisible(true)]
    public class Basico
    {
        public String DiasTrabajados { get; set; }
        public String SueldoTrabajado { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("Transporte.Class")]
    [ComVisible(true)]
    public class Transporte
    {
        public String AuxilioTransporte { get; set; }
        public String ViaticoManutAlojS { get; set; }
        public String ViaticoManutAlojNS { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("HoraExtra.Class")]
    [ComVisible(true)]
    public class HoraExtra
    {
        public String Cantidad { get; set; }
        public String Porcentaje { get; set; }
        public String Pago { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("Vacacion.Class")]
    [ComVisible(true)]
    public class Vacacion
    {
        public String Cantidad { get; set; }
        public String Pago { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("Vacaciones.Class")]
    [ComVisible(true)]
    public class Vacaciones
    {
        public List<Vacacion> VacacionesComunes { get; set; } = new List<Vacacion>();
        public List<Vacacion> VacacionesCompensadas { get; set; } = new List<Vacacion>();
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("Primas.Class")]
    [ComVisible(true)]
    public class Primas
    {
        public String Cantidad { get; set; }
        public String Pago { get; set; }
        public String PagoNS { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("Cesantias.Class")]
    [ComVisible(true)]
    public class Cesantias
    {
        public String Pago { get; set; }
        public String Porcentaje { get; set; }
        public String PagoIntereses { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("Incapacidad.Class")]
    [ComVisible(true)]
    public class Incapacidad
    {
        public String Cantidad { get; set; }
        public String Tipo { get; set; }
        public String Pago { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("Licencia.Class")]
    [ComVisible(true)]
    public class Licencia
    {
        public String Cantidad { get; set; }
        public String Pago { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("Licencias.Class")]
    [ComVisible(true)]
    public class Licencias
    {
        public List<Licencia> LicenciaMP { get; set; } = new List<Licencia>();
        public List<Licencia> LicenciaR { get; set; } = new List<Licencia>();
        public List<Licencia> LicenciaNR { get; set; } = new List<Licencia>();
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("Bonificacion.Class")]
    [ComVisible(true)]
    public class Bonificacion
    {
        public String BonificacionS { get; set; }
        public String BonificacionNS { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("Auxilio.Class")]
    [ComVisible(true)]
    public class Auxilio
    {
        public String AuxilioS { get; set; }
        public String AuxilioNS { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("OtroConcepto.Class")]
    [ComVisible(true)]
    public class OtroConcepto
    {
        public String DescripcionConcepto { get; set; }
        public String ConceptoS { get; set; }
        public String ConceptoNS { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("Compensacion.Class")]
    [ComVisible(true)]
    public class Compensacion
    {
        public String CompensacionO { get; set; }
        public String CompensacionE { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("BonoEPCTV.Class")]
    [ComVisible(true)]
    public class BonoEPCTV
    {
        public String PagoS { get; set; }
        public String PagoNS { get; set; }
        public String PagoAlimentacionS { get; set; }
        public String PagoAlimentacionNS { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("ComisionDTO.Class")]
    [ComVisible(true)]
    public class ComisionDTO
    {
        public String Comision { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("PagoTerceroDTO.Class")]
    [ComVisible(true)]
    public class PagoTerceroDTO
    {
        public String PagoTercero { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("AnticipoDTO.Class")]
    [ComVisible(true)]
    public class AnticipoDTO
    {
        public String Anticipo { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("Devengados.Class")]
    [ComVisible(true)]
    public class Devengados
    {
        public Basico Basico { get; set; } = new Basico();
        public List<Transporte> Transporte { get; set; } = new List<Transporte>();
        public List<HoraExtra> HEDs { get; set; } = new List<HoraExtra>();
        public List<HoraExtra> HENs { get; set; } = new List<HoraExtra>();
        public List<HoraExtra> HEDDFs { get; set; } = new List<HoraExtra>();
        public List<HoraExtra> HENDFs { get; set; } = new List<HoraExtra>();
        public List<HoraExtra> HRNs { get; set; } = new List<HoraExtra>();
        public List<HoraExtra> HRDDFs { get; set; } = new List<HoraExtra>();
        public List<HoraExtra> HRNDFs { get; set; } = new List<HoraExtra>();
        public Vacaciones Vacaciones { get; set; }
        public String Dotacion { get; set; }
        public String ApoyoSost { get; set; }
        public String Teletrabajo { get; set; }
        public String BonifRetiro { get; set; }

        public String Indemnizacion { get; set; }
        public String Reintegro { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("Salud.Class")]
    [ComVisible(true)]
    public class Salud
    {
        public String Porcentaje { get; set; }
        public String Deduccion { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("FondoPension.Class")]
    [ComVisible(true)]
    public class FondoPension
    {
        public String Porcentaje { get; set; }
        public String Deduccion { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("FondoSP.Class")]
    [ComVisible(true)]
    public class FondoSP
    {
        public String Porcentaje { get; set; }
        public String Deduccion { get; set; }
        public String PorcentajeSub { get; set; }
        public String DeduccionSub { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("Sindicato.Class")]
    [ComVisible(true)]
    public class Sindicato
    {
        public String Porcentaje { get; set; }
        public String Deduccion { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("Sanciones.Class")]
    [ComVisible(true)]
    public class Sanciones
    {
        public String SancionPublic { get; set; }
        public String SancionPriv { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("Libranza.Class")]
    [ComVisible(true)]
    public class Libranza
    {
        public String Descripcion { get; set; }
        public String Deduccion { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("OtraDeduccionDTO.Class")]
    [ComVisible(true)]
    public class OtraDeduccionDTO
    {
        public String OtraDeduccion { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("Deducciones.Class")]
    [ComVisible(true)]
    public class Deducciones
    {
        public String PensionVoluntaria { get; set; }
        public String RetencionFuente { get; set; }
        public String AFC { get; set; }
        public String Cooperativa { get; set; }
        public String EmbargoFiscal { get; set; }
        public String PlanComplementarios { get; set; }
        public String Educacion { get; set; }
        public String Reintegro { get; set; }
        public String Deuda { get; set; }
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("NominaIndividualDTO.Class")]
    [ComVisible(true)]
    public class NominaIndividualDTO
    {
        public List<FechaPagoDTO> FechasPagos { get; set; } = new List<FechaPagoDTO>();
        public List<String> Notas { get; set; } = new List<String>();
        public Devengados Devengados { get; set; }
        public Deducciones Deducciones { get; set; }
        public String DevengadosTotal { get; set; }
        public String DeduccionesTotal { get; set; }
        public String ComprobanteTotal { get; set; }
        public String CorrelationDocumentId { get; set; }

        [DispId(0)]
        public void addFechaPago(FechaPagoDTO fechaPago)
        {
            this.FechasPagos.Add(fechaPago);
        }
        [DispId(1)]
        public void addNota(String nota)
        {
            this.Notas.Add(nota);
        }
    }
}
