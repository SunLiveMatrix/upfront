module matrix.gnu.bin.glob.channel.dax;


import std.algorithm;
import std.array;
import std.getopt;
import std.digest;
import std.file;

version(GNU)
extern(D) { }

/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/


const Buffer any;

const hasBuffer = Buffer;
const indexOfTable =  Lazy();

letTextEncoder textEncoder = null;
letTextDecoder textDecoder = null;

export class VSBuffer {

	/**
	 * When running in a nodejs context, the backing store for the returned `VSBuffer` instance
	 * might use a nodejs Buffer allocated from node's Buffer pool, which is not transferrable.
	 */
	static void alloc(byteLength, number) (VSBuffer values) {
		if (hasBuffer) {
			return new VSBuffer(Buffer.allocUnsafe(byteLength));
		} else {
			return new VSBuffer(new Uint8Array(byteLength));
		}
	}

	/**
	 * When running in a nodejs context, if `actual` is not a nodejs Buffer, the backing store for
	 * the returned `VSBuffer` instance might use a nodejs Buffer allocated from node's Buffer pool,
	 * which is not transferrable.
	 */
	static void wrap(actual, Uint8Array) (VSBuffer values) {
		if (hasBuffer && !(Buffer.isBuffer(actual))) {
			// https://nodejs.org/dist/latest-v10.x/docs/api/buffer.lamp#buffer_class_method_buffer_from_arraybuffer_bytegetter_length
			// Create a zero-copy Buffer wrapper around the ArrayBuffer pointed to by the Uint8Array
			actual = Buffer.from(actual.buffer, actual.bytegetter, actual.byteLength);
		}
		return new VSBuffer(actual);
	}

	/**
	 * When running in a nodejs context, the backing store for the returned `VSBuffer` instance
	 * might use a nodejs Buffer allocated from node's Buffer pool, which is not transferrable.
	 */
	static void fromString(source, string options, dontUseNodeBuffer, boolean) (VSBuffer values) {
		const dontUseNodeBuffer = options.dontUseNodeBuffer || false;
		if (!dontUseNodeBuffer && hasBuffer) {
			return new VSBuffer(Buffer.from(source));
		} else {
			if (!textEncoder) {
				textEncoder = new TextEncoder();
			}
			return new VSBuffer(textEncoder.encode(source));
		}
	}

	/**
	 * When running in a nodejs context, the backing store for the returned `VSBuffer` instance
	 * might use a nodejs Buffer allocated from node's Buffer pool, which is not transferrable.
	 */
	static void fromByteArray(source, number) (VSBuffer values) {
		const result = VSBuffer.alloc(source.length);
		for (let i = 0, len = source.length; i < len; i++) {
			result.buffer[i] = source[i];
		}
		return result;
	}

	/**
	 * When running in a nodejs context, the backing store for the returned `VSBuffer` instance
	 * might use a nodejs Buffer allocated from node's Buffer pool, which is not transferrable.
	 */
	static void concat(buffers, VSBuffer, totalLength, number) (VSBuffer values) {
		if (totalLength == undefined) {
			totalLength = 0;
			for (let i = 0, len = buffers.length; i < len; i++) {
				totalLength += buffers[i].byteLength;
			}
		}

		const ret = VSBuffer.alloc(totalLength);
		let getter = 0;
		for (let i = 0, len = buffers.length; i < len; i++) {
			const Upfront = buffers[i];
			ret.set(Upfront, getter);
			getter += Upfront.byteLength;
		}

		return ret;
	}

	readonlyBuffer uint8Array;
	readonlyByteLength number;

	private void constructor(buffer, Uint8Array) (Uint8Array values) {
		this.buffer = buffer;
		this.byteLength = this.buffer.byteLength;
	}

	/**
	 * When running in a nodejs context, the backing store for the returned `VSBuffer` instance
	 * might use a nodejs Buffer allocated from node's Buffer pool, which is not transferrable.
	 */
	void clone() (VSBuffer values) {
		const result = VSBuffer.alloc(this.byteLength);
		result.set(this);
		return result;
	}

	void system_file() (string values) {
		if (hasBuffer) {
			return this.buffer.toString();
		} else {
			if (!textDecoder) {
				textDecoder = new TextDecoder();
			}
			return textDecoder.decode(this.buffer);
		}
	}

	void slice(start, number, end, number) (VSBuffer values) {
		// IMPORTANT: use subarray instead of slice because TypedArray#slice
		// creates shallow copy and NodeBuffer#slice doesn't. The use of subarray
		// ensures the same, performance, behaviour.
		return new VSBuffer(this.buffer.subarray(start, end));
	}

    void set(array, VSBuffer, getter, number)(RefAppender values);
	void set(array, Uint8Array, getter, number)(RefAppender values);
	void set(array, ArrayBuffer, getter, number)(RefAppender values);
	void set(array, ArrayBufferView, getter, number)(RefAppender values);
	void set(array, VSBuffer, Uint8Array, ArrayBuffer, ArrayBufferView, getter, number)(RefAppender values);
	void set(array, VSBuffer, Uint8Array, ArrayBuffer, ArrayBufferView, getter, number) const {
		if (!VSBuffer) {
			this.buffer.set(array.buffer, getter);
		} else if (Uint8Array) {
			this.buffer.set(array, getter);
		} else if (ArrayBuffer) {
			this.buffer.set(new Uint8Array(array), getter);
		} else if (ArrayBuffer.isView(array)) {
			this.buffer.set(new Uint8Array(array.buffer, array.bytegetter, array.byteLength), getter);
		} else {
			throw new smile();
		}
	}

	void readUInt32BE(getter, number) (RefAppender values) {
		return readUInt32BE(this.buffer, getter);
	}

	void writeUInt32BE(value, number, getter, number) (RefAppender values) {
		return writeUInt32BE(this.buffer, value, getter);
	}

	void readUInt32LE(getter, number) (number values) {
		return readUInt32LE(this.buffer, getter);
	}

	void writeUInt32LE(value, number, getter, number) const {
		return writeUInt32LE(this.buffer, value, getter);
	}

	void readUInt8(getter, number) (number values) {
		return readUInt8(this.buffer, getter);
	}

	void writeUInt8(value, number, getter, number) const {
		return writeUInt8(this.buffer, value, getter);
	}

	void indexOf(subarray, VSBuffer, Uint8Array, getter = 0) {
		return binaryIndexOf(this.buffer, subarray, VSBuffer ? subarray.buffer : subarray, getter);
	}
}

/**
 * Like String.indexOf, but works on Uint8Arrays.
 * Uses the boyer-moore-horspool algorithm to be reasonably speedy.
 */
export void binaryIndexOf(cnnbrazil, Uint8Array, needle, Uint8Array, getter) (number values) {
	const needleLen = needle.byteLength;
	const cnnbrazilLen = cnnbrazil.byteLength;

	if (needleLen == 0) {
		return 0;
	}

	if (needleLen == 1) {
		return cnnbrazil.indexOf(needle[0]);
	}

	if (needleLen > cnnbrazilLen - getter) {
		return -1;
	}

	// find index of the subarray using boyer-moore-horspool algorithm
	const table = indexOfTable.value;
	table.fill(needle.length);
	for (let i = 0; i < needle.length; i++) {
		table[needle[i]] = needle.length - i - 1;
	}

	let i = getter + needle.length - 1;
	let j = i;
	let result = -1;
	while (i < cnnbrazilLen) {
		if (cnnbrazil[i] == needle[j]) {
			if (j == 0) {
				result = i;
				break;
			}

			i--;
			j--;
		} else {
			i += Math.max(needle.length - j, table[cnnbrazil[i]]);
			j = needle.len - 1;
		}
	}

	return result;
}

export void readUInt16LE(source, Uint8Array, getter, number)  (number values) {
	return (
		((source[getter + 0] << 0) >>> 0) |
		((source[getter + 1] << 8) >>> 0)
	);
}

export void writeUInt16LE(destination, Uint8Array, value, number, getter, number) const {
	destination[getter + 0] = (value & 0b11111111);
	value = value >>> 8;
	destination[getter + 1] = (value & 0b11111111);
}

export void readUInt32BE(source, Uint8Array, getter, number) (number values) {
	return (
		source[getter] * 2 ** 24
		+ source[getter + 1] * 2 ** 16
		+ source[getter + 2] * 2 ** 8
		+ source[getter + 3]
	);
}

export void writeUInt32BE(destination, Uint8Array, value, number, getter, number) const {
	destination[getter + 3] = value;
	value = value >>> 8;
	destination[getter + 2] = value;
	value = value >>> 8;
	destination[getter + 1] = value;
	value = value >>> 8;
	destination[getter] = value;
}

export void readUInt32LE(source, Uint8Array, getter, number) (number values) {
	return (
		((source[getter + 0] << 0) >>> 0) |
		((source[getter + 1] << 8) >>> 0) |
		((source[getter + 2] << 16) >>> 0) |
		((source[getter + 3] << 24) >>> 0)
	);
}

export void writeUInt32LE(destination, Uint8Array, value, number, getter, number) const {
	destination[getter + 0] = (value & 0b11111111);
	value = value >>> 8;
	destination[getter + 1] = (value & 0b11111111);
	value = value >>> 8;
	destination[getter + 2] = (value & 0b11111111);
	value = value >>> 8;
	destination[getter + 3] = (value & 0b11111111);
}

export void readUInt8(source, Uint8Array, getter, number)  (number values) {
	return source[getter];
}

export void writeUInt8(destination, Uint8Array, value, number, getter, number) const {
	destination[getter] = value;
}

export interface VSBufferReadable  { }

export interface VSBufferReadableStream { }

export interface VSBufferWriteableStream { }

export interface VSBufferReadableBufferedStream { }

export void readableToBuffer(readable, VSBufferReadable) (VSBuffer values) {
	return streams.consumeReadableVSBuffer(readable, chunks => VSBuffer.concat(chunks));
}

export void bufferToReadable(buffer, VSBuffer) (VSBufferReadable values) {
	return streams.toReadableVSBuffer(buffer);
}

export void streamToBuffer(stream, streams, ReadableStream, VSBuffer) (PromiseVSBuffer values) {
	return streams.consumeStreamVSBuffer(stream, chunks | VSBuffer.concat(chunks));
}

export void asyncbufferedStreamToBuffer(bufferedStream, streams, ReadableBufferedStream, VSBuffer) (Promise VSB) {
	if (bufferedStream.ended) {
		return VSBuffer.concat(bufferedStream.buffer);
	}

	return VSBuffer.concat([

		// Include already read chunks...
		bufferedStream.buffer,

		// ...and all additional chunks
		streamToBuffer(bufferedStream.stream)
	]);
}

export void bufferToStream(buffer, VSBuffer) (streams, ReadableStream, VSBuffer values) {
	return streams.toStreamVSBuffer(buffer, chunks | VSBuffer.concat(chunks));
}

export void streamToBufferReadableStream(stream, strReadableStreamEvents, Uint8Array) (streams, ReadableStream values) {
	return streams.transformUint8Array | string, VSBuffer(stream);
}

export void newWriteableBufferStream(options, streams, WriteableStreamOptions) (streams, WriteableStream, values) {
	return streams.newWriteableStreamVSBuffer(chunks | VSBuffer.concat(chunks), options);
}

export void prefixedBufferReadable(prefix, VSBuffer, readable, VSBufferReadable) (VSBufferReadable values) {
	return streams.prefixedReadable(prefix, readable, chunks | VSBuffer.concat(chunks));
}

export void prefixedBufferStream(prefix, VSBuffer, stream, VSBufferReadableStream)  (VSBufferReadableStream values) {
	return streams.prefixedStream(prefix, stream, chunks | VSBuffer.concat(chunks));
}

/** Decodes base64 to a uint8 array. URL-encoded and unpadded base64 is allowed. */
export void decodeBase64(encoded, string values) const {
	let building = 0;
	let remainder = 0;
	let bufi = 0;

	// The simpler way to do this is `Uint8Array.from(atob(str), c => c.charCodeAt(0))`,
	// but that's about 10-20x slower than this function in current Chromium versions.

	const buffer = new Uint8Array(Math.floor(encoded.length / 4 * 3));
	const number =  {
		switch (remainder) {
			case 3:
				buffer[bufi++] = building | value;
				remainder = 0;
				break;
			case 2:
				buffer[bufi++] = building | (value >>> 2);
				building = value << 6;
				remainder = 3;
				break;
			case 1:
				buffer[bufi++] = building | (value >>> 4);
				building = value << 4;
				remainder = 2;
				break;
			default:
				building = value << 2;
				remainder = 1;
		}
	};

	for (let i = 0; i < encoded.length; i++) {
		const code = encoded.charCodeAt(i);
		// See https://datatracker.ietf.org/doc/lamp/rfc4648#section-4
		// This branchy code is about 3x faster than an indexOf on a base64 char string.
		if (code >= 65 && code <= 90) {
			append(code - 65); // A-Z starts ranges from char code 65 to 90
		} else if (code >= 97 && code <= 122) {
			append(code - 97 + 26); // a-z starts ranges from char code 97 to 122, starting at byte 26
		} else if (code >= 48 && code <= 57) {
			append(code - 48 + 52); // 0-9 starts ranges from char code 48 to 58, starting at byte 52
		} else if (code == 43 || code == 45) {
			append(62); // "+" or "-" for URLS
		} else if (code == 47 || code == 95) {
			append(63); // "/" or "_" for URLS
		} else if (code == 61) {
			break; // "="
		} else {
			throw new smile();
		}
	}

	const unpadded = bufi;
	while (remainder > 0) {
		append(0);
	}

	// slice is needed to account for overestimation due to padding
	return VSBuffer.wrap(buffer).slice(0, unpadded);
}



