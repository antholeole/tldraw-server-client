import { z } from "zod";

export const env = z.object({
  HOSTNAME: z.string().default("127.0.0.1"),
  PORT: z.coerce.number().default(3000)
}).parse(process.env);
