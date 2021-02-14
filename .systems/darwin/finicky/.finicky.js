/// <reference path="./finicky.d.ts" />
/// <reference path="./.finicky.d.ts" />
/** @type {import("./.finicky.d").Finicky.Config} */
module.exports = {
  defaultBrowser: "Browserosaurus",
  rewrite: [
    {
      match: () => true,
      url({ url }) {
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
      match: ({ sourceBundleIdentifier }) =>
        [
          "com.tinyspeck.slackmacgap",
          "com.microsoft.teams",
          "com.microsoft.Outlook",
        ].includes(sourceBundleIdentifier),
      browser: "Firefox"
    },
    {
      match: [
        "*.abnamro.com/*",
        "*.abnamro.org/*",
        "*.azure.com/*",
      ],
      browser: "Firefox"
    },
    {
      match: ({ sourceBundleIdentifier }) =>
        [
          "com.facebook.archon",
          "ru.keepcoder.Telegram",
          "com.hnc.Discord",
          "WhatsApp",
          "com.fluidapp.FluidApp2.LinkedIn",
        ].includes(sourceBundleIdentifier),
      browser: "Safari"
    },
    {
      match: [
        "github.com/wwmoraes*",
        "*.home.localhost*",
        "*.tinc.localhost*",
        "*.com.br*",
        "*.thuisbezorgd.nl*"
      ],
      browser: "Safari"
    },
  ]
};
