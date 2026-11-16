if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name typ\
   -timing\
    [list ${::IMEX::libVar}/mmmc/sg13g2_stdcell_typ_1p20V_25C.lib]
create_opcond -name typ -process 1 -voltage 1.2 -temperature 25
create_timing_condition -name typ\
   -library_sets [list typ]\
   -opcond typ
create_rc_corner -name typ\
   -pre_route_res 1\
   -post_route_res 1\
   -pre_route_cap 1\
   -post_route_cap 1\
   -post_route_cross_cap 1\
   -pre_route_clock_res 0\
   -pre_route_clock_cap 0\
   -temperature 25
create_delay_corner -name typ\
   -timing_condition {typ}\
   -rc_corner typ
create_constraint_mode -name func\
   -sdc_files\
    [list /dev/null]
create_analysis_view -name typ -constraint_mode func -delay_corner typ
set_analysis_view -setup [list typ] -hold [list typ]
