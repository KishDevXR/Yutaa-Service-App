import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api/axios';
import { Container, Card, Form, Button, Alert } from 'react-bootstrap';

export default function Login() {
    const [tokenInput, setTokenInput] = useState('');
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');
    const navigate = useNavigate();

    const handleLogin = async (e) => {
        e.preventDefault();
        setLoading(true);
        setError('');

        try {
            // For dev, we accept phone number as "firebaseToken" to mock the flow
            const response = await api.post('/auth/login', {
                firebaseToken: tokenInput
            });

            if (response.data.success) {
                localStorage.setItem('token', response.data.token);
                localStorage.setItem('user', JSON.stringify(response.data.user));
                navigate('/dashboard');
            }
        } catch (err) {
            console.error(err);
            setError(err.response?.data?.message || 'Login failed. Ensure backend is running.');
        } finally {
            setLoading(false);
        }
    };

    return (
        <Container className="d-flex justify-content-center align-items-center vh-100 bg-light">
            <Card className="shadow p-4 border-0" style={{ width: '100%', maxWidth: '400px' }}>
                <Card.Body>
                    <div className="text-center mb-4">
                        <h3 className="fw-bold text-dark">Admin Login</h3>
                        <p className="text-secondary small">Enter your phone number to continue</p>
                    </div>

                    {error && (
                        <Alert variant="danger" className="py-2 small">
                            {error}
                        </Alert>
                    )}

                    <Form onSubmit={handleLogin}>
                        <Form.Group className="mb-3">
                            <Form.Label className="small fw-semibold">Phone Number (Dev Token)</Form.Label>
                            <Form.Control
                                type="text"
                                value={tokenInput}
                                onChange={(e) => setTokenInput(e.target.value)}
                                placeholder="+91 9876543210"
                                required
                                size="lg"
                                className="fs-6"
                            />
                        </Form.Group>

                        <Button
                            variant="primary"
                            type="submit"
                            className="w-100 py-2 fw-semibold"
                            disabled={loading}
                        >
                            {loading ? 'Logging in...' : 'Login'}
                        </Button>
                    </Form>
                </Card.Body>
            </Card>
        </Container>
    );
}
