{ self, pkgs, ... }:

{
  defaultDevShell = true;
  devShellNixpkgs = {
    config.allowUnfree = true;
  };
  devShell = pkgs.mkShell {
    VAULT_DEV_ADDR = "127.0.0.1:8202";
    VAULT_ADDR = "http://127.0.0.1:8202";
    VAULT_TOKEN = "root";

    inputsFrom = [
      (self.lib.shells.mkShell pkgs)
      (self.lib.shells.mkToolShell pkgs)
      (self.lib.shells.mkTestShell pkgs)
    ];

    buildInputs = self.lib.rumor.mkBuildInputs pkgs;

    packages = with pkgs; [
      mdbook
    ];
  };
}
