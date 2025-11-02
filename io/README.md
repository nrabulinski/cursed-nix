# interactive programs in nix!

PoC framework for writing interactive programs using pure Nix.
Just import `io.nix` and write programs like in any other scripting language.
Current examples:
- `repl.nix` - Nix repl written in Nix
- `nested-loops.nix` - Wow, such complex control flow. I cannot believe this works.

## credits

[UlyssesZhan](https://github.com/UlyssesZh) - original idea and implementation.
God bless you for [this](https://discourse.nixos.org/t/interactive-program-written-in-nix-lang/71536) discourse post.

## caveats

- Apparently only works in Lix, as Nix cannot open (and re-open) /dev/stdin and keep reading from it.
- You have to use `nix-build`/`nix build -f` to evaluate the file. `nix-instantiate --eval` will probably not work.

