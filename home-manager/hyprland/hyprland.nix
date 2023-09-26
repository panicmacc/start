{ pkgs, config, lib, ... } @ args: 
#modules: { pkgs, config, lib, ... } @ args: 
let
  inherit (lib) mkEnableOption mkOption mkOptionType mkMerge mkIf types;

  cfg = config.pri.hyprland;

  hyprConfig = ''

  exec-once = polkit-agent-helper-1&
  exec-once = wal --theme sexy-tlh&
  exec-once = waybar&

  $mod = SUPER

  bind = $mod, F, exec, firefox
  bind = , Print, exec, grimblast copy area
  bind = $mod, Return, exec, kitty
  bind = $mod, Escape, exec, wlogout -p layer-shell
  bind = $mod, d, exec, wofi -G --show drun
  bind = SUPER_SHIFT, d, exec, wofi -G --show run
  bind = $mod, Space, togglefloating,
  bind = $mod, TAB, workspace, previous
  bind = $mod, q, killactive,
  #bind = SUPER_SHIFT, q, kill
  bind = SUPER_SHIFT, e, exit
  bind = ,XF86MonBrightnessDown,exec, brillo -q -U 5
  bind = ,XF86MonBrightnessUp,exec, brillo -q -A 5

  bindm = $mod, mouse:272, movewindow
  bindm = $mod, mouse:273, resizewindow
  
  #monitor = eDP-1, 2256x1504, 0x0, 1.3

  general {
  
  	gaps_in = 2
  	gaps_out = 2
  	border_size = 1
  	col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
  	col.inactive_border = rgba(595959aa)
  
  	layout = dwindle
  	no_border_on_floating = yes
  }
  
  decoration {
  	rounding = 4
  	drop_shadow = no
  	shadow_range = 4
  	shadow_render_power = 3
  	col.shadow = rgba(1a1a1aee)
  }

  general {
  }

  input {
    touchpad {
      natural_scroll = true
    }
  }

  # workspaces
  # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
  ${builtins.concatStringsSep "\n" (builtins.genList (
    x: let
      ws = let
        c = (x + 1) / 10;
      in
        builtins.toString (x + 1 - (c * 10));
    in ''
      bind = $mod, ${ws}, workspace, ${toString (x + 1)}
      bind = $mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
    ''
  )
  10)}

  '';

in {

  options = {
    pri.hyprland = mkOption {
      default = {};
      type = types.submodule [
        {
          options.enable = mkEnableOption "hyprland";
          options.hyprchan = mkEnableOption "hyprchan";
        }
      ];
    };
  };

  config =
    mkIf cfg.enable
    (mkMerge [
      { 
        wayland.windowManager.hyprland = {
          enable = true;
          extraConfig = hyprConfig;
        }; 
      }
      {
        #inherit (cfg) warnings assertions;
      }
    ]);

}
