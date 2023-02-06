{
  description = "Panic's Essentials";

  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-22.11";
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
  };
}
