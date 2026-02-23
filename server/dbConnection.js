import pg from "pg";
import dotenv from "dotenv";

const { Pool } = pg;
dotenv.config({ path: "../.env" });

export const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  user: process.env.DB_USER,
  password: String(process.env.DB_PASSWORD),
  database: process.env.DB_NAME,
  ssl: false,
});

pool.on("connect", () => {
  console.log("PostgreSQL connected!");
});
