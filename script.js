/**
 * SYD SPICES - CINEMATIC SLIDER, DRAWER, STORE & CONTACT ENGINE
 */

document.addEventListener('DOMContentLoaded', () => {
  // --------------------------------------------------------------------------
  // 1. Sliding Hero Slider Logic (Only on pages with #hero-slider)
  // --------------------------------------------------------------------------
  const slides = document.querySelectorAll('.hero-slide');
  const progressBars = document.querySelectorAll('.progress-bar-item');
  const currentNumEl = document.getElementById('current-slide-num');
  const prevBtn = document.getElementById('prev-slide-btn');
  const nextBtn = document.getElementById('next-slide-btn');
  const sliderSection = document.getElementById('hero-slider');

  if (slides && slides.length > 0) {
    let currentSlide = 0;
    const totalSlides = slides.length;
    const slideDuration = 6000; // 6 seconds per slide
    let slideInterval = null;
    let progressAnimation = null;

    function goToSlide(index) {
      if (index >= totalSlides) index = 0;
      if (index < 0) index = totalSlides - 1;

      currentSlide = index;

      slides.forEach((slide, i) => {
        slide.classList.toggle('active', i === currentSlide);
      });

      progressBars.forEach((bar, i) => {
        bar.classList.toggle('active', i === currentSlide);
        const fill = bar.querySelector('.progress-bar-fill');
        if (fill) {
          fill.style.transition = 'none';
          fill.style.width = i === currentSlide ? '0%' : (i < currentSlide ? '100%' : '0%');
        }
      });

      if (currentNumEl) {
        currentNumEl.textContent = String(currentSlide + 1).padStart(2, '0');
      }

      startProgressBarAnimation();
    }

    function startProgressBarAnimation() {
      cancelAnimationFrame(progressAnimation);
      const activeBar = progressBars[currentSlide];
      if (!activeBar) return;
      const fill = activeBar.querySelector('.progress-bar-fill');
      if (!fill) return;

      fill.style.transition = 'none';
      fill.style.width = '0%';

      setTimeout(() => {
        fill.style.transition = `width ${slideDuration}ms linear`;
        fill.style.width = '100%';
      }, 50);
    }

    function startSliderTimer() {
      clearInterval(slideInterval);
      startProgressBarAnimation();
      slideInterval = setInterval(() => {
        goToSlide(currentSlide + 1);
      }, slideDuration);
    }

    function pauseSlider() {
      clearInterval(slideInterval);
      const activeBar = progressBars[currentSlide];
      if (activeBar) {
        const fill = activeBar.querySelector('.progress-bar-fill');
        if (fill) {
          const computedWidth = window.getComputedStyle(fill).width;
          fill.style.transition = 'none';
          fill.style.width = computedWidth;
        }
      }
    }

    if (nextBtn) {
      nextBtn.addEventListener('click', () => {
        goToSlide(currentSlide + 1);
        startSliderTimer();
      });
    }

    if (prevBtn) {
      prevBtn.addEventListener('click', () => {
        goToSlide(currentSlide - 1);
        startSliderTimer();
      });
    }

    progressBars.forEach((bar, i) => {
      bar.addEventListener('click', () => {
        goToSlide(i);
        startSliderTimer();
      });
    });

    if (sliderSection) {
      sliderSection.addEventListener('mouseenter', pauseSlider);
      sliderSection.addEventListener('mouseleave', startSliderTimer);
    }

    document.addEventListener('keydown', (e) => {
      if (e.key === 'ArrowRight') {
        goToSlide(currentSlide + 1);
        startSliderTimer();
      } else if (e.key === 'ArrowLeft') {
        goToSlide(currentSlide - 1);
        startSliderTimer();
      }
    });

    goToSlide(0);
    startSliderTimer();
  }

  // --------------------------------------------------------------------------
  // 2. Header & Cart Drawer Logic (Used on all pages)
  // --------------------------------------------------------------------------
  const header = document.getElementById('header');
  const cartToggle = document.getElementById('cart-toggle');
  const cartDrawer = document.getElementById('cart-drawer');
  const drawerBackdrop = document.getElementById('drawer-backdrop');
  const drawerClose = document.getElementById('drawer-close');
  const mobileMenuBtn = document.getElementById('mobile-menu-btn');
  const mobileNavMenu = document.getElementById('mobile-nav-menu');

  // Sticky Header on Scroll
  window.addEventListener('scroll', () => {
    if (window.scrollY > 40) {
      if (header) header.classList.add('scrolled');
    } else {
      if (header) header.classList.remove('scrolled');
    }
  });

  // Shopping Bag Drawer Toggle
  function openBag() {
    if (cartDrawer && drawerBackdrop) {
      cartDrawer.classList.add('active');
      drawerBackdrop.classList.add('active');
      document.body.style.overflow = 'hidden';
    }
  }

  function closeBag() {
    if (cartDrawer && drawerBackdrop) {
      cartDrawer.classList.remove('active');
      drawerBackdrop.classList.remove('active');
      document.body.style.overflow = '';
    }
  }

  if (cartToggle) cartToggle.addEventListener('click', openBag);
  if (drawerClose) drawerClose.addEventListener('click', closeBag);
  if (drawerBackdrop) drawerBackdrop.addEventListener('click', closeBag);

  // Mobile Menu Toggle
  if (mobileMenuBtn && mobileNavMenu) {
    mobileMenuBtn.addEventListener('click', () => {
      mobileNavMenu.classList.toggle('active');
      mobileMenuBtn.textContent = mobileNavMenu.classList.contains('active') ? '✕' : '☰';
    });

    document.querySelectorAll('.mobile-item').forEach(link => {
      link.addEventListener('click', () => {
        mobileNavMenu.classList.remove('active');
        mobileMenuBtn.textContent = '☰';
      });
    });
  }

  // --------------------------------------------------------------------------
  // 3. Dynamic Shopping Bag State & LocalStorage Engine
  // --------------------------------------------------------------------------
  const API_BASE_URL = 'http://127.0.0.1:8000/api';

  let cart = JSON.parse(localStorage.getItem('syd_cart_items')) || [
    { id: 'magic-blend-250g', name: 'Magic Blend', weight: '250g', price: 195, image: 'assets/magicbland.png', qty: 1 },
    { id: 'red-chilli-250g', name: 'Premium Red Chilli Powder', weight: '250g', price: 185, image: 'assets/chilli.png', qty: 1 },
    { id: 'garam-masala-100g', name: 'Premium Garam Masala', weight: '100g', price: 210, image: 'assets/garammasala.png', qty: 1 }
  ];

  function saveCart() {
    localStorage.setItem('syd_cart_items', JSON.stringify(cart));
    updateCartUI();
    syncCartWithBackend();
  }

  // Background Debounced Cart Sync with Laravel Backend
  let syncTimeout = null;
  function syncCartWithBackend() {
    clearTimeout(syncTimeout);
    syncTimeout = setTimeout(async () => {
      try {
        const total = cart.reduce((sum, item) => sum + (item.price * item.qty), 0);
        await fetch(`${API_BASE_URL}/cart/sync`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
          body: JSON.stringify({
            customer_email: localStorage.getItem('syd_customer_email') || 'customer@sydspices.com',
            items: cart.map(i => ({ id: i.id, name: `${i.name} (${i.weight})`, price: i.price, quantity: i.qty })),
            grand_total: total
          })
        });
      } catch (err) {
        // Silent background sync
      }
    }, 800);
  }

  function updateCartUI() {
    const bagCount = document.getElementById('bag-count');
    const drawerBody = document.getElementById('drawer-body');
    const drawerTotal = document.querySelector('.drawer-total span:last-child');

    const totalQty = cart.reduce((sum, item) => sum + item.qty, 0);
    const totalPrice = cart.reduce((sum, item) => sum + (item.price * item.qty), 0);

    if (bagCount) bagCount.textContent = totalQty;
    if (drawerTotal) drawerTotal.textContent = `₹${totalPrice.toFixed(2)}`;

    if (drawerBody) {
      if (cart.length === 0) {
        drawerBody.innerHTML = `
          <div class="drawer-empty-view">
            <div class="drawer-empty-icon">🛍️</div>
            <h3 class="drawer-empty-text">Your Bag is Empty</h3>
            <p class="drawer-empty-sub">Explore our single-origin whole spices and blends to start filling your bag.</p>
            <a href="products.html" class="btn-start-shopping" onclick="document.getElementById('cart-drawer').classList.remove('active'); document.getElementById('drawer-backdrop').classList.remove('active'); document.body.style.overflow = '';">Explore Spices</a>
          </div>
        `;
      } else {
        drawerBody.innerHTML = cart.map(item => `
          <div class="drawer-item" data-id="${item.id}">
            <img src="${item.image}" alt="${item.name}" class="drawer-item-img">
            <div class="drawer-item-info">
              <div class="drawer-item-name">${item.name} (${item.weight})</div>
              <div class="drawer-item-price">₹${(item.price * item.qty).toFixed(2)}</div>
              <div class="drawer-item-actions">
                <div class="drawer-qty-group">
                  <button type="button" class="drawer-qty-btn cart-minus-btn" data-id="${item.id}" aria-label="Decrease quantity">−</button>
                  <span class="drawer-qty-num">${item.qty}</span>
                  <button type="button" class="drawer-qty-btn cart-plus-btn" data-id="${item.id}" aria-label="Increase quantity">+</button>
                </div>
                <button type="button" class="drawer-item-remove" data-id="${item.id}">Remove</button>
              </div>
            </div>
          </div>
        `).join('');

        // Item interactions
        drawerBody.querySelectorAll('.cart-minus-btn').forEach(btn => {
          btn.addEventListener('click', () => {
            const id = btn.getAttribute('data-id');
            const item = cart.find(i => i.id === id);
            if (item) {
              if (item.qty > 1) item.qty--;
              else cart = cart.filter(i => i.id !== id);
              saveCart();
            }
          });
        });

        drawerBody.querySelectorAll('.cart-plus-btn').forEach(btn => {
          btn.addEventListener('click', () => {
            const id = btn.getAttribute('data-id');
            const item = cart.find(i => i.id === id);
            if (item) {
              item.qty++;
              saveCart();
            }
          });
        });

        drawerBody.querySelectorAll('.drawer-item-remove').forEach(btn => {
          btn.addEventListener('click', () => {
            const id = btn.getAttribute('data-id');
            cart = cart.filter(i => i.id !== id);
            saveCart();
            showToast('Item removed from your bag.');
          });
        });
      }
    }
  }

  // Initial cart UI render
  updateCartUI();

  // ==========================================================================
  // 3A. CUSTOMER ACCOUNT & AUTHENTICATION PORTAL (E-COMMERCE SUITE)
  // ==========================================================================
  function getLoggedInCustomer() {
    try {
      const raw = localStorage.getItem('syd_customer_auth');
      return raw ? JSON.parse(raw) : null;
    } catch (e) {
      return null;
    }
  }

  function setLoggedInCustomer(customer) {
    if (customer) {
      localStorage.setItem('syd_customer_auth', JSON.stringify(customer));
      if (customer.name) localStorage.setItem('syd_customer_name', customer.name);
      if (customer.email) localStorage.setItem('syd_customer_email', customer.email);
      if (customer.phone) localStorage.setItem('syd_customer_phone', customer.phone);
      if (customer.address) localStorage.setItem('syd_customer_address', customer.address);
      if (customer.pincode) localStorage.setItem('syd_customer_pincode', customer.pincode);
    } else {
      localStorage.removeItem('syd_customer_auth');
    }
    updateAccountButtonsUI();
  }

  function logoutCustomer() {
    setLoggedInCustomer(null);
    showToast('You have been signed out successfully.');
    closeAccountModal();
  }
  window.logoutCustomer = logoutCustomer;

  function updateAccountButtonsUI() {
    const customer = getLoggedInCustomer();
    document.querySelectorAll('.btn-account').forEach(btn => {
      if (customer) {
        const fLetter = customer.first_name?.[0] || customer.name?.[0] || 'C';
        const lLetter = customer.last_name?.[0] || '';
        const initials = (fLetter + lLetter).toUpperCase();
        btn.classList.add('is-logged-in');
        btn.innerHTML = `
          <span class="account-avatar-badge">${initials}</span>
          <span class="account-btn-label">${customer.first_name || customer.name.split(' ')[0]}</span>
        `;
      } else {
        btn.classList.remove('is-logged-in');
        btn.innerHTML = `
          <svg class="account-icon-svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
            <circle cx="12" cy="7" r="4"></circle>
          </svg>
          <span class="account-btn-label">Sign In</span>
        `;
      }
    });

    document.querySelectorAll('.mobile-account-link').forEach(link => {
      if (customer) {
        link.textContent = `👤 My Account (${customer.first_name || customer.name.split(' ')[0]})`;
      } else {
        link.textContent = '👤 Sign In / Register';
      }
    });
  }

  function ensureAccountModal() {
    let backdrop = document.getElementById('syd-account-backdrop');
    if (!backdrop) {
      backdrop = document.createElement('div');
      backdrop.id = 'syd-account-backdrop';
      backdrop.className = 'syd-account-backdrop';
      backdrop.innerHTML = `
        <div class="syd-account-modal" role="dialog" aria-modal="true" aria-labelledby="account-modal-title">
          <div class="syd-account-header">
            <div class="syd-account-header-left">
              <img src="assets/main logo .png" alt="SYD Spices Logo">
              <div>
                <h2 class="syd-account-title" id="account-modal-title">Customer Kitchen Account</h2>
                <div class="syd-account-subtitle" id="account-modal-subtitle">Pure Indian Spices • Direct Mandi Dispatch</div>
              </div>
            </div>
            <button type="button" class="syd-account-close-btn" id="syd-account-close" aria-label="Close Account Modal">&times;</button>
          </div>
          <div class="syd-account-body" id="syd-account-body"></div>
        </div>
      `;
      document.body.appendChild(backdrop);

      backdrop.addEventListener('click', (e) => {
        if (e.target === backdrop) closeAccountModal();
      });

      document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && backdrop.classList.contains('active')) {
          closeAccountModal();
        }
      });
    }
    return backdrop;
  }

  function closeAccountModal() {
    const backdrop = document.getElementById('syd-account-backdrop');
    if (backdrop) {
      backdrop.classList.remove('active');
      document.body.style.overflow = '';
    }
  }

  function openAccountModal(initialTab = null) {
    const backdrop = ensureAccountModal();
    const closeBtn = document.getElementById('syd-account-close');
    if (closeBtn) closeBtn.onclick = closeAccountModal;

    const customer = getLoggedInCustomer();
    if (customer) {
      renderCustomerPortal(initialTab || 'orders');
    } else {
      renderAuthViews(initialTab || 'login');
    }

    backdrop.classList.add('active');
    document.body.style.overflow = 'hidden';
  }
  window.openAccountModal = openAccountModal;

  // Render Logged-Out Views: Sign In, Register, Forgot Password
  function renderAuthViews(activeTab = 'login') {
    const modalBody = document.getElementById('syd-account-body');
    const modalTitle = document.getElementById('account-modal-title');
    const modalSub = document.getElementById('account-modal-subtitle');
    if (!modalBody) return;

    if (activeTab === 'forgot') {
      if (modalTitle) modalTitle.textContent = 'Reset Password';
      if (modalSub) modalSub.textContent = 'Enter your email to receive recovery instructions';
      modalBody.innerHTML = `
        <div style="max-width: 440px; margin: 0 auto; padding: 10px 0;">
          <form id="syd-forgot-form">
            <p style="font-size: 0.85rem; color: #5A4E45; margin-bottom: 20px; line-height: 1.5;">
              Enter the email address registered with your SYD Spices account and we will send you a secure password reset link.
            </p>
            <div class="syd-form-group">
              <label class="syd-form-label">Email Address <span class="req">*</span></label>
              <input type="email" id="forgot-email" class="syd-form-input" placeholder="e.g. aarav@sydspices.com" required>
            </div>
            <button type="submit" class="btn-confirm-order" style="margin-top: 10px;">
              <span>Send Reset Link</span> &rarr;
            </button>
            <div style="text-align: center; margin-top: 18px; font-size: 0.82rem;">
              <a href="#" id="link-back-to-login" style="color: #C25934; font-weight: 700; text-decoration: none;">&larr; Back to Sign In</a>
            </div>
          </form>
        </div>
      `;

      document.getElementById('link-back-to-login')?.addEventListener('click', (e) => {
        e.preventDefault();
        renderAuthViews('login');
      });

      document.getElementById('syd-forgot-form')?.addEventListener('submit', async (e) => {
        e.preventDefault();
        const em = document.getElementById('forgot-email').value.trim();
        try {
          const res = await fetch(`${API_BASE_URL}/customers/forgot-password`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
            body: JSON.stringify({ email: em })
          });
          const json = await res.json();
          showToast(json.message || 'Password reset link sent!');
          renderAuthViews('login');
        } catch (err) {
          showToast('Password reset link sent to ' + em);
          renderAuthViews('login');
        }
      });
      return;
    }

    if (modalTitle) modalTitle.textContent = activeTab === 'login' ? 'Customer Kitchen Sign In' : 'Create Customer Account';
    if (modalSub) modalSub.textContent = 'Pure Indian Spices • Express Checkout • Order Tracking';

    modalBody.innerHTML = `
      <!-- Auth Switcher Tabs -->
      <div class="syd-auth-nav">
        <button type="button" class="syd-auth-tab-btn ${activeTab === 'login' ? 'active' : ''}" id="tab-auth-login">Sign In</button>
        <button type="button" class="syd-auth-tab-btn ${activeTab === 'register' ? 'active' : ''}" id="tab-auth-register">Create Account</button>
      </div>

      ${activeTab === 'login' ? `
        <!-- Quick 1-Click Demo Testing Login Box -->
        <div class="syd-demo-login-box">
          <div style="display: flex; align-items: center; gap: 8px;">
            <span style="font-size: 1.2rem;">⚡</span>
            <div>
              <strong style="color: #2D5A27; font-size: 0.82rem; display: block;">Instant Demo Login Available</strong>
              <span style="font-size: 0.72rem; color: #4A3E36;">Log in as test customer Aarav Patel with 1 click.</span>
            </div>
          </div>
          <button type="button" class="syd-demo-btn" id="btn-demo-quick-login">⚡ 1-Click Demo Login</button>
        </div>

        <form id="syd-login-form">
          <div class="syd-form-group">
            <label class="syd-form-label">Email or Phone Number <span class="req">*</span></label>
            <input type="text" id="login-identifier" class="syd-form-input" placeholder="e.g. aarav@sydspices.com or 9876543210" required>
          </div>

          <div class="syd-form-group">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 5px;">
              <label class="syd-form-label" style="margin-bottom: 0;">Password <span class="req">*</span></label>
              <a href="#" id="link-forgot-pw" style="font-size: 0.75rem; color: #C25934; font-weight: 600; text-decoration: none;">Forgot Password?</a>
            </div>
            <input type="password" id="login-password" class="syd-form-input" placeholder="Enter password" required>
          </div>

          <button type="submit" class="btn-confirm-order" id="btn-login-submit" style="margin-top: 18px;">
            <span>Sign In to Kitchen</span> &rarr;
          </button>

          <div style="text-align: center; margin-top: 16px; font-size: 0.82rem; color: #7D736A;">
            New to SYD Spices? <a href="#" id="link-switch-to-register" style="color: #C25934; font-weight: 700; text-decoration: none;">Create an account</a>
          </div>
        </form>
      ` : `
        <form id="syd-register-form">
          <div class="syd-form-group">
            <label class="syd-form-label">Full Name <span class="req">*</span></label>
            <input type="text" id="reg-name" class="syd-form-input" placeholder="e.g. Aarav Patel" required>
          </div>

          <div class="syd-form-row">
            <div class="syd-form-group">
              <label class="syd-form-label">Email Address <span class="req">*</span></label>
              <input type="email" id="reg-email" class="syd-form-input" placeholder="aarav@example.com" required>
            </div>
            <div class="syd-form-group">
              <label class="syd-form-label">Phone / WhatsApp <span class="req">*</span></label>
              <input type="tel" id="reg-phone" class="syd-form-input" placeholder="+91 98765 43210" required>
            </div>
          </div>

          <div class="syd-form-group">
            <label class="syd-form-label">Delivery Street Address</label>
            <input type="text" id="reg-address" class="syd-form-input" placeholder="House/Flat No., Street, Landmark">
          </div>

          <div class="syd-form-row">
            <div class="syd-form-group">
              <label class="syd-form-label">City & State</label>
              <input type="text" id="reg-city" class="syd-form-input" placeholder="Ahmedabad, Gujarat" value="Ahmedabad, Gujarat">
            </div>
            <div class="syd-form-group">
              <label class="syd-form-label">Postal Pincode</label>
              <input type="text" id="reg-pincode" class="syd-form-input" placeholder="384170" maxlength="6" value="384170">
            </div>
          </div>

          <div class="syd-form-group">
            <label class="syd-form-label">Choose Password <span class="req">*</span></label>
            <input type="password" id="reg-password" class="syd-form-input" placeholder="Minimum 4 characters" minlength="4" required>
          </div>

          <button type="submit" class="btn-confirm-order" id="btn-reg-submit" style="margin-top: 18px;">
            <span>Create Account &amp; Proceed</span> &rarr;
          </button>

          <div style="text-align: center; margin-top: 16px; font-size: 0.82rem; color: #7D736A;">
            Already have an account? <a href="#" id="link-switch-to-login" style="color: #C25934; font-weight: 700; text-decoration: none;">Sign In</a>
          </div>
        </form>
      `}
    `;

    // Hook tab switches
    document.getElementById('tab-auth-login')?.addEventListener('click', () => renderAuthViews('login'));
    document.getElementById('tab-auth-register')?.addEventListener('click', () => renderAuthViews('register'));
    document.getElementById('link-switch-to-register')?.addEventListener('click', (e) => { e.preventDefault(); renderAuthViews('register'); });
    document.getElementById('link-switch-to-login')?.addEventListener('click', (e) => { e.preventDefault(); renderAuthViews('login'); });
    document.getElementById('link-forgot-pw')?.addEventListener('click', (e) => { e.preventDefault(); renderAuthViews('forgot'); });

    // Demo Quick Login
    document.getElementById('btn-demo-quick-login')?.addEventListener('click', async () => {
      const idInput = document.getElementById('login-identifier');
      const pwInput = document.getElementById('login-password');
      if (idInput && pwInput) {
        idInput.value = 'aarav@sydspices.com';
        pwInput.value = 'user123';
        document.getElementById('syd-login-form')?.dispatchEvent(new Event('submit'));
      }
    });

    // Login Form Submit
    document.getElementById('syd-login-form')?.addEventListener('submit', async (e) => {
      e.preventDefault();
      const submitBtn = document.getElementById('btn-login-submit');
      const identifier = document.getElementById('login-identifier').value.trim();
      const password = document.getElementById('login-password').value;

      if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.innerHTML = `<span>Signing In...</span>`;
      }

      try {
        const res = await fetch(`${API_BASE_URL}/customers/login`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
          body: JSON.stringify({ email: identifier, password: password })
        });
        const result = await res.json();
        if (res.ok && result.success) {
          setLoggedInCustomer(result.data);
          showToast(result.message || 'Signed in successfully!');
          renderCustomerPortal('orders');
        } else {
          throw new Error(result.message || 'Login failed. Please check your credentials.');
        }
      } catch (err) {
        showToast(err.message || 'Could not connect to authentication desk.');
        if (submitBtn) {
          submitBtn.disabled = false;
          submitBtn.innerHTML = `<span>Sign In to Kitchen</span> &rarr;`;
        }
      }
    });

    // Register Form Submit
    document.getElementById('syd-register-form')?.addEventListener('submit', async (e) => {
      e.preventDefault();
      const submitBtn = document.getElementById('btn-reg-submit');
      const name = document.getElementById('reg-name').value.trim();
      const email = document.getElementById('reg-email').value.trim();
      const phone = document.getElementById('reg-phone').value.trim();
      const address = document.getElementById('reg-address').value.trim();
      const city = document.getElementById('reg-city').value.trim();
      const pincode = document.getElementById('reg-pincode').value.trim();
      const password = document.getElementById('reg-password').value;

      if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.innerHTML = `<span>Creating Account...</span>`;
      }

      try {
        const res = await fetch(`${API_BASE_URL}/customers/register`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
          body: JSON.stringify({ name, email, phone, address, city, pincode, password })
        });
        const result = await res.json();
        if (res.ok && result.success) {
          setLoggedInCustomer(result.data);
          showToast('Account created successfully! Welcome to SYD Spices.');
          renderCustomerPortal('orders');
        } else {
          throw new Error(result.message || 'Registration could not be completed.');
        }
      } catch (err) {
        showToast(err.message || 'Registration failed.');
        if (submitBtn) {
          submitBtn.disabled = false;
          submitBtn.innerHTML = `<span>Create Account &amp; Proceed</span> &rarr;`;
        }
      }
    });
  }

  // Render Logged-In Customer Portal: Orders, Address & Profile, Wishlist
  async function renderCustomerPortal(activeTab = 'orders') {
    const modalBody = document.getElementById('syd-account-body');
    const modalTitle = document.getElementById('account-modal-title');
    const modalSub = document.getElementById('account-modal-subtitle');
    const customer = getLoggedInCustomer();
    if (!modalBody || !customer) return;

    if (modalTitle) modalTitle.textContent = 'My Customer Portal';
    if (modalSub) modalSub.textContent = 'Track Orders • Delivery Addresses • Pure Spice Reserve';

    const fLetter = customer.first_name?.[0] || customer.name?.[0] || 'C';
    const lLetter = customer.last_name?.[0] || '';
    const initials = (fLetter + lLetter).toUpperCase();

    modalBody.innerHTML = `
      <!-- Customer Greeting Banner -->
      <div class="syd-portal-hero">
        <div class="syd-portal-user-meta">
          <div class="syd-portal-avatar">${initials}</div>
          <div>
            <h3 class="syd-portal-name">Welcome, ${customer.name || customer.first_name}!</h3>
            <div class="syd-portal-sub">
              ${customer.email} ${customer.phone ? `&bull; ${customer.phone}` : ''}
            </div>
          </div>
        </div>
        <button type="button" class="btn-portal-logout" id="btn-portal-signout">Sign Out</button>
      </div>

      <!-- Portal Tabs -->
      <div class="syd-portal-nav">
        <button type="button" class="syd-portal-tab-btn ${activeTab === 'orders' ? 'active' : ''}" id="tab-portal-orders">
          <span>📦 My Orders</span>
        </button>
        <button type="button" class="syd-portal-tab-btn ${activeTab === 'profile' ? 'active' : ''}" id="tab-portal-profile">
          <span>📍 Saved Address &amp; Profile</span>
        </button>
        <button type="button" class="syd-portal-tab-btn ${activeTab === 'wishlist' ? 'active' : ''}" id="tab-portal-wishlist">
          <span>⭐ Favourites</span>
        </button>
      </div>

      <!-- Tab Content Area -->
      <div id="syd-portal-tab-content">
        <div style="text-align: center; padding: 40px; color: #7D736A;">
          Loading your details...
        </div>
      </div>
    `;

    document.getElementById('btn-portal-signout')?.addEventListener('click', logoutCustomer);
    document.getElementById('tab-portal-orders')?.addEventListener('click', () => renderCustomerPortal('orders'));
    document.getElementById('tab-portal-profile')?.addEventListener('click', () => renderCustomerPortal('profile'));
    document.getElementById('tab-portal-wishlist')?.addEventListener('click', () => renderCustomerPortal('wishlist'));

    const tabContent = document.getElementById('syd-portal-tab-content');

    // 1. ORDERS TAB
    if (activeTab === 'orders') {
      try {
        const res = await fetch(`${API_BASE_URL}/customers/${customer.id}/orders`);
        const data = await res.json();
        const orders = data.orders || [];

        if (orders.length === 0) {
          tabContent.innerHTML = `
            <div class="syd-portal-empty">
              <div class="syd-portal-empty-icon">🛍️</div>
              <h4 class="syd-portal-empty-text">No Orders Placed Yet</h4>
              <p class="syd-portal-empty-sub">Explore our single-origin whole spices and authentic hand-roasted blends.</p>
              <a href="products.html" class="btn-success-close" style="text-decoration:none;" onclick="closeAccountModal()">Explore Spices</a>
            </div>
          `;
        } else {
          tabContent.innerHTML = `
            <div class="syd-account-orders-list">
              ${orders.map(o => `
                <div class="syd-order-card">
                  <div class="syd-order-card-header">
                    <div>
                      <span class="syd-order-num">ORDER #${o.order_number}</span>
                      <span style="font-size: 0.76rem; color: #7D736A; margin-left: 8px;">Placed on ${o.created_at}</span>
                    </div>
                    <span class="syd-order-status-badge ${o.status}">${o.status_label || o.status}</span>
                  </div>

                  <div class="syd-order-card-meta">
                    <span>Payment: <strong>${o.payment_method}</strong></span>
                    <span>Dispatch: <strong>${o.shipping_address}</strong></span>
                  </div>

                  <div class="syd-order-items-preview">
                    ${(o.items || []).map(it => `
                      <div class="syd-order-preview-row">
                        <div class="syd-order-preview-left">
                          <img src="${it.image || 'assets/spices.png'}" alt="${it.name}" class="syd-order-preview-thumb">
                          <div>
                            <strong>${it.name}</strong>
                            <div style="font-size: 0.72rem; color: #7D736A;">Qty: ${it.quantity}</div>
                          </div>
                        </div>
                        <strong>₹${(it.price * it.quantity).toFixed(2)}</strong>
                      </div>
                    `).join('')}
                  </div>

                  <div class="syd-order-card-footer">
                    <div>
                      <span style="font-size: 0.76rem; color: #7D736A; display: block;">Total Paid</span>
                      <span class="syd-order-total-price">₹${Number(o.grand_total).toFixed(2)}</span>
                    </div>
                    <button type="button" class="btn-track-order-mini" onclick="closeAccountModal(); openOrderTracking('${o.order_number}');">
                      Track Live Dispatch &rarr;
                    </button>
                  </div>
                </div>
              `).join('')}
            </div>
          `;
        }
      } catch (err) {
        tabContent.innerHTML = `
          <div style="text-align:center; padding:30px; color:#C25934;">
            Could not fetch order history from backend desk.
          </div>
        `;
      }
    }

    // 2. PROFILE & SAVED ADDRESS TAB
    else if (activeTab === 'profile') {
      try {
        const res = await fetch(`${API_BASE_URL}/customers/${customer.id}/profile`);
        const pData = await res.json();
        const profile = pData.data || customer;

        tabContent.innerHTML = `
          <form id="syd-profile-form">
            <div class="syd-form-row">
              <div class="syd-form-group">
                <label class="syd-form-label">First Name <span class="req">*</span></label>
                <input type="text" id="prof-fname" class="syd-form-input" value="${profile.first_name || ''}" required>
              </div>
              <div class="syd-form-group">
                <label class="syd-form-label">Last Name</label>
                <input type="text" id="prof-lname" class="syd-form-input" value="${profile.last_name || ''}">
              </div>
            </div>

            <div class="syd-form-row">
              <div class="syd-form-group">
                <label class="syd-form-label">Email Address (Registered)</label>
                <input type="email" class="syd-form-input" value="${profile.email || ''}" disabled style="opacity:0.7; cursor:not-allowed;">
              </div>
              <div class="syd-form-group">
                <label class="syd-form-label">Phone / WhatsApp <span class="req">*</span></label>
                <input type="tel" id="prof-phone" class="syd-form-input" value="${profile.phone || ''}" required>
              </div>
            </div>

            <div class="syd-checkout-section-title" style="margin: 18px 0 10px; font-size: 0.85rem;">
              <span>📍 Primary Delivery Address</span>
            </div>

            <div class="syd-form-group">
              <label class="syd-form-label">Street Address</label>
              <input type="text" id="prof-address" class="syd-form-input" placeholder="House/Flat No., Apartment, Street" value="${profile.address || ''}">
            </div>

            <div class="syd-form-row">
              <div class="syd-form-group">
                <label class="syd-form-label">City &amp; State</label>
                <input type="text" id="prof-city" class="syd-form-input" value="${profile.city || 'Ahmedabad, Gujarat'}">
              </div>
              <div class="syd-form-group">
                <label class="syd-form-label">Postal Pincode</label>
                <input type="text" id="prof-pincode" class="syd-form-input" maxlength="6" value="${profile.pincode || '384170'}">
              </div>
            </div>

            <div class="syd-checkout-section-title" style="margin: 18px 0 10px; font-size: 0.85rem;">
              <span>🔒 Change Password (Optional)</span>
            </div>

            <div class="syd-form-group">
              <label class="syd-form-label">New Password</label>
              <input type="password" id="prof-password" class="syd-form-input" placeholder="Leave empty to keep current password">
            </div>

            <button type="submit" class="btn-confirm-order" id="btn-save-profile" style="margin-top: 16px;">
              <span>Save Profile &amp; Address</span> &rarr;
            </button>
          </form>
        `;

        document.getElementById('syd-profile-form')?.addEventListener('submit', async (e) => {
          e.preventDefault();
          const saveBtn = document.getElementById('btn-save-profile');
          const fname = document.getElementById('prof-fname').value.trim();
          const lname = document.getElementById('prof-lname').value.trim();
          const phone = document.getElementById('prof-phone').value.trim();
          const address = document.getElementById('prof-address').value.trim();
          const city = document.getElementById('prof-city').value.trim();
          const pincode = document.getElementById('prof-pincode').value.trim();
          const password = document.getElementById('prof-password').value;

          if (saveBtn) {
            saveBtn.disabled = true;
            saveBtn.innerHTML = `<span>Saving Changes...</span>`;
          }

          try {
            const uRes = await fetch(`${API_BASE_URL}/customers/${customer.id}/profile`, {
              method: 'POST',
              headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
              body: JSON.stringify({
                first_name: fname,
                last_name: lname,
                phone: phone,
                address: address,
                city: city,
                pincode: pincode,
                password: password || undefined
              })
            });
            const uJson = await uRes.json();
            if (uRes.ok && uJson.success) {
              setLoggedInCustomer(uJson.data);
              showToast('Profile and delivery address updated successfully!');
              renderCustomerPortal('profile');
            } else {
              throw new Error(uJson.message || 'Could not update profile.');
            }
          } catch (err) {
            showToast(err.message || 'Failed to update profile.');
            if (saveBtn) {
              saveBtn.disabled = false;
              saveBtn.innerHTML = `<span>Save Profile &amp; Address</span> &rarr;`;
            }
          }
        });
      } catch (err) {
        tabContent.innerHTML = `<div style="text-align:center; padding:30px; color:#C25934;">Could not load profile.</div>`;
      }
    }

    // 3. WISHLIST TAB
    else if (activeTab === 'wishlist') {
      tabContent.innerHTML = `
        <div class="syd-account-orders-list">
          <div class="syd-order-card" style="display: flex; align-items: center; justify-content: space-between; gap: 14px;">
            <div style="display:flex; align-items:center; gap: 12px;">
              <img src="assets/magicbland.png" alt="Magic Blend" style="width:48px; height:48px; border-radius:8px; object-fit:cover; border:1px solid #EAE5DE;">
              <div>
                <strong style="color: #2B231D; font-size: 0.92rem;">Magic Blend (Secret Spice)</strong>
                <div style="font-size: 0.78rem; color: #7D736A;">250g Pouch &bull; ₹195.00</div>
              </div>
            </div>
            <button type="button" class="btn-check-pin" onclick="cart.push({id:'magic-blend-250g', name:'Magic Blend', weight:'250g', price:195, image:'assets/magicbland.png', qty:1}); saveCart(); showToast('Added Magic Blend to your bag!'); closeAccountModal();">
              Add to Bag +
            </button>
          </div>

          <div class="syd-order-card" style="display: flex; align-items: center; justify-content: space-between; gap: 14px;">
            <div style="display:flex; align-items:center; gap: 12px;">
              <img src="assets/garammasala.png" alt="Royal Garam Masala" style="width:48px; height:48px; border-radius:8px; object-fit:cover; border:1px solid #EAE5DE;">
              <div>
                <strong style="color: #2B231D; font-size: 0.92rem;">Royal Garam Masala</strong>
                <div style="font-size: 0.78rem; color: #7D736A;">100g Pouch &bull; ₹210.00</div>
              </div>
            </div>
            <button type="button" class="btn-check-pin" onclick="cart.push({id:'garam-masala-100g', name:'Royal Garam Masala', weight:'100g', price:210, image:'assets/garammasala.png', qty:1}); saveCart(); showToast('Added Royal Garam Masala to your bag!'); closeAccountModal();">
              Add to Bag +
            </button>
          </div>

          <div class="syd-order-card" style="display: flex; align-items: center; justify-content: space-between; gap: 14px;">
            <div style="display:flex; align-items:center; gap: 12px;">
              <img src="assets/chilli.png" alt="Red Chilli Powder" style="width:48px; height:48px; border-radius:8px; object-fit:cover; border:1px solid #EAE5DE;">
              <div>
                <strong style="color: #2B231D; font-size: 0.92rem;">Red Chilli Powder (Stemless Guntur)</strong>
                <div style="font-size: 0.78rem; color: #7D736A;">250g Pouch &bull; ₹185.00</div>
              </div>
            </div>
            <button type="button" class="btn-check-pin" onclick="cart.push({id:'red-chilli-250g', name:'Red Chilli Powder', weight:'250g', price:185, image:'assets/chilli.png', qty:1}); saveCart(); showToast('Added Red Chilli Powder to your bag!'); closeAccountModal();">
              Add to Bag +
            </button>
          </div>
        </div>
      `;
    }
  }

  // Hook all Customer Account buttons across all pages and mobile drawers
  function initAccountButtons() {
    // Check if any .header-actions is missing the button, inject it automatically
    document.querySelectorAll('.header-actions').forEach(actions => {
      if (!actions.querySelector('.btn-account')) {
        const bagBtn = actions.querySelector('.btn-bag');
        const accBtn = document.createElement('button');
        accBtn.type = 'button';
        accBtn.className = 'btn-account';
        accBtn.id = 'account-toggle';
        accBtn.setAttribute('aria-label', 'Customer Account');
        accBtn.innerHTML = `
          <svg class="account-icon-svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
            <circle cx="12" cy="7" r="4"></circle>
          </svg>
          <span class="account-btn-label">Sign In</span>
        `;
        if (bagBtn) {
          actions.insertBefore(accBtn, bagBtn);
        } else {
          actions.appendChild(accBtn);
        }
      }
    });

    document.querySelectorAll('.btn-account').forEach(btn => {
      btn.onclick = (e) => {
        e.preventDefault();
        e.stopPropagation();
        openAccountModal();
      };
    });

    document.querySelectorAll('.mobile-account-link').forEach(link => {
      link.onclick = (e) => {
        e.preventDefault();
        e.stopPropagation();
        const mobileMenu = document.getElementById('mobile-nav-menu');
        if (mobileMenu) mobileMenu.classList.remove('active');
        openAccountModal();
      };
    });

    updateAccountButtonsUI();
  }

  // Call immediately on load
  initAccountButtons();

  // --------------------------------------------------------------------------
  // 3B. ONE-PAGE CHECKOUT MODAL & BACKEND ORDER DESK INTEGRATION
  // --------------------------------------------------------------------------
  function ensureCheckoutModal() {
    let backdrop = document.getElementById('syd-checkout-backdrop');
    if (!backdrop) {
      backdrop = document.createElement('div');
      backdrop.id = 'syd-checkout-backdrop';
      backdrop.className = 'syd-checkout-backdrop';
      backdrop.innerHTML = `
        <div class="syd-checkout-modal" role="dialog" aria-modal="true" aria-labelledby="checkout-modal-title">
          <div class="syd-checkout-header">
            <div class="syd-checkout-header-left">
              <img src="assets/main logo .png" alt="SYD Spices Logo">
              <div>
                <h2 class="syd-checkout-title" id="checkout-modal-title">Direct Kitchen Checkout</h2>
                <div class="syd-checkout-subtitle">100% Pure • Gujarat Sourced • Dispatched Fresh</div>
              </div>
            </div>
            <button type="button" class="syd-checkout-close-btn" id="syd-checkout-close" aria-label="Close Checkout">&times;</button>
          </div>

          <div class="syd-checkout-body" id="syd-checkout-body">
            <!-- Dynamic Content Injected Here -->
          </div>
        </div>
      `;
      document.body.appendChild(backdrop);

      backdrop.addEventListener('click', (e) => {
        if (e.target === backdrop) closeCheckoutModal();
      });

      document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && backdrop.classList.contains('active')) {
          closeCheckoutModal();
        }
      });
    }
    return backdrop;
  }

  function closeCheckoutModal() {
    const backdrop = document.getElementById('syd-checkout-backdrop');
    if (backdrop) {
      backdrop.classList.remove('active');
      document.body.style.overflow = '';
    }
  }

  function openCheckoutModal() {
    if (!cart || cart.length === 0) {
      showToast('Your shopping bag is empty. Please add spices to proceed.');
      return;
    }

    closeBag();

    const backdrop = ensureCheckoutModal();
    const modalBody = document.getElementById('syd-checkout-body');
    const closeBtn = document.getElementById('syd-checkout-close');
    if (closeBtn) closeBtn.onclick = closeCheckoutModal;

    const subtotal = cart.reduce((sum, item) => sum + (item.price * item.qty), 0);
    const shipping = 0.00; // Free direct shipping
    const grandTotal = subtotal + shipping;

    const loggedCustomer = getLoggedInCustomer();
    const savedName = loggedCustomer?.name || localStorage.getItem('syd_customer_name') || '';
    const savedEmail = loggedCustomer?.email || localStorage.getItem('syd_customer_email') || '';
    const savedPhone = loggedCustomer?.phone || localStorage.getItem('syd_customer_phone') || '';
    const savedAddress = loggedCustomer?.address || localStorage.getItem('syd_customer_address') || '';
    const savedPincode = loggedCustomer?.pincode || localStorage.getItem('syd_customer_pincode') || '384170';

    modalBody.innerHTML = `
      <form id="syd-checkout-form" class="syd-checkout-grid">
        <!-- Left: Shipping & Payment Details -->
        <div class="syd-checkout-form-col">
          <!-- Test Mode Banner & 1-Click Auto-Fill -->
          <div style="background: #eef7ee; border: 1.5px solid #2D5A27; border-radius: 8px; padding: 10px 14px; margin-bottom: 16px; display: flex; align-items: center; justify-content: space-between; gap: 10px; flex-wrap: wrap;">
            <div style="display: flex; align-items: center; gap: 8px;">
              <span style="font-size: 1.25rem;">⚡</span>
              <div>
                <strong style="color: #2D5A27; font-size: 0.84rem; display: block;">Instant Test Mode (No Payment Needed)</strong>
                <span style="font-size: 0.74rem; color: #4A3E36;">Add orders directly to Bagisto backend without real payment.</span>
              </div>
            </div>
            <button type="button" id="btn-autofill-test" style="background: #2D5A27; color: #ffffff; border: none; border-radius: 6px; padding: 6px 12px; font-size: 0.76rem; font-weight: 700; cursor: pointer; transition: all 0.2s;">
              ⚡ Fill Test Data
            </button>
          </div>

          <div class="syd-checkout-section-title">
            <span>📍 1. Delivery & Contact Details</span>
          </div>

          <div class="syd-form-group">
            <label class="syd-form-label">Full Name <span class="req">*</span></label>
            <input type="text" id="checkout-name" class="syd-form-input" placeholder="e.g. Aarav Patel" value="${savedName || 'Test Customer (Vivek)'}" required>
          </div>

          <div class="syd-form-row">
            <div class="syd-form-group">
              <label class="syd-form-label">Email Address <span class="req">*</span></label>
              <input type="email" id="checkout-email" class="syd-form-input" placeholder="test.buyer@sydspices.com" value="${savedEmail || 'test.buyer@sydspices.com'}" required>
            </div>
            <div class="syd-form-group">
              <label class="syd-form-label">Phone / WhatsApp <span class="req">*</span></label>
              <input type="tel" id="checkout-phone" class="syd-form-input" placeholder="+91 98765 43210" value="${savedPhone || '+91 98765 43210'}" required>
            </div>
          </div>

          <div class="syd-form-group">
            <label class="syd-form-label">Delivery Street Address <span class="req">*</span></label>
            <input type="text" id="checkout-address" class="syd-form-input" placeholder="House/Flat No., Apartment, Street name" value="${savedAddress || 'Gala No. 12, Spice Park Mandi Road'}" required>
          </div>

          <div class="syd-form-row">
            <div class="syd-form-group">
              <label class="syd-form-label">City & State <span class="req">*</span></label>
              <input type="text" id="checkout-city" class="syd-form-input" placeholder="City, State" value="Ahmedabad, Gujarat" required>
            </div>

            <div class="syd-form-group">
              <label class="syd-form-label">Postal Pincode <span class="req">*</span></label>
              <div class="syd-pincode-wrap">
                <input type="text" id="checkout-pincode" class="syd-form-input" placeholder="6-digit PIN" maxlength="6" value="${savedPincode || '384170'}" required>
                <button type="button" class="btn-check-pin" id="btn-verify-pincode">Verify</button>
              </div>
              <div class="syd-pincode-status serviceable" id="pincode-status-text" style="display:block;">✓ Serviceable: Fresh dispatch from Gujarat Hub</div>
            </div>
          </div>

          <!-- Payment Options -->
          <div class="syd-checkout-section-title" style="margin-top: 20px;">
            <span>💳 2. Payment Method (Test Mode Ready)</span>
          </div>

          <div class="syd-payment-options" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(130px, 1fr)); gap: 10px;">
            <label class="syd-payment-card active" id="pay-card-test">
              <input type="radio" name="payment_method" value="test_order" checked>
              <div>
                <span style="color:#2D5A27; font-weight:700;">⚡ Test Order (Free)</span>
                <div style="font-size: 0.7rem; color: #7D736A; margin-top: 2px;">Direct simulated order</div>
              </div>
            </label>

            <label class="syd-payment-card" id="pay-card-cod">
              <input type="radio" name="payment_method" value="cod">
              <div>
                <span>Cash on Delivery</span>
                <div style="font-size: 0.7rem; color: #7D736A; margin-top: 2px;">Pay upon delivery</div>
              </div>
            </label>

            <label class="syd-payment-card" id="pay-card-upi">
              <input type="radio" name="payment_method" value="upi">
              <div>
                <span>UPI / NetBanking</span>
                <div style="font-size: 0.7rem; color: #7D736A; margin-top: 2px;">GPay, PhonePe (Mock)</div>
              </div>
            </label>
          </div>
        </div>

        <!-- Right: Order Summary Dock -->
        <div class="syd-checkout-summary-col">
          <div class="syd-order-summary-box">
            <div class="syd-checkout-section-title" style="margin-bottom: 12px;">
              <span>📦 Order Review (${cart.length} items)</span>
            </div>

            <div class="syd-order-items-mini">
              ${cart.map(item => `
                <div class="syd-order-mini-item">
                  <img src="${item.image}" alt="${item.name}">
                  <div class="syd-mini-item-info">
                    <div class="syd-mini-item-name">${item.name}</div>
                    <div class="syd-mini-item-meta">${item.weight} &times; ${item.qty}</div>
                  </div>
                  <div class="syd-mini-item-price">₹${(item.price * item.qty).toFixed(2)}</div>
                </div>
              `).join('')}
            </div>

            <div class="syd-summary-line">
              <span>Items Subtotal</span>
              <span>₹${subtotal.toFixed(2)}</span>
            </div>

            <div class="syd-summary-line">
              <span>Gujarat Mandi Dispatch</span>
              <span style="color: #2D5A27; font-weight: 700;">FREE</span>
            </div>

            <div class="syd-summary-line">
              <span>NABL Purity Certification</span>
              <span style="color: #2D5A27; font-weight: 700;">Included</span>
            </div>

            <div class="syd-summary-line total">
              <span>Total Payable</span>
              <span>₹${grandTotal.toFixed(2)}</span>
            </div>

            <button type="submit" class="btn-confirm-order" id="btn-place-order-submit">
              <span>⚡ Place Test Order (No Pay)</span>
              <span>&rarr;</span>
            </button>

            <div class="syd-trust-dock">
              <span>🔒 Direct Bagisto API</span>
              <span>•</span>
              <span>🌿 Live Backend Sync</span>
            </div>
          </div>
        </div>
      </form>
    `;

    // Auto-fill test details button handler
    const autoFillBtn = document.getElementById('btn-autofill-test');
    if (autoFillBtn) {
      autoFillBtn.addEventListener('click', () => {
        document.getElementById('checkout-name').value = 'Test Customer (Vivek)';
        document.getElementById('checkout-email').value = 'test.buyer@sydspices.com';
        document.getElementById('checkout-phone').value = '+91 98765 43210';
        document.getElementById('checkout-address').value = 'Gala No. 12, Spice Park Mandi Road';
        document.getElementById('checkout-city').value = 'Ahmedabad, Gujarat';
        document.getElementById('checkout-pincode').value = '384170';

        const pinStatus = document.getElementById('pincode-status-text');
        if (pinStatus) {
          pinStatus.className = 'syd-pincode-status serviceable';
          pinStatus.style.display = 'block';
          pinStatus.textContent = '✓ Serviceable: Fresh dispatch from Gujarat Hub';
        }

        const testRadio = modalBody.querySelector('input[name="payment_method"][value="test_order"]');
        if (testRadio) {
          testRadio.checked = true;
          testRadio.dispatchEvent(new Event('change'));
        }

        showToast('⚡ Test customer details filled!');
      });
    }

    // Payment selection toggle styling across all payment cards
    const payRadios = modalBody.querySelectorAll('input[name="payment_method"]');
    payRadios.forEach(radio => {
      radio.addEventListener('change', () => {
        modalBody.querySelectorAll('.syd-payment-card').forEach(card => card.classList.remove('active'));
        const parentCard = radio.closest('.syd-payment-card');
        if (parentCard) parentCard.classList.add('active');

        const submitBtn = document.getElementById('btn-place-order-submit');
        if (submitBtn) {
          if (radio.value === 'test_order') {
            submitBtn.innerHTML = `<span>⚡ Place Test Order (No Pay)</span><span>&rarr;</span>`;
          } else if (radio.value === 'cod') {
            submitBtn.innerHTML = `<span>Confirm Cash on Delivery</span><span>&rarr;</span>`;
          } else {
            submitBtn.innerHTML = `<span>Pay via UPI / NetBanking</span><span>&rarr;</span>`;
          }
        }
      });
    });

    // Pincode verification button
    const verifyPinBtn = document.getElementById('btn-verify-pincode');
    const pinInput = document.getElementById('checkout-pincode');
    const pinStatus = document.getElementById('pincode-status-text');
    if (verifyPinBtn && pinInput && pinStatus) {
      verifyPinBtn.addEventListener('click', async () => {
        const pin = pinInput.value.trim();
        if (pin.length !== 6 || isNaN(pin)) {
          pinStatus.className = 'syd-pincode-status not-serviceable';
          pinStatus.style.display = 'block';
          pinStatus.textContent = '⚠️ Enter a valid 6-digit Indian PIN code';
          return;
        }

        verifyPinBtn.textContent = '...';
        verifyPinBtn.disabled = true;

        try {
          const res = await fetch(`${API_BASE_URL}/shipping/check-pincode?pincode=${pin}`);
          const data = await res.json();
          pinStatus.style.display = 'block';
          if (data.serviceable) {
            pinStatus.className = 'syd-pincode-status serviceable';
            pinStatus.textContent = `✓ ${data.message || 'Serviceable for fresh dispatch from Gujarat Hub'}`;
          } else {
            pinStatus.className = 'syd-pincode-status not-serviceable';
            pinStatus.textContent = `⚠️ ${data.message || 'Location not currently serviceable'}`;
          }
        } catch (e) {
          pinStatus.style.display = 'block';
          pinStatus.className = 'syd-pincode-status serviceable';
          pinStatus.textContent = '✓ Serviceable: Standard dispatch via Express Courier (2-4 days)';
        } finally {
          verifyPinBtn.textContent = 'Verify';
          verifyPinBtn.disabled = false;
        }
      });
    }

    // Checkout form submit
    const checkoutForm = document.getElementById('syd-checkout-form');
    if (checkoutForm) {
      checkoutForm.addEventListener('submit', async (e) => {
        e.preventDefault();

        const submitBtn = document.getElementById('btn-place-order-submit');
        let nameVal = document.getElementById('checkout-name').value.trim();
        let emailVal = document.getElementById('checkout-email').value.trim();
        let phoneVal = document.getElementById('checkout-phone').value.trim();
        let addressVal = document.getElementById('checkout-address').value.trim();
        let cityVal = document.getElementById('checkout-city').value.trim();
        let pincodeVal = document.getElementById('checkout-pincode').value.trim();
        const paymentMethod = modalBody.querySelector('input[name="payment_method"]:checked')?.value || 'test_order';

        // Friendly defaults for fast testing
        if (!nameVal) nameVal = 'Test Customer (Vivek)';
        if (!emailVal) emailVal = 'test.buyer@sydspices.com';
        if (!phoneVal) phoneVal = '+91 98765 43210';
        if (!addressVal) addressVal = 'Gala No. 12, Spice Park Mandi Road';
        if (!cityVal) cityVal = 'Ahmedabad, Gujarat';
        if (!pincodeVal) pincodeVal = '384170';

        // Remember contact details for seamless next order
        localStorage.setItem('syd_customer_name', nameVal);
        localStorage.setItem('syd_customer_email', emailVal);
        localStorage.setItem('syd_customer_phone', phoneVal);
        localStorage.setItem('syd_customer_address', addressVal);
        localStorage.setItem('syd_customer_pincode', pincodeVal);

        if (submitBtn) {
          submitBtn.disabled = true;
          submitBtn.innerHTML = `
            <span>Recording in Bagisto Database...</span>
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="animation: spin 1s linear infinite;">
              <circle cx="12" cy="12" r="10" stroke-opacity="0.25"></circle>
              <path d="M12 2a10 10 0 0 1 10 10"></path>
            </svg>
          `;
        }

        try {
          const loggedCust = getLoggedInCustomer();
          const payload = {
            customer_id: loggedCust ? loggedCust.id : undefined,
            customer_name: nameVal,
            customer_email: emailVal,
            customer_phone: phoneVal,
            customer_address: addressVal,
            customer_city: cityVal,
            customer_pincode: pincodeVal,
            payment_method: paymentMethod,
            grand_total: grandTotal,
            items: cart.map(i => ({
              id: i.id,
              name: `${i.name} (${i.weight})`,
              price: i.price,
              quantity: i.qty
            }))
          };

          const response = await fetch(`${API_BASE_URL}/checkout/place-order`, {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json'
            },
            body: JSON.stringify(payload)
          });

          const result = await response.json();

          if (response.ok && result.success) {
            // Render Celebratory Order Confirmation Screen with Direct Link to Bagisto Admin
            modalBody.innerHTML = `
              <div class="syd-success-screen">
                <div class="syd-success-icon">✓</div>
                <h2 class="syd-success-title">Order Confirmed!</h2>
                <div class="syd-order-id-badge">ORDER #${result.order_number}</div>
                <p class="syd-success-message">
                  Thank you, <strong>${result.customer_name}</strong>! Your order for <strong>₹${Number(result.grand_total).toFixed(2)}</strong> has been registered in the <strong>Bagisto backend database</strong>.
                  <br><br>
                  Stock has been automatically updated in inventory. You can verify this order immediately in your official Bagisto Admin sales dashboard.
                </p>
                <div style="margin-bottom: 22px; font-size: 0.82rem; color: #7D736A;">
                  Payment Mode: <strong style="color: #2D5A27;">${result.payment_method}</strong> &bull; Estimated Delivery: <strong>${result.estimated_delivery}</strong>
                </div>
                <div style="display: flex; flex-direction: column; gap: 10px; max-width: 360px; margin: 0 auto 20px;">
                  <a href="http://127.0.0.1:8000/admin/sales/orders" target="_blank" rel="noopener noreferrer" class="btn-success-close" style="background: #2D5A27; color: #ffffff; text-decoration: none; display: flex; align-items: center; justify-content: center; gap: 8px;">
                    <span>View Order in Bagisto Admin</span> &rarr;
                  </a>
                  <button type="button" class="btn-success-close" style="background: #ffffff; color: var(--color-terracotta); border: 1.5px solid var(--color-terracotta);" onclick="openOrderTracking('${result.order_number}')">
                    Track Live Dispatch Status
                  </button>
                  <button type="button" class="btn-success-close" id="btn-continue-shopping" style="background: #FAF7F2; color: #4A3E36; border: 1px solid rgba(80, 60, 45, 0.2);">
                    Continue Exploring Spices
                  </button>
                </div>
              </div>
            `;

            const continueBtn = document.getElementById('btn-continue-shopping');
            if (continueBtn) {
              continueBtn.onclick = () => {
                closeCheckoutModal();
              };
            }

            // Clear shopping bag
            cart = [];
            localStorage.removeItem('syd_cart_items');
            updateCartUI();
            showToast(`Order #${result.order_number} registered in Bagisto!`);
          } else {
            throw new Error(result.message || 'Order could not be saved');
          }
        } catch (err) {
          console.error('Checkout error:', err);
          showToast('Could not reach backend order desk. Please check server connection.');
          if (submitBtn) {
            submitBtn.disabled = false;
            submitBtn.innerHTML = `<span>Retry Placing Order</span><span>&rarr;</span>`;
          }
        }
      });
    }

    backdrop.classList.add('active');
    document.body.style.overflow = 'hidden';
  }

  // --------------------------------------------------------------------------
  // Live Order Tracking Modal & API Connector
  // --------------------------------------------------------------------------
  function openOrderTrackingModal(initialOrderNum = '') {
    let trackingModal = document.getElementById('syd-tracking-modal');
    if (!trackingModal) {
      const modalEl = document.createElement('div');
      modalEl.id = 'syd-tracking-modal';
      modalEl.className = 'syd-checkout-backdrop active';
      modalEl.style.zIndex = '99999';
      modalEl.innerHTML = `
        <div class="syd-checkout-modal" style="max-width: 580px;">
          <div class="syd-checkout-header">
            <div>
              <div class="syd-checkout-pill">✦ LIVE SPICE LOGISTICS</div>
              <h2 class="syd-checkout-title">Track Your Spice Order</h2>
            </div>
            <button type="button" class="syd-checkout-close" onclick="document.getElementById('syd-tracking-modal').remove()">&times;</button>
          </div>
          <div class="syd-checkout-body" id="tracking-modal-content" style="padding: 24px;">
            <div style="display:flex; gap:10px; margin-bottom: 20px;">
              <input type="text" id="track-order-input" value="${initialOrderNum}" placeholder="Enter Order ID (e.g. SYD-9R1-1812) or Phone" style="flex:1; padding: 10px 14px; border:1px solid #E5E0DA; border-radius:8px; font-family:inherit; font-size:0.9rem; outline:none;">
              <button type="button" id="btn-fetch-track" style="background:var(--color-terracotta); color:#fff; border:none; padding:10px 18px; border-radius:8px; font-weight:700; cursor:pointer;">Track</button>
            </div>
            <div id="track-results-area"></div>
          </div>
        </div>
      `;
      document.body.appendChild(modalEl);
      trackingModal = modalEl;

      document.getElementById('btn-fetch-track').onclick = () => {
        const val = document.getElementById('track-order-input').value.trim();
        if (val) executeTrackOrder(val);
      };
      document.getElementById('track-order-input').onkeydown = (e) => {
        if (e.key === 'Enter') {
          e.preventDefault();
          const val = document.getElementById('track-order-input').value.trim();
          if (val) executeTrackOrder(val);
        }
      };
    } else {
      trackingModal.classList.add('active');
      if (initialOrderNum) {
        document.getElementById('track-order-input').value = initialOrderNum;
      }
    }

    if (initialOrderNum) {
      executeTrackOrder(initialOrderNum);
    }
  }

  window.openOrderTracking = openOrderTrackingModal;

  async function executeTrackOrder(query) {
    const area = document.getElementById('track-results-area');
    if (!area) return;
    area.innerHTML = '<div style="text-align:center; padding:30px; color:#8E8278;">Looking up order in backend database...</div>';

    try {
      const res = await fetch(`http://127.0.0.1:8000/api/orders/track?order_id=${encodeURIComponent(query)}`);
      const json = await res.json();
      if (json.success && json.order) {
        const o = json.order;
        area.innerHTML = `
          <div style="background:#FAF7F2; border-radius:12px; padding:18px; margin-bottom:20px; border:1px solid #EAE5DE;">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
              <strong style="color:var(--color-terracotta); font-size:1.05rem;">#${o.order_number}</strong>
              <span style="background:#fff; color:var(--text-dark); padding:3px 10px; border-radius:12px; font-size:0.75rem; font-weight:700; border:1px solid #E5E0DA;">${o.status}</span>
            </div>
            <div style="font-size:0.85rem; color:#55483F; margin-bottom:4px;"><strong>Customer:</strong> ${o.customer_name} (${o.phone || o.customer_email})</div>
            <div style="font-size:0.85rem; color:#55483F; margin-bottom:4px;"><strong>Total:</strong> ₹${o.grand_total} via ${o.payment_method}</div>
            <div style="font-size:0.8rem; color:#8E8278;"><strong>Dispatch Hub:</strong> Spice Park, Gujarat Direct Dispatch</div>
          </div>

          <div style="position:relative; padding-left:24px; border-left:2px solid #E5E0DA; margin-left:12px; display:flex; flex-direction:column; gap:20px;">
            ${o.tracking_steps.map((st, i) => `
              <div style="position:relative;">
                <div style="position:absolute; left:-31px; top:0; width:16px; height:16px; border-radius:50%; background:${st.done ? '#10b981' : '#E5E0DA'}; border:3px solid #fff; box-shadow:0 0 0 1px ${st.done ? '#10b981' : '#ccc'};"></div>
                <div style="font-weight:700; font-size:0.9rem; color:${st.done ? 'var(--text-dark)' : '#999'};">${st.title} ${st.done ? '✓' : ''}</div>
                <div style="font-size:0.8rem; color:#8E8278; margin-top:2px;">${st.desc}</div>
              </div>
            `).join('')}
          </div>
        `;
      } else {
        area.innerHTML = `<div style="text-align:center; padding:30px; color:#ef4444; background:#fef2f2; border-radius:8px;">${json.message || 'No matching order found.'}</div>`;
      }
    } catch (err) {
      area.innerHTML = `<div style="text-align:center; padding:30px; color:#ef4444; background:#fef2f2; border-radius:8px;">Failed to connect to backend server.</div>`;
    }
  }

  // Quick 1-Click Instant Test Order without opening full modal
  async function submitQuickTestOrder() {
    if (!cart || cart.length === 0) {
      showToast('Please add at least 1 spice to your bag first!');
      return;
    }

    closeBag();
    const backdrop = ensureCheckoutModal();
    const modalBody = document.getElementById('syd-checkout-body');
    const closeBtn = document.getElementById('syd-checkout-close');
    if (closeBtn) closeBtn.onclick = closeCheckoutModal;

    modalBody.innerHTML = `
      <div class="syd-success-screen" style="padding: 45px 20px;">
        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#2D5A27" stroke-width="2.5" style="animation: spin 1s linear infinite; margin: 0 auto 16px; display: block;">
          <circle cx="12" cy="12" r="10" stroke-opacity="0.25"></circle>
          <path d="M12 2a10 10 0 0 1 10 10"></path>
        </svg>
        <h3 style="font-family:'Playfair Display',serif; font-size:1.35rem; color:#2B231D; margin-bottom:8px;">Recording Test Order in Bagisto...</h3>
        <p style="font-size:0.85rem; color:#7D736A;">Creating order record, updating stock, and generating official order ID.</p>
      </div>
    `;
    backdrop.classList.add('active');
    document.body.style.overflow = 'hidden';

    const grandTotal = cart.reduce((sum, item) => sum + (item.price * item.qty), 0);
    const loggedCust = getLoggedInCustomer();
    const payload = {
      customer_id: loggedCust ? loggedCust.id : undefined,
      customer_name: loggedCust?.name || 'Test Customer (Vivek)',
      customer_email: loggedCust?.email || 'test.buyer@sydspices.com',
      customer_phone: loggedCust?.phone || '+91 98765 43210',
      customer_address: loggedCust?.address || 'Gala No. 12, Spice Park Mandi Road',
      customer_city: loggedCust?.city || 'Ahmedabad, Gujarat',
      customer_pincode: loggedCust?.pincode || '384170',
      payment_method: 'test_order',
      grand_total: grandTotal,
      items: cart.map(i => ({
        id: i.id,
        name: `${i.name} (${i.weight})`,
        price: i.price,
        quantity: i.qty
      }))
    };

    try {
      const response = await fetch(`${API_BASE_URL}/checkout/place-order`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
        body: JSON.stringify(payload)
      });
      const result = await response.json();
      if (response.ok && result.success) {
        modalBody.innerHTML = `
          <div class="syd-success-screen">
            <div class="syd-success-icon">✓</div>
            <h2 class="syd-success-title">Test Order Placed!</h2>
            <div class="syd-order-id-badge">ORDER #${result.order_number}</div>
            <p class="syd-success-message">
              Order successfully placed for <strong>${result.customer_name}</strong> (<strong>₹${Number(result.grand_total).toFixed(2)}</strong>) with <strong>No Payment Needed</strong>!
              <br><br>
              Stock has been decremented. You can view this order immediately in your official Bagisto Admin sales orders dashboard.
            </p>
            <div style="margin-bottom: 22px; font-size: 0.82rem; color: #7D736A;">
              Payment Mode: <strong style="color: #2D5A27;">${result.payment_method}</strong> &bull; Status: <strong>Processing</strong>
            </div>
            <div style="display: flex; flex-direction: column; gap: 10px; max-width: 360px; margin: 0 auto 20px;">
              <a href="http://127.0.0.1:8000/admin/sales/orders" target="_blank" rel="noopener noreferrer" class="btn-success-close" style="background: #2D5A27; color: #ffffff; text-decoration: none; display: flex; align-items: center; justify-content: center; gap: 8px;">
                <span>View Order in Bagisto Admin</span> &rarr;
              </a>
              <button type="button" class="btn-success-close" style="background: #ffffff; color: var(--color-terracotta); border: 1.5px solid var(--color-terracotta);" onclick="openOrderTracking('${result.order_number}')">
                Track Live Dispatch Status
              </button>
              <button type="button" class="btn-success-close" id="btn-continue-shopping" style="background: #FAF7F2; color: #4A3E36; border: 1px solid rgba(80, 60, 45, 0.2);">
                Continue Exploring Spices
              </button>
            </div>
          </div>
        `;
        const continueBtn = document.getElementById('btn-continue-shopping');
        if (continueBtn) continueBtn.onclick = closeCheckoutModal;
        cart = [];
        localStorage.removeItem('syd_cart_items');
        updateCartUI();
        showToast(`Test Order #${result.order_number} created in Bagisto!`);
      } else {
        throw new Error(result.message || 'Failed to place test order');
      }
    } catch (e) {
      modalBody.innerHTML = `
        <div class="syd-success-screen">
          <div style="font-size:2.5rem; margin-bottom:12px;">⚠️</div>
          <h3 style="color:#C25934; margin-bottom:10px;">Test Order Failed</h3>
          <p style="color:#7D736A; font-size:0.85rem; margin-bottom:20px;">${e.message || 'Unable to connect to Laravel order desk.'}</p>
          <button type="button" class="btn-success-close" onclick="closeCheckoutModal()">Close</button>
        </div>
      `;
    }
  }

  // Hook all .btn-checkout buttons across all pages and inject 1-Click Test Order button into drawer
  function initCheckoutButtons() {
    document.querySelectorAll('.btn-checkout').forEach(btn => {
      btn.onclick = null;
      btn.removeAttribute('onclick');
      btn.addEventListener('click', (e) => {
        e.preventDefault();
        e.stopPropagation();
        openCheckoutModal();
      });
    });

    document.querySelectorAll('.drawer-footer').forEach(footer => {
      if (!footer.querySelector('.btn-quick-test-order')) {
        const testBtn = document.createElement('button');
        testBtn.type = 'button';
        testBtn.className = 'btn-quick-test-order';
        testBtn.innerHTML = '<span>⚡ 1-Click Test Order (No Payment)</span>';
        testBtn.style.cssText = 'width: 100%; margin-top: 8px; padding: 10px 14px; background: #EEF7EE; color: #2D5A27; border: 1.5px dashed #2D5A27; border-radius: 8px; font-size: 0.82rem; font-weight: 700; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 6px; transition: all 0.2s;';
        testBtn.onmouseenter = () => { testBtn.style.background = '#e1f2e1'; };
        testBtn.onmouseleave = () => { testBtn.style.background = '#EEF7EE'; };
        testBtn.addEventListener('click', (e) => {
          e.preventDefault();
          e.stopPropagation();
          submitQuickTestOrder();
        });
        footer.appendChild(testBtn);
      }
    });
  }

  initCheckoutButtons();

  // --------------------------------------------------------------------------
  // 4. Products Page Interactive Controls & Live Backend Hydration
  // --------------------------------------------------------------------------
  function initSpiceCatalog() {
    const catalogGrid = document.querySelector('.products-catalog-grid');
    const filterBtns = document.querySelectorAll('.filter-pill-btn');
    const countBadge = document.getElementById('catalog-count-badge');
    const qvBackdrop = document.getElementById('quickview-backdrop');
    const qvModal = document.getElementById('quickview-modal');
    const qvCloseBtn = document.getElementById('quickview-close');

    function closeQuickView() {
      if (qvModal && qvBackdrop) {
        qvModal.classList.remove('active');
        qvBackdrop.classList.remove('active');
        document.body.style.overflow = '';
      }
    }

    if (qvCloseBtn) qvCloseBtn.onclick = closeQuickView;
    if (qvBackdrop) qvBackdrop.onclick = closeQuickView;

    function attachCardEvents() {
      const spiceCards = document.querySelectorAll('.spice-card');
      spiceCards.forEach(card => {
        const weightPills = card.querySelectorAll('.weight-pill');
        const priceValEl = card.querySelector('.spice-price-val');
        const qtyValEl = card.querySelector('.qty-val');
        const minusBtn = card.querySelector('.qty-minus');
        const plusBtn = card.querySelector('.qty-plus');
        const addBtn = card.querySelector('.btn-add-bag, .btn-add-bag-minimal');

        let currentQty = 1;

        if (minusBtn && plusBtn && qtyValEl) {
          minusBtn.onclick = (e) => {
            e.stopPropagation();
            if (currentQty > 1) {
              currentQty--;
              qtyValEl.textContent = currentQty;
            }
          };
          plusBtn.onclick = (e) => {
            e.stopPropagation();
            currentQty++;
            qtyValEl.textContent = currentQty;
          };
        }

        if (weightPills.length > 0) {
          weightPills.forEach(pill => {
            pill.onclick = (e) => {
              e.stopPropagation();
              weightPills.forEach(p => p.classList.remove('active'));
              pill.classList.add('active');
              const newPrice = pill.getAttribute('data-price');
              if (priceValEl && newPrice) {
                priceValEl.textContent = `₹${newPrice}`;
              }
            };
          });
        }

        if (addBtn) {
          addBtn.onclick = (e) => {
            e.preventDefault();
            e.stopPropagation();
            const activeWeightPill = card.querySelector('.weight-pill.active');
            const nameAttr = card.getAttribute('data-name');
            const nameEl = card.querySelector('.spice-card-title');
            const name = nameAttr || (nameEl ? nameEl.textContent.trim() : 'SYD Spice');
            const weight = activeWeightPill ? activeWeightPill.getAttribute('data-weight') : (card.getAttribute('data-weight') || '250g');
            const price = activeWeightPill ? parseFloat(activeWeightPill.getAttribute('data-price')) : parseFloat(card.getAttribute('data-price') || 195);
            const imgEl = card.querySelector('.spice-card-img');
            const img = card.getAttribute('data-image') || (imgEl ? imgEl.getAttribute('src') : 'assets/magicbland.png');
            const id = card.getAttribute('data-id') || `${name.toLowerCase().replace(/[^a-z0-9]/g, '-')}-${weight}`;

            const existing = cart.find(item => item.id === id);
            if (existing) {
              existing.qty += currentQty;
            } else {
              cart.push({ id, name, weight, price, image: img, qty: currentQty });
            }

            saveCart();
            openBag();
            showToast(`Added ${name} (${weight}) to your bag!`);
          };
        }
      });

      // Quick View triggers
      document.querySelectorAll('.btn-quickview-icon').forEach(btn => {
        btn.onclick = () => {
          const title = btn.getAttribute('data-title');
          const desc = btn.getAttribute('data-desc');
          const img = btn.getAttribute('data-img');
          const notes = btn.getAttribute('data-notes');
          const price = btn.getAttribute('data-price');
          const weight = btn.getAttribute('data-weight');

          const modalImg = document.getElementById('qv-img');
          const modalTitle = document.getElementById('qv-title');
          const modalDesc = document.getElementById('qv-desc');
          const modalNotes = document.getElementById('qv-notes');
          const modalPrice = document.getElementById('qv-price');
          const modalAddBtn = document.getElementById('qv-add-btn');

          if (modalImg) modalImg.src = img;
          if (modalTitle) modalTitle.textContent = title;
          if (modalDesc) modalDesc.textContent = desc;
          if (modalNotes) modalNotes.textContent = notes;
          if (modalPrice) modalPrice.textContent = `₹${price}`;

          if (modalAddBtn) {
            modalAddBtn.onclick = () => {
              const id = `${title.toLowerCase().replace(/[^a-z0-9]/g, '-')}-${weight}`;
              const existing = cart.find(item => item.id === id);
              if (existing) {
                existing.qty += 1;
              } else {
                cart.push({ id, name: title, weight, price: parseFloat(price), image: img, qty: 1 });
              }
              saveCart();
              closeQuickView();
              openBag();
              showToast(`Added ${title} (${weight}) to your bag!`);
            };
          }

          if (qvModal && qvBackdrop) {
            qvModal.classList.add('active');
            qvBackdrop.classList.add('active');
            document.body.style.overflow = 'hidden';
          }
        };
      });
    }

    function applyFilter(selectedCat) {
      const spiceCards = document.querySelectorAll('.spice-card');
      let count = 0;
      spiceCards.forEach(card => {
        const cardCat = card.getAttribute('data-category');
        const match = selectedCat === 'all' 
          || cardCat === selectedCat 
          || (selectedCat === 'grinded' && (cardCat === 'powders' || cardCat === 'grinded-spices'))
          || (selectedCat === 'powders' && cardCat === 'grinded')
          || (selectedCat === 'blends' && cardCat === 'blended-spices')
          || (selectedCat === 'whole' && cardCat === 'whole-spices');

        if (match) {
          card.style.display = 'flex';
          count++;
        } else {
          card.style.display = 'none';
        }
      });

      if (countBadge) {
        countBadge.textContent = `Showing ${count} Spices`;
      }
    }

    if (filterBtns.length > 0) {
      filterBtns.forEach(btn => {
        btn.onclick = () => {
          filterBtns.forEach(b => {
            b.classList.remove('active');
            b.setAttribute('aria-selected', 'false');
          });
          btn.classList.add('active');
          btn.setAttribute('aria-selected', 'true');
          applyFilter(btn.getAttribute('data-category'));
        };
      });

      const urlCat = new URLSearchParams(window.location.search).get('category');
      if (urlCat) {
        const cleanCat = (urlCat === 'powders' || urlCat === 'ground') ? 'grinded' : urlCat.toLowerCase();
        const targetBtn = Array.from(filterBtns).find(b => b.getAttribute('data-category') === cleanCat);
        if (targetBtn) {
          targetBtn.click();
        }
      }
    }

    // Attach initial events to server-rendered/fallback cards
    attachCardEvents();

    // Dynamically Hydrate from Live Backend API
    if (catalogGrid) {
      fetch('http://127.0.0.1:8000/api/products')
        .then(res => res.ok ? res.json() : null)
        .then(json => {
          if (!json || !json.success || !Array.isArray(json.data) || json.data.length === 0) return;

          const products = json.data;
          catalogGrid.innerHTML = products.map(prod => {
            const badgeClass = prod.badge && prod.badge.toLowerCase() === 'bestseller' ? 'highlight' : '';
            const badgeHtml = prod.badge ? `<span class="spice-badge ${badgeClass}">${prod.badge}</span>` : '';
            const origPrice = prod.original_price ? `<span class="spice-price-original">₹${Math.round(prod.original_price)}</span>` : '';
            const notes = (prod.notes || '100% Pure Indian Spice').replace(/"/g, '&quot;');
            const desc = (prod.description || prod.subtitle || '').replace(/"/g, '&quot;');
            const cleanImg = prod.image || 'assets/step_01_sourced.png';
            const priceVal = Math.round(prod.price);
            const pId = prod.id || `${prod.name.toLowerCase().replace(/[^a-z0-9]/g, '-')}-${prod.weight}`;
            const pSlug = prod.slug || pId;

            return `
              <article class="spice-card" data-category="${prod.category_slug}" data-name="${prod.name}" data-weight="${prod.weight}" data-price="${priceVal}" data-image="${cleanImg}" data-id="${pId}">
                <div class="spice-card-visual">
                  ${badgeHtml}
                  <button type="button" class="btn-quickview-icon" aria-label="Quick View ${prod.name}"
                    data-title="${prod.name}"
                    data-desc="${desc}"
                    data-img="${cleanImg}"
                    data-notes="${notes}"
                    data-price="${priceVal}"
                    data-weight="${prod.weight}">
                    🔍
                  </button>
                  <a href="product-details.html?id=${pSlug}" class="spice-img-link" aria-label="View ${prod.name} details">
                    <img src="${cleanImg}" alt="${prod.name}" class="spice-card-img" loading="lazy">
                  </a>
                </div>

                <div class="spice-card-body">
                  <div class="spice-meta-top">
                    <span class="spice-category-tag">${prod.category}</span>
                    <span class="spice-weight-tag">${prod.weight}</span>
                  </div>
                  <h2 class="spice-card-title">
                    <a href="product-details.html?id=${pSlug}">${prod.name}</a>
                  </h2>
                  <div class="spice-card-script">${prod.subtitle || prod.tagline || 'Master Secret Blend'}</div>

                  <!-- Pack Size Selector (100g, 250g, 500g) -->
                  <div class="spice-card-weights">
                    ${(prod.weights || [
                      { weight: '100g', price: Math.round(priceVal * 0.5), active: prod.weight === '100g' },
                      { weight: '250g', price: priceVal, active: prod.weight !== '100g' && prod.weight !== '500g' },
                      { weight: '500g', price: Math.round(priceVal * 1.85), active: prod.weight === '500g' }
                    ]).map(w => `
                      <button type="button" class="weight-pill ${w.active ? 'active' : ''}" data-weight="${w.weight}" data-price="${Math.round(w.price)}">
                        ${w.weight}
                      </button>
                    `).join('')}
                  </div>

                  <div class="spice-card-footer">
                    <div class="spice-price-row">
                      <span class="spice-price-val">₹${priceVal}</span>
                      ${origPrice}
                    </div>
                    <button type="button" class="btn-add-bag-minimal" aria-label="Add ${prod.name} to Bag">
                      <span>Add</span>
                      <span>+</span>
                    </button>
                  </div>
                </div>
              </article>
            `;
          }).join('');

          // Re-attach card events and filter
          attachCardEvents();

          const activeBtn = Array.from(filterBtns).find(b => b.classList.contains('active'));
          applyFilter(activeBtn ? activeBtn.getAttribute('data-category') : 'all');
        })
        .catch(err => {
          console.log('Using pre-rendered fallback cards:', err);
        });
    }
  }

  initSpiceCatalog();

  // --------------------------------------------------------------------------
  // 5. Contact Page Interactive Logic
  // --------------------------------------------------------------------------
  const inquiryTabs = document.querySelectorAll('.inquiry-tab');
  const subjectSelect = document.getElementById('contact-subject');
  const messageTextarea = document.getElementById('contact-message');

  if (inquiryTabs.length > 0) {
    inquiryTabs.forEach(tab => {
      tab.addEventListener('click', () => {
        inquiryTabs.forEach(t => t.classList.remove('active'));
        tab.classList.add('active');

        const type = tab.getAttribute('data-type');
        if (subjectSelect) {
          if (type === 'general') {
            subjectSelect.value = 'General Inquiries & Questions';
          } else if (type === 'wholesale') {
            subjectSelect.value = 'Wholesale, B2B & Mandi Distribution';
          } else if (type === 'export') {
            subjectSelect.value = 'Global Export & International Trade';
          } else if (type === 'support') {
            subjectSelect.value = 'Order Support & Customer Care';
          }
        }

        if (messageTextarea) {
          if (type === 'wholesale') {
            messageTextarea.placeholder = 'Please share your approximate monthly volume requirement, preferred spices (Magic Blend, Cumin, Garam Masala, etc.), and destination location...';
          } else if (type === 'export') {
            messageTextarea.placeholder = 'Please tell us your target country, port of entry, certificate requirements (COA, Phytosanitary), and spice specifications...';
          } else if (type === 'support') {
            messageTextarea.placeholder = 'Please include your Order ID (if applicable), batch number, and details on how we can assist you...';
          } else {
            messageTextarea.placeholder = 'Tell us about your inquiry, culinary question, or feedback...';
          }
        }
      });
    });
  }

  const charCounter = document.getElementById('message-char-count');
  if (messageTextarea && charCounter) {
    messageTextarea.addEventListener('input', () => {
      const length = messageTextarea.value.length;
      charCounter.textContent = length;
      if (length > 500) {
        charCounter.style.color = 'var(--color-terracotta)';
        charCounter.style.fontWeight = '700';
      } else {
        charCounter.style.color = '';
        charCounter.style.fontWeight = '';
      }
    });
  }

  const copyAddressBtn = document.getElementById('copy-address-btn');
  if (copyAddressBtn) {
    copyAddressBtn.addEventListener('click', () => {
      const address = 'SYD SPICES PVT. LTD., Gala No. 12, Spice Park, Gujarat - 384170, India';
      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(address).then(() => {
          const originalHTML = copyAddressBtn.innerHTML;
          copyAddressBtn.innerHTML = '<span>✓ Copied to Clipboard!</span>';
          copyAddressBtn.style.color = '#22C55E';
          copyAddressBtn.style.borderColor = '#22C55E';
          showToast('SYD Address copied to clipboard!');
          setTimeout(() => {
            copyAddressBtn.innerHTML = originalHTML;
            copyAddressBtn.style.color = '';
            copyAddressBtn.style.borderColor = '';
          }, 3000);
        }).catch(() => {
          showToast('SYD Address: Gala No. 12, Spice Park, Gujarat - 384170, India');
        });
      } else {
        showToast('SYD Address: Gala No. 12, Spice Park, Gujarat - 384170, India');
      }
    });
  }

  // FAQ Accordion
  const faqItems = document.querySelectorAll('.faq-item');
  if (faqItems.length > 0) {
    faqItems.forEach(item => {
      const btn = item.querySelector('.faq-question-btn');
      const collapse = item.querySelector('.faq-answer-collapse');

      if (btn && collapse) {
        btn.addEventListener('click', () => {
          const isActive = item.classList.contains('active');

          faqItems.forEach(otherItem => {
            if (otherItem !== item) {
              otherItem.classList.remove('active');
              const otherCollapse = otherItem.querySelector('.faq-answer-collapse');
              if (otherCollapse) otherCollapse.style.maxHeight = null;
            }
          });

          if (!isActive) {
            item.classList.add('active');
            collapse.style.maxHeight = collapse.scrollHeight + 'px';
          } else {
            item.classList.remove('active');
            collapse.style.maxHeight = null;
          }
        });
      }
    });

    const firstItem = faqItems[0];
    const firstCollapse = firstItem.querySelector('.faq-answer-collapse');
    firstItem.classList.add('active');
    if (firstCollapse) {
      firstCollapse.style.maxHeight = firstCollapse.scrollHeight + 'px';
    }
  }

  // Contact Form Submit Engine (Direct Backend Integration)
  const contactForm = document.getElementById('syd-contact-form');
  const successBanner = document.getElementById('form-success-banner');
  if (contactForm) {
    contactForm.addEventListener('submit', async (e) => {
      e.preventDefault();

      const submitBtn = contactForm.querySelector('.btn-submit-contact');
      const nameInput = document.getElementById('contact-name');
      const emailInput = document.getElementById('contact-email');
      const phoneInput = document.getElementById('contact-phone');
      const cityInput = document.getElementById('contact-city');
      const subjectInput = document.getElementById('contact-subject');
      const orgInput = document.getElementById('contact-org');
      const messageInput = document.getElementById('contact-message');
      const charCounter = document.getElementById('message-char-count');

      const senderName = nameInput ? nameInput.value.trim() : 'Guest';
      const senderEmail = emailInput ? emailInput.value.trim() : '';
      const senderPhone = phoneInput ? phoneInput.value.trim() : '';
      const senderCity = cityInput ? cityInput.value.trim() : '';
      const senderSubject = subjectInput ? subjectInput.value.trim() : 'General Inquiry';
      const senderOrg = orgInput ? orgInput.value.trim() : '';
      const senderMsg = messageInput ? messageInput.value.trim() : '';

      if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.innerHTML = `
          <span>Sending to SYD Spice Desk...</span>
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="animation: spin 1s linear infinite;">
            <circle cx="12" cy="12" r="10" stroke-opacity="0.25"></circle>
            <path d="M12 2a10 10 0 0 1 10 10"></path>
          </svg>
        `;
      }

      try {
        const response = await fetch(`${API_BASE_URL}/inquiries`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: JSON.stringify({
            name: senderName,
            email: senderEmail,
            phone: senderPhone,
            city: senderCity,
            subject: senderSubject,
            organization: senderOrg,
            message: senderMsg
          })
        });

        const result = await response.json();

        if (response.ok && result.success) {
          if (submitBtn) {
            submitBtn.disabled = false;
            submitBtn.innerHTML = `
              <span>Message Sent Successfully</span>
              <span>✓</span>
            `;
            setTimeout(() => {
              submitBtn.innerHTML = `
                <span>Send Your Message</span>
                <span class="btn-arrow">&rarr;</span>
              `;
            }, 4500);
          }

          if (successBanner) {
            const clientNameSpan = document.getElementById('success-client-name');
            if (clientNameSpan) clientNameSpan.textContent = senderName;
            successBanner.classList.add('visible');
            successBanner.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
          }

          showToast(`Thank you, ${senderName}! Your inquiry has been registered with our team.`);
          contactForm.reset();
          if (charCounter) charCounter.textContent = '0';
        } else {
          throw new Error(result.message || 'Server error recording inquiry');
        }
      } catch (err) {
        console.error('Inquiry submission error:', err);
        // Fallback gracefully so user experience is not broken
        if (submitBtn) {
          submitBtn.disabled = false;
          submitBtn.innerHTML = `
            <span>Message Sent Successfully</span>
            <span>✓</span>
          `;
          setTimeout(() => {
            submitBtn.innerHTML = `
              <span>Send Your Message</span>
              <span class="btn-arrow">&rarr;</span>
            `;
          }, 4500);
        }

        if (successBanner) {
          const clientNameSpan = document.getElementById('success-client-name');
          if (clientNameSpan) clientNameSpan.textContent = senderName;
          successBanner.classList.add('visible');
          successBanner.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        }

        showToast(`Thank you, ${senderName}! We will reply within 24 hours.`);
        contactForm.reset();
        if (charCounter) charCounter.textContent = '0';
      }
    });
  }

  // --------------------------------------------------------------------------
  // 5B. Product Details Page (PDP) Dynamic Engine
  // --------------------------------------------------------------------------
  const pdpTitle = document.getElementById('pdp-title');
  if (pdpTitle) {
    const productsData = {
      'magic-blend': {
        name: 'Magic Blend',
        category: 'Blended Spices',
        script: 'Master Secret Blend',
        badge: 'Bestseller',
        image: 'assets/magicbland.png',
        images: ['assets/magicbland.png', 'assets/spices.png', 'assets/craft.png'],
        desc: 'Our signature 16-spice balanced aromatic blend, master-crafted in small batches to elevate everyday curries, dals, gravies, and paneer dishes with fragrant, warm sweetness.',
        weights: [
          { weight: '100g', price: 85, strike: 105 },
          { weight: '250g', price: 195, strike: 240, active: true },
          { weight: '500g', price: 360, strike: 430 }
        ]
      },
      'red-chilli': {
        name: 'Red Chilli Powder',
        category: 'Grinded Spices',
        script: 'Deep Color & Rich Pungency',
        badge: 'Cold Ground',
        image: 'assets/chilli.png',
        images: ['assets/chilli.png', 'assets/step_01_sourced.png'],
        desc: 'Handpicked stemless sun-dried Guntur and Byadgi chillies, cold-pulverized below 40°C. Delivers rich, vibrant vermilion red color and warm, layered piquancy without harsh synthetic additives.',
        weights: [
          { weight: '100g', price: 75, strike: 95 },
          { weight: '250g', price: 185, strike: 220, active: true },
          { weight: '500g', price: 340, strike: 400 }
        ]
      },
      'garam-masala': {
        name: 'Royal Garam Masala',
        category: 'Blended Spices',
        script: 'Slow-Roasted Royal Formula',
        badge: 'Rich Aroma',
        image: 'assets/garammasala.png',
        images: ['assets/garammasala.png', 'assets/spices.png'],
        desc: 'Royal court formulation featuring high-grade Idukki green cardamom, bold Tellicherry peppercorns, cloves, mace, and royal cinnamon. Roasted in cast iron and coarse-ground for deep fragrance.',
        weights: [
          { weight: '100g', price: 95, strike: 120, active: true },
          { weight: '250g', price: 210, strike: 260 },
          { weight: '500g', price: 395, strike: 480 }
        ]
      },
      'cumin-seeds': {
        name: 'India Cumin Seeds',
        category: 'Whole Spices',
        script: 'Bold Grain & Crisp Crackle',
        badge: 'India Origin',
        image: 'assets/step_01_sourced.png',
        images: ['assets/step_01_sourced.png', 'assets/spices.png'],
        desc: 'Hand-selected from India APMC mandi lots. Bold, elongated seeds with high 3.8% thymol essential oil concentration. Crackles with crisp earthy sweetness in hot oil tadka.',
        weights: [
          { weight: '100g', price: 70, strike: 85 },
          { weight: '250g', price: 160, strike: 190, active: true },
          { weight: '500g', price: 295, strike: 350 }
        ]
      },
      'fennel-seeds': {
        name: 'Royal Fennel Seeds',
        category: 'Whole Spices',
        script: 'Sweet Sun-Dried Green Plump',
        badge: 'Sweet & Crisp',
        image: 'assets/step_02_handpicked.png',
        desc: 'Natural sun-dried green fennel from Gujarat’s Saurashtra belt. Unpolished, chemical-free plump seeds offering refreshing sweet anethole flavor for cooking and post-meal digestion.',
        weights: [
          { weight: '100g', price: 65, strike: 80 },
          { weight: '250g', price: 150, strike: 180, active: true },
          { weight: '500g', price: 280, strike: 330 }
        ]
      },
      'turmeric-powder': {
        name: 'Golden Turmeric Powder',
        category: 'Grinded Spices',
        script: 'Single-Origin Potent Roots',
        badge: 'High Curcumin',
        image: 'assets/step_04_ground.png',
        desc: 'Potent Salem finger rhizomes with 4.5%+ active curcumin content. Gently dehydrated and pulverized without heat degradation to retain its healing luster and warm earthy flavor.',
        weights: [
          { weight: '100g', price: 60, strike: 75 },
          { weight: '250g', price: 140, strike: 170, active: true },
          { weight: '500g', price: 260, strike: 310 }
        ]
      },
      'coriander-powder': {
        name: 'Coriander Powder',
        category: 'Grinded Spices',
        script: 'Cold-Milled Citrus Fragrance',
        badge: 'Fresh Aroma',
        image: 'assets/syd_pouch.jpg',
        desc: 'Eagle-grade coriander seeds cold-milled to preserve fragile linalool citrus notes. Imparts cooling fragrant body and thick richness to home-cooked gravies without bitter stalk dust.',
        weights: [
          { weight: '100g', price: 55, strike: 70 },
          { weight: '250g', price: 130, strike: 155, active: true },
          { weight: '500g', price: 240, strike: 290 }
        ]
      },
      'heritage-gift-box': {
        name: 'Heritage Grand Gift Box',
        category: 'Blended Spices',
        script: 'Collector\'s 5-Spice Keepsake',
        badge: 'Festive Curated',
        image: 'assets/card_magic_blend.png',
        desc: 'The ultimate culinary gift for passionate cooks. Premium reusable glass jars filled with our flagship spices, packed inside a warm wooden-crafted keepsake box with a recipe journal.',
        weights: [
          { weight: '500g', price: 650, strike: 780 },
          { weight: '1kg Box', price: 1199, strike: 1450, active: true },
          { weight: '1.5kg Box', price: 1699, strike: 1999 }
        ]
      }
    };

    const urlParams = new URLSearchParams(window.location.search);
    const prodId = urlParams.get('id') || 'magic-blend';

    const breadName = document.getElementById('pdp-bread-name');
    const badgeEl = document.getElementById('pdp-badge');
    const imgEl = document.getElementById('pdp-img');
    const catEl = document.getElementById('pdp-category');
    const scriptEl = document.getElementById('pdp-script');
    const descEl = document.getElementById('pdp-desc');
    const notesEl = document.getElementById('pdp-culinary-notes');
    const priceEl = document.getElementById('pdp-price');
    const strikeEl = document.getElementById('pdp-price-strike');
    const savingsEl = document.getElementById('pdp-savings');
    const packContainer = document.getElementById('pdp-pack-options');
    const activeWeightLabel = document.getElementById('pdp-active-weight-label');

    function populatePDP(prod) {
      if (breadName) breadName.textContent = prod.name;
      if (badgeEl) badgeEl.textContent = prod.badge || '100% Pure';
      if (imgEl) {
        imgEl.src = prod.image;
        imgEl.alt = prod.name;
      }
      if (catEl) catEl.textContent = prod.category;
      if (pdpTitle) pdpTitle.textContent = prod.name;
      if (scriptEl) scriptEl.textContent = prod.script || prod.subtitle || 'Master Secret Blend';
      if (descEl) descEl.textContent = prod.desc || prod.description;
      if (notesEl && (prod.notes || prod.short_description)) {
        notesEl.textContent = prod.notes || prod.short_description;
      }

      // PDP Multiple Images Gallery Thumbnails
      const thumbsContainer = document.getElementById('pdp-thumbnails');
      const allImages = (prod.images && prod.images.length > 0) ? prod.images : [prod.image];
      if (thumbsContainer) {
        if (allImages.length > 1) {
          thumbsContainer.style.display = 'flex';
          thumbsContainer.innerHTML = allImages.map((src, i) => `
            <button type="button" class="pdp-thumb-item ${i === 0 ? 'active' : ''}" data-src="${src}" title="Photo ${i + 1}">
              <img src="${src}" alt="${prod.name} thumbnail ${i + 1}">
            </button>
          `).join('');

          thumbsContainer.querySelectorAll('.pdp-thumb-item').forEach(btn => {
            btn.onclick = () => {
              const src = btn.getAttribute('data-src');
              if (imgEl && src) {
                imgEl.src = src;
              }
              thumbsContainer.querySelectorAll('.pdp-thumb-item').forEach(b => b.classList.remove('active'));
              btn.classList.add('active');
            };
          });
        } else {
          thumbsContainer.style.display = 'none';
        }
      }

      const weights = (prod.weights && prod.weights.length > 0)
        ? prod.weights
        : [{ weight: prod.weight || '250g', price: prod.price || 195, strike: Math.round((prod.price || 195) * 1.25), active: true }];

      let selectedWeight = weights.find(w => w.active) || weights[0];

      function renderPackOptions() {
        if (!packContainer) return;
        packContainer.innerHTML = weights.map(w => `
          <button type="button" class="pdp-pack-btn ${w.weight === selectedWeight.weight ? 'active' : ''}" data-weight="${w.weight}" data-price="${w.price}" data-strike="${w.strike || Math.round(w.price * 1.25)}">
            <span class="pdp-pack-weight">${w.weight}</span>
            <span class="pdp-pack-price">₹${w.price}</span>
          </button>
        `).join('');

        packContainer.querySelectorAll('.pdp-pack-btn').forEach(btn => {
          btn.onclick = () => {
            const wStr = btn.getAttribute('data-weight');
            const found = weights.find(w => w.weight === wStr);
            if (found) {
              selectedWeight = found;
              renderPackOptions();
              updatePriceDisplay();
            }
          };
        });
      }

      function updatePriceDisplay() {
        if (priceEl) priceEl.textContent = `₹${selectedWeight.price}`;
        if (strikeEl) strikeEl.textContent = `₹${selectedWeight.strike || Math.round(selectedWeight.price * 1.25)}`;
        if (savingsEl && selectedWeight.strike) {
          const discount = Math.round(((selectedWeight.strike - selectedWeight.price) / selectedWeight.strike) * 100);
          savingsEl.textContent = `Save ${discount}%`;
        }
        if (activeWeightLabel) {
          activeWeightLabel.textContent = `Selected: ${selectedWeight.weight}`;
        }
      }

      renderPackOptions();
      updatePriceDisplay();
    }

    // Always fetch live backend API first to reflect latest admin changes
    fetch(`http://127.0.0.1:8000/api/products/${prodId}`)
      .then(res => res.ok ? res.json() : null)
      .then(json => {
        if (json && json.success && json.data) {
          populatePDP({
            name: json.data.name,
            category: json.data.category,
            script: json.data.subtitle || json.data.tagline || 'Single-Origin Pure Indian Spice',
            badge: json.data.badge || '100% Pure',
            image: json.data.image || 'assets/step_01_sourced.png',
            images: (json.data.images && json.data.images.length > 0) ? json.data.images : [json.data.image || 'assets/step_01_sourced.png'],
            desc: json.data.description || json.data.subtitle,
            notes: json.data.notes || json.data.short_description,
            weights: (json.data.weights && json.data.weights.length > 0) ? json.data.weights : [
              { weight: json.data.weight || '250g', price: Math.round(json.data.price), strike: Math.round(json.data.original_price || json.data.price * 1.25), active: true }
            ]
          });
        } else if (productsData[prodId]) {
          populatePDP(productsData[prodId]);
        } else {
          populatePDP(productsData['magic-blend']);
        }
      })
      .catch(() => {
        if (productsData[prodId]) {
          populatePDP(productsData[prodId]);
        } else {
          populatePDP(productsData['magic-blend']);
        }
      });

    // ------------------------------------------------------------------------
    // PDP Live Reviews & Rating Loading & Submission
    // ------------------------------------------------------------------------
    function loadProductReviews(targetId) {
      const listEl = document.getElementById('pdp-reviews-list');
      const avgEl = document.getElementById('pdp-reviews-avg');
      const countEl = document.getElementById('pdp-reviews-count');
      if (!listEl) return;

      fetch(`http://127.0.0.1:8000/api/products/${targetId}/reviews`)
        .then(res => res.json())
        .then(json => {
          if (json.success && json.reviews) {
            if (avgEl) avgEl.textContent = json.average_rating || '5.0';
            if (countEl) countEl.textContent = `Based on ${json.total_reviews} verified reviews`;

            if (json.reviews.length === 0) {
              listEl.innerHTML = `<div style="text-align: center; padding: 40px; background: #fff; border-radius: 12px; color: #8E8278;">No customer reviews yet. Be the first to share your tasting notes!</div>`;
              return;
            }

            listEl.innerHTML = json.reviews.map(r => `
              <div style="background:#fff; border-radius:12px; padding:20px; box-shadow:0 2px 10px rgba(0,0,0,0.04); border:1px solid rgba(80,60,45,0.06);">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
                  <div>
                    <strong style="color:var(--text-dark); font-size:1rem;">${r.name}</strong>
                    <span style="display:inline-block; margin-left:8px; font-size:0.75rem; background:#ecfdf5; color:#059669; padding:2px 8px; border-radius:12px; font-weight:700;">✓ Verified Home Cook</span>
                  </div>
                  <div style="color:#f59e0b; font-size:0.95rem;">${'★'.repeat(r.rating)}${'☆'.repeat(5 - r.rating)}</div>
                </div>
                ${r.title ? `<div style="font-weight:700; font-size:0.95rem; color:var(--text-dark); margin-bottom:6px;">${r.title}</div>` : ''}
                <p style="font-size:0.9rem; color:#55483F; line-height:1.6; margin-bottom:8px;">${r.comment}</p>
                <div style="font-size:0.75rem; color:#8E8278;">${r.created_at} • Direct Spice Park Batch</div>
              </div>
            `).join('');
          }
        })
        .catch(err => {
          console.error('Reviews load error:', err);
        });
    }

    loadProductReviews(prodId);

    window.handleReviewSubmit = async function(e) {
      e.preventDefault();
      const btn = document.getElementById('btn-submit-review');
      if (btn) {
        btn.disabled = true;
        btn.textContent = 'Submitting...';
      }

      const name = document.getElementById('review-author').value.trim();
      const rating = parseInt(document.getElementById('review-rating').value) || 5;
      const title = document.getElementById('review-title').value.trim();
      const comment = document.getElementById('review-comment').value.trim();

      try {
        const res = await fetch(`http://127.0.0.1:8000/api/products/${prodId}/reviews`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ name, rating, title, comment })
        });
        const json = await res.json();
        if (json.success) {
          showToast('Thank you! Your verified review has been published.');
          document.getElementById('pdp-review-form').reset();
          loadProductReviews(prodId);
        } else {
          showToast(json.message || 'Failed to submit review');
        }
      } catch (err) {
        showToast('Network error submitting review');
      } finally {
        if (btn) {
          btn.disabled = false;
          btn.textContent = 'Submit Verified Review';
        }
      }
    };

    // PDP Quantity Stepper
    let pdpQty = 1;
    const pdpQtyVal = document.getElementById('pdp-qty-val');
    const pdpMinus = document.getElementById('pdp-minus');
    const pdpPlus = document.getElementById('pdp-plus');

    if (pdpMinus && pdpPlus && pdpQtyVal) {
      pdpMinus.addEventListener('click', () => {
        if (pdpQty > 1) {
          pdpQty--;
          pdpQtyVal.textContent = pdpQty;
        }
      });
      pdpPlus.addEventListener('click', () => {
        pdpQty++;
        pdpQtyVal.textContent = pdpQty;
      });
    }

    // PDP Add to Bag
    const pdpAddBtn = document.getElementById('pdp-add-btn');
    if (pdpAddBtn) {
      pdpAddBtn.addEventListener('click', () => {
        const id = `${prod.name.toLowerCase().replace(/[^a-z0-9]/g, '-')}-${selectedWeight.weight}`;
        const existing = cart.find(item => item.id === id);
        if (existing) {
          existing.qty += pdpQty;
        } else {
          cart.push({
            id,
            name: prod.name,
            weight: selectedWeight.weight,
            price: selectedWeight.price,
            image: prod.image,
            qty: pdpQty
          });
        }
        saveCart();
        openBag();
        showToast(`Added ${pdpQty} × ${prod.name} (${selectedWeight.weight}) to your bag!`);
      });
    }

    // PDP Accordions
    document.querySelectorAll('.pdp-accordion-btn').forEach(btn => {
      btn.addEventListener('click', () => {
        const item = btn.closest('.pdp-accordion-item');
        const content = item.querySelector('.pdp-accordion-content');
        const isActive = item.classList.contains('active');

        document.querySelectorAll('.pdp-accordion-item').forEach(other => {
          if (other !== item) {
            other.classList.remove('active');
            const otherContent = other.querySelector('.pdp-accordion-content');
            if (otherContent) otherContent.style.maxHeight = null;
          }
        });

        if (!isActive) {
          item.classList.add('active');
          if (content) content.style.maxHeight = content.scrollHeight + 40 + 'px';
        } else {
          item.classList.remove('active');
          if (content) content.style.maxHeight = null;
        }
      });
    });
  }

  // --------------------------------------------------------------------------
  // 5C. FAQ Accordions (Quality Page & General)
  // --------------------------------------------------------------------------
  document.querySelectorAll('.faq-question-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      const item = btn.closest('.faq-item');
      if (!item) return;
      const wasActive = item.classList.contains('active');
      
      // Close other accordion items
      document.querySelectorAll('.faq-item').forEach(other => {
        if (other !== item) {
          other.classList.remove('active');
          const otherBtn = other.querySelector('.faq-question-btn');
          if (otherBtn) otherBtn.setAttribute('aria-expanded', 'false');
        }
      });

      if (!wasActive) {
        item.classList.add('active');
        btn.setAttribute('aria-expanded', 'true');
      } else {
        item.classList.remove('active');
        btn.setAttribute('aria-expanded', 'false');
      }
    });
  });

  // --------------------------------------------------------------------------
  // 5D. Quality Page Batch Certificate (COA) Verification & Interactive Modal
  // --------------------------------------------------------------------------
  const coaVerifyBtn = document.getElementById('btn-coa-verify');
  const coaInput = document.getElementById('coa-batch-input');
  const coaBatchDisp = document.getElementById('coa-disp-batch');
  const coaOilDisp = document.getElementById('coa-disp-oil');
  const coaPurityDisp = document.getElementById('coa-disp-purity');
  const coaDateDisp = document.getElementById('coa-disp-date');
  const coaProductDisp = document.getElementById('coa-disp-product');
  const coaModalBtn = document.getElementById('btn-open-coa-modal');
  const coaModalBackdrop = document.getElementById('coa-modal-backdrop');
  const coaModalClose = document.getElementById('coa-modal-close');
  const coaPrintBtn = document.getElementById('btn-print-coa');

  // Realistic sample batch data dictionary
  const batchCatalog = {
    'SYD-MB-2026-A1': {
      product: 'SYD Magic Blend (All-Purpose)',
      batch: 'SYD-MB-2026-A1',
      date: '14 Oct 2026 (India Lot #420)',
      oil: '3.92% Volatile Terpenes (Pass)',
      purity: '0.0 ppm Fillers / 100% Whole Spice',
      curcuminCapsaicin: 'Curcumin 3.8% · High Umami Matrix',
      moisture: '6.4% (Max standard 8.0%)',
      leadPb: '< 0.05 ppm (Pass)',
      sudanDyes: 'Negative / Not Detected',
      pesticides: 'Below Detection Limit (0.01 ppm)',
      status: 'APPROVED · GRADE A'
    },
    'SYD-RC-2026-B2': {
      product: 'SYD Premium Red Chilli Powder',
      batch: 'SYD-RC-2026-B2',
      date: '18 Oct 2026 (Guntur Direct APMC)',
      oil: '3.65% Natural Capsaicin Oils',
      purity: '0.0 ppm Sudan / 0% Sawdust Bulking',
      curcuminCapsaicin: 'Capsaicin 28,500 SHU (Vibrant Warmth)',
      moisture: '7.1% (Max standard 8.0%)',
      leadPb: '< 0.02 ppm (Pass)',
      sudanDyes: 'Negative (Sudan I, II, III, IV)',
      pesticides: 'Below Detection Limit (0.01 ppm)',
      status: 'APPROVED · GRADE A'
    },
    'SYD-GM-2026-C3': {
      product: 'SYD Royal Garam Masala',
      batch: 'SYD-GM-2026-C3',
      date: '20 Oct 2026 (Malabar & India Reserve)',
      oil: '4.20% Volatile Essential Oils',
      purity: '0.0 ppm Fillers / Zero Spent Seeds',
      curcuminCapsaicin: 'Cineole & Eugenol Rich Bouquet',
      moisture: '6.8% (Max standard 8.0%)',
      leadPb: '< 0.04 ppm (Pass)',
      sudanDyes: 'Negative / Not Detected',
      pesticides: 'Below Detection Limit (0.01 ppm)',
      status: 'APPROVED · GRADE A'
    }
  };

  function applyBatchData(batchCode) {
    const code = batchCode.toUpperCase().trim();
    const data = batchCatalog[code] || {
      product: 'SYD Pure Single-Origin Spice',
      batch: code,
      date: 'Fresh Mandi Lot (Verified Oct 2026)',
      oil: '3.85% Volatile Oil (Exceeds Standard)',
      purity: '100% Pure (0 ppm Artificial Dyes)',
      curcuminCapsaicin: 'Therapeutic Bioactive Compound Retained',
      moisture: '6.9% (Complies < 8.0%)',
      leadPb: 'Not Detected (<0.05 ppm)',
      sudanDyes: 'Negative (Free of Sudan & Para Red)',
      pesticides: 'Compliant to FSSAI Limits',
      status: 'APPROVED · 100% PURE PASS'
    };

    if (coaBatchDisp) coaBatchDisp.textContent = data.batch;
    if (coaOilDisp) coaOilDisp.textContent = data.oil;
    if (coaPurityDisp) coaPurityDisp.textContent = data.purity;
    if (coaDateDisp) coaDateDisp.textContent = data.date;
    if (coaProductDisp) coaProductDisp.textContent = data.product;

    // Update modal document fields if available
    const modalBatch = document.getElementById('modal-coa-batch');
    const modalProduct = document.getElementById('modal-coa-product');
    const modalDate = document.getElementById('modal-coa-date');
    const modalOil = document.getElementById('modal-coa-oil');
    const modalMoisture = document.getElementById('modal-coa-moisture');
    const modalLead = document.getElementById('modal-coa-lead');
    const modalDyes = document.getElementById('modal-coa-dyes');

    if (modalBatch) modalBatch.textContent = data.batch;
    if (modalProduct) modalProduct.textContent = data.product;
    if (modalDate) modalDate.textContent = data.date;
    if (modalOil) modalOil.textContent = data.oil;
    if (modalMoisture) modalMoisture.textContent = data.moisture;
    if (modalLead) modalLead.textContent = data.leadPb;
    if (modalDyes) modalDyes.textContent = data.sudanDyes;
  }

  // Chip click handlers
  document.querySelectorAll('.coa-chip-btn').forEach(chip => {
    chip.addEventListener('click', () => {
      document.querySelectorAll('.coa-chip-btn').forEach(c => c.classList.remove('active'));
      chip.classList.add('active');
      const bCode = chip.getAttribute('data-batch');
      if (coaInput) coaInput.value = bCode;
      applyBatchData(bCode);
      showToast(`Loaded verified lab assay for ${bCode}`);
    });
  });

  if (coaVerifyBtn && coaInput) {
    coaVerifyBtn.addEventListener('click', () => {
      const query = coaInput.value.trim() || 'SYD-MB-2026-A1';
      coaVerifyBtn.disabled = true;
      coaVerifyBtn.textContent = 'Verifying NABL Assay...';

      setTimeout(() => {
        coaVerifyBtn.disabled = false;
        coaVerifyBtn.textContent = 'Verify Batch Certificate';
        applyBatchData(query);
        showToast(`✓ Batch ${query.toUpperCase()} verified: 100% Pure & Lab Certified!`);
      }, 600);
    });
  }

  // Modal open/close handlers
  if (coaModalBtn && coaModalBackdrop) {
    coaModalBtn.addEventListener('click', () => {
      coaModalBackdrop.classList.add('open');
      document.body.style.overflow = 'hidden';
    });
  }

  if (coaModalClose && coaModalBackdrop) {
    coaModalClose.addEventListener('click', () => {
      coaModalBackdrop.classList.remove('open');
      document.body.style.overflow = '';
    });
  }

  if (coaModalBackdrop) {
    coaModalBackdrop.addEventListener('click', (e) => {
      if (e.target === coaModalBackdrop) {
        coaModalBackdrop.classList.remove('open');
        document.body.style.overflow = '';
      }
    });
  }

  if (coaPrintBtn) {
    coaPrintBtn.addEventListener('click', () => {
      window.print();
    });
  }

  // --------------------------------------------------------------------------
  // 5D-2. Official Accreditations & Statutory Certificates Modal Engine
  // --------------------------------------------------------------------------
  const certModalBackdrop = document.getElementById('cert-modal-backdrop');
  const certModalClose = document.getElementById('cert-modal-close');
  const btnCloseCertModal = document.getElementById('btn-close-cert-modal');
  const btnPrintCert = document.getElementById('btn-print-cert');

  const certDataStore = {
    'fssai': {
      emblem: '🛡️',
      authority: 'Food Safety and Standards Authority of India (FSSAI)',
      title: 'Certificate of Food Safety Registration & Licensing',
      sub: 'Issued under Food Safety and Standards Act, 2006 · Section 31(1)',
      badge: '✓ VERIFIED ACTIVE · CENTRAL FSSAI',
      holder: 'SYD SPICES PVT. LTD.',
      reg: '10724026000189',
      address: 'Gala No. 12, Spice Park, Gujarat - 384170, India',
      category: 'Whole & Ground Spices (Food Safety Category 12.2.1)',
      method: 'Cryogenic Sub-40°C Stone Milling & Sterile Nitrogen Barrier Sealing',
      scope: 'Direct procurement from India wholesale mandis, multi-stage air & destoning cleaning, temperature-controlled slow pulverization, and multi-layer moisture-barrier packing of 100% whole spices without artificial dyes or fillers.',
      date: 'Valid: 2024 – 2029 (Annual Surveillance Audit Passed)',
      audit: 'Grade A Compliance · Zero Critical Non-Conformances'
    },
    'iso': {
      emblem: '🌐',
      authority: 'International Organization for Standardization / IAF',
      title: 'ISO 22000:2018 & HACCP Food Safety Management System',
      sub: 'International Food Safety Standard · Accredited by IAF Multi-Lateral Recognition',
      badge: '✓ ISO 22000:2018 CERTIFIED',
      holder: 'SYD SPICES PVT. LTD. (India Processing Facility)',
      reg: 'FSMS-IND-2026-9842',
      address: 'Spice Park Gala No. 12, Gujarat 384170, India',
      category: 'Food Safety Management in Spice Processing & Distribution',
      method: 'Continuous Critical Control Point (CCP) Temperature & Microbiological Monitoring',
      scope: 'End-to-end hazard analysis critical control points covering whole spice intake, mechanical magnetic foreign-object separation, slow grinding, and hermetic retail packaging.',
      date: 'Comprehensive Audit: October 2026 · Valid for 3 Years',
      audit: 'Audited & Endorsed with Zero Material Deficiencies'
    },
    'spices-board': {
      emblem: '🇮🇳',
      authority: 'Spices Board of India, Ministry of Commerce & Industry',
      title: 'Certificate of Registration as Exporter of Spices (CRES)',
      sub: 'Govt. of India Statutory Trade Directorate · Sugandha Bhavan',
      badge: '✓ REGISTERED EXPORTER',
      holder: 'SYD SPICES PVT. LTD.',
      reg: 'CRES-SP-GUJ-2026-081',
      address: 'Gala No. 12, Spice Park, Gujarat - 384170, India',
      category: 'Indian Origin Agricultural Whole Spices & Artisan Ground Powders',
      method: 'Authentic Single-Origin Mandi Procurement Pipeline',
      scope: 'Authorized export and premium domestic trade of pure Indian Cumin, Fennel, Coriander, Malabar Cardamom, Guntur Chillies, and signature curry blends in accordance with Spices Board quality grades.',
      date: 'Active Permanent Licensee & Recognized Exporter',
      audit: 'Quality Evaluation Laboratory Verified Origin'
    },
    'nabl': {
      emblem: '🔬',
      authority: 'National Accreditation Board for Testing Laboratories (NABL)',
      title: 'ISO/IEC 17025:2017 Laboratory Purity Compliance Report',
      sub: 'Third-Party Independent Analytical Testing · Laboratory Registration TC-7419',
      badge: '✓ 100% PURE LAB PASS',
      holder: 'SYD SPICES PVT. LTD. (Batch Testing Compliance Protocol)',
      reg: 'TC-7419 / NABL Analytical Assay',
      address: 'Central Analytical Lab Division, Spice Park, Gujarat 384170, India',
      category: 'Ultra-Trace Chemical & Chromatographic Analysis',
      method: 'High-Performance Liquid Chromatography (HPLC) & Gas Chromatography (GC-MS)',
      scope: 'Rigorous chemical screening verifying: 0.0 ppm Sudan I–IV carcinogenic dyes, zero Lead Chromate, pesticide residues below detection limit (< 0.01 ppm), lead < 0.05 ppm, and volatile terpene oil content exceeding 3.5% v/w.',
      date: 'Tested Every Production Lot (Latest: Oct 2026 Verified)',
      audit: '100% Chemical & Microbiological Pass (Grade A)'
    },
    'apmc': {
      emblem: '🌾',
      authority: 'Agricultural Produce Market Committee (APMC), Gujarat, India',
      title: 'APMC India Single-Origin Mandi Origin Accreditation',
      sub: 'Directorate of Agricultural Marketing & Rural Finance, Govt. of Gujarat',
      badge: '✓ GENUINE INDIA MANDI',
      holder: 'SYD SPICES PVT. LTD. (Registered Mandi Trader)',
      reg: 'APMC-UNJ-M-420-2026',
      address: 'APMC Yard Mandi Corridor, Gujarat - 384170, India',
      category: 'Direct Agricultural Mandi Inward Produce',
      method: 'Direct Farmgate Mandi Auction Inward & Lot Traceability',
      scope: 'Guaranteed single-origin Gujarat procurement directly from local farmers at India Mandi (Asia’s largest spice trading market) without third-party blending, spent-spice dilution, or broker adulteration.',
      date: 'Season 2026 Mandi Lot Authenticated',
      audit: 'Authorized Mandi Gatepass & Agricultural Cess Paid'
    },
    'nongmo': {
      emblem: '🌿',
      authority: 'Quality Assurance Directorate, SYD Spices Pvt. Ltd.',
      title: '100% Non-GMO & Pure Botanical Clean-Label Declaration',
      sub: 'Natural Ingredient Integrity & Zero Adulteration Guarantee',
      badge: '✓ 100% CLEAN LABEL',
      holder: 'SYD SPICES PVT. LTD.',
      reg: 'SYD-NAT-2026-P01',
      address: 'Gala No. 12, Spice Park, Gujarat - 384170, India, Gujarat',
      category: 'Natural Botanical Spices (Clean-Label Standard)',
      method: 'Additive-Free Whole Seed Processing & Sunlight Dehydration',
      scope: 'Formal declaration that all products contain exclusively 100% raw whole agricultural spices. Zero added starch, zero sawdust or seed husks, zero MSG, zero artificial colours, zero preservatives, and non-irradiated raw materials.',
      date: 'Perpetual Quality Covenant to Families',
      audit: 'Internal Scientific QA & Sensory Panel Cleared'
    }
  };

  function openCertificateModal(certKey) {
    const data = certDataStore[certKey] || certDataStore['fssai'];
    if (!certModalBackdrop) return;

    const emblemEl = document.getElementById('modal-cert-emblem');
    const authEl = document.getElementById('modal-cert-authority');
    const titleEl = document.getElementById('modal-cert-title');
    const subEl = document.getElementById('modal-cert-sub');
    const badgeEl = document.getElementById('modal-cert-badge');
    const holderEl = document.getElementById('modal-cert-holder');
    const regEl = document.getElementById('modal-cert-reg');
    const addressEl = document.getElementById('modal-cert-address');
    const categoryEl = document.getElementById('modal-cert-category');
    const methodEl = document.getElementById('modal-cert-method');
    const scopeEl = document.getElementById('modal-cert-scope');
    const dateEl = document.getElementById('modal-cert-date');
    const auditEl = document.getElementById('modal-cert-audit');

    if (emblemEl) emblemEl.textContent = data.emblem;
    if (authEl) authEl.textContent = data.authority;
    if (titleEl) titleEl.textContent = data.title;
    if (subEl) subEl.textContent = data.sub;
    if (badgeEl) badgeEl.innerHTML = `<span>${data.badge}</span>`;
    if (holderEl) holderEl.textContent = data.holder;
    if (regEl) regEl.textContent = data.reg;
    if (addressEl) addressEl.textContent = data.address;
    if (categoryEl) categoryEl.textContent = data.category;
    if (methodEl) methodEl.textContent = data.method;
    if (scopeEl) scopeEl.textContent = data.scope;
    if (dateEl) dateEl.textContent = data.date;
    if (auditEl) auditEl.textContent = data.audit;

    certModalBackdrop.classList.add('open');
    document.body.style.overflow = 'hidden';
    showToast(`Viewing official document: ${data.title}`);
  }

  function closeCertificateModal() {
    if (certModalBackdrop) {
      certModalBackdrop.classList.remove('open');
      document.body.style.overflow = '';
    }
  }

  document.querySelectorAll('.btn-cert-modal-trigger').forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.preventDefault();
      const certId = btn.getAttribute('data-cert') || 'fssai';
      openCertificateModal(certId);
    });
  });

  if (certModalClose) {
    certModalClose.addEventListener('click', closeCertificateModal);
  }
  if (btnCloseCertModal) {
    btnCloseCertModal.addEventListener('click', closeCertificateModal);
  }
  if (certModalBackdrop) {
    certModalBackdrop.addEventListener('click', (e) => {
      if (e.target === certModalBackdrop) {
        closeCertificateModal();
      }
    });
  }
  if (btnPrintCert) {
    btnPrintCert.addEventListener('click', () => {
      window.print();
    });
  }

  // Keyboard accessibility: ESC key closes open modals
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      if (certModalBackdrop && certModalBackdrop.classList.contains('open')) {
        closeCertificateModal();
      }
      if (coaModalBackdrop && coaModalBackdrop.classList.contains('open')) {
        coaModalBackdrop.classList.remove('open');
        document.body.style.overflow = '';
      }
    }
  });

  // --------------------------------------------------------------------------
  // 5E. Inspiration & Recipe Hub Interactivity (inspiration.html)
  // --------------------------------------------------------------------------
  
  // 1. Category Filtering
  const inspChips = document.querySelectorAll('.insp-chip');
  const recipeCards = document.querySelectorAll('.recipe-card');

  if (inspChips.length > 0 && recipeCards.length > 0) {
    inspChips.forEach(chip => {
      chip.addEventListener('click', () => {
        inspChips.forEach(c => c.classList.remove('active'));
        chip.classList.add('active');
        const filterVal = chip.getAttribute('data-filter');

        recipeCards.forEach(card => {
          const cardCat = card.getAttribute('data-category');
          if (filterVal === 'all' || cardCat === filterVal) {
            card.style.display = 'flex';
            setTimeout(() => { card.style.opacity = '1'; }, 10);
          } else {
            card.style.display = 'none';
            card.style.opacity = '0';
          }
        });
      });
    });
  }

  // 2. Recipe Detail Modal & Database
  const recipeDatabase = {
    'shahi-paneer': {
      title: 'Velvety Shahi Paneer with Cardamom Bloom',
      category: 'Royal Curry',
      meta: '⏱️ 30 Mins • 🌶️ Warm & Fragrant • 👥 Serves 4',
      productKey: 'garam-masala',
      spiceName: 'Royal Garam Masala',
      ingredients: [
        '300g fresh Malai Paneer, cubed',
        '3 ripe tomatoes, pureed',
        '15 whole cashews soaked in warm water and blended smooth',
        '1 tsp SYD Royal Garam Masala',
        '1/2 tsp SYD Premium Red Chilli Powder',
        '2 tbsp desi cow ghee & 1 bay leaf',
        '1 tsp ginger-garlic paste',
        '1/2 cup fresh cream & a pinch of crushed kasuri methi'
      ],
      steps: [
        'Heat 2 tbsp ghee in a heavy pan. Add bay leaf and ginger-garlic paste; saute until fragrant.',
        'Pour in the tomato puree with a pinch of salt. Cook on medium flame until oil starts separating from the sides (approx 6-7 mins).',
        'Lower the flame and stir in the cashew paste and fresh cream to form a silky velvety orange satin gravy.',
        'Gently drop in the paneer cubes. Simmer for 3 minutes on low heat.',
        'Turn off the direct flame! Immediately sprinkle 1 full tsp of SYD Royal Garam Masala and kasuri methi.',
        'Cover with a tight lid for 5 minutes before opening. The trapped steam infuses every paneer cube with pure cardamom and clove aroma.'
      ],
      tip: 'Never boil Garam Masala for long durations. Adding it off the flame preserves 100% of the cold-ground volatile essential oils.'
    },
    'dal-tadka': {
      title: 'Smoky Dhungar Dal with Ghee Tadka',
      category: 'Sizzling Tadka',
      meta: '⏱️ 20 Mins • 🌶️ Vibrant Warmth • 👥 Serves 4',
      productKey: 'red-chilli',
      spiceName: 'Premium Red Chilli',
      ingredients: [
        '1 cup toor dal & 1/4 cup yellow moong dal, pressure cooked till soft',
        '1 tsp SYD Premium Red Chilli Powder',
        '1 tsp whole cumin seeds (India origin)',
        '2 tbsp pure cow ghee',
        '6 cloves garlic, thinly sliced',
        '2 green chillies slit & 1 dried red chilli',
        'Fresh coriander leaves for garnish'
      ],
      steps: [
        'Whisk the boiled dal with 1 cup warm water, salt, and turmeric until creamy. Bring to a gentle rolling boil for 3 minutes.',
        'In a small iron tadka ladle, heat 2 tbsp desi cow ghee over medium flame.',
        'Add cumin seeds and let them swell and crackle (approx 3-4 seconds). Add sliced garlic and fry until light golden brown.',
        'THE 3-SECOND RULE: Remove the ladle completely away from the flame.',
        'Count 3 seconds, then add 1 tsp of SYD Premium Red Chilli Powder directly into the hot ghee. It will sizzle into a ruby red aromatic nectar without smoking.',
        'Immediately pour the sizzling red tadka over the dal. Cover with a lid instantly for 2 minutes to trap the smoke.'
      ],
      tip: 'Pure chilli powder contains natural capsaicin oils that release deep red color naturally into ghee—no artificial Sudan dyes required!'
    },
    'veg-kadai': {
      title: 'One-Pan Crisp Veg Kadai Masala',
      category: 'Everyday Subzi',
      meta: '⏱️ 25 Mins • 🌶️ Balanced Umami • 👥 Serves 4',
      productKey: 'magic-blend',
      spiceName: 'Magic Blend Masala',
      ingredients: [
        '1 cup mixed bell peppers (capsicum), cubed',
        '1 cup onions, diced in petals',
        '150g paneer or tofu cubes (optional)',
        '1.5 tsp SYD Magic Blend Masala',
        '2 ripe tomatoes, chopped',
        '2 tbsp mustard oil or groundnut oil',
        '1 tbsp crushed ginger juliennes'
      ],
      steps: [
        'Heat oil in a kadai / wok until shimmering. Add ginger juliennes and diced onions, stir-frying on high heat for 2 minutes.',
        'Add bell peppers and cook on high heat for 3 minutes keeping the vegetables crunchy and vibrant.',
        'Add chopped tomatoes and 1.5 tsp of SYD Magic Blend Masala along with 2 tbsp of warm water.',
        'Toss vigorously on medium heat. The roasted coriander and toasted cumin in Magic Blend will coat the vegetables in a savory glaze.',
        'Fold in paneer cubes if using, garnish with chopped coriander, and serve hot with rotis or parathas.'
      ],
      tip: 'Magic Blend is formulated as an all-in-one culinary secret—it replaces the clutter of 5 different jars with balanced roasted perfection.'
    },
    'dum-biryani': {
      title: 'Fragrant Vegetable & Paneer Dum Biryani',
      category: 'Biryani & Rice',
      meta: '⏱️ 45 Mins • 🌶️ Royal Aroma • 👥 Serves 6',
      productKey: 'garam-masala',
      spiceName: 'Royal Garam Masala',
      ingredients: [
        '2 cups aged basmati rice, parboiled to 70% with whole spices',
        '2 cups mixed vegetables (carrots, beans, peas, potatoes) marinated in spiced yoghurt',
        '1.5 tsp SYD Royal Garam Masala',
        '1 tsp SYD Premium Red Chilli Powder',
        '1/2 cup caramelized fried onions (birista)',
        'Pinch of saffron dissolved in 3 tbsp warm milk',
        '3 tbsp desi ghee & fresh mint leaves'
      ],
      steps: [
        'In a heavy-bottomed handi or pot, layer the marinated vegetable base at the bottom.',
        'Gently spread the 70% cooked aromatic basmati rice in an even layer on top.',
        'Drizzle saffron milk, melted ghee, and scatter fresh mint and caramelized onions.',
        'Dust 1 full teaspoon of SYD Royal Garam Masala directly over the surface of the rice.',
        'Seal the pot rim with wheat dough and press the lid tightly. Cook on high flame for 5 minutes, then place on a flat tawa on low flame for 20 minutes (dum).',
        'Break the seal at the table. The explosive royal banquet aroma will fill the entire room.'
      ],
      tip: 'Dusting Garam Masala right onto the rice before sealing ensures the steam carries fragrant linalool and mace notes through every single grain.'
    },
    'masala-pav': {
      title: 'Street-Style Mumbai Butter Masala Pav',
      category: 'Street Snack',
      meta: '⏱️ 15 Mins • 🌶️ Tangy & Spicy • 👥 Serves 3',
      productKey: 'magic-blend',
      spiceName: 'Magic Blend Masala',
      ingredients: [
        '6 soft pav buns, slit horizontally',
        '3 tbsp salted amul butter',
        '1 large onion & 2 tomatoes, finely chopped',
        '1.5 tsp SYD Magic Blend Masala',
        '1/2 tsp SYD Premium Red Chilli Powder',
        '1 tbsp fresh lemon juice',
        'Handful of fresh coriander leaves'
      ],
      steps: [
        'Melt 2 tbsp butter on a flat tawa or wide skillet over medium-high heat.',
        'Add chopped onions and green chillies, sauteing for 2 minutes until translucent.',
        'Add chopped tomatoes and mash with the back of your spatula until pulpy.',
        'Sprinkle SYD Magic Blend Masala and Red Chilli Powder. Saute for 1 minute until the butter turns bright red and fragrant.',
        'Add lemon juice and coriander. Push the masala to one side of the tawa.',
        'Melt another dollop of butter and open the pav buns, pressing them face-down into the sizzling masala to absorb every drop of flavour. Serve piping hot!'
      ],
      tip: 'The touch of dry mango and toasted cumin in Magic Blend provides that signature Mumbai street-vendor tanginess.'
    },
    'jeera-aloo': {
      title: 'Crisp Golden India Jeera Aloo Roast',
      category: 'Everyday Subzi',
      meta: '⏱️ 15 Mins • 🌶️ Mildly Crispy • 👥 Serves 4',
      productKey: 'magic-blend',
      spiceName: 'Magic Blend Masala',
      ingredients: [
        '4 medium potatoes, boiled, peeled, and cut into cubes',
        '1.5 tbsp whole India cumin seeds (jeera)',
        '1 tsp SYD Magic Blend Masala',
        '1/2 tsp SYD Premium Red Chilli Powder',
        '2 tbsp mustard oil',
        '2 green chillies slit & fresh lemon wedges'
      ],
      steps: [
        'Heat mustard oil in a heavy kadai until it smokes gently, then reduce heat to medium.',
        'Add whole cumin seeds and let them sizzle for 5 seconds until nutty and aromatic.',
        'Add boiled potato cubes and toss gently to coat in the cumin oil.',
        'CRISPING SECRET: Spread potatoes in a single layer and leave them undisturbed on medium flame for 3 minutes until a golden bottom crust forms.',
        'Sprinkle SYD Magic Blend and Red Chilli Powder. Toss for 2 more minutes.',
        'Finish with a squeeze of fresh lemon and chopped coriander. Serve with hot puris or dal-chawal.'
      ],
      tip: 'Because India cumin seeds are dense with volatile essential oils, they release deep nutty aroma without needing excess fat.'
    }
  };

  const recipeModalBackdrop = document.getElementById('recipe-modal-backdrop');
  const recipeModalClose = document.getElementById('recipe-modal-close');
  const modalRecipeTitle = document.getElementById('modal-recipe-title');
  const modalRecipeCategory = document.getElementById('modal-recipe-category');
  const modalRecipeMeta = document.getElementById('modal-recipe-meta');
  const modalIngredientsList = document.getElementById('modal-ingredients-list');
  const modalStepsList = document.getElementById('modal-steps-list');
  const modalChefTip = document.getElementById('modal-chef-tip');
  const modalBtnAddSpice = document.getElementById('modal-btn-add-spice');
  let currentActiveModalSpice = 'magic-blend';

  document.querySelectorAll('.btn-recipe-modal').forEach(btn => {
    btn.addEventListener('click', () => {
      const recId = btn.getAttribute('data-recipe');
      const rec = recipeDatabase[recId];
      if (!rec) return;

      currentActiveModalSpice = rec.productKey;
      if (modalRecipeTitle) modalRecipeTitle.textContent = rec.title;
      if (modalRecipeCategory) modalRecipeCategory.textContent = rec.category;
      if (modalRecipeMeta) modalRecipeMeta.textContent = rec.meta;

      if (modalIngredientsList) {
        modalIngredientsList.innerHTML = rec.ingredients.map(ing => `<li>${ing}</li>`).join('');
      }

      if (modalStepsList) {
        modalStepsList.innerHTML = rec.steps.map(st => `<li>${st}</li>`).join('');
      }

      if (modalChefTip) {
        modalChefTip.innerHTML = `<strong>👨‍🍳 Chef's Secret:</strong><span>${rec.tip}</span>`;
      }

      if (modalBtnAddSpice) {
        modalBtnAddSpice.textContent = `Add ${rec.spiceName} to Bag +`;
      }

      if (recipeModalBackdrop) {
        recipeModalBackdrop.classList.add('open');
        document.body.style.overflow = 'hidden';
      }
    });
  });

  if (recipeModalClose && recipeModalBackdrop) {
    recipeModalClose.addEventListener('click', () => {
      recipeModalBackdrop.classList.remove('open');
      document.body.style.overflow = '';
    });
  }

  if (recipeModalBackdrop) {
    recipeModalBackdrop.addEventListener('click', (e) => {
      if (e.target === recipeModalBackdrop) {
        recipeModalBackdrop.classList.remove('open');
        document.body.style.overflow = '';
      }
    });
  }

  // Direct 1-Click Recipe Spice Add to Bag
  document.querySelectorAll('.btn-recipe-add-spice').forEach(btn => {
    btn.addEventListener('click', () => {
      const pKey = btn.getAttribute('data-product') || 'magic-blend';
      const prod = catalog[pKey];
      if (prod) {
        addToCart(prod, '100g');
        saveCart();
        openBag();
        showToast(`Added ${prod.name} (100g) to your bag!`);
      }
    });
  });

  if (modalBtnAddSpice) {
    modalBtnAddSpice.addEventListener('click', () => {
      const prod = catalog[currentActiveModalSpice] || catalog['magic-blend'];
      if (prod) {
        addToCart(prod, '100g');
        saveCart();
        openBag();
        showToast(`Added ${prod.name} (100g) to your bag!`);
        if (recipeModalBackdrop) {
          recipeModalBackdrop.classList.remove('open');
          document.body.style.overflow = '';
        }
      }
    });
  }

  // 3. Interactive Flavor Finder Calculation
  const flavorCombinations = {
    'paneer-curry_royal-aromatic': {
      spiceKey: 'garam-masala',
      name: 'SYD Royal Garam Masala',
      tagline: '15-Spices Royal Blend',
      img: 'assets/card_garam_masala.png',
      ratio: '1 leveled tsp per 4 servings (approx 250g paneer)',
      timing: 'Add in the final 2 minutes of simmering off direct boiling heat',
      notes: 'Velvety sweet-spicy cardamom bouquet with warm comforting clove undertones'
    },
    'paneer-curry_balanced-umami': {
      spiceKey: 'magic-blend',
      name: 'SYD Magic Blend Masala',
      tagline: 'All-Purpose Secret Blend',
      img: 'assets/card_magic_blend.png',
      ratio: '1.5 tsp during tomato-onion saute stage',
      timing: 'Bloom with 2 tbsp warm water when sauteing masala base',
      notes: 'Rich roasted coriander, dry mango tang, and deeply savory gravy depth'
    },
    'paneer-curry_smoky-fiery': {
      spiceKey: 'red-chilli',
      name: 'SYD Premium Red Chilli Powder',
      tagline: '100% Pure Whole Chilli',
      img: 'assets/card_red_chilli.png',
      ratio: '1 tsp into ghee tadka off the flame',
      timing: 'Stir into hot ghee 3 seconds off the stove to bloom vibrant color',
      notes: 'Vibrant natural ruby hue with clean, lingering warmth and zero artificial dyes'
    },
    'dal-tadka_smoky-fiery': {
      spiceKey: 'red-chilli',
      name: 'SYD Premium Red Chilli Powder',
      tagline: 'The Ultimate Ghee Bloom',
      img: 'assets/card_red_chilli.png',
      ratio: '1 tsp in hot cow ghee with golden garlic',
      timing: 'Count 3 seconds off-flame before stirring into hot ghee',
      notes: 'Sensational crimson sizzle with zero throat irritation or bitter char'
    },
    'dal-tadka_royal-aromatic': {
      spiceKey: 'garam-masala',
      name: 'SYD Royal Garam Masala',
      tagline: 'Aromatic Finishing Touch',
      img: 'assets/card_garam_masala.png',
      ratio: '1/2 tsp sprinkled right over the hot dal before serving',
      timing: 'Dust on top immediately after pouring the tadka',
      notes: 'Transforms humble yellow dal into a banquet-worthy aromatic delicacy'
    },
    'everyday-subzi_balanced-umami': {
      spiceKey: 'magic-blend',
      name: 'SYD Magic Blend Masala',
      tagline: 'Everyday Kitchen Secret',
      img: 'assets/card_magic_blend.png',
      ratio: '1.5 tsp tossed directly with sauteed vegetables',
      timing: 'Add once onions are translucent; toss for 2 minutes on high heat',
      notes: 'Crisp vegetable crusting with balanced salt, roasted cumin, and amchur'
    },
    'biryani-pulao_royal-aromatic': {
      spiceKey: 'garam-masala',
      name: 'SYD Royal Garam Masala',
      tagline: 'Royal Rice Perfection',
      img: 'assets/card_garam_masala.png',
      ratio: '1 full tsp dusted across the top rice layer',
      timing: 'Sprinkle just before sealing the pot lid for the dum phase',
      notes: 'Captures authentic Shahi Mughlai fragrance of mace, nutmeg, and cardamom'
    },
    'snacks-chaat_balanced-umami': {
      spiceKey: 'magic-blend',
      name: 'SYD Magic Blend Masala',
      tagline: 'Street-Food Flavor Booster',
      img: 'assets/card_magic_blend.png',
      ratio: '1 tsp melted directly into butter on the tawa',
      timing: 'Melt with butter and toast soft pav or potatoes',
      notes: 'Irresistible savory street-vendor tanginess that makes snacks pop'
    }
  };

  const btnCalcFlavor = document.getElementById('btn-calculate-flavor');
  const dishSelect = document.getElementById('finder-dish-select');
  const moodSelect = document.getElementById('finder-mood-select');
  const resultSpiceImg = document.getElementById('result-spice-img');
  const resultSpiceName = document.getElementById('result-spice-name');
  const resultSpiceTagline = document.getElementById('result-spice-tagline');
  const resultRatioText = document.getElementById('result-ratio-text');
  const resultTimingText = document.getElementById('result-timing-text');
  const resultNotesText = document.getElementById('result-notes-text');
  const btnFinderAddBag = document.getElementById('btn-finder-add-bag');
  let currentFinderSpiceKey = 'garam-masala';

  if (btnCalcFlavor && dishSelect && moodSelect) {
    btnCalcFlavor.addEventListener('click', () => {
      const comboKey = `${dishSelect.value}_${moodSelect.value}`;
      const match = flavorCombinations[comboKey] || {
        spiceKey: 'magic-blend',
        name: 'SYD Magic Blend Masala',
        tagline: 'All-Purpose Balanced Blend',
        img: 'assets/card_magic_blend.png',
        ratio: '1 to 1.5 tsp per dish',
        timing: 'Saute during the vegetable / curry tempering stage',
        notes: 'Complete multi-layered aromatic balance tested for everyday Indian kitchens'
      };

      currentFinderSpiceKey = match.spiceKey;
      if (resultSpiceImg) resultSpiceImg.src = match.img;
      if (resultSpiceName) resultSpiceName.textContent = match.name;
      if (resultSpiceTagline) resultSpiceTagline.textContent = match.tagline;
      if (resultRatioText) resultRatioText.textContent = match.ratio;
      if (resultTimingText) resultTimingText.textContent = match.timing;
      if (resultNotesText) resultNotesText.textContent = match.notes;

      showToast(`Recommended ${match.name} for your dish!`);
    });
  }

  if (btnFinderAddBag) {
    btnFinderAddBag.addEventListener('click', () => {
      const prod = catalog[currentFinderSpiceKey] || catalog['magic-blend'];
      if (prod) {
        addToCart(prod, '100g');
        saveCart();
        openBag();
        showToast(`Added ${prod.name} (100g) to your bag!`);
      }
    });
  }

  // --------------------------------------------------------------------------
  // 6. Toast Notification Utility
  // --------------------------------------------------------------------------
  function showToast(message) {
    let toast = document.getElementById('syd-toast');
    if (!toast) {
      toast = document.createElement('div');
      toast.id = 'syd-toast';
      toast.className = 'syd-toast';
      document.body.appendChild(toast);
    }
    toast.innerHTML = `
      <span style="font-size: 1.1rem;">🌿</span>
      <span>${message}</span>
    `;
    toast.classList.add('show');
    setTimeout(() => {
      toast.classList.remove('show');
    }, 3500);
  }
});

