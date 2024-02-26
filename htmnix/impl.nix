builtins.scopedImport
  {
    __findFile =
      _: tag: attrs: body:
      let
        # stolen from nixpkgs/lib
        # ===
        mapAttrsToList = f: attrs: map (name: f name attrs.${name}) (builtins.attrNames attrs);
        # ===
        attrs' = mapAttrsToList (name: value: ''${name}="${value}"'') attrs;
        attrString = builtins.concatStringsSep " " attrs';
        childString = builtins.concatStringsSep "\n" body;
      in
      ''
        <${tag} ${attrString}>
          ${childString}
        </${tag}>
      '';
  }
  ./doc.nix
