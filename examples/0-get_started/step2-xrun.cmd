xrun \
    -uvm -access +rwc \
    +incdir+./my_fsm_pkg/src/sv \
    +incdir+./my_test_pkg/src/sv \
    +incdir+./tb/src/sv \
    my_fsm_pkg/src/sv/my_fsm_pkg.sv \
    +incdir+./simple_vip_pkg/src/sv \
    simple_vip_pkg/src/sv/simple_vip_pkg.sv \
    my_test_pkg/src/sv/my_test_pkg.sv \
    tb/src/sv/tb.sv \
    -top tb -gui