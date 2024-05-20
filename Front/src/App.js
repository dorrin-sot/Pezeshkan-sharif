import { BrowserRouter, Route, Routes } from 'react-router-dom'
import Home from './home'
import  Login  from './login'
import './App.css'
import { useEffect, useState } from 'react'
import { Page } from './page'
import Register from './register'

function App() {
  const [loggedIn, setLoggedIn] = useState(false)
  const [username, setUsername] = useState('')
  const [user, setUser] = useState('Patient')
  
  return (
    <div className="App">
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Home username={username} loggedIn={loggedIn} setLoggedIn={setLoggedIn} />} />
          <Route path="/login" element={<Login setLoggedIn={setLoggedIn} setUsername={setUsername} />} />
          <Route path="/register" element={<Register setLoggedIn={setLoggedIn} setUsername={setUsername} />} />
          {/* <Route path="/page" element={<Page props={[user, username]} />} /> */}
        </Routes>
      </BrowserRouter>
    </div>
  )
}

export default App