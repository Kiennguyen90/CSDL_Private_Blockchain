import { useState, useEffect, useCallback } from 'react'
import { getAllAccounts, getBalance } from '../services/blockchainService'
import AccountTable from '../components/AccountTable'
import LoadingSpinner from '../components/LoadingSpinner'
import AlertMessage from '../components/AlertMessage'

export default function AccountsListPage() {
  const [accounts, setAccounts] = useState([])
  const [balances, setBalances] = useState({})
  const [loading, setLoading] = useState(true)
  const [refreshingBalances, setRefreshingBalances] = useState(false)
  const [error, setError] = useState(null)

  const fetchAccounts = useCallback(async () => {
    setLoading(true)
    setError(null)
    try {
      const data = await getAllAccounts()
      setAccounts(data)
      await fetchBalances(data)
    } catch (err) {
      setError('Failed to load accounts')
    } finally {
      setLoading(false)
    }
  }, [])

  async function fetchBalances(accountList) {
    setRefreshingBalances(true)
    const results = await Promise.allSettled(
      accountList.map((acc) => getBalance(acc.address))
    )
    const map = {}
    accountList.forEach((acc, i) => {
      const result = results[i]
      map[acc.address] = result.status === 'fulfilled'
        ? result.value.balance
        : 'Error'
    })
    setBalances(map)
    setRefreshingBalances(false)
  }

  useEffect(() => {
    fetchAccounts()
  }, [fetchAccounts])

  async function handleRefresh() {
    await fetchAccounts()
  }

  return (
    <div className="page">
      <div className="page-header">
        <h1>All Accounts</h1>
        <button
          className="btn btn-secondary"
          onClick={handleRefresh}
          disabled={loading || refreshingBalances}
        >
          {refreshingBalances ? 'Refreshing...' : 'Refresh'}
        </button>
      </div>
      <p className="page-subtitle">
        All accounts on the private Ethereum network, including pre-funded genesis accounts.
      </p>

      <AlertMessage type="error" message={error} onClose={() => setError(null)} />

      {loading
        ? <LoadingSpinner message="Loading accounts..." />
        : <AccountTable accounts={accounts} balances={balances} />
      }
    </div>
  )
}
