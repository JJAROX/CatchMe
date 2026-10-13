const express = require('express');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

app.get('/api/status', (req, res) => {
  res.json({ status: 'ok', message: 'Backend Express śmiga!' });
});

const PORT = 5001;
app.listen(PORT, () => {
  console.log(`Serwer działa na porcie ${PORT}`);
});