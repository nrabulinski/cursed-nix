let
  inherit (import ./io.nix)
    do
    set
    print
    p
    while
    run
    ;


  main = do [
    (set "x" (p 0))
    (while (io: io.x < 5) (do [
      (set "y" (p 0))
      (while (io: io.y < 5) (do [
        (print (io: "{ ${toString io.x}, ${toString io.y} }"))
        (set "y" (io: io.y + 1))
      ]))
      (set "x" (io: io.x + 1))
    ]))
  ];
in
run main
