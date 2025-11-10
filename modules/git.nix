{ config, pkgs, inputs, ... }:

{
    programs.git = {
        enable = true;
        settings = {
            user.name  = "Domagoj";
            user.email = "a.domagoj@hotmail.com";
            # other git config goes here as nested attrs
        };
        config = {
            defaultBranch = "main";
        };
    };
}


