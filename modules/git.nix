{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name  = "Domagoj";
        email = "a.domagoj@hotmail.com";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
