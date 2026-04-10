using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace PointerPrecisionSwitch
{
    internal class Program
    {
        enum SPIF { NONE = 0x00, SPIF_UPDATEINIFILE = 0x01, SPIF_SENDCHANGE = 0x02 }
        const UInt32 SPI_GETMOUSE = 0x0003, SPI_SETMOUSE = 0x0004;

        [DllImport("user32.dll", EntryPoint = "SystemParametersInfo", SetLastError = true)]
        static extern bool SystemParametersInfo(uint action, uint param, IntPtr vparam, SPIF fWinIni);

        private const int ON = 1;
        private const int OFF = 0;

        [STAThread]
        static void Main(string[] args)
        {
            if ( args == null || args.Length == 0 ||
                Array.IndexOf(args, "/?") >= 0 ||
                Array.IndexOf(args, "-h") >= 0 ||
                (
                    Array.IndexOf(args, "-cs") < 0 &&
                    Array.IndexOf(args, "-on") < 0 &&
                    Array.IndexOf(args, "-off") < 0 &&
                    Array.IndexOf(args, "-tgl") < 0
                )
                )
            {
                Console.WriteLine("-cs : current state of mouse pointer precision");
                Console.WriteLine("-on : on mouse pointer precision");
                Console.WriteLine("-off : off mouse pointer precision");
                Console.WriteLine("-tgl : toggle mouse pointer precision, it has priority over other parameters.");
                Console.WriteLine("-p : save parameter after reboot, if not present setting applying until reboot");

                Console.WriteLine("");
                Console.WriteLine("Current parameters:");
                Console.WriteLine(string.Join(", ", args));
                return;
            }

            int[] mouseParams = new int[3];
            GCHandle gch = GCHandle.Alloc(mouseParams, GCHandleType.Pinned);
            SystemParametersInfo(SPI_GETMOUSE, 0, gch.AddrOfPinnedObject(), SPIF.NONE);

            if (Array.IndexOf(args, "-cs") >= 0)
            {
                var message = mouseParams[2] == ON ? "Mouse pointer precision ON" : "Mouse pointer precision OFF";
                Console.WriteLine(message);
                gch.Free();
                return;
            }

            var prevMouseParam = mouseParams[2];
            mouseParams[2] = GetMouseParam(mouseParams[2], args);
            SystemParametersInfo(SPI_SETMOUSE, 0, gch.AddrOfPinnedObject(), (Array.IndexOf(args, "-p") >= 0) ? SPIF.SPIF_UPDATEINIFILE : SPIF.SPIF_SENDCHANGE);
            gch.Free();

            var finalOutput = "Mouse precision ";
            if(prevMouseParam != mouseParams[2])
            {
                finalOutput = finalOutput + "changed to ";
            }
            else
            {
                finalOutput = finalOutput + "state same: ";
            }

            finalOutput = finalOutput + (mouseParams[2] == ON ? "ON" : "OFF");

            if (Array.IndexOf(args, "-p") >= 0) finalOutput = finalOutput + " Permanent";

            Console.WriteLine(finalOutput);
        }

        private static int GetMouseParam(int curP, string[] args)
        {
            if (Array.IndexOf(args, "-tgl") >= 0) return(curP == OFF ? ON : OFF);

            var onOndex = Array.IndexOf(args, "-on");
            var offOndex = Array.IndexOf(args, "-off");

            if (onOndex >= 0 && offOndex < 0)
            {
                return ON;
            }
            else if (offOndex >= 0 && onOndex < 0)
            {
                return OFF;
            }
            else if(offOndex >= 0 && onOndex >= 0)
            {
                return onOndex < offOndex ? ON : OFF;
            }
            else
            {
                return curP;
            }
        }
    }
}
