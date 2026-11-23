const pool = require('../config/db');

exports.getAllDyspos = async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT d.id, d.user_id, u.full_name AS user_name, d.location_zone, d.intent_icon, d.start_time, d.end_time
      FROM dyspos d
      LEFT JOIN users u ON d.user_id = u.id
      WHERE d.end_time > NOW()
      ORDER BY d.start_time DESC
    `);
    res.status(200).json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Błąd serwera podczas odczytu danych' });
  }
};

exports.addDyspo = async (req, res) => {
  const { user_id, location_zone, intent_icon, duration } = req.body;

  if (!user_id || !location_zone || !intent_icon || !duration || typeof duration !== 'number' || duration <= 0) {
    return res.status(400).json({
      error: 'Wymagane pola: user_id, location_zone, intent_icon oraz dodatni czas trwania (duration w minutach).',
    });
  }

  const startTime = new Date();
  const endTime = new Date(startTime.getTime() + duration * 60 * 1000);

  try {
    const result = await pool.query(
      `INSERT INTO dyspos (user_id, location_zone, intent_icon, start_time, end_time)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING *`,
      [user_id, location_zone, intent_icon, startTime, endTime]
    );

    res.status(201).json({
      message: 'Dyspozycja trwale zapisana w bazie danych',
      dyspo: result.rows[0],
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Błąd serwera podczas zapisu danych' });
  }
};