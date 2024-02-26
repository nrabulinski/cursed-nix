with import ./impl.nix;

htmlSafe ''
  <script>console.log("alert")</script> <- this will be escaped (and that arrow too!)
  ${raw "<h1>hello</h1>"}
  store paths are fine too: ${pkgs.hello}
''
