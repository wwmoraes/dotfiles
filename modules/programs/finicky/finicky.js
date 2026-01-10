/** @import {FinickyConfig, UrlTransformer, UrlRewriteRule} from "/Users/william/Applications/Finicky.app/Contents/Resources/finicky.d.ts" */

if (typeof atob === "undefined" || atob === null) {
	console.log("polyfilling atob");

	const b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",
				// Regular expression to check formal correctness of base64 encoded strings
				b64re = /^(?:[A-Za-z\d+\/]{4})*?(?:[A-Za-z\d+\/]{2}(?:==)?|[A-Za-z\d+\/]{3}=?)?$/;

	/**
		* @param {string} value
		* @returns {string}
	 */
	const atob = function(value) {
		// atob can work with strings with whitespaces, even inside the encoded part,
		// but only \t, \n, \f, \r and ' ', which can be stripped.
		value = String(value).replace(/[\t\n\f\r ]+/g, "");
		if (!b64re.test(value))
				throw new TypeError("Failed to execute 'atob' on 'Window': The string to be decoded is not correctly encoded.");

		// Adding the padding if missing, for semplicity
		value += "==".slice(2 - (value.length & 3));
		var bitmap, result = "", r1, r2, i = 0;
		for (; i < value.length;) {
				bitmap = b64.indexOf(value.charAt(i++)) << 18 | b64.indexOf(value.charAt(i++)) << 12
								| (r1 = b64.indexOf(value.charAt(i++))) << 6 | (r2 = b64.indexOf(value.charAt(i++)));

				result += r1 === 64 ? String.fromCharCode(bitmap >> 16 & 255)
								: r2 === 64 ? String.fromCharCode(bitmap >> 16 & 255, bitmap >> 8 & 255)
								: String.fromCharCode(bitmap >> 16 & 255, bitmap >> 8 & 255, bitmap & 255);
		}
		return result;
	};

	globalThis.atob = atob;
}

/** @type {Record<string,string>} */
const apps = {
	Chrome: "com.google.Chrome",
	Edge: "com.microsoft.edgemac",
	Firefox: "org.mozilla.firefox",
	Safari: "com.apple.Safari",
};

/** @type {Record<string,Contexts>} */
const browsers = {
	"nllm4000559023": {
		main: apps.Edge,
		work: apps.Edge,
		home: apps.Safari,
	},
};

/** @typedef {"main"|"work"|"home"} Context */
/** @typedef {Record<Context,string>} Contexts */
/** @type {Contexts} */
const defaultBrowsers = {
	main: apps.Safari,
	work: apps.Safari,
	home: apps.Safari,
};

/**
 * @param {Context} contextName
 * @returns {BrowserResolver}
 * */
const getBrowser = (contextName) => (_) => {
	console.log(finicky.getSystemInfo().localizedName.split(".")[0]);

	const context = browsers[finicky.getSystemInfo().localizedName.split(".")[0].toLowerCase()] || defaultBrowsers;

	return context[contextName];
};

/**
 * @param {string} prefix
 * @returns {UrlRewriteRule}
 */
const prefixBGone = (prefix) => ({
	match: ({ href }) => href.startsWith(prefix),
	url: ({ href }) => decodeURIComponent(href.substring(prefix.length).replace(/%25/g, "%")).replaceAll(" ", "%20"),
});

/**
 * @param {string} host
 * @param {string} queryParam
 * @returns {UrlRewriteRule}
 */
const redirectBGone = (host, queryParam) => ({
	match: (url) => url.host.endsWith(host),
	url: (url) => url.searchParams.get(queryParam).replace(/%25/g, "%"),
});

/**
 * @param {string} suffix
 * @returns {UrlRewriteRule}
 */
const suffixBGone = (suffix) => ({
	match: (url) => url.href.endsWith(suffix),
	url: (url) => url.href.
		substring(0, (url.href.length - suffix.length)).
		replace(/%25/g, "%"),
});

/**
 * @param {string|RegExp} re
 * @returns {UrlRewriteRule}
 */
const matchBGone = (re) => ({
	match: ({ href }) => href.match(re),
	url: (url) => url.href.
		replace(re, "").
		replace(/%25/g, "%").
		replace( / /g, "%20"),
});

/**
 * @param {string} protocol
 * @returns {UrlRewriteRule}
 */
const defaultProtocol = (protocol) => ({
	match: (url) => !url.href.match(/^[a-z]+:\/\//),
	url: (url) => protocol + "://" + url.href,
});

/** @type {UrlTransformer} */
const fuckOffMandrill = (url) =>
	JSON.parse(JSON.parse(atob(url.searchParams.get("p"))).p).url;

/** @type {FinickyConfig} */
export default {
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
		// // Youtu.be => Yattee
		// {
		// 	// https://youtu.be/T_O-NeTvUzs?feature=shared
		// 	match: ({ href }) => href.startsWith("https://youtu.be"),
		// 	// https://r.yattee.stream/watch?feature=shared&v=T_O-NeTvUzs
		// 	url: ({ href }) => "https://r.yattee.stream/watch?v=" + href.replace(/https:\/\/youtu\.be\/([^\?]+)(\?.*)?/, "$1"),
		// },
		// // Youtube => Yattee
		// {
		// 	match: ({ url }) => url.host == "youtube.com",
		// 	url: ({ url }) => "https://r.yattee.stream/watch?v=" + url.search.replace(/.*(v=[^&]+).*/, "$1"),
		// },
		// Mandrill => wrapped URL
		{
			match: ({ href }) => href.startsWith("https://mandrillapp.com/track/click/"),
			url: fuckOffMandrill,
		},
		{
			// https://realm-group-holdings-limited.app.loxo.co/agencies/11114/email_tracking/click?id=197135213&url=https%3A%2F%2Fdocs.google.com%2Fdocument%2Fd%2F1JLYlq2f4pwksRTO61r4-Dlnu9LIjn3ToV66pS2qvabA%2Fedit
			match: ({ url }) => url.host == "realm-group-holdings-limited.app.loxo.co"
				&& url.pathname.includes("/email_tracking/"),
			url: (url) => decodeURIComponent(url.searchParams.get("url")),
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
			browser: "com.microsoft.teams2"
		},
		// Work: source apps
		{
			match: (_, { opener }) =>
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
			match: (_, { opener }) =>
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
			match: (_, { opener }) =>
				[
					"com.1password.1password"
				].includes(opener.bundleId),
			browser: getBrowser("main")
		}
	]
};
