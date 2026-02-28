import { useState, useEffect } from 'react'
import { getAllAccounts, getBalance, sendTransaction } from '../services/blockchainService'
import LoadingSpinner from '../components/LoadingSpinner'
import AlertMessage from '../components/AlertMessage'

export default function TransactionPage() {
  const [accounts, setAccounts] = useState([])
  const [from, setFrom] = useState('')
  const [to, setTo] = useState('')
  const [amount, setAmount] = useState('')
  const [senderBalance, setSenderBalance] = useState(null)

  const [loadingAccounts, setLoadingAccounts] = useState(true)
  const [loadingBalance, setLoadingBalance] = useState(false)
  const [submitting, setSubmitting] = useState(false)

  const [success, setSuccess] = useState(null)
  const [error, setError] = useState(null)

  useEffect(() => {
    getAllAccounts()
      .then(setAccounts)
      .catch(() => setError('Failed to load accounts'))
      .finally(() => setLoadingAccounts(false))
  }, [])

  useEffect(() => {
    if (!from) {
      setSenderBalance(null)
      return
    }
    setLoadingBalance(true)
    setSenderBalance(null)
    getBalance(from)
      .then((data) => setSenderBalance(data.balance))
      .catch(() => setSenderBalance('Error'))
      .finally(() => setLoadingBalance(false))
  }, [from])

  async function handleSubmit(e) {
    e.preventDefault()
    setError(null)
    setSuccess(null)
    if (!from || !to || !amount) {
      setError('All fields are required')
      return
    }
    if (parseFloat(amount) <= 0) {
      setError('Amount must be greater than 0')
      return
    }
    setSubmitting(true)
    try {
      const result = await sendTransaction(from, to, amount)
      setSuccess(`Transaction submitted! Hash: ${result.txHash}`)
      setAmount('')
      // Refresh sender balance
      getBalance(from).then((data) => setSenderBalance(data.balance))
    } catch (err) {
      setError(err.response?.data?.error || err.message || 'Transaction failed')
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <div className="page">
      <h1>Send Transaction</h1>
      <p className="page-subtitle">Transfer ETH between accounts on the private network.</p>

      {loadingAccounts && <LoadingSpinner message="Loading accounts..." />}

      {!loadingAccounts && (
        <form className="form-card" onSubmit={handleSubmit}>
          <div className="form-group">
            <label htmlFor="from">From Account</label>
            <select
              id="from"
              value={from}
              onChange={(e) => setFrom(e.target.value)}
              required
            >
              <option value="">-- Select sender --</option>
              {accounts.map((acc) => (
                <option key={acc.address} value={acc.address}>
                  {acc.name || acc.address} ({acc.address.slice(0, 10)}...)
                </option>
              ))}
            </select>
            {from && (
              <div className="balance-preview">
                {loadingBalance
                  ? 'Fetching balance...'
                  : senderBalance !== null
                    ? `Balance: ${senderBalance} ETH`
                    : ''}
              </div>
            )}
          </div>

          <div className="form-group">
            <label htmlFor="to">To Address</label>
            <select
              id="to"
              value={to}
              onChange={(e) => setTo(e.target.value)}
              required
            >
              <option value="">-- Select recipient --</option>
              {accounts
                .filter((acc) => acc.address !== from)
                .map((acc) => (
                  <option key={acc.address} value={acc.address}>
                    {acc.name || acc.address} ({acc.address.slice(0, 10)}...)
                  </option>
                ))}
            </select>
          </div>

          <div className="form-group">
            <label htmlFor="amount">Amount (ETH)</label>
            <input
              id="amount"
              type="number"
              step="0.0001"
              min="0.0001"
              value={amount}
              onChange={(e) => setAmount(e.target.value)}
              placeholder="e.g. 1.0"
              required
            />
          </div>

          <button type="submit" className="btn btn-primary" disabled={submitting}>
            {submitting ? 'Sending...' : 'Send Transaction'}
          </button>
        </form>
      )}

      {submitting && <LoadingSpinner message="Broadcasting transaction..." />}

      <AlertMessage type="error" message={error} onClose={() => setError(null)} />
      <AlertMessage type="success" message={success} onClose={() => setSuccess(null)} />
    </div>
  )
}
