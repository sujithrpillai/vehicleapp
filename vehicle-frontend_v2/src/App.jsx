import { useState } from 'react'
import axios from 'axios'; // Component for making HTTP requests
import { Button, TextField, Alert, Stack} from '@mui/material';
import '@mui/material/styles'; // Importing Material-UI styles
import './App.css'; // Custom styles for the application
import CheckIcon from '@mui/icons-material/Check';
import CloseIcon from '@mui/icons-material/Close';
import NoCrashIcon from '@mui/icons-material/NoCrash';


const APIHost = axios.create({
    baseURL: "/api",
    headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json'
    },
    timeout: 5000,
});

const checkVehicle = async (vehicle_to_check)=> {
  try {
    const response = await APIHost.post('/check_vehicle/', { vehicle_to_check });
    return response.data;
  } catch (error) {
    console.error('Error checking vehicle:', error);
    throw error;
  }
}

function App() {
  const [goodVehicle, setGoodVehicle] = useState(null);
  const [badVehicle, setBadVehicle] = useState(null);
  const [checkResult, setCheckResult] = useState(null);
  const [error, setError] = useState(null);

  return (
    <>
      <Stack spacing={2} sx={{ width: '100%' }}>
          <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
            <NoCrashIcon sx={{ fontSize: 80 , color: '#1976d2'}} />
          </div>
        <h1> Vehicle Checker v1</h1>
        <p>
          Enter a vehicle number to check if it has any RTO notices,<br />
          such as being reported stolen, expired registration, or outstanding dues.
        </p>
        <TextField
        fullWidth
          required
          id="vehicle_to_check"
          label="Enter the vehicle to check (E.g.: XY-23-1232)"
          defaultValue=""
        />
        <Button
          variant="contained"
          color="primary"
          onClick={async () => {
            const vehicle_to_check = document.getElementById('vehicle_to_check').value;
            try {
              const result = await checkVehicle(vehicle_to_check);
              //  Set goodVehicle and badVehicle based on the result.status value
              if (result.status === 'no') {
                setGoodVehicle(vehicle_to_check);
                setBadVehicle(null);
              } else if (result.status === 'yes') {
                setBadVehicle(vehicle_to_check);
                setGoodVehicle(null);
              } else {
                setGoodVehicle(null);
                setBadVehicle(null);
              }
              setCheckResult(result);
              setError(null);
            } catch (error) {
              setError(error);
              setCheckResult(null);
            }
          }}
        >
          Check Vehicle
        </Button>
        {goodVehicle && (
          <Alert severity="success">
            Vehicle is clear to use
          </Alert>
        )}
        {badVehicle && (
          <Alert severity="warning">
            Vehicle need to be seized
          </Alert>
        )}
        {error && (
          <Alert severity="error">
            Error checking vehicle: {error.message}
          </Alert>
        )}
      </Stack>
    </>
  )
}

export default App
