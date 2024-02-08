quietly set ACTELLIBNAME PolarFire
quietly set PROJECT_DIR "/home/eraguzin/nextcloud/LuSEE/Libero/calibrator/LuSEE_Calibrator"

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

vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/test_divide.vhd"
vcom -2008 -explicit  -work CORECORDIC_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CORECORDIC/4.1.100/rtl/vhdl/core/cordic_rtl_pack.vhd"
vcom -2008 -explicit  -work CORECORDIC_LIB "${PROJECT_DIR}/component/work/CORECORDIC_C0/CORECORDIC_C0_0/coreparameters.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/cal_average_instance_C1_fixpt_pkg.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/cal_average_instance_C1_fixpt_tb_pkg.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/cal_phaser_alt_fixpt_tb_pkg.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/cal_process_fixpt_pkg.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/cal_process_fixpt_tb_pkg.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/multiply_test_pkg.vhd"
vcom -2008 -explicit  -work CORECORDIC_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CORECORDIC/4.1.100/rtl/vhdl/core/cordic_kit.vhd"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CALFIFO_C0/CALFIFO_C0.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CALFIFO_C0/CALFIFO_C0_0/rtl/vlog/core/CALFIFO_C0_CALFIFO_C0_0_USRAM_top.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CALFIFO_C0/CALFIFO_C0_0/rtl/vlog/core/CALFIFO_C0_CALFIFO_C0_0_ram_wrapper.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CALFIFO_C0/CALFIFO_C0_0/rtl/vlog/core/COREFIFO.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CALFIFO_C0/CALFIFO_C0_0/rtl/vlog/core/corefifo_NstagesSync.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CALFIFO_C0/CALFIFO_C0_0/rtl/vlog/core/corefifo_async.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CALFIFO_C0/CALFIFO_C0_0/rtl/vlog/core/corefifo_fwft.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CALFIFO_C0/CALFIFO_C0_0/rtl/vlog/core/corefifo_grayToBinConv.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CALFIFO_C0/CALFIFO_C0_0/rtl/vlog/core/corefifo_sync.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CALFIFO_C0/CALFIFO_C0_0/rtl/vlog/core/corefifo_sync_scntr.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CAL_AVERAGE_DATA_FIFO/CAL_AVERAGE_DATA_FIFO.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CAL_AVERAGE_DATA_FIFO/CAL_AVERAGE_DATA_FIFO_0/rtl/vlog/core/CAL_AVERAGE_DATA_FIFO_CAL_AVERAGE_DATA_FIFO_0_USRAM_top.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CAL_AVERAGE_DATA_FIFO/CAL_AVERAGE_DATA_FIFO_0/rtl/vlog/core/CAL_AVERAGE_DATA_FIFO_CAL_AVERAGE_DATA_FIFO_0_ram_wrapper.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CAL_AVERAGE_DATA_FIFO/CAL_AVERAGE_DATA_FIFO_0/rtl/vlog/core/COREFIFO.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CAL_AVERAGE_DATA_FIFO/CAL_AVERAGE_DATA_FIFO_0/rtl/vlog/core/corefifo_NstagesSync.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CAL_AVERAGE_DATA_FIFO/CAL_AVERAGE_DATA_FIFO_0/rtl/vlog/core/corefifo_async.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CAL_AVERAGE_DATA_FIFO/CAL_AVERAGE_DATA_FIFO_0/rtl/vlog/core/corefifo_fwft.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CAL_AVERAGE_DATA_FIFO/CAL_AVERAGE_DATA_FIFO_0/rtl/vlog/core/corefifo_grayToBinConv.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CAL_AVERAGE_DATA_FIFO/CAL_AVERAGE_DATA_FIFO_0/rtl/vlog/core/corefifo_sync.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CAL_AVERAGE_DATA_FIFO/CAL_AVERAGE_DATA_FIFO_0/rtl/vlog/core/corefifo_sync_scntr.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CAL_AVERAGE_OTHER_FIFO/CAL_AVERAGE_OTHER_FIFO.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CAL_AVERAGE_OTHER_FIFO/CAL_AVERAGE_OTHER_FIFO_0/rtl/vlog/core/CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CAL_AVERAGE_OTHER_FIFO/CAL_AVERAGE_OTHER_FIFO_0/rtl/vlog/core/CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_ram_wrapper.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CAL_AVERAGE_OTHER_FIFO/CAL_AVERAGE_OTHER_FIFO_0/rtl/vlog/core/COREFIFO.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CAL_AVERAGE_OTHER_FIFO/CAL_AVERAGE_OTHER_FIFO_0/rtl/vlog/core/corefifo_NstagesSync.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CAL_AVERAGE_OTHER_FIFO/CAL_AVERAGE_OTHER_FIFO_0/rtl/vlog/core/corefifo_async.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CAL_AVERAGE_OTHER_FIFO/CAL_AVERAGE_OTHER_FIFO_0/rtl/vlog/core/corefifo_fwft.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CAL_AVERAGE_OTHER_FIFO/CAL_AVERAGE_OTHER_FIFO_0/rtl/vlog/core/corefifo_grayToBinConv.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CAL_AVERAGE_OTHER_FIFO/CAL_AVERAGE_OTHER_FIFO_0/rtl/vlog/core/corefifo_sync.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CAL_AVERAGE_OTHER_FIFO/CAL_AVERAGE_OTHER_FIFO_0/rtl/vlog/core/corefifo_sync_scntr.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CORDICFIFO/CORDICFIFO.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CORDICFIFO/CORDICFIFO_0/rtl/vlog/core/CORDICFIFO_CORDICFIFO_0_LSRAM_top.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CORDICFIFO/CORDICFIFO_0/rtl/vlog/core/CORDICFIFO_CORDICFIFO_0_ram_wrapper.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CORDICFIFO/CORDICFIFO_0/rtl/vlog/core/COREFIFO.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CORDICFIFO/CORDICFIFO_0/rtl/vlog/core/corefifo_NstagesSync.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CORDICFIFO/CORDICFIFO_0/rtl/vlog/core/corefifo_async.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CORDICFIFO/CORDICFIFO_0/rtl/vlog/core/corefifo_fwft.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CORDICFIFO/CORDICFIFO_0/rtl/vlog/core/corefifo_grayToBinConv.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CORDICFIFO/CORDICFIFO_0/rtl/vlog/core/corefifo_sync.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/CORDICFIFO/CORDICFIFO_0/rtl/vlog/core/corefifo_sync_scntr.v"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/CORECORDIC_C0/CORECORDIC_C0.vhd"
vcom -2008 -explicit  -work CORECORDIC_LIB "${PROJECT_DIR}/component/work/CORECORDIC_C0/CORECORDIC_C0_0/CORECORDIC_C0_CORECORDIC_C0_0_CordicLUT_word.vhd"
vcom -2008 -explicit  -work CORECORDIC_LIB "${PROJECT_DIR}/component/work/CORECORDIC_C0/CORECORDIC_C0_0/rtl/vhdl/core/CORECORDIC.vhd"
vcom -2008 -explicit  -work CORECORDIC_LIB "${PROJECT_DIR}/component/work/CORECORDIC_C0/CORECORDIC_C0_0/rtl/vhdl/core/cordic_par.vhd"
vcom -2008 -explicit  -work CORECORDIC_LIB "${PROJECT_DIR}/component/work/CORECORDIC_C0/CORECORDIC_C0_0/rtl/vhdl/core/cordic_word.vhd"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/PF_TPSRAM_CAL/PF_TPSRAM_CAL.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/PF_TPSRAM_CAL/PF_TPSRAM_CAL_0/PF_TPSRAM_CAL_PF_TPSRAM_CAL_0_PF_TPSRAM.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/PF_TPSRAM_CAL_PROCESS/PF_TPSRAM_CAL_PROCESS.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/PF_TPSRAM_CAL_PROCESS/PF_TPSRAM_CAL_PROCESS_0/PF_TPSRAM_CAL_PROCESS_PF_TPSRAM_CAL_PROCESS_0_PF_TPSRAM.v"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/Multiply_generic_32.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/cal_average.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/cal_average_instance_C1_fixpt.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/cal_phaser.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/cal_phaser_alt_fixpt.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/stimulus/calibration_tb.vhd"

vsim -L PolarFire -L presynth -L COREFIFO_LIB -L CORECORDIC_LIB  -t 1ps -pli /usr/local/microchip/Libero_SoC_v2022.3/Libero/lib/modelsimpro/pli/pf_crypto_lin_me_pli.so presynth.calibration_tb
add wave /calibration_tb/*
run 1000ns
