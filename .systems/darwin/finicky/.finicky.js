module.exports = {
  defaultBrowser: "Browserosaurus",
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
