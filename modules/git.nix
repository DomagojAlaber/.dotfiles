{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "DomagojAlaber";
        email = "a.domagoj@hotmail.com";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
