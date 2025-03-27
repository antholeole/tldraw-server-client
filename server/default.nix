pkgs: let
  nodejs = pkgs.nodejs_23;
in
  pkgs.buildNpmPackage rec {
    inherit nodejs;

    name = "tldraw-server";
    src = ./.;

    npmDepsHash = "sha256-Ooz80vQ9lurmFIMBHJwmIop1rkhPG1+0qPYMvOBllpY=";
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
