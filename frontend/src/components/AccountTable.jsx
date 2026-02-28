function truncate(str, start = 8, end = 6) {
  if (!str || str.length <= start + end + 3) return str
  return `${str.slice(0, start)}...${str.slice(-end)}`
}

export default function AccountTable({ accounts, balances = {} }) {
  if (!accounts || accounts.length === 0) {
    return <p className="empty-state">No accounts found.</p>
  }

  return (
    <div className="table-wrapper">
      <table className="account-table">
        <thead>
          <tr>
            <th>Name</th>
            <th>Address</th>
            <th>Balance (ETH)</th>
          </tr>
        </thead>
        <tbody>
          {accounts.map((acc) => (
            <tr key={acc.address}>
              <td>{acc.name || '—'}</td>
              <td>
                <span className="mono" title={acc.address}>
                  {truncate(acc.address)}
                </span>
              </td>
              <td>
                {balances[acc.address] !== undefined
                  ? balances[acc.address]
                  : <span className="muted">—</span>}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
