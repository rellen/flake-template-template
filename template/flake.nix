{
  description = "<insert description here>";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      treefmt-nix,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
        pkgs = nixpkgs.legacyPackages.${system};

        # other packages e.g.
        # haskellPackages = pkgs.haskellPackages;
      in
      {
        # for `nix fmt`
        formatter = treefmtEval.config.build.wrapper;

        # for `nix flake check`
        checks = {
          formatting = treefmtEval.config.build.check self;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # <add packages here>

            # formatting
            treefmt
            nixfmt-rfc-style
          ];

          shellHook = ''
            echo "<insert name here> development environment loaded!"
          '';
        };
      }
    );
}
