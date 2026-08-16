{ lib, ... }: 
let
  node = "usb-Yamaha_Corporation_Yamaha_URX44-00";
  nodeIn = "alsa_input.${node}.multichannel-input";
  nodeOut = "alsa_output.${node}.multichannel-output";
  # For Pro Audio
  # nodeIn = "alsa_input.${node}.pro-input-0";
  # nodeOut = "alsa_output.${node}.pro-output-0";

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
    { name = "Yamaha URX44 MAIN USB A"; portCapture = [ "AUX0" "AUX1" ]; portPlayback = [ "FL" "FR" ]; }
    { name = "Yamaha URX44 MAIN USB B"; portCapture = [ "AUX2" "AUX3" ]; portPlayback = [ "FL" "FR" ]; }
    { name = "Yamaha URX44 MAIN USB C"; portCapture = [ "AUX4" "AUX5" ]; portPlayback = [ "FL" "FR" ]; }
    { name = "Yamaha URX44 USB DAW 1"; portCapture = lib.singleton "AUX6"; portPlayback = lib.singleton "MONO"; }
    { name = "Yamaha URX44 USB DAW 2"; portCapture = lib.singleton "AUX7"; portPlayback = lib.singleton "MONO"; }
    { name = "Yamaha URX44 USB DAW 3"; portCapture = lib.singleton "AUX8"; portPlayback = lib.singleton "MONO"; }
    { name = "Yamaha URX44 USB DAW 4"; portCapture = lib.singleton "AUX9"; portPlayback = lib.singleton "MONO"; }
    { name = "Yamaha URX44 USB DAW 5/6"; portCapture = [ "AUX10" "AUX11" ]; portPlayback = [ "FL" "FR" ]; }
    { name = "Yamaha URX44 USB DAW 7/8"; portCapture = [ "AUX12" "AUX13" ]; portPlayback = [ "FL" "FR" ]; }
    { name = "Yamaha URX44 USB DAW 9/10"; portCapture = [ "AUX14" "AUX15" ]; portPlayback = [ "FL" "FR" ]; }
    { name = "Yamaha URX44 USB DAW 11/12"; portCapture = [ "AUX16" "AUX17" ]; portPlayback = [ "FL" "FR" ]; }
  ];

  portOut = [
    { name = "Yamaha URX44 MAIN USB A"; portCapture = [ "FL" "FR" ]; portPlayback = [ "AUX0" "AUX1" ]; }
    { name = "Yamaha URX44 MAIN USB B"; portCapture = [ "FL" "FR" ]; portPlayback = [ "AUX2" "AUX3" ]; }
    { name = "Yamaha URX44 MAIN USB C"; portCapture = [ "FL" "FR" ]; portPlayback = [ "AUX4" "AUX5" ]; }
    { name = "Yamaha URX44 USB DAW 1/2"; portCapture = [ "FL" "FR" ]; portPlayback = [ "AUX6" "AUX7" ]; }
    { name = "Yamaha URX44 USB DAW 3/4"; portCapture = [ "FL" "FR" ]; portPlayback = [ "AUX8" "AUX9" ]; }
    { name = "Yamaha URX44 USB DAW 5/6"; portCapture = [ "FL" "FR" ]; portPlayback = [ "AUX10" "AUX11" ]; }
    { name = "Yamaha URX44 USB DAW 7/8"; portCapture = [ "FL" "FR" ]; portPlayback = [ "AUX12" "AUX13" ]; }
    { name = "Yamaha URX44 USB DAW 9/10"; portCapture = [ "FL" "FR" ]; portPlayback = [ "AUX14" "AUX15" ]; }
    { name = "Yamaha URX44 USB DAW 11/12"; portCapture = [ "FL" "FR" ]; portPlayback = [ "AUX16" "AUX17" ]; }
  ];

  loopbackIns = map (p: makeLoopbackIn p.name p.portCapture p.portPlayback) portIn;
  loopbackOuts = map (p: makeLoopbackOut p.name p.portCapture p.portPlayback) portOut;
in {
  boot.kernelModulesPatch.usb_audio = {
    path = "sound/usb";
    patches = [ ./urx44.patch ];
  };

  services.pipewire = {
    extraConfig.pipewire."10-yamaha-urx44" = {
      "context.modules" = loopbackIns ++ loopbackOuts;
    };
    wireplumber.extraConfig."10-yamaha-urx44" = {
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