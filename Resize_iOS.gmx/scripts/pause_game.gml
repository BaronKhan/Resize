//pause_game()

background_hspeed[0] = 0
background_vspeed[0] = 0

background_hspeed[1] = 0
background_vspeed[1] = 0

//ads_disable(0)

instance_create(0,0,obj_pause_menu)

instance_create(view_xview+display_get_gui_width()/2, view_yview+display_get_gui_height()/2,obj_pause_button_unpause)
instance_create(view_xview+display_get_gui_width()/2, view_yview+display_get_gui_height()/2,obj_pause_button_retry)
instance_create(view_xview+display_get_gui_width()/2, view_yview+display_get_gui_height()/2,obj_pause_button_home)

instance_create(view_xview+display_get_gui_width()/2, (view_yview+display_get_gui_height()/5)*4,obj_pause_CS)


instance_deactivate_all(true)

instance_activate_object(obj_pause_menu)

instance_activate_object(obj_pause_button_unpause)

instance_activate_object(obj_pause_button_retry)

instance_activate_object(obj_pause_button_home)

instance_activate_object(obj_pause_CS)

instance_activate_object(obj_fixres_iOS)

instance_activate_object(obj_esc_endgame)

if instance_number(obj_pause_button) > 0
{
    obj_pause_button.pause = true
}