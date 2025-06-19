import {
	Tldraw,
	defaultShapeUtils,
	defaultBindingUtils,
	type TLAssetStore,
} from "tldraw";
import { useSync } from "@tldraw/sync";
import "./style.css";
import { assets } from "./lib/assets";
import "tldraw/tldraw.css";
import { useEffect } from "react";

const myAssetStore: TLAssetStore = {
	async upload() {
		return "";
	},
	resolve(asset) {
		return asset.props.src;
	},
};

const uri = `${import.meta.env.VITE_SERVER_HTTPS ? "wss" : "ws"}://${import.meta.env.VITE_SERVER_URL}/draw/connect`;

export const TldrawFrontend = () => {
	useEffect(() => {
		console.debug(`connecting to uri ${uri}`)
	}, [])
	
	const store = useSync({
		uri,
		assets: myAssetStore,
		shapeUtils: defaultShapeUtils,
		bindingUtils: defaultBindingUtils,
	});

	return (
		<div className="tldraw">
			<Tldraw store={store} assetUrls={assets} />
		</div>
	);
};
