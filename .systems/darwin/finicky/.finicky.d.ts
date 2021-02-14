/// <reference types="finicky" />

export module Finicky {
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
