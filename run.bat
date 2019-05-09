cd "F:\Desktop\Bochs-2.6.9\kd_os\src\"
call compile.bat

cd "F:\Desktop\Bochs-2.6.9\kd_os\"
call dd_copy.bat

cd "F:\Desktop\Bochs-2.6.9\kd_os"
..\bochsdbg -q -f bochsrc.bxrc
