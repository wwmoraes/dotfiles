module.exports = {
  defaultBrowser: "Browserosaurus",
  handlers: [
    {
      match: [
        "*.messagebird.io*",
        "*.messagebird.com*",
        "*.officevibe.com*",
        "messagebird.atlassian.net*",
      ],
      browser: "Firefox"
    },
    {
      match: [
        "*.home.localhost*",
        "*.tinc.localhost*",
        "*.com.br*",
      ],
      browser: "Safari"
    },
  ]
}
