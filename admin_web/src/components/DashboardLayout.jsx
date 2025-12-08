import { useEffect, useState } from 'react';
import { useNavigate, Outlet, useLocation, Link } from 'react-router-dom';
import { Container, Row, Col, Nav, Navbar } from 'react-bootstrap';

export default function DashboardLayout() {
    const navigate = useNavigate();
    const location = useLocation();
    const [user, setUser] = useState(null);

    useEffect(() => {
        const token = localStorage.getItem('token');
        const userData = localStorage.getItem('user');

        if (!token) {
            navigate('/login');
            return;
        }

        if (userData) {
            setUser(JSON.parse(userData));
        }
    }, [navigate]);

    const handleLogout = () => {
        localStorage.removeItem('token');
        localStorage.removeItem('user');
        navigate('/login');
    };

    const menuItems = [
        { label: 'Dashboard', path: '/dashboard', icon: 'bi-speedometer2' },
        { label: 'Partners', path: '/partners', icon: 'bi-briefcase' },
        { label: 'Bookings', path: '/bookings', icon: 'bi-calendar-check' },
        { label: 'Users', path: '/users', icon: 'bi-people' },
        { label: 'Settings', path: '/settings', icon: 'bi-gear' },
    ];

    return (
        <Container fluid className="vh-100 d-flex flex-column p-0">
            <Row className="flex-grow-1 g-0">
                {/* Sidebar */}
                <Col md={2} className="bg-dark text-white p-0 d-none d-md-flex flex-column">
                    <div className="p-3 border-bottom border-secondary">
                        <h5 className="m-0 fw-bold">ServiceHub Admin</h5>
                    </div>
                    <Nav className="flex-column flex-grow-1 p-2">
                        {menuItems.map((item) => {
                            const isActive = location.pathname.startsWith(item.path);
                            return (
                                <Nav.Link
                                    as={Link}
                                    to={item.path}
                                    key={item.path}
                                    className={`d-flex align-items-center gap-2 mb-1 rounded ${isActive ? 'bg-primary text-white' : 'text-secondary'} `}
                                    style={{ fontWeight: isActive ? '600' : '400' }}
                                >
                                    <i className={`bi ${item.icon}`}></i>
                                    {item.label}
                                </Nav.Link>
                            )
                        })}
                    </Nav>
                    <div className="p-3 border-top border-secondary mt-auto">
                        <div className="d-flex align-items-center gap-2">
                            <div className="bg-primary rounded-circle d-flex align-items-center justify-content-center text-white fw-bold" style={{ width: 40, height: 40 }}>
                                {user?.name?.[0].toUpperCase() || 'A'}
                            </div>
                            <div className="flex-grow-1 overflow-hidden">
                                <div className="fw-bold text-truncate" style={{ fontSize: '0.9rem' }}>{user?.name || 'Admin'}</div>
                                <div className="text-secondary small text-truncate">admin@servicehub.com</div>
                            </div>
                        </div>
                        <button onClick={handleLogout} className="btn btn-link text-danger p-0 mt-2 small text-decoration-none">
                            Sign out
                        </button>
                    </div>
                </Col>

                {/* Main Content */}
                <Col md={10} className="bg-light p-0 d-flex flex-column h-100 overflow-auto">
                    {/* Mobile Header */}
                    <Navbar bg="white" className="border-bottom d-md-none px-3">
                        <Navbar.Brand className="fw-bold">ServiceHub</Navbar.Brand>
                        <Navbar.Toggle />
                    </Navbar>

                    <div className="p-4 flex-grow-1">
                        <Outlet />
                    </div>
                </Col>
            </Row>
        </Container>
    );
}
