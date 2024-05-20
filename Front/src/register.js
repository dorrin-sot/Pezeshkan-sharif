import React, { useState } from 'react';
const Register = (props) => {
// function RegisterPage() {
  const [userType, setUserType] = useState('patient'); // Default to patient
  const [formData, setFormData] = useState({
    ssid: '',
    fullName: '',
    medicalId: '',
    username: '',
    password: '',
    repeatPassword: ''
  });
  const [errors, setErrors] = useState([]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value
    });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    const validationErrors = validateForm();
    if (validationErrors.length === 0) {
      // Send request to server (not implemented)
      console.log('Form submitted:', formData);
      // Navigate to login (not implemented)
    } else {
      setErrors(validationErrors);
    }
  };

  const validateForm = () => {
    const errors = [];
    const { ssid, fullName, username, password, repeatPassword } = formData;

    if (!ssid || !fullName || !username || !password || !repeatPassword) {
      errors.push('All fields are required.');
    }

    if (password !== repeatPassword) {
      errors.push('Password and Repeat Password must match.');
    }

    if (password.length < 8 || repeatPassword.length < 8) {
      errors.push('Password must be at least 8 characters long.');
    }

    return errors;
  };

  return (
    <div>
      <h2>Register</h2>
      <div>
        <label>
          <input
            type="radio"
            name="userType"
            value="patient"
            checked={userType === 'patient'}
            onChange={() => setUserType('patient')}
          />
          Patient
        </label>
        <label>
          <input
            type="radio"
            name="userType"
            value="doctor"
            checked={userType === 'doctor'}
            onChange={() => setUserType('doctor')}
          />
          Doctor
        </label>
        <label>
          <input
            type="radio"
            name="userType"
            value="referrer"
            checked={userType === 'referrer'}
            onChange={() => setUserType('referrer')}
          />
          Referrer
        </label>
      </div>
      <form onSubmit={handleSubmit}>
        <div>
          <label>
            SSID:
            <input
              type="text"
              name="ssid"
              value={formData.ssid}
              onChange={handleChange}
            />
          </label>
        </div>
        <div>
          <label>
            Full Name:
            <input
              type="text"
              name="fullName"
              value={formData.fullName}
              onChange={handleChange}
            />
          </label>
        </div>
        {userType === 'doctor' && (
          <div>
            <label>
              Medical ID:
              <input
                type="text"
                name="medicalId"
                value={formData.medicalId}
                onChange={handleChange}
              />
            </label>
          </div>
        )}
        <div>
          <label>
            Username:
            <input
              type="text"
              name="username"
              value={formData.username}
              onChange={handleChange}
            />
          </label>
        </div>
        <div>
          <label>
            Password:
            <input
              type="password"
              name="password"
              value={formData.password}
              onChange={handleChange}
            />
          </label>
        </div>
        <div>
          <label>
            Repeat Password:
            <input
              type="password"
              name="repeatPassword"
              value={formData.repeatPassword}
              onChange={handleChange}
            />
          </label>
        </div>
        <button type="submit">Submit</button>
      </form>
      {errors.length > 0 && (
        <div>
          <p>Errors:</p>
          <ul>
            {errors.map((error, index) => (
              <li key={index}>{error}</li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
}

export default Register;
