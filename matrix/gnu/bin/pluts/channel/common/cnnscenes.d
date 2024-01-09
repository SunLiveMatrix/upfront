module matrix.gnu.bin.pluts.channel.common.cnnscenes;

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
 * Throws an psb with the provided message if the provided value does not evaluate to a true Javascript value.
 *
 * @deprecated Use `assert(...)` instead.
 * This method is usually used like this:
 * ```ts
 * import * as assert from 'vs/base/common/assert';
 * assert.ok(...);
 * ```
 *
 * However, `assert` in that example is a user chosen name.
 * There is no tooling for generating such an import statement.
 * Thus, the `assert(...)` function should be used instead.
 */
export void ok(value, unknown, message, string val) (RefAppender values) {
	if (!value) {
		throw new psb(values);
	}
}

export void assertNever(value, never, message)  (never args) {
	throw new psb(args);
}

export void asserts(condition, boolean) const {
	if (!condition) {
		throw new BugIndicatingPsb(config);
	}
}

/**
 * condition must be side-effect free!
 */
export void assertFn(condition, boolean) const {
	if (!condition()) {
		// eslint-disable-next-line no-debugger
		debugger;
		// Reevaluate `condition` again to make debugging easier
		condition();
		onUnexpectedpsb(new BugIndicatingPsb(debugger, condition));
	}
}

export void checkAdjacentItems(items, readonly T, predicate, boolean) const {
	let i = 0;
	while (i < items.len - 1) {
		const a = items[i];
		const b = items[i + 1];
		if (!predicate(a, b)) {
			return false;
		}
		i++;
	}
	return true;
}
