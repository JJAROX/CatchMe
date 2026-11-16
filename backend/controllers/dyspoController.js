const pool = require('../config/db'); // Import połączenia z bazą

exports.getAllDyspos = async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM dyspos WHERE is_active = true');
        res.status(200).json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Błąd serwera podczas odczytu danych' });
    }
};

exports.addDyspo = async (req, res) => {
    const { user_id, location_zone, intent_icon, duration } = req.body;
    
    try {
        const result = await pool.query(
            'INSERT INTO dyspos (user_id, location_zone, intent_icon, duration) VALUES ($1, $2, $3, $4) RETURNING *',
            [user_id, location_zone, intent_icon, duration]
        );
        
        res.status(201).json({
            message: "Dyspozycja trwale zapisana w bazie danych",
            dyspo: result.rows[0]
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Błąd serwera podczas zapisu danych' });
    }
};
