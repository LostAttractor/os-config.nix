{
  inputs,
  pkgs,
  ...
}:
{
  networking.hosts = {
    "0.0.0.0" = [
      "osuspider.yuanshen.com"
      "overseauspider.yuanshen.com"
      "uspider.yuanshen.com"

      "log-upload-os.hoyoverse.com"
      "log-upload-os.mihoyo.com"
      "apm-log-upload-os.hoyoverse.com"
      "zzz-log-upload-os.hoyoverse.com"
      "log-upload.mihoyo.com"
      "ys-log-upload.mihoyo.com"
      "ys-log-upload-os.hoyoverse.com"
      "hkrpg-log-upload-os.hoyoverse.com"
      "dump.gamesafe.qq.com"
      "devlog-upload.mihoyo.com"

      "globaldp-prod-cn01.bhsr.com"
      "globaldp-prod-cn01.juequling.com"

      "sg-public-data-api.hoyoverse.com"
      "public-data-api.mihoyo.com"

      "prd-lender.cdp.internal.unity3d.com"
      "thind-prd-knob.data.ie.unity3d.com"
      "thind-gke-usc.prd.data.corp.unity3d.com"
      "cdp.cloud.unity3d.com"
      "remote-config-proxy-prd.uca.cloud.unity3d.com"

      "pc.crashsight.wetest.net"
    ];
  };

  environment.systemPackages = let
    aagl-pkgs = inputs.aagl.packages.${pkgs.stdenv.hostPlatform.system};
    override = prev: {
      extraPkgs = pkgs: [ pkgs.bubblewrap ]; # Use bubblewrap sandbox to set hostname to `STEAMDECK` to bypass anti-cheat
    };
    aagl-override-attrs = final: prev: let
      # See https://github.com/an-anime-team/an-anime-game-launcher/issues/572#issuecomment-3476345318
      my_wrapper = pkgs.writeShellScriptBin prev.pname ''
        # --- Configuration ---
        STRACE_CMD="${pkgs.strace}/bin/strace -f -e trace=process -o /dev/null ${prev.passthru.wrapper}/bin/${prev.passthru.wrapper.name} "$@""
        ESCORT_DURATION=120
        GAME_PROCESS_NAME="YuanShen.exe"
        LAUNCHER_PROCESS_NAME="${prev.passthru.wrapper.name}"
        POLLING_INTERVAL=5 # Polling interval in seconds

        # --- Variables ---
        STRACE_PID=""
        KILLER_PID=""

        # --- Cleanup Function ---
        cleanup() {
            echo "[Fix Script] Exit signal received, cleaning up..."
            if [ ! -z "$KILLER_PID" ] && ps -p "$KILLER_PID" > /dev/null; then
                kill -9 "$KILLER_PID"
            fi
            if [ ! -z "$STRACE_PID" ] && ps -p "$STRACE_PID" > /dev/null; then
                kill -9 "$STRACE_PID"
            fi
            pkill -9 -f "$LAUNCHER_PROCESS_NAME"
            echo "[Fix Script] Cleanup complete."
        }
        trap cleanup EXIT SIGINT SIGTERM

        # 1. Start the escort and the launcher
        echo "[Fix Script] Escort enabled..."
        $STRACE_CMD &
        STRACE_PID=$!
        echo "[Fix Script] Escort process PID: $STRACE_PID"

        # 2. Main monitoring loop
        echo "[Fix Script] Waiting for you to start the game from the launcher..."
        while ps -p $STRACE_PID > /dev/null; do
            if pgrep -f -x $GAME_PROCESS_NAME > /dev/null; then
                # State: In-Game
                if [ -z "$KILLER_PID" ]; then
                    echo "[Fix Script] Game process detected! Starting $ESCORT_DURATION-second separation countdown..."
                    # Start a "timed killer" in the background, its only job is to kill strace
                    (sleep $ESCORT_DURATION && kill -9 $STRACE_PID) &
                    KILLER_PID=$!
                    echo "[Fix Script] Detach program deployed, PID: $KILLER_PID"
                fi
            else
                # State: In-Launcher (or game not started)
                if [ ! -z "$KILLER_PID" ]; then
                    echo "[Fix Script] Game has been exited. Revoking detach program..."
                    if ps -p $KILLER_PID > /dev/null; then
                        kill -9 $KILLER_PID
                    fi
                    KILLER_PID=""
                    echo "[Fix Script] Reset. Ready to relaunch the game."
                fi
            fi
            sleep $POLLING_INTERVAL
        done

        # When the strace process ends (either killed or the user closed the launcher), the script will arrive here.
        # We perform a final, failsafe cleanup here.
        echo "[Fix Script] Escort task finished. Performing final cleanup."
        pkill -9 -f "$LAUNCHER_PROCESS_NAME"

        exit 0
      '';
    in {
      passthru = prev.passthru // {wrapper = my_wrapper;};
      paths = with prev.passthru; [icon desktopEntry my_wrapper];
    };

    anime-game-launcher = (aagl-pkgs.anime-game-launcher.override override).overrideAttrs aagl-override-attrs;
    honkers-railway-launcher = aagl-pkgs.honkers-railway-launcher.override override;
    sleepy-launcher = aagl-pkgs.sleepy-launcher.override override;
  in [
    anime-game-launcher
    honkers-railway-launcher
    sleepy-launcher
  ];
}
