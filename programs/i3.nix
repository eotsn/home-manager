{ config, lib, pkgs, ... }:

{
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      defaultWorkspace = "workspace number 1";
      keybindings =
        let
	  modifier = config.xsession.windowManager.i3.config.modifier;
        in lib.mkOptionDefault {
          "${modifier}+Shift+x" = "exec --no-startup-id i3lock -c 000000";

          # Use wpctl to adjust volume in PipeWire
          "XF86AudioRaiseVolume" = "exec --no-startup-id wpctl set-volume @DEFAULT_SINK@ 10%+ --limit 1.0";
          "XF86AudioLowerVolume" = "exec --no-startup-id wpctl set-volume @DEFAULT_SINK@ 10%-";
          "XF86AudioMute" = "exec --no-startup-id wpctl set-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec --no-startup-id wpctl set-mute @DEFAULT_SOURCE@ toggle";

          # Use brightnessctl to adjust screen brightness
          "XF86MonBrightnessUp" = "exec --no-startup-id ${pkgs.brightnessctl}/bin/brightnessctl set +5%";
          "XF86MonBrightnessDown" = "exec --no-startup-id ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";

          # Use playerctl for media controls
          "XF86AudioPlay" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioPause" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioNext" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl next";
          "XF86AudioPrev" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl previous";
	};
      startup = [
        { command = "dex --autostart --environment i3"; notification = false; }
	{ command = "xss-lock --transfer-sleep-lock -- i3lock --no-fork"; notification = false; } 
        { command = "nm-applet"; notification = false; }
        { command = "${pkgs.picom}/bin/picom -b --backend xrender --vsync"; notification = false; }
        { command = "${pkgs.xwallpaper}/bin/xwallpaper --daemon --zoom ~/.background"; always = true; notification = false; }
	{ command = "\"setxkbmap -layout us,se -variant altgr-intl, -option grp:win_space_toggle\""; always = true; notification = false; }
      ];
    };
  };
}
