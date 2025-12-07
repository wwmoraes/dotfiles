{
  home-manager.sharedModules = [
    (
      { lib, ... }:
      {
        programs.docker.desktopSettings = {
          FilesharingDirectories = lib.mkDefault [
            "/tmp"
          ];
        };
      }
    )
  ];

  services.docker = {
    enable = true;

    desktopSettings = {
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
      ContainerTerminal = "system";
      ContainersOverrideProxyExclude = "";
      ContainersOverrideProxyHTTP = "";
      ContainersOverrideProxyHTTPS = "";
      ContainersOverrideProxyPAC = "";
      ContainersOverrideProxyTCP = "";
      ContainersOverrideProxyTransparentPorts = "80,443";
      ContainersProxyHTTPMode = "";
      Cpus = 2;
      CustomWslDistroDir = "";
      DefaultSnapshotter = "overlayfs";
      DeprecatedCgroupv1 = false;
      DesktopTerminalEnabled = false;
      DevEnvironmentsEnabled = false;
      DisableHardwareAcceleration = false;
      DisableUpdate = false;
      DiskFlush = "";
      DiskSizeMiB = 81920;
      DiskStats = "";
      DiskTRIM = true;
      DisplayRestartDialog = false;
      DisplaySwitchWinLinContainers = false;
      Displayed18362Deprecation = false;
      DisplayedOnboarding = true;
      DockerBinInstallPath = "user";
      DockerDebugDefaultEnabled = false;
      DogfoodFeatureFlagsEnabled = false;
      ECIDockerSocketCmdListType = "deny";
      EnableCLIHints = false;
      EnableCloud = false;
      EnableCloudGPUSupport = false;
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
      HostNetworkingEnabled = false;
      HostNetworkingPreferEnabled = false;
      IPv4Only = false;
      IPv6Only = false;
      KernelForUDP = true;
      KubernetesEnabled = false;
      KubernetesImagesRepository = "";
      KubernetesInitialInstallPerformed = false;
      KubernetesMode = "";
      KubernetesNodesCount = 0;
      LastLoginDate = 0;
      LatestBannerKey = "";
      LicenseTermsVersion = 2;
      LifecycleTimeoutSeconds = 600;
      MemoryMiB = 2048;
      NetworkType = "gvisor";
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
      SettingsVersion = 43;
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
      WslEnableGrpcfuse = false;
      WslEngineEnabled = false;
      WslInstallMode = "installLatestWsl";
      WslUpdateRequired = false;
    };

    settings = {
      builder = {
        features = {
          buildkit = true;
        };
        gc = {
          defaultKeepStorage = "20GB";
          enabled = true;
        };
      };
      debug = false;
      experimental = false;
    };
  };
}
