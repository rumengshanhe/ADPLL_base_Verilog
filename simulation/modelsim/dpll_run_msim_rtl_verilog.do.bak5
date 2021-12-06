transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/comber/ADPLL/source {D:/comber/ADPLL/source/dpll.v}
vlog -vlog01compat -work work +incdir+D:/comber/ADPLL/source {D:/comber/ADPLL/source/freqdivider.v}
vlog -vlog01compat -work work +incdir+D:/comber/ADPLL/source {D:/comber/ADPLL/source/phasecomparator.v}
vlog -vlog01compat -work work +incdir+D:/comber/ADPLL/source {D:/comber/ADPLL/source/randomwalkfilter.v}
vlog -vlog01compat -work work +incdir+D:/comber/ADPLL/source {D:/comber/ADPLL/source/variableresetrandomwalkfilter.v}

vlog -vlog01compat -work work +incdir+D:/comber/ADPLL/simulation/modelsim {D:/comber/ADPLL/simulation/modelsim/dpll.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  dpll_vlg_tst

add wave *
view structure
view signals
run -all
