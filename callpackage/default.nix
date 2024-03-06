rec {
  pkgs = import <nixpkgs> { };
  inherit (pkgs) lib;

  callPackageScopedWith = autoArgs: fn: builtins.scopedImport autoArgs fn;

  callPackageScoped = callPackageScopedWith pkgs;

  hello = callPackageScoped ./package.nix;
}
