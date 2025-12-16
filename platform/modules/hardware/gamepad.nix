_: {
  hardware = {
    xone.enable = true;
    xpadneo.enable = true;
  };

  services.udev.extraRules = ''
    ACTION=="add", KERNEL=="0005:045E:02FD.*|0005:045E:02E0.*|0005:045E:0B05.*|0005:045E:0B13.*|0005:045E:0B20.*|0005:045E:0B22.*", SUBSYSTEM=="hid", DRIVER!="xpadneo", ATTR{driver/unbind}="%k", ATTR{[drivers/hid:xpadneo]bind}="%k"
    ACTION=="add|change", DRIVERS=="xpadneo", SUBSYSTEM=="input", ENV{ID_INPUT_JOYSTICK}=="1", TAG+="uaccess", MODE="0664", ENV{LIBINPUT_IGNORE_DEVICE}="1"

    #FIXME(issue-291) Work around Steamlink not properly detecting the mappings
    #FIXME(issue-457) Word around QMK overriding our hidraw rules
    ACTION=="add|change", DRIVERS=="xpadneo", SUBSYSTEM=="hidraw", MODE:="0000", TAG-="uaccess"
  '';
}
