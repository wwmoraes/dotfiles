/** @typedef {"main"|"work"|"home"} Context */
/** @typedef {Record<Context,string>} Contexts */
/** @typedef {Record<string,Contexts>} Browsers */
/** @typedef {Record<string,string>} Applications */

/** @type {Applications} */
const apps = {
  Edge: "com.microsoft.edgemac",
  // Chrome: "com.google.Chrome",
  Firefox: "org.mozilla.firefox",
  Safari: "com.apple.Safari",
};

/** @type {Browsers} */
const browsers = {
  "c02dq36nmd6p.local": {
    main: apps.Edge,
    work: apps.Edge,
    home: apps.Firefox,
  },
};

/** @type {Contexts} */
const defaultBrowsers = {
  main: apps.Safari,
  work: apps.Firefox,
  home: apps.Safari,
};

/**
 * @param {Context} contextName
 * @returns {import("./.finicky.d").Finicky.BrowserFn}
 * */
const getBrowser = (contextName) => (params) => {
  const context = browsers[finicky.getSystemInfo().name] || defaultBrowsers;
  return context[contextName];
};

/**
  * @param {string} prefix
  * @returns {import("./.finicky.d").Finicky.Rewrite}
*/
const prefixBGone = (prefix) => ({
  match: ({ urlString }) => urlString.startsWith(prefix),
  url: ({ urlString }) => decodeURIComponent(urlString.substring(prefix.length).replace(/%25/g, "%")),
});

/**
 * @param {string} host
 * @param {string} queryParam
 * @returns {import("./.finicky.d").Finicky.Rewrite}
 */
const redirectBGone = (host, queryParam) => ({
  match: ({ url }) => url.host.endsWith(host),
  url: ({ url }) => decodeURIComponent((new URLSearchParams(url.search)).get(queryParam).replace(/%25/g, "%")),
});

/// <reference path="./.finicky.d.ts" />
/** @type {import("./.finicky.d").Finicky.Config} */
module.exports = {
  defaultBrowser: getBrowser("main"),
  rewrite: [
    // cleanup TLDR newsletter links
    prefixBGone("https://tracking.tldrnewsletter.com/CL0/"),
    // cleanup Outlook redirects
    redirectBGone("safelinks.protection.outlook.com", "url"),
    // remove tracking query parameters
    {
      match: () => true,
      url: ({ url }) => {
        const removeKeysStartingWith = [
          "__hs", // HubSpot
          "_bta_", // Bronto
          "_hs", // HubSpot
          "gdf", // GoDataFeed
          "hsa_", // HubSpot
          "matomo_", // Matomo
          "mc_", // MailChimp
          "mkt_", // Adobe Marketo
          "ml_", // MailerLite
          "mtm_", // Matomo
          "oly_", // Omeda
          "piwik_", // Piwik
          "pk_", // Piwik
          "trk_", // Listrak
          "uta_",
          "utm_", // Google Analytics
          "vero_", // Vero
        ];
        const removeKeys = [
          "__s", // Drip.com
          "_ga", // Google Analytics
          "_ke", // Klaviyo
          "_openstat", // Yandex
          "auto_subscribed",
          "dclid", // Google
          "dm_i", // dotdigital
          "ef_id", // Adobe Advertising Cloud
          "email_source",
          "epik", // Pinterest
          "fbclid", // Facebook
          "fblid",
          "gclid", // Google AdWords/Analytics
          "gclsrc", // Google DoubleClick
          "hsCtaTracking", // HubSpot
          "igshid", // Instagram
          "mkwid", // Marin
          "msclkid", // Microsoft Advertising
          "pcrid", // Marin
          "rb_clickid", // Unknown high-entropy
          "redirect_log_mongo_id", // Springbot
          "redirect_mongo_id", // Springbot
          "s_cid", // Adobe Site Catalyst
          "s_kwcid", // Adobe Analytics
          "sb_referer_host", // Springbot
          "wickedid", // Wicked Reports
          "yclid", // Yandex click ID
        ];

        const search = url.search
          .split("&")
          .map((parameter) => parameter.split("="))
          .filter(([key]) =>
            !removeKeysStartingWith.some(
              (startingWith) => key.startsWith(startingWith)
            )
          )
          .filter(([key]) => !removeKeys.some((removeKey) => key === removeKey));

        return {
          ...url,
          search: search.map((parameter) => parameter.join("=")).join("&"),
        };
      },
    }
  ],
  handlers: [
    // Work: Azure DevOps
    {
      match: "*dev.azure.com*",
      browser: getBrowser("work")
    },
    // Work: Microsoft Teams handler
    {
      match: finicky.matchHostnames("teams.microsoft.com"),
      browser: "com.microsoft.teams",
      url({ url }) {
        return {
          ...url,
          protocol: "msteams",
        };
      },
    },
    // Work: source apps
    {
      match: ({ opener }) =>
        [
          "com.tinyspeck.slackmacgap",
          "com.microsoft.teams",
          "com.microsoft.Outlook",
        ].includes(opener.bundleId),
      browser: getBrowser("work")
    },
    // Work: specific domains
    {
      match: [
        "*.abnamro.com*",
        "*.abnamro.org*",
        "https://portal.azure.com*",
      ],
      browser: getBrowser("work")
    },
    // Personal: social and IM apps
    {
      match: ({ opener }) =>
        [
          "com.facebook.archon",
          "ru.keepcoder.Telegram",
          "com.hnc.Discord",
          "WhatsApp"
        ].includes(opener.bundleId),
      browser: getBrowser("home")
    },
    // Personal: local and private domains
    {
      match: [
        "github.com/wwmoraes*",
        "*.local*",
        "*.com.br*",
        "*.thuisbezorgd.nl*",
        "*.krisp.ai*"
      ],
      browser: getBrowser("home")
    },
    // General: apps that should open on the main browser directly
    {
      match: ({ opener }) =>
        [
          "com.1password.1password"
        ].includes(opener.bundleId),
      browser: getBrowser("main")
    }
  ]
};
