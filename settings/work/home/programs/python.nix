{
  home.sessionVariables = {
    # PYTHONWARNINGS = "ignore";
  };

  xdg.configFile."pip/pip.conf".text = ''
    [global]
    index = https://p-nexus-3.development.nl.eu.abnamro.com:8443/repository/python-group/pypi
    index-url = https://p-nexus-3.development.nl.eu.abnamro.com:8443/repository/python-group/simple
  '';
}
