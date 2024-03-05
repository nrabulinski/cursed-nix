let
  inherit (builtins)
    mul
    isPath
    isString
    pathExists
    readFileType
    readDir
    substring
    stringLength
    attrNames
    filter
    ;
  hasPrefix =
    prefix: str:
    let
      pLen = stringLength prefix;
      sLen = stringLength str;
    in
    if prefix == "" then
      true
    else if pLen >= sLen then
      prefix == str
    else
      prefix == (substring 0 pLen str);
  hasSuffix =
    suffix: str:
    let
      pLen = stringLength suffix;
      sLen = stringLength str;
    in
    if suffix == "" then
      true
    else if pLen >= sLen then
      suffix == str
    else
      suffix == (substring (sLen - pLen) pLen str);

  glob =
    path: suffix:
    let
      isRoot = pathExists path && readFileType path == "directory";
      parent = dirOf path;
      dirToSearch =
        if isRoot then
          path
        else
          assert pathExists parent;
          parent;

      path' = toString path;
      parent' = toString parent;
      pathLen = stringLength path';
      parentLen = stringLength parent';
      prefix = if isRoot then "" else substring (parentLen + 1) (pathLen - parentLen - 1) path';

      entries = attrNames (readDir dirToSearch);
      entries' = filter (name: hasPrefix prefix name && hasSuffix suffix name) entries;
    in
    map (f: dirToSearch + "/${f}") entries';
in
{
  __mul = lhs: rhs: if isPath lhs && isString rhs then glob lhs rhs else mul lhs rhs;
}
