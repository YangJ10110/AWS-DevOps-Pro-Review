const express = require('express');

// app.js
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
    res.send('Hello, World!');
});

app.listen(port, () => {
    console.log(`App is running on http://localhost:${port}`);
});

// test changes