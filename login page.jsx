

import React, { useState } from 'react';
import './App.css';

const App = () => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();

    // Simple validation
    if (!username || !password) {
      setError('Please enter both username and password');
      return;
    }

    // Mocking login request to server (replace this with actual API call)
    const users = {
      doctor: { username: 'doctor', password: 'doctor123' },
      patient: { username: 'patient', password: 'patient123' },
      referrer: { username: 'referrer', password: 'referrer123' }
    };

    if (users.doctor.username === username && users.doctor.password === password) {
      // Navigate to doctor profile
      setError('');
      alert('Logged in as Doctor');
      // Implement navigation to doctor profile
    } else if (users.patient.username === username && users.patient.password === password) {
      // Navigate to patient profile
      setError('');
      alert('Logged in as Patient');
      // Implement navigation to patient profile
    } else if (users.referrer.username === username && users.referrer.password === password) {
      // Navigate to referrer profile
      setError('');
      alert('Logged in as Referrer');
      // Implement navigation to referrer profile
    } else {
      setError('Invalid username or password');
    }
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>Login Page</h1>
      </header>
      <div className="content">
        <form onSubmit={handleSubmit} className="login-form">
          <h2>Login</h2>
          {error && <div className="error-message">{error}</div>}
          <div className="form-group">
            <label htmlFor="username">Username:</label>
            <input
              type="text"
              id="username"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
            />
          </div>
          <div className="form-group">
            <label htmlFor="password">Password:</label>
            <input
              type="password"
              id="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
          </div>
          <button type="submit">Login</button>
        </form>
      </div>
    </div>
  );
};

export default App;
