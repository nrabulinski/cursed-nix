let
  pkgs = import <nixpkgs> {};
  lib = pkgs.lib;

  _startMarker = "__START__";
  _endMarker = "__END__";

  dropFirst = lib.drop 1;
  dropLast = lst: lib.sublist 0 (lib.length lst - 1) lst;

  yeet = s: builtins.unsafeDiscardStringContext (builtins.unsafeDiscardOutputDependency s);

  getContent = drvPath: let
    d = builtins.readFile drvPath;
    _valid = builtins.match ".*${lib.escapeRegex _startMarker}.*${lib.escapeRegex _endMarker}.*" d != null;
    content = lib.pipe d [
      (lib.splitString _startMarker)
      dropFirst
      (lib.concatStringsSep _startMarker)
      (lib.splitString _endMarker)
      dropLast
      (lib.concatStringsSep _endMarker)
    ];
  in if _valid then content else (import drvPath).outPath;
  
  htmlSafe = str: let
    ctx = builtins.getContext str;
    ctxNames = lib.attrNames ctx;
    _recurSubDrv = restNames: strs: let
      h = lib.head restNames;
      d = import h;
      last = (lib.length restNames) == 1;
      o = getContent h;
      mapStr = s: let
        m = lib.splitString (yeet d.outPath) s;
        __m = if last
          then map lib.strings.escapeXML
          else _recurSubDrv (lib.tail restNames);
        out = __m m;
      in lib.concatStringsSep o out;
    in map mapStr strs;
    final = _recurSubDrv ctxNames [str];
    final' = assert (lib.length final == 1); lib.head final;
  in if builtins.hasContext str
    then yeet final'
    else lib.strings.escapeXML str;

  raw = str: derivation {
    name = "a";
    system = "a";
    builder = "a";
    rawContent = "${_startMarker}${yeet str}${_endMarker}";
  };
in {
  inherit
    htmlSafe
    raw
    pkgs;
}
