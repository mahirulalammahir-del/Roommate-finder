document.addEventListener('DOMContentLoaded', () => {
    // --- Sign In Logic ---
    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            const btn = loginForm.querySelector('button');
            const originalText = btn.innerText;

            if (email && password) {
                btn.innerText = 'Verifying...';

                setTimeout(() => {
                    // Check localStorage
                    const storedUser = localStorage.getItem(email);

                    if (storedUser) {
                        const user = JSON.parse(storedUser);
                        if (user.password === password) {
                            // Success
                            // Save current session user (optional extensions)
                            localStorage.setItem('currentUser', JSON.stringify(user));
                            window.location.href = 'dashboard.html';
                            return;
                        }
                    }

                    // Failure
                    alert('Invalid email or password. Please try again or create an account.');
                    btn.innerText = originalText;
                }, 800);
            }
        });
    }

    // --- Sign Up Logic ---
    const signupForm = document.getElementById('signupForm');
    if (signupForm) {
        signupForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const name = document.getElementById('name').value;
            const email = document.getElementById('signupEmail').value;
            const password = document.getElementById('signupPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const btn = signupForm.querySelector('button');
            const originalText = btn.innerText;

            if (password !== confirmPassword) {
                alert("Passwords do not match!");
                return;
            }

            if (localStorage.getItem(email)) {
                alert("An account with this email already exists.");
                return;
            }

            btn.innerText = 'Creating Account...';

            setTimeout(() => {
                const newUser = {
                    name,
                    email,
                    password
                };

                // Save to localStorage
                localStorage.setItem(email, JSON.stringify(newUser));

                alert('Account created successfully! Please sign in.');
                window.location.href = 'signin.html';
            }, 800);
        });
    }

    // --- Dashboard Logic (Optional: display name) ---
    // If we wanted to display the user's name on dashboard:
    const currentUserJson = localStorage.getItem('currentUser');
    if (currentUserJson && window.location.pathname.includes('dashboard.html')) {
        const user = JSON.parse(currentUserJson);
        // Find element to update if exists. Currently dashboard has static "Welcome, User"
        // Logic to update it could go here if we added an ID to that span.
    }
});
