// Server Model (server.js, dbQueries.js, controller.js) inspired by
// https://github.students.cs.ubc.ca/CPSC304/CPSC304_Node_Project

import express from "express";
import cors from "cors";
import bodyParser from "body-parser";
import controller from "./controller.js";
import dotenv from "dotenv";

dotenv.config({ path: "../.env" });
const app = express();
const PORT = process.env.PORT || 65534; // Adjust the PORT if needed (e.g., if you encounter a "port already occupied" error)

// Middleware setup
// CORS to allow front end to query backend
app.use(cors());

// parse incoming request bodies
app.use(bodyParser.json());

// mount the router
app.use("/", controller);

// Parse incoming JSON payloads
app.use(express.json());

// Starting the server
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}/`);
});
