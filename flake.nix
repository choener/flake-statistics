{
  description = "Repository of statistical software";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: let

    # each system
    eachSystem = system: let
      config = { allowUnfree = true;};
      pkgs = import nixpkgs {
        inherit system;
        inherit config;
        overlays = [ self.overlay ];
      };

    in rec {
      devShell = pkgs.stdenv.mkDerivation {
        name = "statistics";
        nativeBuildInputs = [ pkgs.cmdstan ];
      }; # devShell
    }; # eachSystem

  in
    flake-utils.lib.eachDefaultSystem eachSystem // { overlay = final: prev: {
      cmdstan = final.callPackage ./cmdstan.nix {};
    };};
}
