{
  description = "Panic's Essentials";

  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-23.05";
    flake-utils = { url = "github:numtide/flake-utils"; };
    rust-overlay = { url = "github:oxalica/rust-overlay"; };
    pri-templates.url = "github:panicmacc/templates";
  };

  outputs = { self, flake-utils, nixpkgs-stable, pri-templates, rust-overlay, ... }@inputs:
  
  let
    templates = pri-templates.templates;

  in {
    inherit templates;
    overlays = {
      inherit rust-overlay;
    };
    inherit flake-utils;
    inherit nixpkgs-stable;

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
  };
}
