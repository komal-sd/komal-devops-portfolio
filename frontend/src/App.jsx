import { useState, useEffect } from 'react'
import './App.css'

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000'

const TYPE_EMOJI = {
  achievement: '🏆',
  project: '🚀',
  certification: '🎓',
  internship: '💼',
  job: '👑',
}

function App() {
  const [projects, setProjects]     = useState([])
  const [skills, setSkills]         = useState([])
  const [milestones, setMilestones] = useState([])
  const [health, setHealth]         = useState(null)
  const [loading, setLoading]       = useState(true)

  useEffect(() => {
    Promise.all([
      fetch(`${API_URL}/api/health`).then(r => r.json()),
      fetch(`${API_URL}/api/projects`).then(r => r.json()),
      fetch(`${API_URL}/api/skills`).then(r => r.json()),
      fetch(`${API_URL}/api/milestones`).then(r => r.json()),
    ]).then(([h, p, s, m]) => {
      setHealth(h)
      setProjects(p)
      setSkills(s)
      setMilestones(m)
      setLoading(false)
    }).catch(() => setLoading(false))
  }, [])

  if (loading) return <div className="loading">LOADING...</div>

  return (
    <div className="dashboard">

      {/* HEADER */}
      <div className="header">
        <h1>Komal Yadav</h1>
        <div className="title">DevOps Engineer</div>
        <div className="status">⚡ Available for Opportunities</div>
      </div>

      {/* HEALTH */}
      {health && (
        <div className="health">
          <div className="dot" />
          API {health.status.toUpperCase()} — Live on AWS ECS Fargate
        </div>
      )}

      {/* PROJECTS */}
      <div className="section">
        <h2>Projects</h2>
        <div className="grid">
          {projects.map(p => (
            <div key={p.id} className="card">
              <h3>{p.title}</h3>
              <p>{p.description}</p>
              <div className="tech">Stack: {p.tech_stack}</div>
              <div className="links">
                {p.github_url && <a href={p.github_url} target="_blank">GitHub →</a>}
                {p.live_url && <a href={p.live_url} target="_blank">Live →</a>}
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* SKILLS */}
      <div className="section">
        <h2>Skills</h2>
        <div className="skills-grid">
          {skills.map(s => (
            <div key={s.id} className={`skill-badge ${s.category.toLowerCase()}`}>
              {s.name}
            </div>
          ))}
        </div>
      </div>

      {/* MILESTONES */}
      <div className="section">
        <h2>Journey</h2>
        {milestones.map(m => (
          <div key={m.id} className="milestone">
            <div className="emoji">{TYPE_EMOJI[m.type] || '⭐'}</div>
            <div className="content">
              <h4>{m.title}</h4>
              <p>{m.description}</p>
              <div className="date">{m.date}</div>
            </div>
          </div>
        ))}
      </div>

    </div>
  )
}

export default App