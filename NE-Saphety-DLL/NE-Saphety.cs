using System.Runtime.InteropServices;
using NE_Saphety_DLL.Controller;

namespace NE_Saphety_DLL
{
    public class NominaElectronica
    {
        [InterfaceType(ComInterfaceType.InterfaceIsDual)]
        public interface DLLInterface
        {
            [DispId(0)]
            string enviarNominaIndividual(NominaIndividualDTO nominaIndividualDTO);
            [DispId(1)]
            bool auth(string empresa);
            [DispId(2)]
            bool saveConfig(ConfiguracionDTO configuracionDTO);
            [DispId(3)]
            ConfiguracionDTO loadConfig();
        }

        [ComSourceInterfaces(typeof(DLLInterface))]
        [ClassInterface(ClassInterfaceType.AutoDual)]
        [ProgId("NESaphety.Class")]
        [ComVisible(true)]
        public class NESaphety : DLLInterface
        {
            private InvoiceController invoiceController = new InvoiceController();
            public string enviarNominaIndividual(NominaIndividualDTO nominaIndividualDTO)
            {
                return invoiceController.enviarNominaIndividual(nominaIndividualDTO);
            }
            public bool auth(string empresa)
            {
                return invoiceController.auth(empresa);
            }
            public bool saveConfig(ConfiguracionDTO configuracionDTO)
            {
                return invoiceController.saveConfig(configuracionDTO);
            }
            public ConfiguracionDTO loadConfig() 
            {
                return invoiceController.loadConfig();
            }
        }
    }
}
