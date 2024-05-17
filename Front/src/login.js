import React, { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { Page } from './page';

const Login = (props) => {
  // export function Login({ user }) {
    const [data, setData] = useState('Patient');
  const [loggedIn, setLoggedIn] = useState(false)
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [usernameError, setUsernameError] = useState('')
  const [passwordError, setPasswordError] = useState('')

  const [newState, setNewState] = useState({data: data, username: username, password: password})

  const navigate = useNavigate()

  const onButtonClick = () => {
    // Set initial error values to empty
    setUsernameError('')
    setPasswordError('')
  
    // Check if the user has entered both fields correctly
    if ('' === username) {
      setUsernameError('Please enter your username')
      return
    }
  
    if (!/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(username)) {
      setUsernameError('Please enter a valid username')
      return
    }
  
    if ('' === password) {
      setPasswordError('Please enter a password')
      return
    }
  
    if (password.length < 7) {
      setPasswordError('The password must be 8 characters or longer')
      return
    }
    
    // navigate('/page',{ props: {
    //   username: username,
    //   user: data
    //   }
    // })

    // Hard coded username, untill we connect it to back
    if(username == 'user@mail.com' && password == '12345678'){
      setUsername(username)
      setPassword(password)
      setLoggedIn(true)
      setNewState({data: data, username: username, password: password})
      console.log("passed")
    }
    // Authentication calls will be made here...
  }
  if(!loggedIn){
    return (
      <div className={'mainContainer'}>
        <div className={'titleContainer'}>
          <div>Login</div>
        </div>
        <br />
        <div>
              <select value={data} onChange={e => setData(e.target.value)}>
                  <option value="Patient">Patient</option>
                  <option value="Doctor">Doctor</option>
                  <option value="Others">Others</option>
              </select>
        </div>
        <div className={'inputContainer'}>
          <input
            value={username}
            placeholder="Enter your username here"
            onChange={(ev) => setUsername(ev.target.value)}
            className={'inputBox'}
          />
          <label className="errorLabel">{usernameError}</label>
        </div>
        <br />
        <div className={'inputContainer'}>
          <input
            value={password}
            placeholder="Enter your password here"
            onChange={(ev) => setPassword(ev.target.value)}
            className={'inputBox'}
          />
          <label className="errorLabel">{passwordError}</label>
        </div>
        <br />
        <div className={'inputContainer'}>
          <input className={'inputButton'} type="button" onClick={onButtonClick} value={'Log in'} />
        </div>
      </div>
    )
  }
  else{
    
    return(
      <Page props = {newState}/>
    )
  }
}
export default Login