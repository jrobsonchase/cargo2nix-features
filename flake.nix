{
  description = "foo";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    cargo2nix = {
      url = "github:cargo2nix/cargo2nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay, cargo2nix, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = cargo2nix.overlays.${system};
        };

        rustChannel = "1.56.0";

        rustPkgs = pkgs.rustBuilder.makePackageSet' {
          inherit rustChannel;
          packageFun = import ./Cargo.nix;
        };
      in
      rec {
        inherit rustPkgs;
        packages = builtins.mapAttrs (name: value: value { }) rustPkgs.workspace;
        defaultPackage = packages.foo;
      });
}
