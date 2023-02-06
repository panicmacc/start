{
  description = "Panic's Essentials";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    utils = { url = "github:numtide/flake-utils"; };
    rust-overlay = { url = "github:oxalica/rust-overlay"; };
    flake-compat = {
      url = "github:edolstra/flake-compat"; 
      flake = false;
    };
    pmc-templates.url = "github:panicmacc/templates";
  };

  outputs = { self, nixpkgs, pmc-templates, utils, rust-overlay, ... }@inputs:
  
  let

    #########
    # Global settings
    #
    
    system = "x86_64-linux";
    
    #########
    # Uncomment to track stable with some unstable overrides
    #
      
    # pkgsUnstable = import nixpkgs-unstable {
    #   inherit system;
    #   config = { allowUnfree = true; };
    # };
      
    # # Cherry-pick some things from unstable
    # stable_unstable_things = self: super: with pkgsUnstable; {
    #   inherit blender cmctl glooctl postman super-slicer kicad;
    # };
    
    # stable_overlays = [
    #   rust-overlay.overlays.default
    #   stable_unstable_things
    # ];
 
    stable-overlay = self: super: {
      stable = nixpkgs;
    };
    # pkgs = import nixpkgs {
    #   inherit system;
    #   overlays = stable_overlays;
    #   config = { allowUnfree = true; };
    # };
    # Helper functions
    #lib = nixpkgs.lib;

    #########
    # Uncomment to use unstable everything
    #
    
    # overlays = [
    #   rust-overlay.overlays.default
    # ];
    
    # pkgs = import nixpkgs-unstable {
    #   inherit overlays system;
    #   config = { allowUnfree = true; };
    # };

    # # Helper functions
    # lib = nixpkgs-unstable.lib;
      
    # ##########
    # # Rust Overlay Configuration  
    # #
      
    # rustChannel = "nightly";
    
    # rustVersion = (pkgs.rust-bin.${rustChannel}.latest.default.override {
    #   extensions = [ "rust-src" ];
    #   targets = [ "wasm32-unknown-unknown" ];
    # });
        
    # rustPlatform = pkgs.makeRustPlatform {
    #   cargo = rustVersion;
    #   rustc = rustVersion;
    # };
    
    # #########~

    # # `buildInputs` is for runtime dependencies. They need to match the target architecture.
    # buildInputs = with pkgs; [
    #   alsa-lib
    #   egl-wayland
    #   glew-egl
    #   glib
    #   libGL
    #   libGLU
    #   libglvnd
    #   libxkbcommon
    #   mesa
    #   openssl.dev
    #   vulkan-loader
    #   wayland
    #   wayland-protocols
    #   xorg.libxcb
    #   xorg.libX11
    #   xorg.libXi
    #   pkgconfig
    #   rust-analyzer
    #   udev
    #   alsaLib
    #   #xlibsWrapper
    #   xorg.libXcursor
    #   xorg.libXrandr
    #   xorg.libXi
    #   vulkan-tools
    #   vulkan-headers
    #   vulkan-loader
    #   vulkan-validation-layers        
    #   atk
    #   gsettings-desktop-schemas
    #   gtk3
    #   gdk-pixbuf
    # ];

    # # `nativeBuildInputs` is for build dependencies. They need to match the build host architecture.
    # #  These get automatically added to PATH at build time.
    # nativeBuildInputs = with pkgs; [
    #   binaryen
    #   cargo
    #   jq
    #   nodejs
    #   pkgconfig
    #   rust-analyzer
    #   rustVersion
    #   python3
    #   speechd
    #   trunk
    #   unzip
    #   vulkan-loader
    #   wasm-bindgen-cli
    #   wasm-pack
    #   zip
    # ];

    templates = pmc-templates.templates;

  in {
    inherit templates;
    overlays = {
      inherit rust-overlay;
      inherit stable-overlay;
      # stable-overlay = self: super: {
      #   flake-utils = utils;
      #   stable = nixpkgs;
      # };
    };
    nixpkgs-stable = nixpkgs;
  };
}
