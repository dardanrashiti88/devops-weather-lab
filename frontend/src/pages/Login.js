import React, { useState } from 'react';
import { GoogleLogin, GoogleOAuthProvider } from '@react-oauth/google';
import { Lock, User } from 'lucide-react';
import Logo from '../components/Logo';
import { motion } from 'framer-motion';
import { jwtDecode } from 'jwt-decode';

const CLIENT_ID = 'YOUR_GOOGLE_CLIENT_ID'; // Replace with your Google OAuth client ID

const bgGradient = {
  background: 'linear-gradient(135deg, #36d1c4 0%, #5b86e5 50%, #7f53ac 100%)',
  minHeight: '100vh',
  width: '100vw',
  position: 'absolute', // changed from fixed
  top: 0,
  left: 0,
  zIndex: 0,           // changed from -1
  overflow: 'hidden',
  pointerEvents: 'none',
};

const cardVariants = {
  hidden: { opacity: 0, y: 40, scale: 0.95 },
  visible: { opacity: 1, y: 0, scale: 1, transition: { duration: 0.7, ease: 'easeOut' } },
};

const Login = () => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const [runtimeError, setRuntimeError] = useState(null);

  let decodedUser = null;
  const token = localStorage.getItem('token');
  if (token) {
    try {
      decodedUser = jwtDecode(token);
    } catch {}
  }

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      const res = await fetch('/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username, password })
      });
      const data = await res.json();
      if (res.ok) {
        localStorage.setItem('token', data.token);
        window.location.href = '/';
      } else {
        setError(data.error || 'Login failed');
      }
    } catch (err) {
      setError('Network error');
    }
    setLoading(false);
  };

  const handleGoogleLogin = async (credentialResponse) => {
    setError('');
    setLoading(true);
    try {
      const res = await fetch('/google-login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ credential: credentialResponse.credential })
      });
      const data = await res.json();
      if (res.ok) {
        localStorage.setItem('token', data.token);
        window.location.href = '/';
      } else {
        setError(data.error || 'Google login failed');
      }
    } catch (err) {
      setError('Network error');
    }
    setLoading(false);
  };

  try {
    return (
      <div style={bgGradient}>
        <div style={{ fontSize: '2rem', color: 'red', textAlign: 'center', fontWeight: 900, marginTop: 20 }}>
          DEBUG: ADVANCED LOGIN PAGE RENDERED
        </div>
        <motion.div
          className="login-page"
          style={{ minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center' }}
        >
          {/* Animated Card */}
          <motion.div
            className="glass"
            variants={cardVariants}
            initial="hidden"
            animate="visible"
            style={{
              padding: '2.8rem 2.2rem',
              borderRadius: '32px',
              boxShadow: '0 12px 48px 0 rgba(0,0,0,0.18)',
              maxWidth: 420,
              width: '100%',
              position: 'relative',
              overflow: 'hidden',
              backdropFilter: 'blur(18px)',
            }}
          >
            <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', marginBottom: '1.5rem' }}>
              <Logo size={60} />
              <h2 className="gradient-text" style={{ textAlign: 'center', margin: '1.2rem 0 0.5rem 0', fontWeight: 800, fontSize: '2.2rem', letterSpacing: '-1px' }}>Welcome Back</h2>
              <div style={{ color: '#888', fontWeight: 500, fontSize: '1.1rem' }}>Sign in to WeatherTech</div>
              {decodedUser && <div style={{ color: '#2563eb', fontWeight: 600, marginTop: 8 }}>Logged in as: {decodedUser.username}</div>}
            </div>
            <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '1.2rem', marginTop: '1rem' }}>
              <div style={{ display: 'flex', alignItems: 'center', background: 'rgba(255,255,255,0.18)', borderRadius: 12, padding: '0.6rem 1.1rem' }}>
                <User size={22} style={{ marginRight: 10, color: '#0099cc' }} />
                <input type="text" placeholder="Username" value={username} onChange={e => setUsername(e.target.value)} required style={{ border: 'none', background: '#fff', outline: 'none', color: '#222', flex: 1, fontSize: '1.08rem', borderRadius: 6, padding: '0.3rem 0.5rem' }} />
              </div>
              <div style={{ display: 'flex', alignItems: 'center', background: 'rgba(255,255,255,0.18)', borderRadius: 12, padding: '0.6rem 1.1rem' }}>
                <Lock size={22} style={{ marginRight: 10, color: '#0099cc' }} />
                <input type="password" placeholder="Password" value={password} onChange={e => setPassword(e.target.value)} required style={{ border: 'none', background: '#fff', outline: 'none', color: '#222', flex: 1, fontSize: '1.08rem', borderRadius: 6, padding: '0.3rem 0.5rem' }} />
              </div>
              <motion.button
                type="submit"
                className="glow"
                whileHover={{ scale: 1.04, boxShadow: '0 0 24px #00d4ff' }}
                whileTap={{ scale: 0.98 }}
                style={{
                  padding: '0.85rem',
                  borderRadius: 12,
                  border: 'none',
                  background: 'linear-gradient(90deg, #00d4ff, #0099cc)',
                  color: '#fff',
                  fontWeight: 700,
                  fontSize: '1.15rem',
                  cursor: 'pointer',
                  boxShadow: '0 2px 12px rgba(0,212,255,0.16)',
                  marginTop: '0.2rem',
                  letterSpacing: '0.01em',
                  transition: 'all 0.2s',
                }}
                disabled={loading}
              >
                {loading ? 'Signing in...' : 'Login'}
              </motion.button>
            </form>
            <div style={{ textAlign: 'center', margin: '1.7rem 0 1.2rem 0', color: '#888', fontWeight: 500, fontSize: '1.05rem' }}>or</div>
            <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.2 }} style={{ display: 'flex', justifyContent: 'center' }}>
              <GoogleOAuthProvider clientId={CLIENT_ID}>
                <GoogleLogin
                  onSuccess={handleGoogleLogin}
                  onError={() => setError('Google login failed')}
                  width="100%"
                  shape="pill"
                  theme="filled_blue"
                  text="signin_with"
                />
              </GoogleOAuthProvider>
            </motion.div>
            {error && <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="error" style={{ color: '#ff6b6b', marginTop: '1.5rem', textAlign: 'center', fontWeight: 600 }}>{error}</motion.div>}
          </motion.div>
        </motion.div>
      </div>
    );
  } catch (err) {
    setTimeout(() => setRuntimeError(err.message), 0);
    return (
      <div style={{ color: 'red', fontWeight: 900, fontSize: '2rem', textAlign: 'center', marginTop: 40 }}>
        RUNTIME ERROR: {err.message}
      </div>
    );
  }
};

export default Login; 