{
  flake.modules.darwin.default = {
    system.defaults = {
      CustomUserPreferences = {
        "com.apple.spotlight" = {
          "engagementCount-com.apple.Spotlight.suggestions" = 0;
          EnabledPreferenceRules = [
            "Custom.relatedContents"
            "Domain.IMAGES"
            "Domain.MOVIES"
            "Domain.MUSIC"
            "Domain.PDF"
            "Domain.SOURCE"
            "Domain.SPREADSHEETS"
            "com.apple.AddressBook"
            "com.apple.Photos"
            "com.apple.VoiceMemos"
            "com.apple.podcasts"
            "com.apple.tips"
            "com.surteesstudios.Bartender"
            # "com.getdropbox.dropbox"
            # "com.microsoft.rdc.macos"
            # "com.synology.CloudStationUI"
            # "euronewsuniversal"
            # "net.whatsapp.WhatsApp"
          ];
          orderedItems = [
            {
              enabled = 1;
              name = "APPLICATIONS";
            }
            {
              enabled = 1;
              name = "MENU_EXPRESSION";
            }
            {
              enabled = 1;
              name = "MENU_CONVERSION";
            }
            {
              enabled = 1;
              name = "MENU_DEFINITION";
            }
            {
              enabled = 1;
              name = "SYSTEM_PREFS";
            }
            {
              enabled = 1;
              name = "BOOKMARKS";
            }
            {
              enabled = 1;
              name = "DIRECTORIES";
            }
            {
              enabled = 0;
              name = "PDF";
            }
            {
              enabled = 0;
              name = "FONTS";
            }
            {
              enabled = 0;
              name = "DOCUMENTS";
            }
            {
              enabled = 0;
              name = "MESSAGES";
            }
            {
              enabled = 0;
              name = "CONTACT";
            }
            {
              enabled = 0;
              name = "EVENT_TODO";
            }
            {
              enabled = 0;
              name = "IMAGES";
            }
            {
              enabled = 0;
              name = "MUSIC";
            }
            {
              enabled = 0;
              name = "MOVIES";
            }
            {
              enabled = 0;
              name = "PRESENTATIONS";
            }
            {
              enabled = 0;
              name = "SPREADSHEETS";
            }
            {
              enabled = 0;
              name = "SOURCE";
            }
            {
              enabled = 0;
              name = "MENU_OTHER";
            }
            {
              enabled = 0;
              name = "MENU_WEBSEARCH";
            }
            {
              enabled = 0;
              name = "MENU_SPOTLIGHT_SUGGESTIONS";
            }
          ];
          showedFTE = 1;
          showedLearnMore = 1;
        };
      };
    };
  };
}
