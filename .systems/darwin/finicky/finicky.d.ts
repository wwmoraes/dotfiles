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
}
