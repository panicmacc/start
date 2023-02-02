{
  description = "Panic's Essentials";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    utils = { url = "github:numtide/flake-utils"; };
    rust-overlay = { url = "github:oxalica/rust-overlay"; };
    flake-compat = {
      url = "github:edolstra/flake-compat"; 
      flake = false;
    };
    pmc-templates.url = "github:panicmacc/templates";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, pmc-templates, utils, rust-overlay, ... }@inputs:
  
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
    
    overlays = [
      rust-overlay.overlays.default
    ];
    
    pkgs = import nixpkgs-unstable {
      inherit overlays system;
      config = { allowUnfree = true; };
    };

    # Helper functions
    lib = nixpkgs-unstable.lib;
      
    ##########
    # Rust Overlay Configuration  
    #
      
    rustChannel = "nightly";
    
    rustVersion = (pkgs.rust-bin.${rustChannel}.latest.default.override {
      extensions = [ "rust-src" ];
      targets = [ "wasm32-unknown-unknown" ];
    });
        
    rustPlatform = pkgs.makeRustPlatform {
      cargo = rustVersion;
      rustc = rustVersion;
    };
    
    #########~

    # `buildInputs` is for runtime dependencies. They need to match the target architecture.
    buildInputs = with pkgs; [
      alsa-lib
      egl-wayland
      glew-egl
      glib
      libGL
      libGLU
      libglvnd
      libxkbcommon
      mesa
      openssl.dev
      vulkan-loader
      wayland
      wayland-protocols
      xorg.libxcb
      xorg.libX11
      xorg.libXi
      # Adding these to try to get bevy to build
      pkgconfig
      rust-analyzer
      udev
      alsaLib
      #xlibsWrapper
      xorg.libXcursor
      xorg.libXrandr
      xorg.libXi
      vulkan-tools
      vulkan-headers
      vulkan-loader
      vulkan-validation-layers        
      #for blackjack
      atk
      gsettings-desktop-schemas
      gtk3
      gdk-pixbuf
    ];

    # `nativeBuildInputs` is for build dependencies. They need to match the build host architecture.
    #  These get automatically added to PATH at build time.
    nativeBuildInputs = with pkgs; [
      binaryen
      cargo
      jq
      nodejs
      pkgconfig
      rust-analyzer
      rustVersion
      python3
      speechd
      trunk
      unzip
      vulkan-loader
      wasm-bindgen-cli
      wasm-pack
      zip
    ];

    templates = pmc-templates.templates;

  in rec {

    packages = utils.lib.flattenTree {
      inherit nixpkgs;
    };

    # packages = utils.lib.flattenTree {
    #   deck = rustPlatform.buildRustPackage {
          
    #       pname = "deck";
    #       version = "0.0.1";
    #       src = self;
    #       cargoLock.lockFile = ./Cargo.lock;
    #       cargoHash = "sha256-B8CFQ595BEMMLncJuD3xcnLrEEuaQadEp+CiFksi3c8=";
          
    #       meta = with lib; {
    #         description = "Utility for managing systems, users, and projects.";
    #         license = licenses.unlicense;
    #       };
          
    #   };
    # };
    
    # defaultPackage.x86_64-linux = packages.deck;
    
    # `nix develop`
    # devShell = pkgs.mkShell {
    #   inputsFrom = builtins.attrValues self.packages.${system};

    #   buildInputs = buildInputs ++ (with pkgs; [
    #   ]);

    #   # Here you can add any tools you need present in your development environment, 
    #   #  but that may not be needed at build or runtime. 
    #   nativeBuildInputs = nativeBuildInputs ++ (with pkgs; [
    #     cargo-watch
    #     nixpkgs-fmt
    #     rust-analyzer
    #     rust-bin.${rustChannel}.latest.rust-analysis
    #     vulkan-tools
    #   ]);
      
    #   LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
    #   RUST_SRC_PATH = 
    #     "${pkgs.rust-bin.${rustChannel}.latest.rust-src}/lib/rustlib/src/rust/library";

    #   shellHook = ''
    #     export PATH="$HOME/.cargo/bin:$PATH"
    #   '';
    # };

    # templates = {
    #   golang-basic = {
    #     path = ./templates/golang-basic;
    #     description = "A simple Golang app.";
    #   };
    #   python-basic = {
    #     path = ./templates/python-basic;
    #     description = "A simple Python app.";
    #   };
    #   rust-basic = {
    #     path = ./templates/rust-basic;
    #     description = "A simple Rust CLI app.";
    #   };
    #   rust-iot-nrf52 = {
    #     path = ./templates/rust-iot-nrf52;
    #     description = "Rust IoT on nRF52.";
    #   };
    #   rust-node = {
    #     path = ./templates/rust-node;
    #     description = "A simple Rust CLI app.";
    #   };
    #   rust-sam = {
    #     path = ./templates/rust-sam;
    #     description = "A simple Rust CLI app.";
    #   };
    #   tex-basic = {
    #     path = ./templates/tex-basic;
    #     description = "A simple LaTeX Document.";
    #   };
    #   vagrant-basic = {
    #     path = ./templates/vagrant-basic;
    #     description = "Basic vagrant boilerplate.";
    #   };
    # };
    inherit templates;
  };
}
