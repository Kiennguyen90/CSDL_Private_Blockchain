import { NavLink } from 'react-router-dom'

export default function Navbar() {
  return (
    <nav className="navbar">
      <div className="navbar-brand">Blockchain Demo</div>
      <div className="navbar-links">
        <NavLink to="/" end className={({ isActive }) => isActive ? 'active' : ''}>
          Accounts
        </NavLink>
        <NavLink to="/create" className={({ isActive }) => isActive ? 'active' : ''}>
          Create Account
        </NavLink>
        <NavLink to="/transaction" className={({ isActive }) => isActive ? 'active' : ''}>
          Send Transaction
        </NavLink>
      </div>
    </nav>
  )
}
