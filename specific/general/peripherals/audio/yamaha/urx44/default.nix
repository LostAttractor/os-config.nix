{ lib, ... }: 
let
  node = "usb-Yamaha_Corporation_Yamaha_URX44-00";
  nodeIn = "~alsa_input.${node}*";
  nodeOut = "~alsa_output.${node}*";
  # nodeIn = "alsa_input.${node}.pro-input-0";
  # nodeOut = "alsa_output.${node}.pro-output-0";
  splitNode = "hw_URX44";
  splitNodeIn = "~alsa_input.${splitNode}*";
  splitNodeOut = "~alsa_output.${splitNode}*";

  # makeLoopbackOut = name: portCapture: portPlayback: {
  #   name = "libpipewire-module-loopback";
  #   args = {
  #     "node.description" = name;
  #     "node.group" = lib.strings.sanitizeDerivationName name;
  #     "node.name" = lib.strings.sanitizeDerivationName name;
  #     "capture.props" = {
  #       "media.class" = "Audio/Sink";
  #       "audio.position" = portCapture;
  #       "audio.channels" = lib.length portCapture;
  #     };
  #     "playback.props" = {
  #       "node.name" = lib.strings.sanitizeDerivationName "${name} Split";
  #       "target.object" = nodeOut;
  #       "audio.position" = portPlayback;
  #       "stream.dont-remix" = true;
  #       "node.passive" = true;
  #       # "node.dont-fallback" = true;
  #       # "node.linger" = true;
  #     };
  #   };
  # };

  # makeLoopbackIn = name: portCapture: portPlayback: {
  #   name = "libpipewire-module-loopback";
  #   args = {
  #     "node.description" = name;
  #     "node.group" = lib.strings.sanitizeDerivationName name;
  #     "node.name" = lib.strings.sanitizeDerivationName name;
  #     "capture.props" = {
  #       "node.name" = lib.strings.sanitizeDerivationName "${name} Split";
  #       "target.object" = nodeIn;
  #       "audio.position" = portCapture;
  #       "stream.dont-remix" = true;
  #       "node.passive" = true;
  #       # "node.dont-fallback" = true;
  #       # "node.linger" = true;
  #     };
  #     "playback.props" = {
  #       "media.class" = "Audio/Source";
  #       "audio.position" = portPlayback;
  #       "audio.channels" = lib.length portPlayback;
  #     };
  #   };
  # };

  # portOut = [
  #   { name = "Yamaha URX44 MAIN USB A"; portCapture = [ "FL" "FR" ]; portPlayback = [ "AUX0" "AUX1" ]; }
  #   { name = "Yamaha URX44 MAIN USB B"; portCapture = [ "FL" "FR" ]; portPlayback = [ "AUX2" "AUX3" ]; }
  #   { name = "Yamaha URX44 MAIN USB C"; portCapture = [ "FL" "FR" ]; portPlayback = [ "AUX4" "AUX5" ]; }
  # ];

  # portIn = [
  #   { name = "Yamaha URX44 MAIN USB A"; portCapture = [ "AUX0" "AUX1" ]; portPlayback = [ "FL" "FR" ]; }
  #   { name = "Yamaha URX44 MAIN USB B"; portCapture = [ "AUX2" "AUX3" ]; portPlayback = [ "FL" "FR" ]; }
  #   { name = "Yamaha URX44 MAIN USB C"; portCapture = [ "AUX4" "AUX5" ]; portPlayback = [ "FL" "FR" ]; }
  # ];

  # loopbackIns = map (p: makeLoopbackIn p.name p.portCapture p.portPlayback) portIn;
  # loopbackOuts = map (p: makeLoopbackOut p.name p.portCapture p.portPlayback) portOut;
in {
  boot.kernelModulesPatch.usb_audio = {
    path = "sound/usb";
    patches = [ ./urx44.patch ];
  };

  services.pipewire = {
    extraConfig.pipewire."10-yamaha-urx44" = {
      # "context.modules" = loopbackOuts ++ loopbackIns;
    };
    wireplumber.extraConfig."10-yamaha-urx44" = {
      "monitor.alsa.rules" = [
        {
          matches = map (name: { "node.name" = name; }) [ nodeIn nodeOut splitNodeIn splitNodeOut ];
          actions.update-props = {
            # "session.suspend-timeout-seconds" = 0;
            # "node.always-process" = true;
            # "api.alsa.use-ucm" = false;
            # "api.alsa.disable-batch" = true;
            "api.alsa.auto-link" = true;
            "api.alsa.disable-tsched" = true;
            # "node.force-quantum" = 128;
            "api.alsa.period-size" = 256;
            "clock.name" = "api.alsa.3";
          };
        }
        # {
        #   matches = [{
        #     "device.name" = "~alsa_card.${node}*";
        #   }];
        #   actions.update-props = {
        #     "device.profile" = "pro-audio";
        #   };
        # }
      ];
    };
  };
}