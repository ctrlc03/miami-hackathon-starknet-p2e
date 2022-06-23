import type { DisconnectOptions, GetStarknetWalletOptions, IStarknetWindowObject } from "./types";
export declare const getStarknet: () => IStarknetWindowObject;
export declare const connect: (options?: GetStarknetWalletOptions | undefined) => Promise<IStarknetWindowObject | undefined>;
export declare const disconnect: (options?: DisconnectOptions | undefined) => boolean;
export * from "./types";
