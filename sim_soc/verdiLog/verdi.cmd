sidCmdLineBehaviorAnalysisOpt -incr -clockSkew 0 -loopUnroll 0 -bboxEmptyModule 0  -cellModel 0 -bboxIgnoreProtected 0 
debImport "-f" "arm926fpga.f" "-f" "arm926fpga_vhdl.f" "-top" "tbench_top" \
          "+fsdb+noindex"
debLoadSimResult /home/ICer/work/sim_soc/wave.fsdb
wvCreateWindow
srcHBSelect "tbench_top.dut" -win $_nTrace1
srcSetScope -win $_nTrace1 "tbench_top.dut" -delim "."
srcHBSelect "tbench_top.dut" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "led" -line 11 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoom -win $_nWave2 947628437.986508 1085998962.117281
wvZoom -win $_nWave2 995882196.271855 1007299380.151872
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 1431925272.444214 -snap {("G2" 0)}
debReload
