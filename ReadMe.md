## Project Object
由于<操作系统真象还原>一书中涉及的例子是对ELF格式的内核进行映射.
所以整体平台我迁移到了CentOS 7-x64.

## 文件介绍
### Linux complie
sh build.sh #if power is no enough,you should execute: `chmod 764 test.sh`


### windows complie
dd.bat 用于将MBR.bin 写入到 hd60M.img.
run.bat 用于启动BOCHS虚拟机.
./src/compier.bat 用于编译mbr.bin
