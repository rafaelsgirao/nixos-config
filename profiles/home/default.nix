{
  inputs,
  profiles,
  ...
}:
{
  imports = [
    profiles.home.nixvim
    inputs.nixvim.homeModules.nixvim
  ];
}
