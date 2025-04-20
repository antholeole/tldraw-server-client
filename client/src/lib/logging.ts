export const setupLogging = async () => {
	if (window.__TAURI__) {
		const { warn, debug, trace, info, error, attachConsole } = window.__TAURI__.log;

		window.console = {
			...window.console,
			trace,
			info,
			debug,
			warn,
			error,
			log: info,
		};

		await attachConsole();

		console.info("logging initalized");
	}
};
