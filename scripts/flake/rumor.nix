{
  self,
  pkgs,
  lib,
  ...
}:

let
  buildInputs = self.lib.rumor.mkBuildInputs pkgs;

  shebang = ''#!${pkgs.nushell}/bin/nu --stdin'' + ''\n$env.PATH = "${lib.makeBinPath buildInputs}"'';

  version = "3.0.0";
in
{
  flake.lib.rumor.mkBuildInputs =
    pkgs:
    with pkgs;
    [
      nushell
      nlohmann_json_schema_validator
      age
      sops
      nebula
      openssl
      mkpasswd
      mo
      openssh
      vault
      vault-medusa
      coreutils
      libargon2
      ssss
      util-linux
    ]
    ++ (lib.optionals pkgs.hostPlatform.isLinux [
      cockroachdb
      systemd
      bubblewrap
    ]);

  defaultPackage = true;
  packageNixpkgs = {
    config.allowUnfree = true;
  };
  package = pkgs.stdenvNoCC.mkDerivation {
    inherit version;

    pname = "rumor";

    src = self;

    inherit buildInputs;

    patchPhase = ''
      runHook prePatch

      sed \
        -i 's|#!/usr/bin/env -S nu --stdin|${shebang}|g' \
        ./src/main.nu

      sed \
        -i 's|\$"(\$env.FILE_PWD)/schema.json"'"|\"$out/share/rumor/schema.json\"|g" \
        ./src/main.nu
      sed \
        -i 's|\$"(\$env.FILE_PWD)/main.nu"'"|\"$out/bin/rumor\"|g" \
        ./src/main.nu
      sed \
        -i "s|^\\s*let version = \".*\"|let version = \"${version}\"|" \
        src/main.nu

      runHook postPatch
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/rumor
      cp ./src/schema.json $out/share/rumor

      mkdir -p $out/bin
      cp ./src/main.nu $out/bin/rumor
      chmod +x $out/bin/rumor

      runHook postInstall
    '';

    meta = {
      description = "A small tool for generating, encrypting, and managing secrets";
      mainProgram = "rumor";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
    };
  };
}
