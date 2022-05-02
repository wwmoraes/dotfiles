local queryParams = {
  -- web tracking parameters
  "__hs.*", -- HubSpot
  "__s", -- Drip.com
  "_bta_.*", -- Bronto
  "_ga", -- Google Analytics
  "_hs.*", -- HubSpot
  "_ke", -- Klaviyo
  "_openstat", -- Yandex
  "auto_subscribed",
  "dclid", -- Google
  "dm_i", -- dotdigital
  "ef_id", -- Adobe Advertising Cloud
  "email_source",
  "epik", -- Pinterest
  "fbclid", -- Facebook
  "gclid", -- Google AdWords/Analytics
  "gdf.*", -- GoDataFeed
  "gclsrc", -- Google DoubleClick
  "hsa_.*", -- HubSpot
  "hsCtaTracking", -- HubSpot
  "igshid", -- Instagram
  "matomo_.*", -- Matomo
  "mc_.*", -- MailChimp
  "mkt_.*", -- Adobe Marketo
  "mkwid", -- Marin
  "ml_.*", -- MailerLite
  "msclkid", -- Microsoft Advertising
  "mtm_.*", -- Matomo
  "oly_.*", -- Omeda
  "pcrid", -- Marin
  "piwik_.*", -- Piwik
  "pk_.*", -- Piwik
  "rb_clickid", -- Unknown high-entropy
  "redirect_log_mongo_id", -- Springbot
  "redirect_mongo_id", -- Springbot
  "s_cid", -- Adobe Site Catalyst
  "s_kwcid", -- Adobe Analytics
  "sb_referer_host", -- Springbot
  "trk_.*", -- Listrak
  "uta_.*",
  "utm_.*", -- Google Analytics
  "vero_.*", -- Vero
  "wickedid", -- Wicked Reports
  "yclid", -- Yandex click ID
}

return queryParams
