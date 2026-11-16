#  ___       _ _
# |_ _|_ __ (_) |_
#  | || '_ \| | __|
#  | || | | | | |_
# |___|_| |_|_|\__|

source $::env(FLOW_DIR)/steps.innovus.tcl

gui_show
gui_fit

# 1. Инициализация дизайна
user_init_design

# 2. Подключение питания и земли
global_net

# 3. Загрузка floorplan
user_read_floorplan

# 4. Подготовка к placement
user_preplace

# 5. Placement и оптимизация
user_place
global_net

# 6. Clock Tree Synthesis
user_clock_tree_synthesis
global_net

# 7. Routing
user_route
global_net

# 8. Извлечение паразитных RC
user_extract_rc

# 9. Финальный статический анализ тайминга
user_sta
