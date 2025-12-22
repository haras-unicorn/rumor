{ ... }:

{
  flake.lib.shells.mkShell =
    pkgs:
    pkgs.mkShell {
      packages = with pkgs; [
        git
        nushell
        just
        fd
      ];
    };

  flake.lib.shells.mkTestShell =
    pkgs:
    pkgs.mkShell {
      packages = with pkgs; [
        pueue
        gum
        delta
        coreutils
      ];
    };

  flake.lib.shells.mkCiShell =
    pkgs:
    pkgs.mkShell {
      packages = with pkgs; [
        nixfmt-rfc-style
        nixVersions.stable

        markdownlint-cli
        nodePackages.markdown-link-check

        nodePackages.cspell

        nodePackages.prettier
      ];
    };

  flake.lib.shells.mkToolShell =
    pkgs:
    pkgs.mkShell {
      packages = with pkgs; [
        nil
        nixfmt-rfc-style
        nixVersions.stable

        markdownlint-cli
        nodePackages.markdown-link-check
        marksman

        nodePackages.cspell

        nodePackages.vscode-langservers-extracted
        nodePackages.prettier
        nodePackages.yaml-language-server
        taplo
      ];
    };
}
