import { render, screen } from '@testing-library/react';
import App from './App';

test('renders Vehicle Checker heading', () => {
  render(<App />);
  expect(screen.getByText(/Vehicle Checker/i)).toBeInTheDocument();
});