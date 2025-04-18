import { tldraw } from "./tldraw/router.ts";
import Fastify from "fastify";
import websocketPlugin from "@fastify/websocket";
import { env } from "./env.ts";

const fastify = Fastify({
	logger: true,
});

fastify.register(websocketPlugin);
fastify.register(tldraw);

fastify.get('/ping', async () => {
  return 'pong\n';
})



await fastify.listen({ port: env.PORT, host: env.HOSTNAME });
