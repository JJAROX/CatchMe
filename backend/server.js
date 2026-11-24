require('dotenv').config();
const express = require('express');
const cors = require('cors');

const groupsController = require('./controllers/groupsController');
const meetingsController = require('./controllers/meetingsController');
const dyspoController = require('./controllers/dyspoController');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get('/api/health', (req, res) => res.json({ status: 'ok' }));

// Historia 1: Grupy
app.get('/api/groups', groupsController.getAllGroups);
app.post('/api/groups', groupsController.createGroup);

// Historia 2: Spotkania i głosowanie na lokalizację
app.get('/api/meetings', meetingsController.getAllMeetings);
app.post('/api/meetings', meetingsController.createMeetingVote);

// Dotychczasowy moduł dyspozycyjności
app.get('/api/dyspo', dyspoController.getAllDyspos);
app.post('/api/dyspo', dyspoController.addDyspo);

app.listen(PORT, () => {
  console.log(`Serwer CatchMe API działa na http://localhost:${PORT}`);
});