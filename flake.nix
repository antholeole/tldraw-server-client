{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  };

  outputs = {...} @ inputs: let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs {inherit system;};
  in rec {
    packages.${system} = let
      client = (import ./client) pkgs;
    in {
      tldraw-server = (import ./server) pkgs;

      web-frontend = client.frontend-client;
      client-app = client.client-app;
      client-app-example = packages.${system}.client-app.overrideAttrs {
        VITE_SERVER_URL = "localhost:3000";
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      inputsFrom = [
        packages.${system}.tldraw-server
        packages.${system}.web-frontend
        packages.${system}.client-app
      ];

      # https://github.com/tauri-apps/tauri/issues/5711#issuecomment-1482705393
      # required for dev tools
      XDG_DATA_DIRS = let
        base = pkgs.lib.concatMapStringsSep ":" (x: "${x}/share") [
          pkgs.adwaita-icon-theme
          pkgs.shared-mime-info
        ];
        gsettings_schema = pkgs.lib.concatMapStringsSep ":" (x: "${x}/share/gsettings-schemas/${x.name}") [
          pkgs.glib
          pkgs.gsettings-desktop-schemas
          pkgs.gtk3
        ];
      in "${base}:${gsettings_schema}";

      packages = [];
    };
  };
}
