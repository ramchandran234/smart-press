import React, { useState } from 'react'
import { HashRouter as Router, Routes, Route, useNavigate } from 'react-router-dom'
import './App.css'

function Login() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const navigate = useNavigate()

  const handleLogin = (e) => {
    e.preventDefault()
    setLoading(true)
    setTimeout(() => {
      setLoading(false)
      if (email === 'admin@smartpress.com' && password === 'password123') {
        navigate('/dashboard')
      } else {
        alert('Invalid credentials! (Try admin@smartpress.com / password123)')
      }
    }, 800)
  }

  return (
    <div className="auth-wrapper">
      <div className="glow-circle blue"></div>
      <div className="glow-circle purple"></div>
      <div className="glass-card auth-card">
        <div className="logo-container">
          <div className="logo-icon">⚡</div>
          <h1 className="logo-text">Smart<span>Press</span></h1>
        </div>
        <p className="subtitle">Sign in to access your dashboard</p>
        <form onSubmit={handleLogin} className="auth-form">
          <div className="form-group">
            <label htmlFor="email">Email Address</label>
            <input 
              id="email" 
              type="email" 
              placeholder="name@company.com" 
              value={email} 
              onChange={(e) => setEmail(e.target.value)} 
              required 
            />
          </div>
          <div className="form-group">
            <label htmlFor="password">Password</label>
            <input 
              id="password" 
              type="password" 
              placeholder="••••••••" 
              value={password} 
              onChange={(e) => setPassword(e.target.value)} 
              required 
            />
          </div>
          <button id="login-button" type="submit" disabled={loading}>
            {loading ? 'Signing in...' : 'Sign In'}
          </button>
        </form>
        <p className="hint">Demo: admin@smartpress.com / password123</p>
      </div>
    </div>
  )
}

function Dashboard() {
  const navigate = useNavigate()

  return (
    <div className="dashboard-wrapper">
      <nav className="dashboard-nav">
        <div className="logo-container">
          <div className="logo-icon">⚡</div>
          <h1 className="logo-text">Smart<span>Press</span></h1>
        </div>
        <button className="logout-btn" onClick={() => navigate('/login')}>Logout</button>
      </nav>
      <main className="dashboard-content">
        <header className="content-header">
          <h2>Welcome back, Admin!</h2>
          <p>Here's what is happening with your press operations today.</p>
        </header>
        <div className="stats-grid">
          <div className="stat-card">
            <h3>Active Jobs</h3>
            <div className="stat-value">12</div>
            <p className="stat-desc">4 in queue</p>
          </div>
          <div className="stat-card">
            <h3>Efficiency Rate</h3>
            <div className="stat-value">98.4%</div>
            <p className="stat-desc">+0.6% this week</p>
          </div>
          <div className="stat-card">
            <h3>Revenue (MTD)</h3>
            <div className="stat-value">$14,240</div>
            <p className="stat-desc">Target: $15,000</p>
          </div>
        </div>
      </main>
    </div>
  )
}

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/" element={<Login />} />
      </Routes>
    </Router>
  )
}

export default App
