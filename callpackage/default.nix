rec {
  pkgs = import <nixpkgs> { };
  inherit (pkgs) lib;

  callPackageScopedWith =
    autoArgs: f: args:
    let
      res = builtins.scopedImport (autoArgs // args) f;
      override = callPackageScopedWith autoArgs f;
    in
    if builtins.isAttrs res then (res // { inherit override; }) else res;

  callPackageScoped = callPackageScopedWith pkgs;

  myhello = callPackageScoped ./package.nix { };
  myhello-cross = myhello.override { stdenv = pkgs.pkgsCross.musl64.stdenv; };
  myhello-mod = myhello.overrideAttrs (old: { pname = "other"; });
}
