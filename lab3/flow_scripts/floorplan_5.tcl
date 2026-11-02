# 1. Загрузка процедур и импорт проекта.
source $::env(FLOW_DIR)/steps.innovus.tcl
user_init_design
global_net

# 2. Геометрия floorplan.
set_io_flow_flag 0
create_floorplan -site CoreSite -core_size 170.88 170.94 15 15 15 15

# 3. Сигнальные пины.
set_db assign_pins_edit_in_batch true
edit_pin -fix_overlap 1 -unit micron -spread_direction clockwise -side Top -layer 3 -spread_type center -spacing 0.48 -pin clk
edit_pin -fix_overlap 1 -spread_direction clockwise -side Left -layer 3 -spread_type range -start 0.0 70.266 -end 0.0 130.494 -pin {{data_a[0]} {data_a[1]} {data_a[2]} {data_a[3]} {data_a[4]} {data_a[5]} {data_a[6]} {data_a[7]} {data_a[8]} {data_a[9]} {data_a[10]} {data_a[11]} {data_a[12]} {data_a[13]} {data_a[14]} {data_a[15]} {data_b[0]} {data_b[1]} {data_b[2]} {data_b[3]} {data_b[4]} {data_b[5]} {data_b[6]} {data_b[7]} {data_b[8]} {data_b[9]} {data_b[10]} {data_b[11]} {data_b[12]} {data_b[13]} {data_b[14]} {data_b[15]} {operation[0]} {operation[1]}}
edit_pin -pin_width 0.2 -pin_depth 0.72 -fix_overlap 1 -spread_direction counterclockwise -side Right -layer 3 -spread_type range -start 200.64 20.076 -end 200.64 180.684 -pin {{result[0]} {result[1]} {result[2]} {result[3]} {result[4]} {result[5]} {result[6]} {result[7]} {result[8]} {result[9]} {result[10]} {result[11]} {result[12]} {result[13]} {result[14]} {result[15]} {result[16]} {result[17]} {result[18]} {result[19]} {result[20]} {result[21]} {result[22]} {result[23]} {result[24]} {result[25]} {result[26]} {result[27]} {result[28]} {result[29]} {result[30]} {result[31]}}
edit_pin -fix_overlap 1 -unit micron -spread_direction counterclockwise -side Bottom -layer 3 -spread_type center -spacing 0.48 -pin {rst_n valid_in valid_out}

# 4. Кольца питания.
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
add_rings -nets VSS -type core_rings -follow io -layer {top TopMetal1 bottom TopMetal1 left TopMetal2 right TopMetal2} -width {top 4.01 bottom 4.01 left 4.01 right 4.01} -spacing {top 2.01 bottom 2.01 left 2.01 right 2.01} -offset {top 4.01 bottom 4.01 left 4.01 right 4.01} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none
add_rings -nets VDD -type core_rings -follow io -layer {top TopMetal1 bottom TopMetal1 left TopMetal2 right TopMetal2} -width {top 4.01 bottom 4.01 left 4.01 right 4.01} -spacing {top 2.01 bottom 2.01 left 2.01 right 2.01} -offset {top 10.03 bottom 10.03 left 10.03 right 10.03} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none

# 5. Два центральных вертикальных проводника питания.
# Координаты рассчитаны для die 200.64 x 200.76, начало (0, 0).
# Оси X: VDD = 97.31, VSS = 103.33; ширина 4.01, зазор 2.01.
set_db edit_wire_type special
set_db edit_wire_layer_horizontal TopMetal1
set_db edit_wire_layer_vertical TopMetal2
set_db edit_wire_width_horizontal 4.01
set_db edit_wire_width_vertical 4.01

# VDD: нижняя и верхняя стороны внутреннего кольца.
set_db edit_wire_nets VDD
edit_add_route_point 97.31 12.035
edit_add_route_point 97.31 188.725
edit_end_route_point 97.31 188.725

# VSS: нижняя и верхняя стороны внешнего кольца.
set_db edit_wire_nets VSS
edit_add_route_point 103.33 6.015
edit_add_route_point 103.33 194.745
edit_end_route_point 103.33 194.745

# 6. Вырезание периферийных rows.
split_row -area 0 0 16.04 200.76
split_row -area 184.60 0 200.64 200.76
split_row -area 16.04 0 184.60 16.04
split_row -area 16.04 184.72 184.60 200.76

# 7. Итоговые blockages.
create_place_blockage -area 40.13 114.43 72.23 148.56 -type hard
create_route_blockage -layers {Metal3} -area 130.42 54.21 162.52 88.33

# 8. Шины питания вдоль rows, после создания blockages.
set_db route_special_via_connect_to_shape { noshape }
route_special -connect core_pin -layer_change_range { Metal1(1) TopMetal2(7) } -block_pin_target nearest_target -core_pin_target first_after_row_end -allow_jogging 1 -crossover_via_layer_range { Metal1(1) TopMetal2(7) } -nets { VDD VSS } -allow_layer_change 1 -target_via_layer_range { Metal1(1) TopMetal2(7) }
