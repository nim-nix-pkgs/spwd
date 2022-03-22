{
  description = ''module for working with the UNIX shadow password file'';

  inputs.flakeNimbleLib.owner = "riinr";
  inputs.flakeNimbleLib.ref   = "master";
  inputs.flakeNimbleLib.repo  = "nim-flakes-lib";
  inputs.flakeNimbleLib.type  = "github";
  inputs.flakeNimbleLib.inputs.nixpkgs.follows = "nixpkgs";
  
  inputs.src-spwd-master.flake = false;
  inputs.src-spwd-master.owner = "achesak";
  inputs.src-spwd-master.ref   = "master";
  inputs.src-spwd-master.repo  = "nim-spwd";
  inputs.src-spwd-master.type  = "github";
  
  outputs = { self, nixpkgs, flakeNimbleLib, ...}@deps:
  let 
    lib  = flakeNimbleLib.lib;
    args = ["self" "nixpkgs" "flakeNimbleLib" "src-spwd-master"];
  in lib.mkRefOutput {
    inherit self nixpkgs ;
    src  = deps."src-spwd-master";
    deps = builtins.removeAttrs deps args;
    meta = builtins.fromJSON (builtins.readFile ./meta.json);
  };
}