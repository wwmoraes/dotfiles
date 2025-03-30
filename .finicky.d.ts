// / <reference types="finicky" />

declare global {
	/** Finicky utility functions available within the configuration */
	export const finicky: Finicky.API;
}

export module Finicky {
	/** Finicky global API available on user-land configuration script */
	export interface API {
		/** logs a string to the finicky console */
		log: (message: string) => void;
		/** display a notification */
		notify: (title: string, subtitle: string) => void;
		/** get the battery status */
		getBattery: () => BatteryInfo;
		/** get the pressed status of keyboard modifier keys */
		getKeys: () => ModifierState;
		/** get system information */
		getSystemInfo: () => SystemInfo;
		/** utility function to make it easier to match on the domain/hostnames part */
		matchHostnames: (matchers: string | RegExp | (string | RegExp)[]) => boolean;
	}

	/** host battery information */
	export interface BatteryInfo {
		/** true if the computer is charging */
		isCharging: boolean;
		/** true if the computer is plugged on power */
		isPluggedIn: boolean;
		/** current battery percentage (0-100) */
		chargePercentage: number;
	}

	/** modifier keys' state information */
	export interface ModifierState {
		/** `true` if the Control key is pressed */
		control: boolean;
		/** `true` if the Fn key is pressed */
		function: boolean;
		/** `true` if the Shift key is pressed */
		shift: boolean;
		/** `true` if the Option/Alt key is pressed */
		option: boolean;
		/** `true` if the Command key is pressed */
		command: boolean;
		/** `true` if Caps Lock is on */
		capsLock: boolean;
	}

	/** host system information */
	export interface SystemInfo {
		localizedName: string;
		name: string;
	}

	/** user configuration */
	export interface Config {
		defaultBrowser?: BrowserParameter;
		options?: Options;
		handlers?: Handler[];
		rewrite?: Rewrite[];
	}

	export interface Parameters {
		/** full URL as string */
		urlString: string;
		/** URL detailed information */
		url: URLInfo;
		/** source application which triggered the URL to open */
		opener: Opener;
		/**
		 * status of modifier keys on keyboard
		 * @deprecated replaced by `finicky.getKeys` */
		keys: ModifierState;
		/** @deprecated use `opener.bundleId` instead */
		sourceBundleIdentifier: string;
		/** @deprecated use `opener.path` instead */
		sourceProcessPath: string;
	}

	export interface Opener {
		pid: number;
		path: string;
		bundleId: string;
		name: string;
	}

	export interface Options {
		/** hide the finicky icon from the top bar (default `false`) */
		hideIcon?: boolean;
		/** check for update on startup (default `true`) */
		checkForUpdate?: boolean;
		/** change the internal list of url shortener services (default `undefined`) */
		urlShorteners?: (list: string[]) => string[];
		/** log every request with basic information to console. (default `false`) */
		logRequests?: boolean;
	}

	export interface Handler {
		/** matches the incoming URL against one or more  */
		match: MatchParameter;
		browser: BrowserParameter;
	}

	export interface Rewrite {
		match: MatchParameter;
		url: string | URLFn;
	}

	export interface Browser {
		name: string;
		profile?: string;
		appType?: "appName" | "bundleId" | "appPath";
		openInBackground?: boolean;
	}

	/** URL representation broken down by its components */
	export interface URLInfo {
		protocol: string;
		username?: string;
		password?: string;
		host: string;
		port?: number;
		pathname?: string;
		search?: string;
		hash?: string;
	}

	export type MatchParameter = string | RegExp | MatchFn | (string | RegExp | MatchFn)[];
	export type BrowserParameter = string | Browser | BrowserFn | (string | Browser | BrowserFn)[];

	export type MatchFn = (params: Parameters) => boolean;
	export type URLFn = (params: Parameters) => string | URLInfo;
	export type BrowserFn = (params: Parameters) => string | Browser;
}
