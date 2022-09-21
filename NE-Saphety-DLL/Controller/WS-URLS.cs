﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NE_Saphety_DLL.Controller;

namespace NE_Saphety_DLL.Utils
{
    public enum WS_URL
    {
        SOLICITAR_TOKEN,
        ENVIAR_DOCUMENTO_SOPORTE,
        ENVIAR_AJUSTE_DOCUMENTO
    }

    public static class WS_URLS_EXTENSIONS
    {
        private static PropertiesController properties = new PropertiesController();
        private static string virtualOperator = properties.read("VIRTUAL_OPERATOR") + "/";
        private static string version = "/v2/";
        public static string getUrl(this WS_URL URL)
        {
            switch (URL)
            {
                case WS_URL.SOLICITAR_TOKEN:
                    return version + "auth/gettoken";
                case WS_URL.ENVIAR_DOCUMENTO_SOPORTE:
                    return version + virtualOperator + "outbounddocuments/supportDocument";
                case WS_URL.ENVIAR_AJUSTE_DOCUMENTO:
                    return version + virtualOperator + "outbounddocuments/supportDocumentAdjust";
                default:
                    return null;
            }
        }
    }
}
