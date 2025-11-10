pkgs: let
  name = "tldraw-client";
  version = "1.0.0";
  src = ./.;
  npmDeps = pkgs.fetchNpmDeps {
    name = "${name}-npm-deps-${version}";
    inherit src;
    hash = "sha256-SCBGx7RQZ46Hz0Fw5nGR0njQvGC7ySfAR1BSYg8t6Zo=";
  };
  configurePhase = ''
    runHook preConfigure

    env >> .env.production

    runHook postConfigure
  '';
in {
  frontend-client = pkgs.buildNpmPackage {
    inherit version src npmDeps configurePhase;
    pname = "${name}-web";
    nodejs = pkgs.nodejs_24;

    buildPhase = ''
      npm run build:web --base=/
    '';

    installPhase = ''
      mv dist/ $out/
    '';
  };

  client-app = pkgs.rust.packages.stable.rustPlatform.buildRustPackage rec {
    inherit version src npmDeps configurePhase;
    pname = "${name}-app";

    useFetchCargoVendor = true;

    cargoLock.lockFile = ./src-tauri/Cargo.lock;
    cargoRoot = "src-tauri";
    buildAndTestSubdir = cargoRoot;
    nativeBuildInputs = with pkgs; [
      cargo-tauri.hook
      nodejs_24
      npmHooks.npmConfigHook
      pkg-config
      wrapGAppsHook4
    ];
    buildInputs =
      [pkgs.openssl]
      ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        pkgs.glib-networking
        pkgs.webkitgtk_4_1
      ];

    preFixup = ''
      gappsWrapperArgs+=(
        --set WEBKIT_DISABLE_COMPOSITING_MODE 1
        --prefix XDG_DATA_DIRS : ${pkgs.lib.concatMapStringsSep ":" (x: "${x}/share") [pkgs.adwaita-icon-theme pkgs.shared-mime-info]}
        --prefix XDG_DATA_DIRS : ${pkgs.lib.concatMapStringsSep ":" (x: "${x}/share/gsettings-schemas/${x.name}") [pkgs.glib pkgs.gsettings-desktop-schemas pkgs.gtk3]}
        --prefix GIO_EXTRA_MODULES : ${pkgs.glib-networking}/lib/gio/modules
      )
    '';
  };
}
