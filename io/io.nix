let
  do = ops: io:
    let
      final = builtins.foldl' (
        io: op:
        let
          io' = op io;
        in
        if io.break then io else builtins.deepSeq io' io'
      ) io ops;
    in
    builtins.deepSeq final final;

  set = name: val: { vars, loop, break, }:
    {
      inherit loop break;
      vars = vars // {
        ${name} = (val vars);
      };
    };

  print = val: io: builtins.trace (val io.vars) io;

  if_ = cond: then_: else_: io:
    if (cond io.vars) then then_ io else else_ io;

  if' = cond: then_: if_ cond then_ (io: io);

  p = val: io: val; # p for pure

  nop = val: io: builtins.deepSeq (val io.vars) io;

  read = io: builtins.readFile /dev/stdin;

  break = { vars, loop, break, }:
    if loop == 0 then
      builtins.throw "Cannot use break outside of a loop"
    else
      {
        inherit loop vars;
        break = true;
      };

  setLoop = { vars, loop, break, }:
    {
      inherit vars break;
      loop = loop + 1;
    };
  loop = op: io: let
    iters = builtins.genericClosure {
      startSet = [ { key = 0; io = setLoop io; } ];
      operator = { key, io }: let
        io' = op io;
        key' = if io'.break then 0 else key + 1;
      in
      [ {
          key = builtins.seq io' key';
          io = io';
      } ];
    };
    len = builtins.length iters;
    last = builtins.elemAt iters (len - 1);
  in {
    inherit (last.io) vars;
    loop = last.io.loop - 1;
    break = false;
  };

  while = cond: op: loop (do [
    (if' (io: !(cond io)) break)
    op
  ]);

  run = op:
    builtins.deepSeq (op {
      vars = { };
      loop = 0;
      break = false;
    }) {};
in
{
  inherit
    do
    set
    print
    if_
    if'
    p
    nop
    read
    break
    loop
    while
    run
    ;
}
