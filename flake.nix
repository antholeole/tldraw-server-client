{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs = {...} @ inputs: let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs {inherit system;};
  in rec {
    packages.${system} = {
      tldraw-server = (import ./server) pkgs;

      web-frontend = (import ./client) pkgs;
      web-frontend-example = packages.${system}.web-frontend.overrideAttrs {
        VITE_SERVER_URL = "testing";
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      inputsFrom = [
        packages.${system}.tldraw-server
        packages.${system}.web-frontend
      ];

      packages = [];
    };
  };
}
