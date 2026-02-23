import { pool } from "./dbConnection.js";

export const testPostgresConnection = async () => {
  try {
    const result = await pool.query("SELECT NOW()");
    return result;
  } catch (err) {
    throw err;
  }
};

export const getAllNamePositionTeam = () => {
  try {
    const result = pool.query(`
			SELECT person_id, name, position, current_team as team
			FROM Athlete, PositionDetails
			WHERE Athlete.jersey_num = PositionDetails.jersey_num
		`);
    return result;
  } catch (err) {
    throw err;
  }
};

export const getTeams = () => {
  try {
    const result = pool.query(`SELECT team_name FROM Team`);
    return result;
  } catch (err) {
    throw err;
  }
};

export const getPositions = () => {
  try {
    const result = pool.query(`SELECT * FROM PositionDetails`);
    return result;
  } catch (err) {
    throw err;
  }
};

export const insertAthlete = (body) => {
  const {
    person_id,
    name,
    birthdate,
    height,
    weight,
    phone_number,
    email,
    address,
    date_started,
    jersey_num,
    current_team,
    salary,
  } = body;

  try {
    const result = pool.query(`
      INSERT INTO Athlete VALUES (
        ${person_id}, 
        '${name}', 
        '${birthdate}',
        ${height}, 
        ${weight}, 
        ${phone_number}, 
        '${email}', 
        '${address}', 
        '${date_started}',
        ${jersey_num}, 
        '${current_team}', 
        ${salary}
      )
    `);
    return result;
  } catch (err) {
    throw err;
  }
};

export const deleteAthlete = (person_id) => {
  try {
    const result = pool.query(
      `DELETE FROM Athlete WHERE person_id = ${person_id}`,
    );
    return result;
  } catch (err) {
    throw err;
  }
};

export const getAthlete = (person_id) => {
  try {
    const result = pool.query(
      `SELECT * FROM Athlete WHERE Athlete.person_id = ${person_id}`,
    );
    return result;
  } catch (err) {
    throw err;
  }
};

export const updateAthlete = (body) => {
  const {
    person_id,
    name,
    birthdate,
    height,
    weight,
    phone_number,
    email,
    address,
    date_started,
    jersey_num,
    current_team,
    salary,
  } = body;

  try {
    const result = pool.query(`
      UPDATE Athlete 
      SET name='${name}',
        birthdate='${birthdate}',
        height=${height}, 
        weight=${weight}, 
        phone_number=${phone_number}, 
        email='${email}', 
        address='${address}', 
        date_started='${date_started}',
        jersey_num=${jersey_num}, 
        current_team='${current_team}', 
        salary=${salary}
      WHERE person_id=${person_id}
    `);
    return result;
  } catch (err) {
    throw err;
  }
};

export const getPlayerAwards = (person_id) => {
  try {
    const result = pool.query(
      `SELECT Athlete.person_id, Awards.year, Awards.award_name FROM Athlete, WinsAward, Awards WHERE Athlete.person_id=WinsAward.person_id AND WinsAward.award_id=Awards.award_id AND Athlete.person_id=${person_id}`,
    );
    return result;
  } catch (err) {
    throw err;
  }
};

export const getTables = () => {
  // not allowing user to see certain "private" tables, but otherwise is dynamic
  // Postgres uses information_schema instead of Oracle's user_tables
  try {
    const result = pool.query(
      `SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_name NOT IN ('participatesin', 'locatedin', 'hassponsor', 'givenby', 'winsaward', 'referees')`,
    );
    return result;
  } catch (err) {
    throw err;
  }
};

export const getAttributes = (table_name) => {
  // Postgres uses information_schema instead of Oracle's USER_TAB_COLS
  try {
    const result = pool.query(
      `SELECT column_name FROM information_schema.columns WHERE table_schema = 'public' AND table_name='${table_name.toLowerCase()}'`,
    );
    return result;
  } catch (err) {
    throw err;
  }
};

export const getTable = (body) => {
  const { table, attributes } = body;

  try {
    const result = pool.query(`SELECT ${attributes.toString()} FROM ${table}`);
    return result;
  } catch (err) {
    throw err;
  }
};

export const getStandings = () => {
  const query = `WITH GamesPerTeam AS (
			SELECT t.team_name, COUNT(*) as games_played
			FROM Game g, Team t, ParticipatesIn p
			WHERE g.game_ID = p.game_ID AND (t.team_name = p.team_1 OR t.team_name = p.team_2)
			GROUP BY t.team_name
		),
		-- begin calculations for W/L
		GoalsPerAthlete AS (
			SELECT s.STATS_ID, s.PERSON_ID, s.GAME_ID, SUM(s.goals) AS total_goals
			FROM Athlete a, Statistics s
			WHERE s.PERSON_ID = a.PERSON_ID
			GROUP BY s.stats_ID, s.PERSON_ID, s.GAME_ID
		),
		GoalsPerTeam AS (
			SELECT gpa.stats_id, gpa.game_id, a.CURRENT_TEAM, g.home, g.away, gpa.total_goals
			FROM GoalsPerAthlete gpa, athlete a, Game g
			WHERE gpa.person_id = a.person_id AND gpa.game_id = g.GAME_ID
		),
		HomeGoals AS (
			SELECT gpt.game_id, gpt.home, SUM(gpt.total_goals) as total_goals
			FROM GoalsPerTeam gpt
			WHERE gpt.CURRENT_TEAM = gpt.home
			GROUP BY gpt.game_id, gpt.home
		),
		AwayGoals AS (
		SELECT gpt.game_id, gpt.away, SUM(gpt.total_goals) as total_goals
			FROM GoalsPerTeam gpt
			WHERE gpt.CURRENT_TEAM = gpt.away
			GROUP BY gpt.game_id, gpt.away
		),
		-- col 2, wins
		HomeWins AS (
			SELECT t1.game_id, t1.home, t1.total_goals as home_goals, t2.away, t2.total_goals as away_goals
			FROM HomeGoals t1, AwayGoals t2
			WHERE t1.game_id = t2.game_id AND t1.total_goals > t2.total_goals
		),
		AwayWins AS (
			SELECT t1.game_id, t1.home, t1.total_goals as home_goals, t2.away, t2.total_goals as away_goals
			FROM HomeGoals t1, AwayGoals t2
			WHERE t1.game_id = t2.game_id AND t1.total_goals < t2.total_goals
		),
		WinnerPerGame AS (
			SELECT aw.game_id as game_id, aw.away as team
			FROM AwayWins aw
			UNION
			SELECT hw.game_id as game_id, hw.home as team
			FROM HomeWins hw
		),
		CountWins AS (
			SELECT w.team, Count(*) as winCount
			FROM WinnerPerGame w
			GROUP BY w.team
		),
		CountWinsAll AS (
			SELECT team_name, COALESCE(cw.winCount, 0) as winCount
			FROM team t
				LEFT OUTER JOIN CountWins cw ON t.TEAM_NAME = cw.TEAM
		),
		-- col3, losses
		HomeLosses AS (
			SELECT t1.game_id, t1.home, t1.total_goals as home_goals, t2.away, t2.total_goals as away_goals
			FROM HomeGoals t1, AwayGoals t2
			WHERE t1.game_id = t2.game_id AND t1.total_goals < t2.total_goals
		),
		AwayLosses AS (
			SELECT t1.game_id, t1.home, t1.total_goals as home_goals, t2.away, t2.total_goals as away_goals
			FROM HomeGoals t1, AwayGoals t2
			WHERE t1.game_id = t2.game_id AND t1.total_goals > t2.total_goals
		),
		LosersPerGame AS (
			SELECT al.game_id as game_id, al.away as team
			FROM AwayLosses al
			UNION
			SELECT hl.game_id as game_id, hl.home as team
			FROM HomeLosses hl
		),
		CountLosses AS (
			SELECT l.team, Count(*) as lossCount
			FROM LosersPerGame l
			GROUP BY l.team
		),
		CountLossesAll AS (
			SELECT team_name, COALESCE(lossCount, 0) as lossCount
			FROM team t
				LEFT OUTER JOIN CountLosses cl ON t.TEAM_NAME = cl.TEAM
		),
		-- col4, draws
		HomeDraws AS (
			SELECT t1.game_id, t1.home, t1.total_goals as home_goals, t2.away, t2.total_goals as away_goals
			FROM HomeGoals t1, AwayGoals t2
			WHERE t1.game_id = t2.game_id AND t1.total_goals = t2.total_goals
		),
		AwayDraws AS (
			SELECT t1.game_id, t1.home, t1.total_goals as home_goals, t2.away, t2.total_goals as away_goals
			FROM HomeGoals t1, AwayGoals t2
			WHERE t1.game_id = t2.game_id AND t1.total_goals = t2.total_goals
		),
		DrawsPerGame AS (
			SELECT ad.game_id as game_id, ad.away as team
			FROM AwayDraws ad
			UNION
			SELECT hd.game_id as game_id, hd.home as team
			FROM HomeDraws hd
		),
		CountDraws AS (
			SELECT d.team, Count(*) as drawCount
			FROM DrawsPerGame d
			GROUP BY d.team
		),
		CountDrawsAll AS (
			SELECT team_name, COALESCE(drawCount, 0) as drawCount
			FROM team t
				LEFT OUTER JOIN CountDraws cd ON t.TEAM_NAME = cd.TEAM
		)
		SELECT t.team_name as TeamName, g.games_played as GamesPlayed,
				w.winCount as WinCount, l.lossCount as LossCount, d.drawCount as DrawCount
		FROM team t, GamesPerTeam g, CountWinsAll w, CountLossesAll l, CountDrawsAll d
		WHERE t.TEAM_NAME = g.TEAM_NAME AND t.TEAM_NAME = w.TEAM_NAME AND
			t.TEAM_NAME = l.TEAM_NAME AND t.TEAM_NAME = d.TEAM_NAME
		ORDER BY WinCount DESC
	`;

  try {
    const result = pool.query(query);
    return result;
  } catch (err) {
    throw err;
  }
};

export const getMaxAvgGoalsPerGame = () => {
  const query = `WITH GoalsPerAthlete AS (
			SELECT s.STATS_ID, s.PERSON_ID, s.GAME_ID, SUM(s.goals) AS total_goals
			FROM Athlete a, Statistics s
			WHERE s.PERSON_ID = a.PERSON_ID
			GROUP BY s.stats_ID, s.PERSON_ID, s.GAME_ID
		),
		GoalsPerTeam AS (
			SELECT gpa.stats_id, gpa.game_id, a.CURRENT_TEAM, g.home, g.away, gpa.total_goals
			FROM GoalsPerAthlete gpa, athlete a, Game g
			WHERE gpa.person_id = a.person_id AND gpa.game_id = g.GAME_ID
		),
		HomeGoals AS (
			SELECT gpt.game_id, gpt.home, SUM(gpt.total_goals) as total_goals
			FROM GoalsPerTeam gpt
			WHERE gpt.CURRENT_TEAM = gpt.home
			GROUP BY gpt.game_id, gpt.home
		),
		AwayGoals AS (
		SELECT gpt.game_id, gpt.away, SUM(gpt.total_goals) as total_goals
			FROM GoalsPerTeam gpt
			WHERE gpt.CURRENT_TEAM = gpt.away
			GROUP BY gpt.game_id, gpt.away
		),
		AvgGoalsPerGame AS (
			(SELECT home as team, total_goals
			FROM HomeGoals)
			UNION ALL
			(SELECT away as team, total_goals
			FROM AwayGoals)
		)
		SELECT team, avg(total_goals) as AvgGoalsPerGame
		FROM AvgGoalsPerGame a
		GROUP BY team
		HAVING avg(total_goals) >= all  (SELECT avg(a.total_goals)
										FROM AvgGoalsPerGame a
										GROUP BY a.team)
	`;

  try {
    const result = pool.query(query);
    return result;
  } catch (err) {
    throw err;
  }
};

export const getFourMostRecentGames = (limit) => {
  const rowsToFetch = limit ? `LIMIT ${limit}` : "";

  const query = `
	SELECT 
			g.game_date,
			g.home AS home_team,
			COALESCE(home_stats.home_goals, 0) AS home_goals,
			g.away AS away_team,
			COALESCE(away_stats.away_goals, 0) AS away_goals
	FROM game g
	-- Aggregate goals for home team
	LEFT JOIN (
			SELECT s.game_id, a.current_team, SUM(s.goals) AS home_goals
			FROM statistics s
			JOIN athlete a ON s.person_id = a.person_id
			GROUP BY s.game_id, a.current_team
	) home_stats
			ON g.game_id = home_stats.game_id AND g.home = home_stats.current_team
	-- Aggregate goals for away team
	LEFT JOIN (
			SELECT s.game_id, a.current_team, SUM(s.goals) AS away_goals
			FROM statistics s
			JOIN athlete a ON s.person_id = a.person_id
			GROUP BY s.game_id, a.current_team
	) away_stats
			ON g.game_id = away_stats.game_id AND g.away = away_stats.current_team
	ORDER BY g.game_date DESC
	${rowsToFetch};
	`;

  try {
    const result = pool.query(query);
    return result;
  } catch (err) {
    throw err;
  }
};

export const getTeamsByCoachExp = () => {
  try {
    const result = pool.query(
      `SELECT current_team, AVG(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM date_started)) AS avgCoachingYears FROM Coach GROUP BY current_team HAVING AVG(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM date_started)) > 15 ORDER BY avgCoachingYears DESC`,
    );
    return result;
  } catch (err) {
    throw err;
  }
};

export const getRefsInAllGames = () => {
  try {
    const result = pool.query(
      `SELECT r.NAME, r.CERTIFICATION_LEVEL FROM Referee r WHERE NOT EXISTS ((SELECT g.game_id FROM Game g) EXCEPT (SELECT rs.game_id FROM Referees rs WHERE r.PERSON_ID = rs.PERSON_ID))`,
    );
    return result;
  } catch (err) {
    throw err;
  }
};

export const findPhoneNumber = (body) => {
  const { person_id, phone_number } = body;

  try {
    const result = pool.query(
      `SELECT phone_number FROM (SELECT person_id, phone_number FROM Athlete UNION SELECT person_id, phone_number FROM Coach UNION SELECT person_id, phone_number FROM Referee) WHERE phone_number=${phone_number} AND person_id<>${person_id}`,
    );
    return result;
  } catch (err) {
    throw err;
  }
};

export const findEmail = (body) => {
  const { person_id, email } = body;

  try {
    const result = pool.query(
      `SELECT email FROM (SELECT person_id, email FROM Athlete UNION SELECT person_id, email FROM Coach UNION SELECT person_id, email FROM Referee) WHERE email='${email}' AND person_id<>${person_id}`,
    );
    return result;
  } catch (err) {
    throw err;
  }
};

export const getVenues = () => {
  try {
    const result = pool.query(`SELECT * FROM Venue`);
    return result;
  } catch (err) {
    throw err;
  }
};

export const findGames = (body) => {
  const { venueName } = body;
  try {
    const result = pool.query(
      `SELECT g.game_date::text, g.home, g.away, v.venue_address FROM Game g, LocatedIn l, Venue v WHERE g.GAME_ID = l.GAME_ID AND l.venue_address = v.venue_address AND v.venue_name = '${venueName}' ORDER BY g.game_date DESC`,
    );
    return result;
  } catch (err) {
    throw err;
  }
};

export const filterSponsor = (body) => {
  const { whereClause } = body;

  const where = whereClause ? `WHERE ${whereClause}` : "";

  try {
    const result = pool.query(`
			SELECT *
			FROM Sponsor
			${where}
		`);
    return result;
  } catch (err) {
    throw err;
  }
};
