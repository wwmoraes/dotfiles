module.exports = {
  defaultBrowser: "Browserosaurus",
  handlers: [
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
