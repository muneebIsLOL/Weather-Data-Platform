import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import './index.css';
import App from './App.js';
import { HealthCheck } from "./routes/health/Health.jsx";
import { BrowserRouter, Routes, Route } from "react-router";

const domNode = document.getElementById('root') as HTMLDivElement;

createRoot(domNode).render(
  <StrictMode>
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<App />} />
        <Route path="/health" element={<HealthCheck />} />
      </Routes>
    </BrowserRouter>
  </StrictMode>
);