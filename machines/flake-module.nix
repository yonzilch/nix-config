{
  inputs,
  self,
  ...
}: {
  imports = with inputs; [
    clan-core.flakeModules.default
  ];
  clan = {
    machines = {
      "example" = {
        clan.deployment.requireExplicitUpdate = true;
      };
    };
    meta.name = "yzlab";
    specialArgs = {
      inputs = inputs;
      self = self;
    };
  };
}
