/// <reference path="./.finicky.d.ts" />
/** @type {import("./.finicky.d").Finicky.Config} */
module.exports = {
  defaultBrowser: "OpenIn",
  rewrite: [
    {
      match: "tracking.tldrnewsletter.com/*",
      url: ({ url }) => {
        let newUrlString = url.pathname.replace(/.*?(https?)/, "$1");
        let length = 0;
        while (newUrlString.length != length) {
          length = newUrlString.length;
          newUrlString = unescape(newUrlString);
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
      match: ({ opener }) =>
        [
          "com.tinyspeck.slackmacgap",
          "com.microsoft.teams",
          "com.microsoft.Outlook",
        ].includes(opener.bundleId),
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
      match: ({ opener }) =>
        [
          "com.facebook.archon",
          "ru.keepcoder.Telegram",
          "com.hnc.Discord",
          "WhatsApp",
          "com.fluidapp.FluidApp2.LinkedIn",
          "com.readdle.smartemail-Mac"
        ].includes(opener.bundleId),
      browser: "Safari"
    },
    {
      match: [
        "github.com/wwmoraes*",
        "*.home.localhost*",
        "*.tinc.localhost*",
        "*.com.br*",
        "*.thuisbezorgd.nl*",
        "*.krisp.ai/*"
      ],
      browser: "Safari"
    },
  ]
};
