pkgs: pkgs.buildNpmPackage rec {
      pname = "home-server-client";
      version = "1.0.0";
      src = ./.;
      npmDeps = pkgs.fetchNpmDeps {
        name = "${pname}-npm-deps-${version}";
        inherit src;
        hash = "sha256-9eQFCVz/+8wYQjb+JlkydjZCIABEAFxVsI0sY8VE1FU=";
      };

      # TODO: we should validate the env by using something like
      # https://github.com/Julien-R44/vite-plugin-validate-env
      # at build time
      configurePhase = ''
        env >> .env.production
      '';

      buildPhase = ''
        npm run build:web --base=/
      '';

      installPhase = ''
        mv dist/ $out/
      '';
    }


# {
#   packages = {
#     # you should add all env vars found in .env.development to this or else
#     # it will fail to build.
#     client-frontend = 
#     # TODO: move elsewhere
#     client-app = pkgs.rust.packages.stable.rustPlatform.buildRustPackage rec {
#       pname = "home-server-client-app";
#       version = "1.0.0";
#       cargoHash = "sha256-nLfBITr4G+6Y0S+aKZr0PkSXTGwfor4n9g+1Q/Qu6ag=";
#       src = ./.;

#       npmDeps = fetchNpmDeps {
#         name = "${pname}-npm-deps-${version}";
#         inherit src;
#         hash = "sha256-oRWShW57FRrzI4NJcjCnN+XOe/bha6GZcWenLdUjS0c=";
#       };

#       nativeBuildInputs = [
#         cargo-tauri.hook
#         nodejs
#         npmHooks.npmConfigHook
#         pkg-config
#         wrapGAppsHook4
#       ];

#       buildInputs =
#         [openssl]
#         ++ lib.optionals stdenv.hostPlatform.isLinux [
#           glib-networking
#           webkitgtk_4_1
#         ];

#       cargoRoot = "src-tauri";
#       buildAndTestSubdir = cargoRoot;
#     };
#   };
# }
