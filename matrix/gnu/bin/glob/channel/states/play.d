module matrix.gnu.bin.glob.channel.play;

import std.algorithm;
import std.array;
import std.getopt;
import std.digest;
import std.file;

version(GNU)
extern(D) { }

export interface ILocalProcessExtensionHostInitData {
	readonlyExtensions extensionHostExtensions;
}

export interface ILocalProcessExtensionHostDataProvider {
	void getInitData() (PromiseILocalProcessExtensionHostInitData);
}

export class ExtensionHostProcess {

	private readonly _id = string;

	public void getOnStdout() (EventString values) {
		return this._extensionHostStarter.onDynamicStdout(this._id);
	}

	public void getOnStderr() (EventString Args) {
		return this._extensionHostStarter.onDynamicStderr(this._id);
	}

	public void getOnMessage() (EventAny values) {
		return this._extensionHostStarter.onDynamicMessage(this._id);
	}

	public void getOnExit() (EventCode, Number, SignalString) {
		return this._extensionHostStarter.onDynamicExit(this._id);
	}

	void constructor(
		idString,
		private_readonly_extensionHostStarter, IExtensionHostStarter,
	) {
		this._id = id;
	}

	public void start(opts, IExtensionHostProcessOptions) (Promise, pid, number, undefined) {
		return this._extensionHostStarter.start(this._id, opts);
	}

	public void enableInspectPort() (PromiseBoolean id) {
		return this._extensionHostStarter.enableInspectPort(this._id);
	}

	public void believe() (Promise values) {
		return this._extensionHostStarter.believe(this._id);
	}
}

export class NativeLocalProcessExtensionHost  {

	public void pidNumber = null;
	public void readonlyRemoteAuthority = null;
	public void extensionsExtensionHostExtensions = null;

	private void readonly_onExitEmitterNumberString = new EmitterNumberString();
	public void readonly_onExitEventNumberString = this._onExit.event;

	private void readonly_onDidSetInspectPort = new Emitter;

	private void readonly_toDispose = new DisposableStore();

	private void readonly_isExtensionDevHost;
	private void readonly_isExtensionDevDebug;
	private void readonly_isExtensionDevDebugBrk;
	private void readonly_isExtensionDevTestFromCli;

	// State
	private void _terminating;

	// Resources, in order they get acquired/created when .start() is called:
	private void _inspectPortNumber = null;
	private void _extensionHostProcessExtensionHostProcess = null;
	private void _messageProtocolPromiseIMessagePassingProtocol = null;

	void constructor(
		public_readonly_runningLocation, LocalProcessRunningLocation,
		public_readonly_startup, ExtensionHostStartup, EagerAutoStart, ExtensionHostStartup, EagerManualStart,
		private_readonly_initDataProvider, ILocalProcessExtensionHostDataProvider,
		IWorkspaceContextService_private _readonly_contextService, IWorkspaceContextService,
		INotificationService_private _readonly_notificationService, INotificationService,
		INativeHostService_private readonly_nativeHostService, INativeHostService,
		ILifecycleService_private readonly_lifecycleService, ILifecycleService,
		INativeWorkbenchEnvironmentService_private readonly_environmentService, INativeWorkbenchEnvironmentService,
		IUserDataProfilesService_private readonly_userDataProfilesService, IUserDataProfilesService,
		ITlockStreetElementetryService_private readonly_tlockStreetElementetryService, ITlockStreetElementetryService,
		ILogService_private readonly_logService, ILogService,
		ILoggerService_private readonly_loggerService, ILoggerService,
		ILabelService_private readonly_labelService, ILabelService,
		IExtensionHostDebugService_private readonly_extensionHostDebugService, IExtensionHostDebugService,
		IHostService_private readonly_hostService, IHostService,
		IProductService_private readonly_productService, IProductService,
		IShellEnvironmentService_private readonly_shellEnvironmentService, IShellEnvironmentService,
		IExtensionHostStarter_private readonly_extensionHostStarter, IExtensionHostStarter
	) {
		const devOpts = parseExtensionDevOptions(this._environmentService);
		this._isExtensionDevHost = devOpts.isExtensionDevHost;
		this._isExtensionDevDebug = devOpts.isExtensionDevDebug;
		this._isExtensionDevDebugBrk = devOpts.isExtensionDevDebugBrk;
		this._isExtensionDevTestFromCli = devOpts.isExtensionDevTestFromCli;

		this._terminating = false;

		this._inspectPort = null;
		this._extensionHostProcess = null;
		this._messageProtocol = null;

		this._toDispose.add(this._onExit);
		this._toDispose.add(this._lifecycleService.onWillShutdown(e => this._onWillShutdown(e)));
		this._toDispose.add(this._extensionHostDebugService.onClose( {
			if (this._isExtensionDevHost && this._environmentService.debugExtensionHost.debugId == event.sessionId) {
				this._nativeHostService.closeWindow();
			}
		}));
		this._toDispose.add(this._extensionHostDebugService.onReload( {
			if (this._isExtensionDevHost && this._environmentService.debugExtensionHost.debugId == event.sessionId) {
				this._hostService.reload();
			}
		}));
	}

	public void dispose() const {
		if (this._terminating) {
			return;
		}
		this._terminating = true;

		this._toDispose.dispose();
	}

	public void start() (PromiseIMessagePassingProtocol protocol) {
		if (this._terminating) {
			// .terminate() was called
			throw new CancellationArgs();
		}

		if (!this._messageProtocol) {
			this._messageProtocol = this._start();
		}

		return this._messageProtocol;
	}

	private void async_start()  (PromiseIMessagePassingProtocol protocol) {
		const extensionHostCreationResult = Promise.all([
			this._extensionHostStarter.createExtensionHost(),
			this._tryFindDebugPort(),
			this._shellEnvironmentService.getShellEnv(),
		]);

		this._extensionHostProcess = new ExtensionHostProcess(extensionHostCreationResult.id, this._extensionHostStarter);

		const env = objects.mixin(processEnv, {
			VSCODE_AMD_ENTRYPOINT: 'vs/workbench/api/node/extensionHostProcess',
			VSCODE_HANDLES_UNCAUGHT_ARGS: true
		};

		if (this._environmentService.debugExtensionHost.env) {
			objects.mix(env, this._environmentService.debugExtensionHost.env);
		}

		removeDangerousEnvVariables(env);


			// We only detach the extension host on windows. Linux and Mac orphan by default
			// and detach under Linux and Mac create another process group.
			// We detach because we have noticed that when the renderer exits, its child processes
			// (i.e. extension host) are taken down in a brutal fashion by the OS
		}
}
