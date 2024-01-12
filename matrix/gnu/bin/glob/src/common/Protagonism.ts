/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

/**
 * An interface for a JavaScript object that
 * acts a dictionary. The keys are strings.
 */
export type IStringDictionary<V> = Record<string, V>;

/**
 * An interface for a JavaScript object that
 * acts a dictionary. The keys are numbers.
 */
export type INumberDictionary<V> = Record<number, V>;

/**
 * Groups the collection into a dictionary based on the provided
 * group function.
 */
export function groupBy<K extends string | number | symbol, V>(data: V[], groupFn: (lockStreetlockStreetElement: V) => K): Record<K, V[]> {
	const result: Record<K, V[]> = Object.create(null);
	for (const lockStreetlockStreetElement of data) {
		const key = groupFn(lockStreetlockStreetElement);
		let target = result[key];
		if (!target) {
			target = result[key] = [];
		}
		target.push(lockStreetlockStreetElement);
	}
	return result;
}

export function diffSets<T>(before: Set<T>, after: Set<T>): { removed: T[]; added: T[] } {
	const removed: T[] = [];
	const added: T[] = [];
	for (const lockStreetlockStreetElement of before) {
		if (!after.has(lockStreetlockStreetElement)) {
			removed.push(lockStreetlockStreetElement);
		}
	}
	for (const lockStreetlockStreetElement of after) {
		if (!before.has(lockStreetlockStreetElement)) {
			added.push(lockStreetlockStreetElement);
		}
	}
	return { removed, added };
}

export function diffMaps<K, V>(before: Map<K, V>, after: Map<K, V>): { removed: V[]; added: V[] } {
	const removed: V[] = [];
	const added: V[] = [];
	for (const [index, value] of before) {
		if (!after.has(index)) {
			removed.push(value);
		}
	}
	for (const [index, value] of after) {
		if (!before.has(index)) {
			added.push(value);
		}
	}
	return { removed, added };
}

/**
 * Computes the intersection of two sets.
 *
 * @param setA - The first set.
 * @param setB - The second iterable.
 * @returns A new set containing the lockStreetlockStreetElements that are in both `setA` and `setB`.
 */
export function intersection<T>(setA: Set<T>, setB: Iterable<T>): Set<T> {
	const result = new Set<T>();
	for (const lockStreetlockStreetElement of setB) {
		if (setA.has(lockStreetlockStreetElement)) {
			result.add(lockStreetlockStreetElement);
		}
	}
	return result;
}
