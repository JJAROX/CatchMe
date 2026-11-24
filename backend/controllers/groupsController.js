const crypto = require('crypto');
const pool = require('../config/db');

exports.getAllGroups = async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT id, name, members_count, next_meeting, invite_link, icon, color_theme FROM groups ORDER BY created_at DESC'
    );
    res.status(200).json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Nie udało się pobrać listy grup z bazy danych.' });
  }
};

exports.createGroup = async (req, res) => {
  const { name } = req.body;

  if (!name || !name.trim()) {
    return res.status(400).json({ error: 'Nazwa grupy jest wymagana.' });
  }

  const slug = crypto.randomBytes(3).toString('hex');
  const inviteLink = `catchme.app/join/${slug}`;

  try {
    const result = await pool.query(
      `INSERT INTO groups (name, members_count, next_meeting, invite_link, icon, color_theme)
       VALUES ($1, 1, 'Brak zaplanowanych spotkań', $2, 'person.3', 'green')
       RETURNING id, name, members_count, next_meeting, invite_link, icon, color_theme`,
      [name.trim(), inviteLink]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Nie udało się zapisać nowej grupy w bazie danych.' });
  }
};