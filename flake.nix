{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs = {...} @ inputs: let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs {inherit system;};
  in rec {
    packages.${system}.tldraw-server = (import ./server) pkgs;
    devShells.${system}.default = pkgs.mkShell {
      inputsFrom = [
        packages.${system}.tldraw-server
      ];
      
      packages = [];
    };
  };
}
