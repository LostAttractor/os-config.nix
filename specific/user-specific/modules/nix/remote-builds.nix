_:
let
  systems = [
    "x86_64-linux"
    "i686-linux"
    "aarch64-linux"
  ];
  supportedFeatures = [
    "nixos-test"
    "benchmark"
    "big-parallel"
    "kvm"
    "nix-command"
    "flakes"
    "ca-derivations"
  ];
in
{
  nix.buildMachines = [
    {
      hostName = "nixremote@hydra.home.lostattractor.net";
      systems = systems;
      maxJobs = 4;
      speedFactor = 4;
      supportedFeatures = supportedFeatures;
      mandatoryFeatures = [ ];
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSU9iWjBoTjEwbjBYSUtvS1dEdjg1ZElkVlZPbjNPMlozSUhRdkgxK051Tlogcm9vdEBIeWRyYQo=";
    }
  ];
  nix.distributedBuilds = true;
  # Optional, useful when the builder has a faster internet connection than yours
  nix.settings.builders-use-substitutes = true;

  programs.ssh.extraConfig = ''
    Host hydra.home.lostattractor.net
      IdentityFile /root/.ssh/nixremote
  '';
}
