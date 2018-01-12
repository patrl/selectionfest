{ pkgs ? import <nixpkgs> { }, ghc ? pkgs.ghc }:

pkgs.haskell.lib.buildStackProject {
  name = "selectionfest";
  inherit ghc;
  buildInputs = with pkgs; [
    zlib
    # This is necessary for the deploy command
  ];
  LANG = "en_US.UTF-8";
  TMPDIR = "/tmp";

}
