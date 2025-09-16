import express from "express";
import fetch from "node-fetch";
import dotenv from "dotenv";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

const API_KEY = process.env.EXCHANGE_RATE_API_KEY;

app.get("/", (req, res) => {
  res.send("FlipCash Backend çalışıyor!");
});

app.get("/rates/:base", async (req, res) => {
  const base = req.params.base.toUpperCase();
  try {
    const response = await fetch(
      `https://v6.exchangerate-api.com/v6/${API_KEY}/latest/${base}`
    );
    const data = await response.json();

    if (data.result === "success") {
      res.json({
        base: data.base_code,
        date: data.time_last_update_utc,
        rates: data.conversion_rates,
      });
    } else {
      res.status(400).json({ error: "API sonucu başarısız" });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "API çağrısı başarısız" });
  }
});

// Backend başlat
app.listen(PORT, () => {
  console.log(`Backend server running on port ${PORT}`);
});
