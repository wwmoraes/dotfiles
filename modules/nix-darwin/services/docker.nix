{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkPackageOption
    types
    mkOption
    ;
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

  cfg = config.services.docker;
  configText = lib.generators.toJSON { } cfg.settings;
in
{
  meta.maintainers = [
    lib.maintainers.wwmoraes or "wwmoraes"
  ];

  options = {
    services.docker = {
      enable = mkEnableOption "Docker daemon to run containerized applications";

      package = mkPackageOption pkgs "docker" {
        nullable = true;
        default = "docker";
      };

      settings = mkOption {
        default = { };
        type = with types; attrsOf anything;
      };
    };
  };

  ## TODO converge docker settings with NixOS options
  ## see https://search.nixos.org/options?channel=25.05&show=virtualisation.docker.daemon.settings&from=0&size=50&sort=relevance&type=packages&query=virtualisation.docker
  config = mkIf cfg.enable {
    ## TODO move rootless docker configuration to virtualisation group
    ## https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/virtualisation/docker-rootless.nix
    environment.etc."docker/daemon.json".text = mkIf isLinux configText;

    environment.systemPackages = lib.optional cfg.enable cfg.package;

    home-manager.sharedModules = [
      (
        { config, lib, ... }:
        {
          home.activation.unlinkDockerDesktop = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            ## replaces links with file copy otherwise Docker Desktop fails to start...

            sed --in-place= ';' "${config.home.homeDirectory}/Library/Group Containers/group.com.docker/settings-store.json"
            chmod u+w "${config.home.homeDirectory}/Library/Group Containers/group.com.docker/settings-store.json"

            sed --in-place= ';' "${config.home.homeDirectory}/.docker/daemon.json"
            chmod u+w "${config.home.homeDirectory}/.docker/daemon.json"

            sed --in-place= ';' "${config.home.homeDirectory}/.docker/config.json"
            chmod u+w "${config.home.homeDirectory}/.docker/config.json"
          '';

          ## TODO configure credentials for work
          # security add-internet-password -a C82334 -s p-nexus-3.development.nl.eu.abnamro.com -r htps -P 18447 -l "Docker Credentials" -w 'SECRET'

          home.file.".docker/daemon.json".text = mkIf isDarwin configText;

          home.file."Library/Group Containers/group.com.docker/settings-store.json" = {
            text = lib.mkIf isDarwin (
              builtins.toJSON {
                AcceptCanaryUpdates = false;
                ActiveOrganizationName = "";
                AllowBetaFeatures = false;
                AllowExperimentalFeatures = false;
                AnalyticsEnabled = false;
                AutoDownloadUpdates = true;
                AutoPauseTimedActivitySeconds = 30;
                AutoPauseTimeoutSeconds = 30;
                AutoStart = false;
                BackupData = false;
                BlockDockerLoad = false;
                # ComposeAutoFileShares = null;
                # ComposeBridge = null;
                ContainerTerminal = "system";
                ContainersOverrideProxyExclude = "";
                ContainersOverrideProxyHTTP = "";
                ContainersOverrideProxyHTTPS = "";
                ContainersOverrideProxyPAC = "";
                ContainersOverrideProxyTCP = "";
                ContainersOverrideProxyTransparentPorts = "80,443";
                ContainersProxyHTTPMode = "";
                Cpus = 2;
                CredentialHelper = "docker-credential-${if isDarwin then "osxkeychain" else "desktop"}";
                CustomWslDistroDir = "";
                DataFolder = "${config.home.homeDirectory}/Library/Containers/com.docker.docker/Data/vms/0/data";
                DefaultSnapshotter = "overlayfs";
                DeprecatedCgroupv1 = false;
                DesktopTerminalEnabled = false;
                DevEnvironmentsEnabled = false;
                DisableHardwareAcceleration = false;
                # DisableLocalEngine = false;
                DisableUpdate = false;
                DiskFlush = "";
                DiskSizeMiB = 81920;
                DiskStats = "";
                DiskTRIM = true;
                DisplayRestartDialog = false;
                DisplaySwitchWinLinContainers = false;
                Displayed18362Deprecation = false;
                DisplayedElectronPopup = [ ];
                DisplayedOnboarding = true;
                DockerAppLaunchPath = "${config.home.homeDirectory}/Applications/Docker.app";
                DockerBinInstallPath = "user";
                DockerDebugDefaultEnabled = false;
                DogfoodFeatureFlagsEnabled = false;
                ECIDockerSocketCmdList = [ ];
                ECIDockerSocketCmdListType = "deny";
                ECIDockerSocketImgList = [ ];
                EnableCLIHints = false;
                EnableDefaultDockerSocket = false;
                EnableDockerAI = false;
                EnableDockerMCPToolkit = false;
                EnableInference = false;
                EnableIntegrationWithDefaultWslDistro = false;
                EnableIntegrityCheck = true;
                EnableSegmentDebug = false;
                EnableWasmShims = false;
                EnhancedContainerIsolation = false;
                ExposeDockerAPIOnTCP2375 = false;
                ExtensionsEnabled = false;
                ExtensionsPrivateMarketplace = false;
                ExtensionsPrivateMarketplaceAdminContactURL = "";
                FilesharingDirectories = [
                  "${config.home.homeDirectory}"
                  "/Volumes"
                  "/private"
                  "/tmp"
                ];
                HostNetworkingEnabled = false;
                HostNetworkingPreferEnabled = false;
                IPv4Only = false;
                IPv6Only = false;
                IntegratedWslDistros = null;
                KernelForUDP = true;
                KubernetesEnabled = false;
                KubernetesImagesRepository = "";
                KubernetesInitialInstallPerformed = false;
                KubernetesMode = "";
                KubernetesNodesCount = 0;
                LastContainerdSnapshotterEnable = null;
                LastLoginDate = 0;
                LatestBannerKey = "";
                LicenseTermsVersion = 2;
                LifecycleTimeoutSeconds = 600;
                MemoryMiB = 2048;
                NetworkType = "gvisor";
                NoWindowsContainers = true;
                OnlyMarketplaceExtensions = false;
                OpenUIOnStartupDisabled = true;
                OverrideProxyExclude = "";
                OverrideProxyHTTP = "";
                OverrideProxyHTTPS = "";
                OverrideProxyPAC = "";
                OverrideProxyTCP = "";
                OverrideWindowsDockerdPort = -1;
                ProxyEnableKerberosNTLM = false;
                ProxyHTTPMode = "system";
                ProxyLocalhostPort = 0;
                RequireVmnetd = false;
                RunWinServiceInWslMode = false;
                SbomIndexing = false;
                ScoutNotificationPopupsEnabled = false;
                ScoutOsNotificationsEnabled = false;
                SettingsVersion = 42;
                ShowAnnouncementNotifications = false;
                ShowExtensionsSystemContainers = false;
                ShowGeneralNotifications = false;
                ShowInstallScreen = false;
                ShowKubernetesSystemContainers = false;
                ShowPromotionalNotifications = false;
                ShowSurveyNotifications = false;
                SkipUpdateToWSLPrompt = false;
                SkipWSLMountPerfWarning = false;
                SocksProxyPort = 0;
                SwapMiB = 2048;
                SynchronizedDirectories = [ ];
                ThemeSource = "system";
                UpdateAvailableTime = 0;
                UpdateHostsFile = false;
                UpdateInstallTime = 0;
                UseBackgroundIndexing = false;
                UseContainerdSnapshotter = false;
                UseCredentialHelper = true;
                UseGrpcfuse = false;
                UseLibkrun = false;
                UseNightlyBuildUpdates = false;
                UseResourceSaver = true;
                UseVirtualizationFramework = true;
                UseVirtualizationFrameworkRosetta = true;
                UseVirtualizationFrameworkVirtioFS = true;
                UseVpnkit = true;
                UseWindowsContainers = false;
                VpnKitAllowedBindAddresses = "0.0.0.0";
                VpnKitMTU = 1500;
                VpnKitMaxConnections = 2000;
                VpnKitMaxPortIdleTime = 300;
                VpnKitTransparentProxy = true;
                VpnkitCIDR = "192.168.65.0/24";
                # WslDiskCompactionThresholdGb = 0;
                WslEnableGrpcfuse = false;
                WslEngineEnabled = false;
                WslInstallMode = "installLatestWsl";
                WslUpdateRequired = false;
              }
            );
          };

          xdg.configFile."docker/daemon.json" = mkIf isLinux {
            text = configText;
          };
        }
      )
    ];

    homebrew.casks = lib.optional cfg.enable "docker-desktop";
  };
}
