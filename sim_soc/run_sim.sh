# 一步式（VCS 直接编译+elaborate）：glbl 必须作为顶层，否则 unisim 的 glbl.GSR/GTS 解析失败
vcs -full64 -sverilog -f arm926fpga.f -R -top tbench_top -top glbl \
    -l 1.log -P /home/synopsys/verdi/Verdi_O-2018.09-SP2/share/PLI/VCS/LINUXAMD64/novas.tab /home/synopsys/verdi/Verdi_O-2018.09-SP2/share/PLI/VCS/LINUXAMD64/pli.a
