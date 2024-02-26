# escaping html modern framework style in nix!
## everything is properly escaped, except the things you want to not be
### (customisation incoming)

Just edit `doc.nix` and run `nix eval --raw -f doc.nix` and voila you have your html! So awesome!

## Implementation
`raw` just returns a good ol' derivation which `htmlSafe` reads from `getContext` and replaces with the ***unsafe*** contents. beware what you're putting there!

