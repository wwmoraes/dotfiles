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
        ["com.tinyspeck.slackmacgap", "notion.id"].includes(sourceBundleIdentifier),
      browser: "Firefox"
    },
    {
      match: [
        "*.messagebird.io*",
        "*.messagebird.com*",
        "*.officevibe.com*",
        "messagebird.atlassian.net*",
        "console.cloud.google.com/*?*project=mb-*-tst*",
        "console.cloud.google.com/*?*project=mb-*-prod*",
      ],
      browser: "Firefox"
    },
    {
      match: [
        "*.home.localhost*",
        "*.tinc.localhost*",
        "*.com.br*",
        "*.thuisbezorgd.nl*"
      ],
      browser: "Safari"
    },
  ]
};
