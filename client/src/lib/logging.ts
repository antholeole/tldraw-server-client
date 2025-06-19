export const setupLogging = () => {
	if (window.__TAURI__) {
		const { warn, debug, trace, info, error } = window.__TAURI__.log;

		const forwardConsole = (
			fnName: "log" | "debug" | "info" | "warn" | "error",
			logger: (message: string) => Promise<void>,
		) => {
			const original = console[fnName];
			console[fnName] = (message) => {
				original(message);
				logger(message);
			};
		};

		forwardConsole("log", trace);
		forwardConsole("debug", debug);
		forwardConsole("info", info);
		forwardConsole("warn", warn);
		forwardConsole("error", error);

		console.info("logging initalized");
	}
};
