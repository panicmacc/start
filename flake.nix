{
  description = "Panic's Essentials";

  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-23.05";
    flake-utils = { url = "github:numtide/flake-utils"; };
    rust-overlay = { url = "github:oxalica/rust-overlay"; };
    pri-templates.url = "github:panicmacc/templates";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-stable";
  };

  outputs = { self, flake-utils, nixpkgs-stable, pri-templates, rust-overlay, home-manager, ... }@inputs:
  
  let

    templates = pri-templates.templates;

  in {

    inherit flake-utils;
    inherit home-manager;
    inherit nixpkgs-stable;
    inherit templates;

    overlays = { inherit rust-overlay; };

    # Downstream systems can call this to generate a sane default config for their
    #  Rust environments.
    mkRustDefaults = pkgs: rec {
      rustChannel = "nightly";
      rustVersion = ( pkgs.rust-bin.${rustChannel}.latest.default.override {
        extensions = [ "rust-src" ];
        targets = [ "wasm32-unknown-unknown" ];
      });
      rustPlatform = pkgs.makeRustPlatform {
        cargo = rustVersion;
        rustc = rustVersion;
      };
    };

    homeManagerModules = {
      hyprland = import ./home-manager/hyprland/hyprland.nix;
    };

  };
}
