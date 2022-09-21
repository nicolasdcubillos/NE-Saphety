﻿using System.Runtime.InteropServices;
using NE_Saphety_DLL.Controller;

namespace NE_Saphety_DLL
{
    public class DocumentoSoporte
    {
        [InterfaceType(ComInterfaceType.InterfaceIsDual)]
        public interface DLLInterface
        {
            [DispId(0)]
            string enviarDocumentoSoporte(DocumentoSoporteDTO documentoSoporteDTO);
            [DispId(1)]
            bool auth(string empresa);
            [DispId(2)]
            bool saveConfig(ConfiguracionDTO configuracionDTO);
            [DispId(3)]
            ConfiguracionDTO loadConfig();
        }

        [ComSourceInterfaces(typeof(DLLInterface))]
        [ClassInterface(ClassInterfaceType.AutoDual)]
        [ProgId("DSSaphety.Class")]
        [ComVisible(true)]
        public class DSSaphety : DLLInterface
        {
            private InvoiceController invoiceController = new InvoiceController();
            public string enviarDocumentoSoporte (DocumentoSoporteDTO documentoSoporteDTO)
            {
                return invoiceController.enviarDocumentoSoporte(documentoSoporteDTO);
            }
            public string enviarAjusteDocumento (DocumentoSoporteAjusteDTO documentoSoporteAjusteDTO)
            {
                return invoiceController.enviarAjusteDocumento(documentoSoporteAjusteDTO);
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
