const pool = require('../config/db');

exports.getAllMeetings = async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT id, day_label, month_label, title, details, group_name, location_choice, is_highlighted
       FROM meetings
       ORDER BY created_at DESC`
    );
    res.status(200).json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Nie udało się pobrać nadchodzących spotkań.' });
  }
};

exports.createMeetingVote = async (req, res) => {
  const { day_label, month_label, slot_title, group_name, location_choice } = req.body;

  if (!slot_title || !group_name || !location_choice) {
    return res.status(400).json({ error: 'Brakuje wymaganych danych spotkania lub wybranej lokalizacji.' });
  }

  const title = `Spotkanie: ${location_choice}`;
  const details = `${slot_title} · ${location_choice}`;

  try {
    const result = await pool.query(
      `INSERT INTO meetings (day_label, month_label, title, details, group_name, location_choice, is_highlighted)
       VALUES ($1, $2, $3, $4, $5, $6, true)
       RETURNING id, day_label, month_label, title, details, group_name, location_choice, is_highlighted`,
      [day_label || '23', month_label || 'PAŹ', title, details, group_name, location_choice]
    );

    // Aktualizacja opisu najbliższego spotkania na karcie grupy
    await pool.query(
      'UPDATE groups SET next_meeting = $1 WHERE name = $2',
      [`${slot_title} · ${location_choice}`, group_name]
    );

    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Nie udało się zapisać głosu i spotkania w bazie danych.' });
  }
};