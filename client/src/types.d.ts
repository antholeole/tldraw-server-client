import type logPlugin from '@tauri-apps/plugin-log';

declare global {
	interface Window {
		__TAURI__?: {
			log: logPlugin
		};
	}	
}
