import { MantineProvider } from "@mantine/core";
import { setupLogging } from "./lib/logging";
import React, { useEffect } from "react";
import ReactDOM from "react-dom/client";
import "@mantine/core/styles.css";
import { theme } from "./lib/theme";

const CommonEntry: React.FC<React.PropsWithChildren> = ({ children }) => {
	useEffect(() => {
		setupLogging();
	}, []);

	return (
		<main className="container">
			<MantineProvider theme={theme}>
				{children}
			</MantineProvider>
		</main>
	);
};

export const init = (Element: React.FC<unknown>) =>
	ReactDOM.createRoot(document.getElementById("root") as HTMLElement).render(
		<React.StrictMode>
			<CommonEntry>
				<Element />
			</CommonEntry>
		</React.StrictMode>,
	);
