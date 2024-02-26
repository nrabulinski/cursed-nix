builtins.scopedImport
  {
    __findFile =
      _: tag: attrs:
      let
        # stolen from nixpkgs/lib
        # ===
        mapAttrsToList = f: attrs: map (name: f name attrs.${name}) (builtins.attrNames attrs);
        # ===
        attrs' = mapAttrsToList (name: value: ''${name}="${value}"'') attrs;
        attrString = builtins.concatStringsSep " " attrs';
        elem = "<${tag} ${attrString}>";
      in
      {
        outPath = elem;
        __functor =
          _: body:
          let
            childString = if builtins.isList body then builtins.concatStringsSep "\n" body else toString body;
          in
          if body == null then
            elem
          else
            ''
              ${elem}
              ${childString}
              </${tag}>
            '';
      };
  }
  ./doc.nix
