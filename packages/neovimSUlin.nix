{ pkgs }:

{
  let
    neovimSUlinUnWrapped = pkgs.wrapNeovim pkgs.neovim {};
  in pkgs.writeShellApplication {
    name
  }
}
