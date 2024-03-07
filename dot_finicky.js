/** @typedef {"main"|"work"|"home"} Context */
/** @typedef {Record<Context,string>} Contexts */
/** @typedef {Record<string,Contexts>} Browsers */
/** @typedef {Record<string,string>} Applications */

/** @type {Applications} */
const apps = {
  Chrome: "com.google.Chrome",
  Edge: "com.microsoft.edgemac",
  Firefox: "org.mozilla.firefox",
  Safari: "com.apple.Safari",
};

/** @type {Browsers} */
const browsers = {
  "NLLM4000559023": {
    main: apps.Firefox,
    work: apps.Firefox,
    home: apps.Safari,
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
  // finicky.log(finicky.getSystemInfo().name);
  const context = browsers[finicky.getSystemInfo().name] || defaultBrowsers;
  return context[contextName];
};

/**
  * @param {string} prefix
  * @returns {import("./.finicky.d").Finicky.Rewrite}
*/
const prefixBGone = (prefix) => ({
  match: ({ urlString }) => urlString.startsWith(prefix),
  url: ({ urlString }) => decodeURIComponent(urlString.substring(prefix.length).replace(/%25/g, "%")).replaceAll(" ", "%20"),
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

const suffixBGone = (prefix, suffix) => ({
  match: ({ urlString }) => urlString.endsWith(suffix),
  url: ({ urlString }) => decodeURIComponent(urlString.substring(0, urlString.length - suffix.length).replace(/%25/g, "%")),
});

const matchBGone = (re) => ({
  match: ({ urlString }) => urlString.match(re),
  url: ({ urlString }) => decodeURIComponent(urlString.replace(re, "").replace(/%25/g, "%")).replaceAll(" ", "%20"),
});

const defaultPrefix = (prefix) => ({
  match: ({ urlString }) => !urlString.match(/^[a-z]+:\/\//),
  url: ({ urlString }) => "https://" + urlString,
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
    // gotta love those email trackers
    prefixBGone("https://click.pstmrk.it/3s/"),
    matchBGone(/\/nqxP\/[^/]{6}\/AQ\/.*/),
    // new gimmick: urldefense.com wraps the URL with some hash at the end
    prefixBGone("https://urldefense.com/v3/__"),
    matchBGone(/__;!!.*?\$$/),
    // some trackers don't add the protocol to the target URL, so we add https
    defaultPrefix("https://"),
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
    },
    // Youtu.be => Yattee
    {
      // https://youtu.be/T_O-NeTvUzs?feature=shared
      match: ({ urlString }) => urlString.startsWith("https://youtu.be"),
      // https://r.yattee.stream/watch?feature=shared&v=T_O-NeTvUzs
      url: ({ urlString }) => "https://r.yattee.stream/watch?v=" + urlString.replace(/https:\/\/youtu\.be\/([^\?]+)(\?.*)?/, "$1"),
    },
    // Youtube => Yattee
    {
      match: ({ url }) => url.host == "youtube.com",
      url: ({ url }) => "https://r.yattee.stream/watch?v=" + url.search.replace(/.*(v=[^&]+).*/, "$1"),
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
      browser: "com.microsoft.teams2",
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
          "com.microsoft.teams2",
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
