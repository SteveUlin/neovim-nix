rec {
  toLuaObj = args:
    let
      # Converts a Nix value to its Lua equivalent
      convert = type: {
        null = "nil";
        set =
          if builtins.hasAttr "__raw" args
            then args."__raw"
          else
            let
              pairs = map (name: "['${name}'] = ${toLuaObj args.${name}}") (builtins.attrNames args);
            in
              "{ ${(builtins.concatStringsSep ", " pairs)} }";
        list = "{ ${(builtins.concatStringsSep ", " (map toLuaObj args))} }";
        int = toString args;
        float = toString args;
        bool = if args then "true" else "false";
        string = "'${args}'";
        # Handling of Nix paths as Lua strings (this adds the path to the Nix store)
        path = "'${args}'";
        # Default case for unsupported types
        default = builtins.throw "Unsupported Nix type for Lua conversion: ${type}";
      }.${type} or (convert.default);
    in
      convert (builtins.typeOf args);
}

