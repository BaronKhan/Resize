//create_survival_object(object, relative x , relative y)

obj = argument0   //The object to create
rel_x = argument1 //The position relative to view_xview+(view_wview/2)
rel_y = argument2 //The position relative to view_yview (beware of clipping)

if view_yview > 1280
{
    return instance_create(view_xview+(view_wview/2) + rel_x, view_yview - 128 + rel_y, obj)
}