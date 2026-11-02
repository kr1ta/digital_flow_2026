# 1. Загрузка процедур и импорт проекта.
source $::env(FLOW_DIR)/steps.innovus.tcl
user_init_design
global_net

# 2. Геометрия floorplan.
set_io_flow_flag 0
create_floorplan -site CoreSite -die_size 201.12 201.18 20.16 20.16 20.16 20.16

# Все сигнальные пины слева, группой по центру.
set_db assign_pins_edit_in_batch true
edit_pin -fix_overlap 1 -unit micron -spread_direction clockwise -side Left -layer 3 -spread_type center -spacing 0.48 -pin [get_db ports .name]
set_db assign_pins_edit_in_batch false

# 3. Настройки и создание колец питания.
set_db add_rings_target default
set_db add_rings_extend_over_row 0
set_db add_rings_ignore_rows 0
set_db add_rings_avoid_short 0
set_db add_rings_skip_shared_inner_ring none
set_db add_rings_stacked_via_top_layer TopMetal2
set_db add_rings_stacked_via_bottom_layer Metal1
set_db add_rings_via_using_exact_crossover_size 1
set_db add_rings_orthogonal_only true
set_db add_rings_skip_via_on_pin {  standardcell }
set_db add_rings_skip_via_on_wire_shape {  noshape }
add_rings -nets {VDD VSS} -type core_rings -follow core -layer {top Metal1 bottom Metal1 left Metal2 right Metal2} -width {top 4 bottom 4 left 4 right 4} -spacing {top 2 bottom 2 left 2 right 2} -offset {top 4 bottom 4 left 4 right 4} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none

# 4. Шины питания вдоль rows.
set_db route_special_via_connect_to_shape { noshape }
route_special -connect core_pin -layer_change_range { Metal1(1) TopMetal2(7) } -block_pin_target nearest_target -core_pin_target first_after_row_end -allow_jogging 1 -crossover_via_layer_range { Metal1(1) TopMetal2(7) } -nets { VDD VSS } -allow_layer_change 1 -target_via_layer_range { Metal1(1) TopMetal2(7) }

# 5. Четыре именованных периферийных hard placement blockages.
create_place_blockage -rects {{0.0 0.0 16.16 201.18}} -type hard -no_cut_by_core
create_place_blockage -rects {{184.96 0.0 201.12 201.18}} -type hard -no_cut_by_core
create_place_blockage -rects {{16.16 0.0 184.96 16.16}} -type hard -no_cut_by_core
create_place_blockage -rects {{16.16 185.02 184.96 201.18}} -type hard -no_cut_by_core
