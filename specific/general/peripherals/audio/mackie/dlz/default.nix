{ lib, ... }: 
let
  node = "usb-LOUD_Audio__LLC_DLZ_Creator";
  nodeIn = "~alsa_input.${node}*";
  nodeOut = "~alsa_output.${node}*";

  makeLoopbackIn = name: portCapture: portPlayback: {
    name = "libpipewire-module-loopback";
    args = {
      "node.description" = name;
      "capture.props" = {
        "target.object" = nodeIn;
        "audio.position" = portCapture;
        "stream.dont-remix" = true;
        "node.passive" = true;
        "node.dont-fallback" = true;
        "node.linger" = true;
      };
      "playback.props" = {
        "node.name" = lib.strings.sanitizeDerivationName name;
        "media.class" = "Audio/Source";
        "audio.position" = portPlayback;
        "audio.channels" = lib.length portPlayback;
      };
    };
  };

  makeLoopbackOut = name: portCapture: portPlayback: {
    name = "libpipewire-module-loopback";
    args = {
      "node.description" = name;
      "capture.props" = {
        "node.name" = lib.strings.sanitizeDerivationName name;
        "media.class" = "Audio/Sink";
        "audio.position" = portCapture;
        "audio.channels" = lib.length portCapture;
      };
      "playback.props" = {
        "target.object" = nodeOut;
        "audio.position" = portPlayback;
        "stream.dont-remix" = true;
        "node.passive" = true;
        "node.dont-fallback" = true;
        "node.linger" = true;
      };
    };
  };

  portIn = [
    # { name = "DLZ Creator Line 1"; portCapture = lib.singleton "AUX0"; portPlayback = lib.singleton "MONO"; }
    # { name = "DLZ Creator Line 2"; portCapture = lib.singleton "AUX1"; portPlayback = lib.singleton "MONO"; }
    # { name = "DLZ Creator Line 3"; portCapture = lib.singleton "AUX2"; portPlayback = lib.singleton "MONO"; }
    # { name = "DLZ Creator Line 4"; portCapture = lib.singleton "AUX3"; portPlayback = lib.singleton "MONO"; }
    # { name = "DLZ Creator Line 5/6"; portCapture = [ "AUX4" "AUX5" ]; portPlayback = [ "FL" "FR" ]; }
    # { name = "DLZ Creator Line 7/8"; portCapture = [ "AUX6" "AUX7" ]; portPlayback = [ "FL" "FR" ]; }
    # { name = "DLZ Creator Line 9/10"; portCapture = [ "AUX8" "AUX9" ]; portPlayback = [ "FL" "FR" ]; }
    # { name = "DLZ Creator Line 11/12"; portCapture = [ "AUX10" "AUX11" ]; portPlayback = [ "FL" "FR" ]; }
    # { name = "DLZ Creator Main Mix"; portCapture = [ "AUX12" "AUX13" ]; portPlayback = [ "FL" "FR" ]; }
    { name = "DLZ Creator Line 1/2"; portCapture = [ "AUX0" "AUX1" ]; portPlayback = [ "FL" "FR" ]; }
    { name = "DLZ Creator Line 3/4"; portCapture = [ "AUX2" "AUX3" ]; portPlayback = [ "FL" "FR" ]; }
  ];

  portOut = [
    { name = "DLZ Creator Line 1/2"; portCapture = [ "FL" "FR" ]; portPlayback = [ "FL" "FR" ]; }
    { name = "DLZ Creator Line 3/4"; portCapture = [ "FL" "FR" ]; portPlayback = [ "RL" "RR" ]; }
    # For Pro Audio
    # { name = "DLZ Creator Line 1/2"; portCapture = [ "FL" "FR" ]; portPlayback = [ "AUX0" "AUX1" ]; }
    # { name = "DLZ Creator Line 3/4"; portCapture = [ "FL" "FR" ]; portPlayback = [ "AUX2" "AUX3" ]; }
  ];

  loopbackIns = map (p: makeLoopbackIn p.name p.portCapture p.portPlayback) portIn;
  loopbackOuts = map (p: makeLoopbackOut p.name p.portCapture p.portPlayback) portOut;
in {
  boot.kernelModulesPatch.usb_audio = {
    path = "sound/usb";
    patches = [ ./mackie-dlz.patch ];
  };

  services.pipewire = {
    extraConfig.pipewire."10-mackie-dlz" = {
      "context.modules" = loopbackIns ++ loopbackOuts;
      # "context.properties" = {
      #   "default.clock.quantum" = 256;
      # };
    };
    wireplumber.extraConfig."10-mackie-dlz" = {
      "monitor.alsa.rules" = [
        {
          matches = map (name: { "node.name" = name; }) [ nodeIn nodeOut ];
          actions.update-props = {
            # "session.suspend-timeout-seconds" = 0;
            "node.always-process" = true;
          };
        }
      #   {
      #     matches = [{
      #       "device.name" = "alsa_card.${node}";
      #     }];
      #     actions.update-props = {
      #       "device.profile" = "pro-audio";
      #     };
      #   }
      ];
    };
  };
}