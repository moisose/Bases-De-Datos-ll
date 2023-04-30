import "./App.css";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import React, { Component } from "react";
import LogIn from "./components/LogIn";
import ShowFiles from "./components/ShowFiles";

function App() {
  return (
    <div className="App">
      <Router>
        <Routes>
          <Route path="/" element={<LogIn />} />
          <Route path="/home" element={<ShowFiles />} />
        </Routes>
      </Router>
    </div>
  );
}

export default App;
