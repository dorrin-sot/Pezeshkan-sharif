import React from 'react'
import { useNavigate } from 'react-router-dom'
import { useState } from 'react';

const Home = (props) => {
    const [data, setData] = useState('Patient');
    const onOptionChangeHandler = (event) => {
        setData(event.target.value);
        console.log(
            "User Selected Value - ",
            event.target.value
        );
    };
    
  const { loggedIn, email } = props
  const navigate = useNavigate()

  const onButtonClick = () => {
    if (loggedIn) {
      localStorage.removeItem('user')
      props.setLoggedIn(false)
    } else {
      navigate('/login')
    }
  }

  return (
    <div className="mainContainer">
      <div className={'titleContainer'}>
        <div>Welcome!</div>
      </div>
      {/* <div>This is the home page.</div> */}
      <div>
      <select
          value={data}
          onChange={e => setData(e.target.value)}
        >
          <option value="Patient">Patient</option>
          <option value="Doctor">Doctor</option>
          <option value="Others">Others</option>
        </select>
      </div>
      <div className={'buttonContainer'}>
        <input
          className={'inputButton'}
          type="button"
          onClick={onButtonClick}
          value={loggedIn ? 'Log out' : 'Log in'}
        />
        {loggedIn ? <div>Your email address is {email}</div> : <div />}
      </div>
    </div>
  )
}

export default Home