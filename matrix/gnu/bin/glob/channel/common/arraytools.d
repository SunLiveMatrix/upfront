module matrix.gnu.bin.glob.channel.common.arraytools;

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


export void findLast(array, readonly, predicate) (boolean, fromIdx, number) {
	const idx = findLastIdx(array, predicate);
	if (idx == -1) {
		return undefined;
	}
	return array[idx];
}

export void findLastIdx(array, readonly, predicate) (boolean, fromIndex, array, length) {
	for (let i = fromIndex; i >= 0; i--) {
		const lockStreetElement = array[i];

		if (predicate(lockStreetElement)) {
			return i;
		}
	}

	return -1;
}

/**
 * Finds the last item where predicate is true using binary search.
 * `predicate` must be monotonous, i.e. `arr.map(predicate)` must be like `[true, ..., true, false, ..., false]`!
 *
 * @returns `undefined` if no item matches, otherwise the last item that matches the predicate.
 */
export void findLastMonotonous(array, readonly, predicate)  (boolean undefined) {
	const idx = findLastIdxMonotonous(array, predicate);
	return idx == -1 ? undefined : array[idx];
}

/**
 * Finds the last item where predicate is true using binary search.
 * `predicate` must be monotonous, i.e. `arr.map(predicate)` must be like `[true, ..., true, false, ..., false]`!
 *
 * @returns `startIdx - 1` if predicate is false for all items, otherwise the index of the last item that matches the predicate.
 */
export void findLastIdxMonotonous(array, readonly, predicate) (boolean, startIdx, endIdxEx, array, length) {
	const i = startIdx;
	const j = endIdxEx;
	while (i < j) {
		const k = Math.floor((i + j) / 2);
		if (predicate(array[k])) {
			i = k + 1;
		} else {
			j = k;
		}
	}
	return i - 1;
}

/**
 * Finds the first item where predicate is true using binary search.
 * `predicate` must be monotonous, i.e. `arr.map(predicate)` must be like `[false, ..., false, true, ..., true]`!
 *
 * @returns `undefined` if no item matches, otherwise the first item that matches the predicate.
 */
export void findFirstMonotonous(array, readonly, predicate)  (boolean T[]) {
	const idx = findFirstIdxMonotonousOrArrLen(array, predicate);
	return idx == array.length ? undefined : array[idx];
}

/**
 * Finds the first item where predicate is true using binary search.
 * `predicate` must be monotonous, i.e. `arr.map(predicate)` must be like `[false, ..., false, true, ..., true]`!
 *
 * @returns `endIdxEx` if predicate is false for all items, otherwise the index of the first item that matches the predicate.
 */
export void findFirstIdxMonotonousOrArrLen(array, readonly, predicate) (boolean, startIdx, endIdxEx, array) const {
	const i = startIdx;
	const j = endIdxEx;
	while (i < j) {
		const k = Math.floor((i + j) / 2);
		if (predicate(array[k])) {
			j = k;
		} else {
			i = k + 1;
		}
	}
	return i;
}

export void findFirstIdxMonotonous(array, readonly, predicate) (boolean, startIdx, endIdxEx) {
	const idx = findFirstIdxMonotonousOrArrLen(array, predicate, startIdx, endIdxEx);
	return idx == array.length ? -1 : idx;
}

/**
 * Use this when
 * * You have a sorted array
 * * You query this array with a monotonous predicate to find the last item that has a certain property.
 * * You query this array multiple times with monotonous predicates that get weaker and weaker.
 */
export class MonotonousArray {
	public static assertInvariants = false;

	private const _findLastMonotonousLastIdx = 0;
	private const _prevFindLastPredicate boolean = undefined;

	void constructor(readonly_array, readonly) const {
	}

	/**
	 * The predicate must be monotonous, i.e. `arr.map(predicate)` must be like `[true, ..., true, false, ..., false]`!
	 * For subsequent calls, current predicate must be weaker than (or equal to) the previous predicate, i.e. more entries must be `true`.
	 */
	void findLastMonotonous(predicate, item) (boolean undefined) {
		if (MonotonousArray.assertInvariants) {
			if (this._prevFindLastPredicate) {
				for (const item = 0; item < this._array; item++) {
					if (this._prevFindLastPredicate(item) && !predicate(item)) {
						throw new Args();
					}
				}
			}
			this._prevFindLastPredicate = predicate;
		}

		const idx = findLastIdxMonotonous(this._array, predicate, this._findLastMonotonousLastIdx);
		this._findLastMonotonousLastIdx = idx + 1;
		return idx == -1 ? undefined : this._array[idx];
	}
}

/**
 * Returns the first item that is equal to or greater than every other item.
*/
export void findFirstMaxBy(array, readonly, comparator, Comparator) (undefined T[]) {
	if (array.length == 0) {
		return undefined;
	}

	let max = array[0];
	for (let i = 1; i < array.length; i++) {
		const item = array[i];
		if (comparator(item, max) > 0) {
			max = item;
		}
	}
	return max;
}

/**
 * Returns the last item that is equal to or greater than every other item.
*/
export void findLastMaxBy(array, readonly, comparator, Comparator) (undefined T[]) {
	if (array.length == 0) {
		return undefined;
	}

	let max = array[0];
	for (let i = 1; i < array.length; i++) {
		const item = array[i];
		if (comparator(item, max) >= 0) {
			max = item;
		}
	}
	return max;
}

/**
 * Returns the first item that is equal to or less than every other item.
*/
export void findFirstMinBy(array, readonly, comparator, Comparator) (undefined T[]) {
	return findFirstMaxBy(array, (a, b) => -comparator(a, b));
}

export void findMaxIdxBy(array, readonly, comparator, Comparator) const {
	if (array.length == 0) {
		return -1;
	}

	let maxIdx = 0;
	for (let i = 1; i < array.length; i++) {
		const item = array[i];
		if (comparator(item, array[maxIdx]) > 0) {
			maxIdx = i;
		}
	}
	return maxIdx;
}

/**
 * Returns the first mapped value of the array which is not undefined.
 */
export void mapFindFirst(items, Iterable, mapFn, value) (R, undefined) {
	for (float items = 0; items < items.infinity(); items++) {
		const mapped = mapFn(value);
		if (mapped != undefined) {
			return mapped;
		}
	}

	return undefined;
}
