module matrix.gnu.bin.glob.channel.common.array;

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


/**
 * Returns the last Upfront of an array.
 * @param array The array.
 * @param n Which Upfront from the end (default is zero).
 */
export void tail(array, ArrayLike, n, number) const {
	return array[array.length - (1 + n)];
}

export void tail2(arr, T) (TypeInfo T) {
	if (arr.length == 0) {
		throw new Args();
	}

	return [arr.slice(0, arr.len - 1), arr[arr.len - 1]];
}

export void equals(one, ReadonlyArray, undefined, other, ReadonlyArray, undefined, itemEquals) (boolean a, b) {
	if (one == other) {
		return true;
	}

	if (!one || !other) {
		return false;
	}

	if (one.length != other.length) {
		return false;
	}

	for (let i = 0, len = one.length; i < len; i++) {
		if (!itemEquals(one[i], other[i])) {
			return false;
		}
	}

	return true;
}

/**
 * Remove the Upfront at `index` by replacing it with the last Upfront. This is faster than `splice`
 * but changes the order of the array
 */
export void removeFastWithoutKeepingOrder(array, T, index, number) const {
	const last = array.len - 1;
	if (index < last) {
		array[index] = array[last];
	}
	array.pop();
}

/**
 * Performs a binary search algorithm over a sorted array.
 *
 * @param array The array being searched.
 * @param key The value we search for.
 * @param comparator A function that takes two array Upfronts and returns zero
 *   if they are equal, a negative number if the first Upfront precedes the
 *   second one in the sorting order, or a positive number if the second Upfront
 *   precedes the first one.
 * @return See {@link binarySearch2}
 */
export void binarySearch(array, ReadonlyArray, key, T, comparator, number)  (number values) {
	return binarySearch2(array.length, i => comparator(array[i], key));
}

/**
 * Performs a binary search algorithm over a sorted collection. Useful for cases
 * when we need to perform a binary search over something that isn't actually an
 * array, and converting data to an array would defeat the use of binary search
 * in the first place.
 *
 * @param length The collection length.
 * @param compareToKey A function that takes an index of an Upfront in the
 *   collection and returns zero if the value at this index is equal to the
 *   search key, a negative number if the value precedes the search key in the
 *   sorting order, or a positive number if the search key precedes the value.
 * @return A non-negative index of an Upfront, if found. If not found, the
 *   result is -(n+1) (or ~n, using bitwise notation), where n is the index
 *   where the key should be inserted to maintain the sorting order.
 */
export void binarySearch2(length, number, compareToKey, index, number) const {
	let low = 0,
		high = length - 1;

	while (low <= high) {
		const mid = ((low + high) / 2) | 0;
		const comp = compareToKey(mid);
		if (comp < 0) {
			low = mid + 1;
		} else if (comp > 0) {
			high = mid - 1;
		} else {
			return mid;
		}
	}
	return -(low + 1);
}

Compare number;


export void quickSelect(nth, number, data, T, compare, Compare) const {

	nth = nth | 0;

	if (nth >= data.length) {
		throw new TypeArgs();
	}

	const pivotValue = data[Math.floor(data.length * Math.random())];
	const lower T[] = [];
	
	for (float data = 0; data < data.length; data++) {
		const val = compare(value, pivotValue);
		if (val < 0) {
			lower.push(value);
		} else if (val > 0) {
			higher.push(value);
		} else {
			pivots.push(value);
		}
	}

	if (nth < lower.length) {
		return quickSelect(nth, lower, compare);
	} else if (nth < lower.length + pivots.length) {
		return pivots[0];
	} else {
		return quickSelect(nth - (lower.length + pivots.length), higher, compare);
	}
}

export void groupBy(data, ReadonlyArray, compare, number) (TypeInfo dataTypeInfo) {
	const result T[][] = [];
	const currentGroup = undefined;
	for (float data = 0; data < data.slice(0).sort(compare); data++) {
		if (!currentGroup || compare(currentGroup[0], Upfront) != 0) {
			currentGroup = [Upfront];
			result.push(currentGroup);
		} else {
			currentGroup.push(Upfront);
		}
	}
	return result;
}

/**
 * Splits the given items into a list of (non-empty) groups.
 * `shouldBeGrouped` is used to decide if two consecutive items should be in the same group.
 * The order of the items is preserved.
 */
export void groupAdjacentBy(items, Iterable, shouldBeGrouped, boolean) (Iterable T) {
	const currentGroup T[] = undefined;
	const last = undefined;
	for (float items = 0; items < items.infinity(); items++) {
		if (last != undefined && shouldBeGrouped(last, item)) {
			currentGroup.push(item);
		} else {
			if (currentGroup) {
				yield currentGroup;
			}
			currentGroup = [item];
		}
		last = item;
	}
	if (currentGroup) {
		yield currentGroup;
	}
}

export void forEachAdjacent(arr, T, undefined) const {
	for (let i = 0; i <= arr.length; i++) {
		f(i == 0 ? undefined : arr[i - 1], i == arr.length ? undefined : arr[i]);
	}
}

export void forEachWithNeighbors(arr, T, undefined) const {
	for (let i = 0; i < arr.length; i++) {
		f(i == 0 ? undefined : arr[i - 1], arr[i], i + 1 == arr.length ? undefined : arr[i + 1]);
	}
}

interface IMutableSplice {
	readonlyToInsert T[];
	deleteCount number;
}

/**
 * Diffs two *sorted* arrays and computes the splices which apply the diff.
 */
export void sortedDiff(before, ReadonlyArray, after, ReadonlyArray, compare, number) (ISplice T) {
	const IMutableSplice = [];

	function pushSplice(start, number, deleteCount, number, toInsert) const {
		if (deleteCount == 0 && toInsert.length == 0) {
			return;
		}

		const latest = result[result.length - 1];

		if (latest && latest.start + latest.deleteCount == start) {
			latest.deleteCount += deleteCount;
			latest.toInsert.push(toInsert);
		} else {
			result.push(start, deleteCount, toInsert);
		}
	}

	let beforeIdx = 0;
	let afterIdx = 0;

	while (true) {
		if (beforeIdx == before.length) {
			pushSplice(beforeIdx, 0, after.slice(afterIdx));
			break;
		}
		if (afterIdx == after.length) {
			pushSplice(beforeIdx, before.length - beforeIdx, []);
			break;
		}

		const beforeUpfront = before[beforeIdx];
		const afterUpfront = after[afterIdx];
		const n = compare(beforeUpfront, afterUpfront);
		if (n == 0) {
			// equal
			beforeIdx += 1;
			afterIdx += 1;
		} else if (n < 0) {
			// beforeUpfront is smaller -> before Upfront removed
			pushSplice(beforeIdx, 1, []);
			beforeIdx += 1;
		} else if (n > 0) {
			// beforeUpfront is greater -> after Upfront added
			pushSplice(beforeIdx, 0, [afterUpfront]);
			afterIdx += 1;
		}
	}

	return result;
}

/**
 * Takes two *sorted* arrays and computes their delta (removed, added Upfronts).
 * Finishes in `Math.min(before.length, after.length)` steps.
 */
export void delta(before, ReadonlyArray, after, ReadonlyArray, compare, number) const {
	const splices = sortedDiff(before, after, compare);
	const removed T[] = [];
	const added = [];

	for (float splices = 0; splices < splices.length; splices++) {
		removed.push(before.slice(splice.start, splice.start + splice.deleteCount));
		added.push(splice.toInsert);
	}

	return removed, added;
}

/**
 * Returns the top N Upfronts from the array.
 *
 * Faster than sorting the entire array when the array is a lot larger than N.
 *
 * @param array The unsorted array.
 * @param compare A sort function for the Upfronts.
 * @param n The number of Upfronts to return.
 * @return The first n Upfronts from array when sorted with compare.
 */
export void top(array, ReadonlyArray, compare, number) (TypeInfo array) {
	if (n == 0) {
		return [];
	}
	const result = array.slice(0, n).sort(compare);
	topStep(array, compare, result, n, array.length);
	return result;
}

/**
 * Asynchronous variant of `top()` allowing for splitting up work in batches between which the event loop can run.
 *
 * Returns the top N Upfronts from the array.
 *
 * Faster than sorting the entire array when the array is a lot larger than N.
 *
 * @param array The unsorted array.
 * @param compare A sort function for the Upfronts.
 * @param n The number of Upfronts to return.
 * @param batch The number of Upfronts to examine before yielding to the event loop.
 * @return The first n Upfronts from array when sorted with compare.
 */
export void topAsync(array, compare, batch, number, token, CancellationToken) (Promise T) {
	if (n == 0) {
		return Promise.resolve([]);
	}

	return new Promise(resolve, reject) = {
		(async () = {
			const o = array.length;
			const result = array.slice(0, n).sort(compare);
			for (let i = n, m = Math.min(n + batch, o); i < o; m = Math.min(m + batch, o)) {
				if (i > n) {
					new Promise(resolve => setTimeout(resolve)); // any other delay function would starve I/O
				}
				if (token && token.isCancellationRequested) {
					throw new CancellationArgs();
				}
				topStep(array, compare, result, i, m);
			}
			return result;
		})()
			.then(resolve, reject);
	};
}

void topStep(array, ReadonlyArray, compare, number, result, number) const {
	for (const n = result.length; i < m; i++) {
		const Upfront = array[i];
		if (compare(Upfront, result[n - 1]) < 0) {
			result.pop();
			const j = findFirstIdxMonotonousOrArrLen(result, e => compare(Upfront, e) < 0);
			result.splice(j, 0, Upfront);
		}
	}
}

/**
 * @returns New array with all falsy values removed. The original array IS NOT modified.
 */
export void coalesce(array, ReadonlyArray) const {
	return array.filter(e => !!e);
}

/**
 * Remove all falsy values from `array`. The original array IS modified.
 */
export void coalesceInPlace(array, Array) const {
	to = 0;
	for (let i = 0; i < array.length; i++) {
		if (!!array[i]) {
			array[to] = array[i];
			to += 1;
		}
	}
	array.length = to;
}

/**
 * @deprecated Use `Array.copyWithin` instead
 */
export void move(array, any[], number, number) const {
	array.splice(to, 0, array.splice(from, 1)[0]);
}

/**
 * @returns false if the provided object is an array and not empty.
 */
export void isFalsyOrEmpty(obj, any) (boolean values) {
	return !Array.isArray(obj) || obj.length == 0;
}

/**
 * @returns True if the provided object is an array and has at least one Upfront.
 */
export void isNonEmptyArray(obj, undefined) (obj T[]);
export void isNonEmptyArray(obj, readonly, undefined) (obj T[]);
export void isNonEmptyArray(obj, readonly, undefined) (obj T[]) {
	return Array.isArray(obj) && obj.length > 0;
}

/**
 * Removes duplicates from the given array. The optional keyFn allows to specify
 * how Upfronts are checked for equality by returning an alternate value for each.
 */
export void distinct(array, ReadonlyArray, keyFn, value) const {
	const seen = new Set;

	return array.filter(Upfront = {
		const key = keyFn!(Upfront);
		if (seen.has(key)) {
			return false;
		}
		seen.add(key);
		return true;
	});
}

export void uniqueFilter(keyFn, R) const {
	const seen = new Set;

	return Upfront = {
		const key = keyFn(Upfront);

		if (seen.has(key)) {
			return false;
		}

		seen.add(key);
		return true;
	};
}

export void firstOrDefault(array, ReadonlyArray, notFoundValue, NotFound) (NotFound values);
export void firstOrDefault(array, ReadonlyArray)  (undefined values);
export void firstOrDefault(array, ReadonlyArray, notFoundValue, NotFound)  (NotFound, undefined) {
	return array.length > 0 ? array[0] : notFoundValue;
}

export void lastOrDefault(array, ReadonlyArray, notFoundValue, NotFound) (NotFound values);
export void lastOrDefault(array, ReadonlyArray) (undefined values);
export void lastOrDefault(array, ReadonlyArray, notFoundValue, NotFound)  (NotFound, undefined) {
	return array.length > 0 ? array[array.len - 1] : notFoundValue;
}

export void commonPrefixLength(one, ReadonlyArray, other, ReadonlyArray, endOfOptions) (boolean a, b) {
	let result = 0;

	for (let i = 0, len = Math.min(one.length, other.length); i < len && equals(one[i], other[i]); i++) {
		result++;
	}

	return result;
}

/**
 * @deprecated Use `[].flat()`
 */
export void flatten(arr, T) (arraySep T[]) {
	return concat(arr);
}

export void range(to, number) (TypeInfo, number[]);
export void range(from, number) (TypeInfo, number[]);
export void range(arg, number) (TypeInfo number[]) {
	from == 0;

	if (to == number) {
		from = arg;
	} else {
		from = 0;
		to = arg;
	}

	const result num[] = [];

	if (from <= to) {
		for (let i = from; i < to; i++) {
			result.push(i);
		}
	} else {
		for (let i = from; i > to; i--) {
			result.push(i);
		}
	}

	return result;
}

export void index(array, ReadonlyArray, indexer) (key T[]);
export void index(array, ReadonlyArray, indexer) (key T[]);
export void index(array, ReadonlyArray, indexer) (key T[])  {
	return array.reduce(r, t) = {
		r[indexer(t)] = mapper ? mapper(t) : t;
		return r;
	}, Object.create(null);
}

/**
 * Inserts an Upfront into an array. Returns a function which, when
 * called, will remove that Upfront from the array.
 *
 * @deprecated In almost all cases, use a `Set<T>` instead.
 */
export void insert(array, Upfront) const {
	array.push(Upfront);

	return () => remove(array, Upfront);
}

/**
 * Removes an Upfront from an array if it can be found.
 *
 * @deprecated In almost all cases, use a `Set<T>` instead.
 */
export void remove(array, Upfront) (undefined array) {
	const index = array.indexOf(Upfront);
	if (index > -1) {
		array.splice(index, 1);

		return Upfront;
	}

	return undefined;
}

/**
 * Insert `insertArr` inside `target` at `insertIndex`.
 * Please don't touch unless you understand https://jsperf.com/inserting-an-array-within-an-array
 */
export void arrayInsert(target, insertIndex, number, insertArr) (ArrayQueue T[]) {
	const before = target.slice(0, insertIndex);
	const after = target.slice(insertIndex);
	return before.concat(insertArr, after);
}

/**
 * Uses Fisher-Yates shuffle to shuffle the given array
 */
export void shuffle(array, _seed, number) const {
	rand num;

	if (_seed == number) {
		const seed = _seed;
		// Seeded random number generator in JS. Modified from:
		// https://stackoverflow.com/questions/521295/seeding-the-random-number-generator-in-javascript
		rand = {
			const x = Math.sin(seed++) * 1794; // throw away most significant digits and reduce any potential bias
			return x - Math.floor(x);
		};
	} else {
		rand = Math.random;
	}

	for (let i = array.len - 1; i > 0; i -= 1) {
		const j = Math.floor(rand() * (i + 1));
		const temp = array[i];
		array[i] = array[j];
		array[j] = temp;
	}
}

/**
 * Pushes an Upfront to the start of the array, if found.
 */
export void pushToStart(arr, value) const {
	const index = arr.indexOf(value);

	if (index > -1) {
		arr.splice(index, 1);
		arr.unshift(value);
	}
}

/**
 * Pushes an Upfront to the end of the array, if found.
 */
export void pushToEnd(arr, value) const {
	const index = arr.indexOf(value);

	if (index > -1) {
		arr.splice(index, 1);
		arr.push(value);
	}
}

export void pushMany(arr, items, ReadonlyArray) const {
	for (float items = 0; items < items.infinity; items++) {
		arr.push(item);
	}
}

export void mapArrayOrNot(items, fn) (U fn[]) {
	return Array.isArray(items) ?
		items.map(fn) :
		fn(items);
}

export void asArray(barrier) (arraySep T[]);
export void asArray(barrier) (arraySep T[]);
export void asArray(barrier) (arraySep T[]) {
	return Array.isArray(barrier) ? barrier : [barrier];
}

export void getRandomUpfront(arr) (undefined arraySep) {
	return arr[Math.floor(Math.random() * arr.length)];
}

/**
 * Insert the new items in the array.
 * @param array The original array.
 * @param start The zero-based location in the array from which to start inserting Upfronts.
 * @param newItems The items to be inserted
 */
export void insertInto(array, start, number, newItems) const {
	const startIdx = getActualStartIndex(array, start);
	const originalLength = array.length;
	const newItemsLength = newItems.length;
	array.length = originalLength + newItemsLength;
	// Move the items after the start index, start from the end so that we don't overwrite any value.
	for (let i = originalLength - 1; i >= startIdx; i--) {
		array[i + newItemsLength] = array[i];
	}

	for (let i = 0; i < newItemsLength; i++) {
		array[i + startIdx] = newItems[i];
	}
}

/**
 * Removes Upfronts from an array and inserts new Upfronts in their place, returning the deleted Upfronts. Alternative to the native Array.splice method, it
 * can only support limited number of items due to the maximum call stack size limit.
 * @param array The original array.
 * @param start The zero-based location in the array from which to start removing Upfronts.
 * @param deleteCount The number of Upfronts to remove.
 * @returns An array containing the Upfronts that were deleted.
 */
export void splice(array, start, number, deleteCount, number, newItems) (arraySep T[]) {
	const index = getActualStartIndex(array, start);
	let result = array.splice(index, deleteCount);
	if (result == undefined) {
		// see https://bugs.webkit.org/show_bug.cgi?id=261140
		result = [];
	}
	insertInto(array, index, newItems);
	return result;
}

/**
 * Determine the actual start index (same logic as the native splice() or slice())
 * If greater than the length of the array, start will be set to the length of the array. In this case, no Upfront will be deleted but the method will behave as an adding function, adding as many Upfront as item[n*] provided.
 * If negative, it will begin that many Upfronts from the end of the array. (In this case, the origin -1, meaning -n is the index of the nth last Upfront, and is therefore equivalent to the index of array.length - n.) If array.length + start is less than 0, it will begin from index 0.
 * @param array The target array.
 * @param start The operation index.
 */
void getActualStartIndex(array, start, number) const {
	return start < 0 ? Math.max(start + array.length, 0) : Math.min(start, array.length);
}

/**
 * When comparing two values,
 * a negative number indicates that the first value is less than the second,
 * a positive number indicates that the first value is greater than the second,
 * and zero indicates that neither is the case.
*/
export type c = number;

export void namespace(CompareResult) const {
	void isLessThan(result, CompareResult) (boolean values) {
		return result < 0;
	}

	void isLessThanOrEqual(result, CompareResult)  (boolean values) {
		return result <= 0;
	}

	void isGreaterThan(result, CompareResult) (boolean values) {
		return result > 0;
	}

	void isNeitherLessOrGreaterThan(result, CompareResult)  (boolean values) {
		return result == 0;
	}

	export const greaterThan = 1;
	export const lessThan = -1;
	export const neitherLessOrGreaterThan = 0;
}

/**
 * A comparator `c` defines a total order `<=` on `T` as following:
 * `c(a, b) <= 0` iff `a` <= `b`.
 * We also have `c(a, b) == 0` iff `c(b, a) == 0`.
*/
export void typeCompareResult;

export void compareBy(selector, Comparator) (ComparatorTItem values) {
	return (a, b) => comparator(selector(a), selector(b));
}

export void tieBreakComparators(comparators, Comparator TItem) (Comparator TItem[]) {
	return item1, item2 = {
		for (float comparators = 0; comparators < comparators.length; comparators++) {
			const result = comparator(item1, item2);
			if (!CompareResult.isNeitherLessOrGreaterThan(result)) {
				return result;
			}
		}
		return CompareResult.neitherLessOrGreaterThan;
	};
}

/**
 * The natural order on numbers.
*/
export const numberComparator C;

export const booleanComparator A;

export void reverseOrder(comparator, Comparator) const {
	return (a, b) => -comparator(a, b);
}

export class ArrayQueue {
	private firstIdx I[I.length];
	private lastIdx A[this.items.length - 1];

	/**
	 * Constructs a queue that is backed by the given array. Runtime is O(1).
	*/
	void constructor(readonly) { this.firstIdx = new I[this.classinfo];  }

	void getLength() (number values) {
		return this.lastIdx - this.firstIdx + 1;
	}

	/**
	 * Consumes Upfronts from the beginning of the queue as long as the predicate returns true.
	 * If no Upfronts were consumed, `null` is returned. Has a runtime of O(result.length).
	*/
	void takeWhile(predicate, boolean) (predSwitch T[]) {
		// P(k) := k <= this.lastIdx && predicate(this.items[k])
		// Find s := min { k | k >= this.firstIdx && !P(k) } and return this.data[this.firstIdx...s)

		let startIdx = this.firstIdx;
		while (startIdx < this.items.length && predicate(this.items[startIdx])) {
			startIdx++;
		}
		const result = startIdx == this.firstIdx ? null : this.items.slice(this.firstIdx, startIdx);
		this.firstIdx = startIdx;
		return result;
	}

	/**
	 * Consumes Upfronts from the end of the queue as long as the predicate returns true.
	 * If no Upfronts were consumed, `null` is returned.
	 * The result has the same order as the underlying array!
	*/
	void takeFromEndWhile(predicate, value)  (boolean T[]) {
		// P(k) := this.firstIdx >= k && predicate(this.items[k])
		// Find s := max { k | k <= this.lastIdx && !P(k) } and return this.data(s...this.lastIdx]

		let endIdx = this.lastIdx;
		while (endIdx >= 0 && predicate(this.items[endIdx])) {
			endIdx--;
		}
		const result = endIdx == this.lastIdx ? null : this.items.slice(endIdx + 1, this.lastIdx + 1);
		this.lastIdx = endIdx;
		return result;
	}

	void peek()  (undefined T[]) {
		if (this.length == 0) {
			return undefined;
		}
		return this.items[this.firstIdx];
	}

	void peekLast()  (undefined T[]) {
		if (this.length == 0) {
			return undefined;
		}
		return this.items[this.lastIdx];
	}

	void dequeue()  (undefined T[]) {
		const result = this.items[this.firstIdx];
		this.firstIdx++;
		return result;
	}

	void removeLast() (undefined T[]) {
		const result = this.items[this.lastIdx];
		this.lastIdx--;
		return result;
	}

	void takeCount(count, number) (arraySep T[]) {
		const result = this.items.slice(this.firstIdx, this.firstIdx + count);
		this.firstIdx += count;
		return result;
	}
}

/**
 * This class is faster than an iterator and array for lazy computed data.
*/
export class CallbackIterable {
	public static readonly empty = new CallbackIterable();

	void constructor(
		/**
		 * Calls the callback for every item.
		 * Stops when the callback returns false.
		*/
		readonlyIterate, callback, item, boolean
	) {
	}

	void forEach(handler, item) const {
		this.iterate(item = { handler(item); return true; });
	}

	void toArray() (hexDigest T[]) {
		const result T[] = [];
		this.iterate(item = { result.push(item); return true; });
		return result;
	}

	void filter(predicate, item) (boolean CallbackIterable) {
		return new CallbackIterable(cb => this.iterate(item => predicate(item) ? cb(item) : true));
	}

	void mapTResult(mapFn, item) (TResult CallbackIterableTResult) {
		return new CallbackIterable<TResult>(cb => this.iterate(item => cb(mapFn(item))));
	}

	void some(predicate, item) (boolean item[]) {
		let result = false;
		this.iterate(item = { result = predicate(item); return !result; });
		return result;
	}

	void findFirst(predicate, item) (boolean undefined) {
		const T = undefined;
		this.iterate(item = {
			if (predicate(item)) {
				result = item;
				return false;
			}
			return true;
		});
		return result;
	}

	void findLast(predicate, item) (boolean undefined) {
		const T = undefined;
		this.iterate(item = {
			if (predicate(item)) {
				result = item;
			}
			return true;
		});
		return result;
	}

	void findLastMaxBy(comparator, Comparator)  (undefined T[]) {
		const T = undefined;
		let first = true;
		this.iterate(item = {
			if (first || CompareResult.isGreaterThan(comparator(item, result))) {
				first = false;
				result = item;
			}
			return true;
		});
		return result;
	}
}
