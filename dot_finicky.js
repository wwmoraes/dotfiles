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

if (typeof atob === "undefined" || atob === null) {
	const b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",
				// Regular expression to check formal correctness of base64 encoded strings
				b64re = /^(?:[A-Za-z\d+\/]{4})*?(?:[A-Za-z\d+\/]{2}(?:==)?|[A-Za-z\d+\/]{3}=?)?$/;

	const atob = function(string) {
		// atob can work with strings with whitespaces, even inside the encoded part,
		// but only \t, \n, \f, \r and ' ', which can be stripped.
		string = String(string).replace(/[\t\n\f\r ]+/g, "");
		if (!b64re.test(string))
				throw new TypeError("Failed to execute 'atob' on 'Window': The string to be decoded is not correctly encoded.");

		// Adding the padding if missing, for semplicity
		string += "==".slice(2 - (string.length & 3));
		var bitmap, result = "", r1, r2, i = 0;
		for (; i < string.length;) {
				bitmap = b64.indexOf(string.charAt(i++)) << 18 | b64.indexOf(string.charAt(i++)) << 12
								| (r1 = b64.indexOf(string.charAt(i++))) << 6 | (r2 = b64.indexOf(string.charAt(i++)));

				result += r1 === 64 ? String.fromCharCode(bitmap >> 16 & 255)
								: r2 === 64 ? String.fromCharCode(bitmap >> 16 & 255, bitmap >> 8 & 255)
								: String.fromCharCode(bitmap >> 16 & 255, bitmap >> 8 & 255, bitmap & 255);
		}
		return result;
	};

	globalThis.atob = atob;
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
	"nllm4000559023": {
		main: apps.Edge,
		work: apps.Edge,
		home: apps.Safari,
	},
};

/** @type {Contexts} */
const defaultBrowsers = {
	main: apps.Safari,
	work: apps.Safari,
	home: apps.Safari,
};

/**
 * @param {Context} contextName
 * @returns {import("./.finicky.d").Finicky.BrowserFn}
 * */
const getBrowser = (contextName) => (_) => {
	finicky.log(finicky.getSystemInfo().localizedName.split(".")[0]);

	const context = browsers[finicky.getSystemInfo().localizedName.split(".")[0].toLowerCase()] || defaultBrowsers;

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

/**
 * @param {string} suffix
 * @returns {import("./.finicky.d").Finicky.Rewrite}
 */
const suffixBGone = (suffix) => ({
	match: ({ urlString }) => urlString.endsWith(suffix),
	url: ({ urlString }) => decodeURIComponent(urlString.substring(0, urlString.length - suffix.length).replace(/%25/g, "%")),
});

/**
 * @param {string|RegExp} re
 * @returns {import("./.finicky.d").Finicky.Rewrite}
 */
const matchBGone = (re) => ({
	match: ({ urlString }) => urlString.match(re),
	url: ({ urlString }) => decodeURIComponent(urlString.replace(re, "").replace(/%25/g, "%")).replaceAll(" ", "%20"),
});

/**
 * @param {string} prefix
 * @returns {import("./.finicky.d").Finicky.Rewrite}
 */
const log = (prefix) => ({
	match: () => true,
	url: (params) => {
		finicky.log(prefix + ": " + params.urlString);

		return params.url;
	},
});

/**
 * @param {string} protocol
 * @returns {import("./.finicky.d").Finicky.Rewrite}
 */
const defaultProtocol = (protocol) => ({
	match: ({ urlString }) => !urlString.match(/^[a-z]+:\/\//),
	url: ({ urlString }) => protocol + "://" + urlString,
});

/**
 * @type {import("./.finicky.d").Finicky.URLFn}
 */
const fuckOffMandrill = ({ url }) =>
	JSON.parse(JSON.parse(atob((new URLSearchParams(url.search)).get("p"))).p).url;

/// <reference path="./.finicky.d.ts" />
/** @type {import("./.finicky.d").Finicky.Config} */
module.exports = {
	defaultBrowser: getBrowser("main"),
	rewrite: [
		// log("pre-rewrite"),
		redirectBGone("statics.teams.cdn.office.net", "url"),
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
		defaultProtocol("https"),
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
		},
		// Mandrill => wrapped URL
		{
			match: ({ urlString }) => urlString.startsWith("https://mandrillapp.com/track/click/"),
			url: fuckOffMandrill,
		},
		{
			// https://realm-group-holdings-limited.app.loxo.co/agencies/11114/email_tracking/click?id=197135213&url=https%3A%2F%2Fdocs.google.com%2Fdocument%2Fd%2F1JLYlq2f4pwksRTO61r4-Dlnu9LIjn3ToV66pS2qvabA%2Fedit
			match: ({ url }) => url.host == "realm-group-holdings-limited.app.loxo.co"
				&& url.pathname.includes("/email_tracking/"),
			url: ({ url }) => decodeURIComponent((new URLSearchParams(url.search)).get("url")),
		},
		// log("post-rewrite"),
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
				"*.office.net",
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
