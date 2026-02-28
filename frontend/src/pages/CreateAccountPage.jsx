import { useState } from 'react'
import { createAccount } from '../services/blockchainService'
import AccountCard from '../components/AccountCard'
import LoadingSpinner from '../components/LoadingSpinner'
import AlertMessage from '../components/AlertMessage'

export default function CreateAccountPage() {
  const [name, setName] = useState('')
  const [loading, setLoading] = useState(false)
  const [account, setAccount] = useState(null)
  const [error, setError] = useState(null)

  async function handleSubmit(e) {
    e.preventDefault()
    setLoading(true)
    setError(null)
    setAccount(null)
    try {
      const result = await createAccount(name.trim() || null)
      setAccount(result)
    } catch (err) {
      setError(err.response?.data?.error || err.message || 'Failed to create account')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="page">
      <h1>Create Account</h1>
      <p className="page-subtitle">Generate a new Ethereum keypair on the private network.</p>

      <form className="form-card" onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="name">Account Name (optional)</label>
          <input
            id="name"
            type="text"
            value={name}
            onChange={(e) => setName(e.target.value)}
            placeholder="e.g. Alice"
            maxLength={64}
          />
        </div>
        <button type="submit" className="btn btn-primary" disabled={loading}>
          {loading ? 'Creating...' : 'Create Account'}
        </button>
      </form>

      {loading && <LoadingSpinner message="Generating keypair..." />}

      <AlertMessage type="error" message={error} onClose={() => setError(null)} />

      {account && (
        <div className="result-section">
          <AlertMessage type="success" message="Account created successfully!" />
          <AccountCard account={account} />
          <p className="warning-note">
            Save your private key now — it will not be shown again after you leave this page.
          </p>
        </div>
      )}
    </div>
  )
}
