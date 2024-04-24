/** @typedef {"main"|"work"|"home"} Context */
/** @typedef {Record<Context,string>} Contexts */
/** @typedef {Record<string,Contexts>} Browsers */
/** @typedef {Record<string,string>} Applications */

if (typeof URLSearchParams === "undefined" || URLSearchParams === null) {
  URLSearchParams = class URLSearchParamsPolyfill {
    /**
     * @readonly
     * @type {number}
     */
    size;

    /**
     * @private
     * @type {Record<string, string[]>}
     */
    data;

    /**
     * @param {string[][] | Record<string, string> | string | URLSearchParams} [init]
     */
    constructor(init) {
      switch (typeof init) {
        case "string":
          Object.defineProperty(this, "data", {
            configurable: false,
            enumerable: true,
            value: init.split("&").reduce(
              /**
               * @param {Record<string,string[]>} obj
               */
              (obj, entry) => {
                const pair = entry.split("=", 2);
                let value = obj[pair[0]] || new Array();
                value.push(pair[1]);
                obj[pair[0]] = value;
                return obj;
              },
              {},
            ),
            writable: false,
          });
          break;
        default:
          throw new Error("URLSearchParams polyfill supports string init only");
      }

      Object.defineProperty(this, "size", {
        configurable: false,
        enumerable: false,
        value: Object.keys(this.data).length,
        writable: false,
      });
    }

    /**
     * Appends a specified key/value pair as a new search parameter.
     *
     * [MDN Reference](https://developer.mozilla.org/docs/Web/API/URLSearchParams/append)
     * @param {string} name
     * @param {string} value
     */
    append(name, value) {
      let currentValue = this.data[name] || new Array();
      currentValue.push(value);
      this.data[name] = currentValue;
    }

    /**
     * Deletes the given search parameter, and its associated value, from the list of all search parameters.
     *
     * [MDN Reference](https://developer.mozilla.org/docs/Web/API/URLSearchParams/delete)
     * @param {string} name
     * @param {string} [value]
     */
    delete(name, value) {
      const currentValues = this.data[name];
      if (typeof currentValues === "undefined" || currentValues === null) {
        return;
      }

      if (typeof value !== "undefined" && value !== null) {
        this.data[name] = currentValues.filter(currentValue => currentValue != value);
        return;
      }

      this.data[name] = null;
    }

    /**
     * Returns the first value associated to the given search parameter.
     *
     * [MDN Reference](https://developer.mozilla.org/docs/Web/API/URLSearchParams/get)
     * @param {string} name
     * @returns {string | null}
     */
    get(name) {
      return (this.data[name] || [])[0] || null;
    };

    /**
     * Returns all the values association with a given search parameter.
     *
     * [MDN Reference](https://developer.mozilla.org/docs/Web/API/URLSearchParams/getAll)
     * @param {string} name
     * @returns {string[]}
     */
    getAll(name) {
      return this.data[name] || [];
    }

    /**
     * Returns a Boolean indicating if such a search parameter exists.
     *
     * [MDN Reference](https://developer.mozilla.org/docs/Web/API/URLSearchParams/has)
     * @param {string} name
     * @param {string} [value]
     * @returns {boolean}
     */
    has(name, value) {

    }

    /**
     * Sets the value associated to a given search parameter to the given value. If there were several values, delete the others.
     *
     * [MDN Reference](https://developer.mozilla.org/docs/Web/API/URLSearchParams/set)
     * @param {string} name
     * @param {string} value
     */
    set(name, value) {
      this.data[name] = [value];
    }

    /** [MDN Reference](https://developer.mozilla.org/docs/Web/API/URLSearchParams/sort) */
    sort() {

    }

    /** Returns a string containing a query string suitable for use in a URL. Does not include the question mark.
     * @returns {string}
     */
    toString() {
      return Object.entries(this.data).map(([key, values]) =>
        values.map(value => key + "=" + value).join("&")).join("&");
    }

    /**
     * @callback forEachCallback
     * @param {string} value
     * @param {string} key
     * @param {URLSearchParams} parent
     */

    /**
     * @param {forEachCallback} callbackfn
     * @param {any} [thisArg]
     */
    forEach(callbackfn, thisArg) {
      Object.entries(this.data).forEach(([key, values]) =>
        values.forEach(value => callbackfn(value, key, thisArg || this)));
    }

    /** Returns an array of key, value pairs for every entry in the search params.
     * @returns {IterableIterator<[string, string]>}
     */
    [Symbol.iterator]() {
      return Object.entries(this.data).map(([key, values]) =>
        values.map(value => [key, value])).flat(1);
    }

    /** Returns an array of key, value pairs for every entry in the search params.
     * @returns {IterableIterator<[string, string]>}
     */
    entries() {
      return Object.entries(this.data).map(([key, values]) =>
        values.map(value => [key, value])).flat(1);
    }

    /** Returns a list of keys in the search params. */
    /**
     * @returns {IterableIterator<string>}
     */
    keys() {
      return Object.keys(this.data);
    }

    /** Returns a list of values in the search params. */
    /**
     * @returns {IterableIterator<string>}
     */
    values() {
      return Object.values(this.data);
    }
  };
}

/** @type {Applications} */
const apps = {
  Chrome: "com.google.Chrome",
  Edge: "com.microsoft.edgemac",
  Firefox: "org.mozilla.firefox",
  Safari: "com.apple.Safari",
};

/** @type {Browsers} */
const browsers = {
  "nllm4000559023.local": {
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
    // new gimmick: awstrack wraps the URL with some hash at the end
    matchBGone(/^https:\/\/.+\.awstrack\.me\/L0\//),
    matchBGone(/\/[0-9]\/\w{16}-\w{8}-\w{4}-\w{4}-\w{4}-\w{12}-\w{6}\/\S+=[0-9]+$/),
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
