{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.11";

    perch.url = "github:haras-unicorn/perch/refs/tags/1.0.3";
    perch.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { perch, ... }@inputs:
    perch.lib.flake.make {
      inherit inputs;
      root = ./.;
      prefix = "scripts/flake";
    };
}
