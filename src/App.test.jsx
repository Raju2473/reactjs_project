import { render, screen } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import App from './App'

test('renders landing page heading', () => {
  render(
    <MemoryRouter>
      <App />
    </MemoryRouter>
  )

  expect(
    screen.getByText(/powerpulse responsive web frontend/i)
  ).toBeInTheDocument()
})