pkgs:
pkgs.buildNpmPackage rec {
  nodejs = pkgs.nodejs_24;

  name = "tldraw-server";
  src = ./.;

  npmDepsHash = "sha256-TzbImtwagskJOLjm45s4mrTT/mVrIkP6D8yFcdZDA+M=";
  dontNpmBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib

    cp -rv src $out/lib/src
    cp -rv node_modules $out/lib/node_modules
    cp -rv package.json $out/lib/src

    cat <<EOF > $out/bin/${name}
    #!${nodejs}/bin/node --experimental-strip-types

    import '$out/lib/src/main.ts';
    EOF

    chmod a+x $out/bin/${name}
  '';
}
