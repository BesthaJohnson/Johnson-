set_scenario_status -active true [all_scenarios] ;
#set_scenario_status -active true [get_scenarios "func.ff_m40c test.ff_125c"]

#set_scenario_status -active false [get_scenarios -filter active]
#set_scenario_status -active true <>
set_app_options -name cts.compile.primary_corner -value ss_125c
synthesize_clock_trees -propagate_only





set_app_options -name opt.common.user_instance_name_prefix -value CLOCK_Buff


#redirect -tee -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_app_options.start {report_app_options -non_default *}
#redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_lib_cell_purpose {report_lib_cell -objects [get_lib_cells] -column {full_name:20 valid_purposes}}
#redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.pre_cts.report_clock_settings {report_clock_settings} ;# CTS constraints and settings
#redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.pre_cts.check_clock_tree {check_clock_tree} ;# checks issues that could hurt CTS results




create_routing_rule icc2_2w2s -default_reference_rule -multiplier_width 3 -multiplier_spacing 2
set_clock_routing_rules -net_type root -rule icc2_2w2s -min_routing_layer M5 -max_routing_layer M6
set_clock_routing_rules -net_type internal -rule icc2_2w2s -min_routing_layer M5 -max_routing_layer M6
create_routing_rule icc2_leaf -default_reference_rule
set_clock_routing_rules -net_type sink -rule icc2_leaf -min_routing_layer M5 -max_routing_layer M6






set_lib_cell_purpose -exclude cts [get_lib_cells *INV*]

set_lib_cell_purpose -include cts [get_lib_cells "*/NBUFFX8_LVT */NBUFFX4_LVT */NBUFFX2_LVT"]

set_lib_cell_purpose -include cts [get_lib_cells /**NBUFF*]

set_max_transition 0.120 -clock_path [get_clocks *]

clock_opt -from build_clock -to route_clock

save_block -as route_clk_56
close_blocks -force

open_block route_clk_56

set_ignored_layers -min_routing_layer M2 -max_routing_layer M6
route_global
route_track
route_detail
save_block -as route_16
