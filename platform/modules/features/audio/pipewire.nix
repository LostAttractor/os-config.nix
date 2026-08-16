{ pkgs, config, ... }:
let
  alsa-ucm-conf' = with pkgs; alsa-ucm-conf.overrideAttrs (oldAttrs: {
    src = fetchFromGitHub {
      owner = "LostAttractor";
      repo = "alsa-ucm-conf";
      rev = "880c9e20edaedfe9ec4131211ec8f5eeaa4f37b1";
      hash = "sha256-33g1vI8KePrv6vV4VNlqJYZVjlvcPGl0qQd/tmaJIz8=";
    };
    patches = [ ];
    # patches = oldAttrs.patches or [ ] ++  [ ./ucm.patch ];
  });
  wireplumber' = with pkgs; wireplumber.overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches or [ ] ++ [ ./wireplumber.patch ];
  });
in {
  # rtkit (optional, recommended) allows Pipewire to use the realtime scheduler for increased performance.
  security.rtkit.enable = true;
  security.rtkit.args  = [
    "--scheduling-policy=FIFO"
    "--our-realtime-priority=89"
    "--max-realtime-priority=88"
    "--min-nice-level=-19"
    "--rttime-usec-max=2000000"
    "--users-max=100"
    "--processes-per-user-max=1000"
    "--threads-per-user-max=10000"
    "--actions-burst-sec=10"
    "--actions-per-burst-max=1000"
    "--canary-cheep-msec=30000"
    "--canary-watchdog-msec=60000"
  ];
  services.pipewire = {
    enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment the following
    jack.enable = true;
    wireplumber.enable = true;  
    wireplumber.package = wireplumber';

    extraConfig = {
      client."99-resample"."stream.properties"."resample.quality" = 10;
      pipewire-pulse."99-resample"."stream.properties"."resample.quality" = 10;
      pipewire = {
        "99-basic" = {
          "context.properties" = {
            "log.level" = 3;
            # "default.clock.quantum" = 128;
            "default.clock.rate" = 96000;
            "mem.allow-mlock" = true;
          };
          "context.modules" = [{
            name = "libpipewire-module-rt";
            args = {
              "nice.level" = -19;
            };
            flags = [ "ifexists" "nofail" ];
          }];
        };
        # "10-echo-cancel" = {
        #   # Echo cancellation
        #   "context.modules" = [
        #     {
        #       name = "libpipewire-module-echo-cancel";
        #       args = {
        #         # Monitor mode: Instead of creating a virtual sink into which all
        #         # applications must play, in PipeWire the echo cancellation module can read
        #         # the audio that should be cancelled directly from the current fallback
        #         # audio output
        #         "monitor.mode" = true;
        #         "capture.props" = {
        #           # The audio source / microphone the echo should be cancelled from
        #           # Can be found with: pw-cli list-objects Node | grep node.name
        #           # Optional; if not specified the module uses/follows the fallback audio source
        #           #node.target = "alsa_input.usb-UGREEN_Camera_UGREEN_Camera_SN0001-02.analog-stereo"
        #           # Passive node: Do not keep the microphone alive when this capture is idle
        #           "node.passive" = true;
        #           # Force quanatum of input stream in the graph
        #           # Fiddle with if experiencing voice distortion/crackling
        #           # Default: 0/unset
        #           #"node.force-quantum" = 256;
        #         };
        #         # Output sink to be filtered from input
        #         # Can be found with: pw-cli list-objects Node | grep node.name
        #         # Optional; if not specified the module uses/follows the fallback audio source
        #         #"sink.props" = {
        #         #   "node.target" = "alsa_output.pci-0000_0f_00.4.analog-stereo";
        #         #};
        #         "source.props" = {
        #             # The virtual audio source that provides the echo-cancelled microphone audio
        #             "node.name" = "source_ec";
        #             "node.description" = "Echo-cancelled source";
        #         };
        #         "aec.args" = {
        #             # Settings for the WebRTC echo cancellation engine
        #             # Gain control: On-the-fly microphone audio normalization
        #             # Default: false
        #             # Caution, the PipeWire WebRTC source code advises against enabling it:
        #             #  > Note: AGC seems to mess up with Agnostic Delay Detection, especially
        #             #  > with speech, result in very poor performance, disable by default
        #             #webrtc.gain_control = true
        #             # Extended filter: Widened audio delay window (?)
        #             # Default: true
        #             # Quote from the old source of the abandoned Mozilla Positron project (2016):
        #             #  > The extended filter mode gives us the flexibility to ignore the system's
        #             #  > reported delays. We do this for platforms which we believe provide results
        #             #  > which are incompatible with the AEC's expectations.
        #             # Suggestion: Turn it off unless required
        #             "webrtc.extended_filter" = false;
        #         };
        #       };
        #     }
        #   ];
        # };
      };
    };
  };

  environment.variables = {
    ALSA_CONFIG_UCM = "${alsa-ucm-conf'}/share/alsa/ucm";
    ALSA_CONFIG_UCM2 = "${alsa-ucm-conf'}/share/alsa/ucm2";
  };
  environment.sessionVariables = {
    ALSA_CONFIG_UCM = "${alsa-ucm-conf'}/share/alsa/ucm";
    ALSA_CONFIG_UCM2 = "${alsa-ucm-conf'}/share/alsa/ucm2";
  };
  systemd.user.services.pipewire.environment.ALSA_CONFIG_UCM =
    config.environment.variables.ALSA_CONFIG_UCM;
  systemd.user.services.pipewire.environment.ALSA_CONFIG_UCM2 =
    config.environment.variables.ALSA_CONFIG_UCM2;
  systemd.user.services.wireplumber.environment.ALSA_CONFIG_UCM =
    config.environment.variables.ALSA_CONFIG_UCM;
  systemd.user.services.wireplumber.environment.ALSA_CONFIG_UCM2 =
    config.environment.variables.ALSA_CONFIG_UCM2;

  musnix = {
    enable = true;
    rtcqs.enable = true;
    rtirq = {
      enable = true;
      prioHigh = 95;
      prioDecr = 1;
    };
  };

  environment.systemPackages = with pkgs; [ alsa-ucm-conf' pwvucontrol coppwr crosspipe qjackctl qpwgraph jack-example-tools ];
}
