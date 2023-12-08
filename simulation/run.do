quietly set ACTELLIBNAME PolarFire
quietly set PROJECT_DIR "/home/eraguzin/nextcloud/LuSEE/Libero/calibrator/calibrator"

if {[file exists presynth/_info]} {
   echo "INFO: Simulation library presynth already exists"
} else {
   file delete -force presynth 
   vlib presynth
}
vmap presynth presynth
vmap PolarFire "/usr/local/microchip/Libero_SoC_v2022.3/Libero/lib/modelsimpro/precompiled/vlog/polarfire"
if {[file exists COREFIFO_LIB/_info]} {
   echo "INFO: Simulation library COREFIFO_LIB already exists"
} else {
   file delete -force COREFIFO_LIB 
   vlib COREFIFO_LIB
}
vmap COREFIFO_LIB "COREFIFO_LIB"
if {[file exists CORECORDIC_LIB/_info]} {
   echo "INFO: Simulation library CORECORDIC_LIB already exists"
} else {
   file delete -force CORECORDIC_LIB 
   vlib CORECORDIC_LIB
}
vmap CORECORDIC_LIB "CORECORDIC_LIB"

vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/cal_phaser_alt_fixpt.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/cal_average_instance_C1_fixpt_pkg.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/cal_average_instance_C1_fixpt_tb_pkg.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/cal_phaser_alt_fixpt_tb_pkg.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/cal_process_fixpt_pkg.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/cal_process_fixpt_tb_pkg.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/cal_average_instance_C1_fixpt.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/cal_process_fixpt.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/Multiply_generic_32.vhd"
vcom -2008 -explicit  -work COREFIFO_LIB "${PROJECT_DIR}/component/Actel/DirectCore/COREFIFO/3.0.101/rtl/vhdl/core/fifo_pkg.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/CALFIFO_C0/CALFIFO_C0.vhd"
vcom -2008 -explicit  -work COREFIFO_LIB "${PROJECT_DIR}/component/work/CALFIFO_C0/CALFIFO_C0_0/rtl/vhdl/core/CALFIFO_C0_CALFIFO_C0_0_USRAM_top.vhd"
vcom -2008 -explicit  -work COREFIFO_LIB "${PROJECT_DIR}/component/work/CALFIFO_C0/CALFIFO_C0_0/rtl/vhdl/core/CALFIFO_C0_CALFIFO_C0_0_ram_wrapper.vhd"
vcom -2008 -explicit  -work COREFIFO_LIB "${PROJECT_DIR}/component/work/CALFIFO_C0/CALFIFO_C0_0/rtl/vhdl/core/COREFIFO.vhd"
vcom -2008 -explicit  -work COREFIFO_LIB "${PROJECT_DIR}/component/work/CALFIFO_C0/CALFIFO_C0_0/rtl/vhdl/core/corefifo_NstagesSync.vhd"
vcom -2008 -explicit  -work COREFIFO_LIB "${PROJECT_DIR}/component/work/CALFIFO_C0/CALFIFO_C0_0/rtl/vhdl/core/corefifo_async.vhd"
vcom -2008 -explicit  -work COREFIFO_LIB "${PROJECT_DIR}/component/work/CALFIFO_C0/CALFIFO_C0_0/rtl/vhdl/core/corefifo_fwft.vhd"
vcom -2008 -explicit  -work COREFIFO_LIB "${PROJECT_DIR}/component/work/CALFIFO_C0/CALFIFO_C0_0/rtl/vhdl/core/corefifo_grayToBinConv.vhd"
vcom -2008 -explicit  -work COREFIFO_LIB "${PROJECT_DIR}/component/work/CALFIFO_C0/CALFIFO_C0_0/rtl/vhdl/core/corefifo_sync.vhd"
vcom -2008 -explicit  -work COREFIFO_LIB "${PROJECT_DIR}/component/work/CALFIFO_C0/CALFIFO_C0_0/rtl/vhdl/core/corefifo_sync_scntr.vhd"
vcom -2008 -explicit  -work CORECORDIC_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CORECORDIC/4.1.100/rtl/vhdl/core/cordic_rtl_pack.vhd"
vcom -2008 -explicit  -work CORECORDIC_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CORECORDIC/4.1.100/rtl/vhdl/core/cordic_kit.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/CORDICFIFO/CORDICFIFO.vhd"
vcom -2008 -explicit  -work COREFIFO_LIB "${PROJECT_DIR}/component/work/CORDICFIFO/CORDICFIFO_0/rtl/vhdl/core/CORDICFIFO_CORDICFIFO_0_LSRAM_top.vhd"
vcom -2008 -explicit  -work COREFIFO_LIB "${PROJECT_DIR}/component/work/CORDICFIFO/CORDICFIFO_0/rtl/vhdl/core/CORDICFIFO_CORDICFIFO_0_ram_wrapper.vhd"
vcom -2008 -explicit  -work COREFIFO_LIB "${PROJECT_DIR}/component/work/CORDICFIFO/CORDICFIFO_0/rtl/vhdl/core/COREFIFO.vhd"
vcom -2008 -explicit  -work COREFIFO_LIB "${PROJECT_DIR}/component/work/CORDICFIFO/CORDICFIFO_0/rtl/vhdl/core/corefifo_NstagesSync.vhd"
vcom -2008 -explicit  -work COREFIFO_LIB "${PROJECT_DIR}/component/work/CORDICFIFO/CORDICFIFO_0/rtl/vhdl/core/corefifo_async.vhd"
vcom -2008 -explicit  -work COREFIFO_LIB "${PROJECT_DIR}/component/work/CORDICFIFO/CORDICFIFO_0/rtl/vhdl/core/corefifo_fwft.vhd"
vcom -2008 -explicit  -work COREFIFO_LIB "${PROJECT_DIR}/component/work/CORDICFIFO/CORDICFIFO_0/rtl/vhdl/core/corefifo_grayToBinConv.vhd"
vcom -2008 -explicit  -work COREFIFO_LIB "${PROJECT_DIR}/component/work/CORDICFIFO/CORDICFIFO_0/rtl/vhdl/core/corefifo_sync.vhd"
vcom -2008 -explicit  -work COREFIFO_LIB "${PROJECT_DIR}/component/work/CORDICFIFO/CORDICFIFO_0/rtl/vhdl/core/corefifo_sync_scntr.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/CORECORDIC_C0/CORECORDIC_C0.vhd"
vcom -2008 -explicit  -work CORECORDIC_LIB "${PROJECT_DIR}/component/work/CORECORDIC_C0/CORECORDIC_C0_0/CORECORDIC_C0_CORECORDIC_C0_0_CordicLUT_word.vhd"
vcom -2008 -explicit  -work CORECORDIC_LIB "${PROJECT_DIR}/component/work/CORECORDIC_C0/CORECORDIC_C0_0/coreparameters.vhd"
vcom -2008 -explicit  -work CORECORDIC_LIB "${PROJECT_DIR}/component/work/CORECORDIC_C0/CORECORDIC_C0_0/rtl/vhdl/core/CORECORDIC.vhd"
vcom -2008 -explicit  -work CORECORDIC_LIB "${PROJECT_DIR}/component/work/CORECORDIC_C0/CORECORDIC_C0_0/rtl/vhdl/core/cordic_par.vhd"
vcom -2008 -explicit  -work CORECORDIC_LIB "${PROJECT_DIR}/component/work/CORECORDIC_C0/CORECORDIC_C0_0/rtl/vhdl/core/cordic_word.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/cal_phaser.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/stimulus/cal_average_instance_C1_fixpt_tb.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/stimulus/cal_phaser_alt_fixpt_tb.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/stimulus/cal_process_fixpt_tb.vhd"

vsim -L PolarFire -L presynth -L COREFIFO_LIB -L CORECORDIC_LIB  -t 1ps -pli /usr/local/microchip/Libero_SoC_v2022.3/Libero/lib/modelsimpro/pli/pf_crypto_lin_me_pli.so presynth.cal_phaser_alt_fixpt_tb
add wave /cal_phaser_alt_fixpt_tb/*
run 1000ns
