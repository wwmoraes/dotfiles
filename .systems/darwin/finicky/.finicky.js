/** @typedef {"main"|"work"|"home"} Context */
/** @typedef {Record<Context,string>} Contexts */
/** @typedef {Record<string,Contexts>} Browsers */
/** @typedef {Record<string,string>} Applications */

/** @type {Applications} */
const apps = {
  Edge: "com.microsoft.edgemac",
  Chrome: "com.google.Chrome",
  Firefox: "org.mozilla.firefox",
  Safari: "com.apple.Safari",
};

/** @type {Browsers} */
const browsers = {
  "c02dq36nmd6p.local": {
    main: apps.Edge,
    work: apps.Edge,
    home: apps.Chrome,
  },
};

/** @type {Contexts} */
const defaultBrowsers = {
  main: apps.Firefox,
  work: apps.Chrome,
  home: apps.Firefox,
};

/**
 * @param {Context} contextName
 * @returns {import("./.finicky.d").Finicky.BrowserFn}
 * */
const getBrowser = (contextName) => (params) => {
  const context = browsers[finicky.getSystemInfo().name] || defaultBrowsers;
  return context[contextName];
};

/// <reference path="./.finicky.d.ts" />
/** @type {import("./.finicky.d").Finicky.Config} */
module.exports = {
  defaultBrowser: "Browserosaurus",
  rewrite: [
    // cleanup TLDR newsletter links
    {
      match: "tracking.tldrnewsletter.com/*",
      url: ({ url }) => {
        let newUrlString = url.pathname.replace(/.*?(https?)/, "$1");
        let length = 0;
        while (newUrlString.length != length) {
          length = newUrlString.length;
          newUrlString = decodeURI(newUrlString);
        }
        return newUrlString;
      },
    },
    // remove tracking query parameters
    {
      match: () => true,
      url: ({ url }) => {
        const removeKeysStartingWith = ["utm_", "uta_"];
        const removeKeys = ["fblid", "gclid", "auto_subscribed", "email_source"];

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
      /// TODO investigate and contribute to finicky's browser path detection
      /// to work with apps on the home Applications folder
      browser: "com.fluidapp.FluidApp2.AzureDevOps"
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
          "WhatsApp",
          "com.fluidapp.FluidApp2.LinkedIn"
        ].includes(opener.bundleId),
      browser: getBrowser("home")
    },
    // Personal: local and private domains
    {
      match: [
        "github.com/wwmoraes*",
        "*.home.localhost*",
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
