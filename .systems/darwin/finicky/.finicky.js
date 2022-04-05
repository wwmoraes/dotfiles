/** @typedef {"work"|"home"} Context */
/** @typedef {Record<Context,string>} Contexts */
/** @typedef {Record<string,Contexts>} Browsers */

/** @type {Browsers} */
const browsers = {
  "c02dq36nmd6p.local": {
    work: "com.microsoft.edgemac",
    home: "com.google.Chrome",
  },
};

/** @type {Contexts} */
const defaultBrowsers = {
  work: "org.mozilla.firefox",
  home: "com.apple.Safari",
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
    {
      match: "*dev.azure.com*",
      /// TODO investigate and contribute to finicky's browser path detection
      /// to work with apps on the home Applications folder
      browser: "com.fluidapp.FluidApp2.AzureDevOps"
    },
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
    {
      match: ({ opener }) =>
        [
          "com.tinyspeck.slackmacgap",
          "com.microsoft.teams",
          "com.microsoft.Outlook",
        ].includes(opener.bundleId),
      browser: getBrowser("work")
    },
    {
      match: [
        "*.abnamro.com*",
        "*.abnamro.org*",
        "https://portal.azure.com*",
      ],
      browser: getBrowser("work")
    },
    {
      match: ({ opener }) =>
        [
          "com.facebook.archon",
          "ru.keepcoder.Telegram",
          "com.hnc.Discord",
          "WhatsApp",
          "com.fluidapp.FluidApp2.LinkedIn",
          "com.readdle.smartemail-Mac"
        ].includes(opener.bundleId),
      browser: getBrowser("home")
    },
    {
      match: [
        "github.com/wwmoraes*",
        "*.home.localhost*",
        "*.tinc.localhost*",
        "*.com.br*",
        "*.thuisbezorgd.nl*",
        "*.krisp.ai*"
      ],
      browser: getBrowser("home")
    },
  ]
};
