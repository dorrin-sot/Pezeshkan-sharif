import React from 'react'
import { useNavigate } from 'react-router-dom'
import { useState } from 'react';
import  Login  from './login';

const Home = (props) => {
    
  const { loggedIn, username } = props
  const navigate = useNavigate()

  const onButtonClick = () => {
    console.log("got it ")
    if (loggedIn) {
      console.log("here")
      localStorage.removeItem('user')
      props.setLoggedIn(false)
    } else {
      console.log("found here")
      navigate('/login')
    }
  }
  const onRegisterClick = () => {
    console.log("got it ")
    if (loggedIn) {
      localStorage.removeItem('user')
      props.setLoggedIn(false)
    } else {
      console.log("found here")
      navigate('/register')
    }
  }
  return (
    <div className="mainContainer">
      <div className={'titleContainer'}>
        <div>Welcome!</div>
      </div>
      <div className={'buttonContainer'}>
        <input
          className={'inputButton'}
          type="button"
          onClick={onButtonClick}
          value={loggedIn ? 'Log out' : 'Log in'}
        />
        <input
          className={'inputButton'}
          type="button"
          onClick={onRegisterClick}
          value={loggedIn ? 'Log out' : 'Register'}
        />
        {loggedIn ? <div>Your username address is {username}</div> : <div />}
      </div>
    </div>
  )
}

export default Home