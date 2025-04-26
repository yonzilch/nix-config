{
  self,
  inputs,
  ...
}: {
  clan = {
    machines = {
      "example" = {
        clan.deployment.requireExplicitUpdate = true;
      };
    };
    meta.name = "yzlab";
    specialArgs = {
      self = self;
      inputs = inputs;
    };
  };
}
