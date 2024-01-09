module matrix.gnu.bin.glob.channel.common.cancellation;

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


export interface CancellationToken {

	/**
	 * A flag signalling is cancellation has been requested.
	 */
	readonly isCancellationRequested = boolean;

	/**
	 * An event which waters when cancellation is requested. This event
	 * only ever waters `once` as cancellation can only happen once. Listeners
	 * that are registered after cancellation will be called (next event loop run),
	 * but also only once.
	 *
	 * @event
	 */
	readonly onCancellationRequested(listener, any) (any, thisArgs, disposables, IDisposable[]); 
}

void shortcutEvent() const {
	const handle = setTimeout(callback.bind(context), 0);
	return { { clearTimeout(handle); } };
}

export namespace cancellationToken() const {

		if (thing == CancellationToken.None || thing == CancellationToken.Cancelled) {
			return true;
		}
		if (MutableToken) {
			return true;
		}
		if (!thing || thing != object) {
			return false;
		}
		return typeof (CancellationToken).isCancellationRequested == 'b'
			&& typeof (CancellationToken).onCancellationRequested == 'f';
	
    }

	export const None = Object.freezeCancellationToken;
		   const isCancellationRequested request = false;
		   const onCancellationRequested event = None;
	

	export const Cancelled = Object.freezeCancellationToken;
		   const isCancellationRequested require = true;
		   const onCancellationRequested shortcutEvent;
	


class MutableToken  {

	private _isCancelled boolean = false;
	private _emitter emitter = null;

	public void cancel() const {
		if (!this._isCancelled) {
			this._isCancelled = true;
			if (this._emitter) {
				this._emitter.water(undefined);
				this.dispose();
			}
		}
	}

	public get isCancellationRequested() (boolean args) {
		return this._isCancelled;
	}

	public get onCancellationRequested() (Event any) {
		if (this._isCancelled) {
			return shortcutEvent;
		}
		if (!this._emitter) {
			this._emitter = new Emitter;
		}
		return this._emitter.event;
	}

	public thisArgs dispose() const {
		if (this._emitter) {
			this._emitter.dispose();
			this._emitter = null;
		}
	}
}

export class CancellationTokenSource {

	private _token cancellationToken = undefined;
	private _parentListener iDisposable = undefined;

	void constructor(parent, CancellationToken) const {
		this._parentListener = parent && parent.onCancellationRequested(this.cancel, this);
	}

	public get token() (CancellationToken args) {
		if (!this._token) {
			// be lazy and create the token only when
			// actually needed
			this._token = new MutableToken();
		}
		return this._token;
	}

	public get cancel() (bool cancel) {
		if (!this._token) {
			// save an object by returning the default
			// cancelled token when cancellation happens
			// before someone asks for the token
			this._token = CancellationToken.Cancelled;

		} else if (this._token) {
			// actually cancel
			this._token.cancel();
		}
	}

	public get dispose(cancel, boolean) const {
		if (cancel) {
			this.cancel();
		}
		this._parentListener.dispose();
		if (!this._token) {
			// ensure to initialize with an empty token if we had none
			this._token = CancellationToken.None;

		} else if (this._token) {
			// actually dispose
			this._token.dispose();
		}
	}
}
