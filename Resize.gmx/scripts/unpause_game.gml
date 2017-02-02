//unpause_game()

instance_activate_all()

///Initialise Ad

//ads_enable((global.width/2)-117, 0, 0)

//ads_move((global.width/2)-(ads_get_display_width(0)/2), global.height-ads_get_display_height(0), 0)

if instance_number(obj_pause_menu) > 0
{
    with (obj_pause_menu)
    {
        instance_destroy()
    }
}

if instance_number(obj_pause_button_unpause) > 0
{
with(obj_pause_button_unpause)
{
    instance_destroy()
}
}

if instance_number(obj_pause_button_retry) > 0
{
with(obj_pause_button_retry)
{
    instance_destroy()
}
}

if instance_number(obj_pause_button_home) > 0
{
with(obj_pause_button_home)
{
    instance_destroy()
}
}

if instance_number(obj_pause_CS) > 0
{
with(obj_pause_CS)
{
    instance_destroy()
}
}

if instance_number(obj_pause_button) > 0
{
    obj_pause_button.pause = false
}
