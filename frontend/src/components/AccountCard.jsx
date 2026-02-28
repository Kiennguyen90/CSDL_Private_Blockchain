export default function AccountCard({ account }) {
  const { address, name, privateKey } = account

  return (
    <div className="account-card">
      <div className="account-card-header">
        <span className="account-name">{name || 'Unnamed Account'}</span>
      </div>
      <div className="account-card-body">
        <div className="field">
          <label>Address</label>
          <span className="mono">{address}</span>
        </div>
        <div className="field">
          <label>Private Key</label>
          <span className="mono private-key">{privateKey}</span>
        </div>
      </div>
    </div>
  )
}
