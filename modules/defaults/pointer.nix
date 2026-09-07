{
  flake.modules.darwin.default = rec {
    system.defaults = {
      CustomUserPreferences = {
        "com.apple.AppleMultitouchTrackpad" = {
          TrackpadFiveFingerPinchGesture = 2;
          TrackpadFourFingerHorizSwipeGesture = 2;
          TrackpadFourFingerPinchGesture = 2;
          TrackpadFourFingerVertSwipeGesture = 2;
          TrackpadHandResting = true;
          TrackpadHorizScroll = 1;
          TrackpadMomentumScroll = true;
          TrackpadPinch = 1;
          TrackpadRotate = 1;
          TrackpadScroll = true;
          TrackpadThreeFingerVertSwipeGesture = 2;
          TrackpadTwoFingerDoubleTapGesture = 1;
          TrackpadTwoFingerFromRightEdgeSwipeGesture = 3;
        };
        "com.apple.driver.AppleBluetoothMultitouch.trackpad" =
          system.defaults.trackpad
          // system.defaults.CustomUserPreferences."com.apple.AppleMultitouchTrackpad";
      };

      NSGlobalDomain = {
        "com.apple.mouse.tapBehavior" = 1;
      };

      trackpad = {
        Clicking = false;
        TrackpadRightClick = true;
        TrackpadThreeFingerTapGesture = 2;
      };
    };
  };
}
