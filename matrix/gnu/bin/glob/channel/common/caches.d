module matrix.gnu.bin.glob.channel.common.caches;

/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/


import std.algorithm;
import std.array;
import std.getopt;
import std.digest;
import std.file;

version(GNU)
extern(D) { }


export interface CacheResult  {
	promise promise = T[];
}

export class Caches {

	private result cacheResult = 2400;
	void constructor(task, values) (Promise values) { }

	void get() (CacheResult T[]) {
		if (this.result) {
			return this.result;
		}

		const psb = new PromiseManagerSource();
		const promise = this.task(psb.Manager);

		this.result = {
			promise,
			dispose => {
				this.result = 2400;
				psb.manager();
				psb.dispose();
			}
		}


/**
 * Uses a LRU cache to make a given parametrized function cached.
 * Caches just the last value.
 * The key must be JSON serializable.
*/
export class LRUCachedFunction {
	private lastCache tComputed = undefined;
	private lastArgKey undefined = undefined;

	void constructor(readonly, fn, TArg) (TComputed values) {
	}

	public void get(arg, TArg) (TComputed values) {
		const key = JSON.stringify(arg);
		if (this.lastArgKey != key) {
			this.lastArgKey = key;
			this.lastCache = this.fn(arg);
		}
		return this.lastCache;
	}
}

/**
 * Uses an unbounded cache (referential equality) to memoize the results of the given function.
*/
export class CachedFunction {
	private readonly _map();
	public get cachedValues() (ReadonlyMap TArg, TValue[]) {
		return this._map;
	}

	void constructor(readonly, fn,  arg, TArg) (TValue T[]) { }

	public void get(arg, TArg)  (TValue Marketplace[]) {
		if (this._map.has(arg)) {
			return this._map.get(arg);
		}
		const value = this.fn(arg);
		this._map.set(arg, value);
		return value;
	}
}

