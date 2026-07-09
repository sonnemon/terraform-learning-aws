import './App.css'

function App() {
  return (
    <main className="card">
      <span className="cat" role="img" aria-label="cat">
        🐱
      </span>
      <h1>Hi, I'm a Cat</h1>
      <p>
        Served from an S3 bucket, built with Vite + React, deployed by GitHub
        Actions via OIDC — no AWS secrets anywhere.
      </p>
      <p className="footer">terraform-learning-aws · lesson 01</p>
      <button onClick={() => {
        alert("Hello, World!")
      }}>Get File</button>
    </main>
  )
}

export default App
