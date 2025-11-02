let
  inherit (import ./io.nix)
    do
    set
    print
    if'
    p
    read
    break
    loop
    run
    ;

  banner = ''

    /***********************************************\
     * Nix REPL, written in Nix.                   *
     * After typing the code you want to evaluate, * 
     * press enter and then ^D (Ctrl-D).           *
    \***********************************************/
  '';
  prompt = "nix-repl>";

  isQuit = code: (builtins.match "[[:space:]]*:q[[:space:]]*" code) != null;
  repl = do [
    (print (p prompt))
    (set "code" read)
    (if' (io: isQuit io.code) break)
    (set "path" (io: builtins.toFile "repl.nix" io.code))
    (set "result" (io: import io.path))
    (print (io: io.result))
  ];

  main = do [
    (print (p banner))
    (loop repl)
    (print (p "bye!"))
  ];
in
run main
