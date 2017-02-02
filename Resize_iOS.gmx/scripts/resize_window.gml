/*
----Script:--------------------------------------------------------------------
window_resize(gap)
Written by Osmium @ GMC.
Resize the window if not fully displayed.
Works flawlessly with views as well!
----Instructions:--------------------------------------------------------------
gap = the distance between the browser and the window in pixels.
      Refer to this image here: http://i.imgur.com/5z1sf.png
Use the above script in the step event.
-------------------------------------------------------------------------------
Warning: DO NOT use virtual keys! Use the alternate touch scripts instead(i.e touch_check, touch_pressed or touch_released)!
*/
var g,w,h,r;
g = argument0  //the gap between the browser and window in pixels.
w = room_width
h = room_height
r = h/w //the ratio of height to width (i.e h:w)
//Reset the values of width and height if views are enabled
if view_enabled == true
{
 w = view_wview
 h = view_hview
 r = h/w
}
//Resize the window only for windows, mac or linux operating systems
//if os_type == os_windows or os_type == os_macosx or os_type == os_linux
//{
//if browser_height < h
if h != browser_height - g
{
 h = browser_height - g
 w = h/r
 if view_enabled == true
 {
 view_wport = w 
 view_hport = h
 }
 window_set_size(w,h)
}
//}