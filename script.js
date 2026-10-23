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
  let cart = JSON.parse(localStorage.getItem('syd_cart_items')) || [
    { id: 'magic-blend-250g', name: 'Magic Blend', weight: '250g', price: 195, image: 'assets/magicbland.png', qty: 1 },
    { id: 'red-chilli-250g', name: 'Premium Red Chilli Powder', weight: '250g', price: 185, image: 'assets/chilli.png', qty: 1 },
    { id: 'garam-masala-100g', name: 'Premium Garam Masala', weight: '100g', price: 210, image: 'assets/garammasala.png', qty: 1 }
  ];

  function saveCart() {
    localStorage.setItem('syd_cart_items', JSON.stringify(cart));
    updateCartUI();
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

  // --------------------------------------------------------------------------
  // 4. Products Page Interactive Controls
  // --------------------------------------------------------------------------
  const spiceCards = document.querySelectorAll('.spice-card');
  if (spiceCards.length > 0) {
    spiceCards.forEach(card => {
      const weightPills = card.querySelectorAll('.weight-pill');
      const priceValEl = card.querySelector('.spice-price-val');
      const qtyValEl = card.querySelector('.qty-val');
      const minusBtn = card.querySelector('.qty-minus');
      const plusBtn = card.querySelector('.qty-plus');
      const addBtn = card.querySelector('.btn-add-bag, .btn-add-bag-minimal');

      let currentQty = 1;

      if (minusBtn && plusBtn && qtyValEl) {
        minusBtn.addEventListener('click', (e) => {
          e.stopPropagation();
          if (currentQty > 1) {
            currentQty--;
            qtyValEl.textContent = currentQty;
          }
        });
        plusBtn.addEventListener('click', (e) => {
          e.stopPropagation();
          currentQty++;
          qtyValEl.textContent = currentQty;
        });
      }

      if (weightPills.length > 0) {
        weightPills.forEach(pill => {
          pill.addEventListener('click', (e) => {
            e.stopPropagation();
            weightPills.forEach(p => p.classList.remove('active'));
            pill.classList.add('active');
            const newPrice = pill.getAttribute('data-price');
            if (priceValEl && newPrice) {
              priceValEl.textContent = `₹${newPrice}`;
            }
          });
        });
      }

      if (addBtn) {
        addBtn.addEventListener('click', (e) => {
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
        });
      }
    });

    // Category Filter Pills
    const filterBtns = document.querySelectorAll('.filter-pill-btn');
    const countBadge = document.getElementById('catalog-count-badge');

    if (filterBtns.length > 0) {
      filterBtns.forEach(btn => {
        btn.addEventListener('click', () => {
          filterBtns.forEach(b => b.classList.remove('active'));
          btn.classList.add('active');

          const selectedCat = btn.getAttribute('data-category');
          let count = 0;

          spiceCards.forEach(card => {
            const cardCat = card.getAttribute('data-category');
            if (selectedCat === 'all' || cardCat === selectedCat) {
              card.style.display = 'flex';
              count++;
            } else {
              card.style.display = 'none';
            }
          });

          if (countBadge) {
            countBadge.textContent = `Showing ${count} Spices`;
          }
        });
      });
    }

    // Quick View Modal Logic
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

    if (qvCloseBtn) qvCloseBtn.addEventListener('click', closeQuickView);
    if (qvBackdrop) qvBackdrop.addEventListener('click', closeQuickView);

    document.querySelectorAll('.btn-quickview-icon').forEach(btn => {
      btn.addEventListener('click', () => {
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
      });
    });
  }

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

  // Contact Form Submit Simulation
  const contactForm = document.getElementById('syd-contact-form');
  const successBanner = document.getElementById('form-success-banner');
  if (contactForm) {
    contactForm.addEventListener('submit', (e) => {
      e.preventDefault();

      const submitBtn = contactForm.querySelector('.btn-submit-contact');
      const nameInput = document.getElementById('contact-name');
      const senderName = nameInput ? nameInput.value.trim() : 'Guest';

      if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.innerHTML = `
          <span>Sending Message...</span>
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="animation: spin 1s linear infinite;">
            <circle cx="12" cy="12" r="10" stroke-opacity="0.25"></circle>
            <path d="M12 2a10 10 0 0 1 10 10"></path>
          </svg>
        `;
      }

      setTimeout(() => {
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
      }, 1000);
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
        category: 'Signature Blend',
        script: 'Master Secret Blend',
        badge: 'Bestseller',
        image: 'assets/magicbland.png',
        desc: 'Our signature 16-spice balanced aromatic blend, master-crafted in small batches to elevate everyday curries, dals, gravies, and paneer dishes with fragrant, warm sweetness.',
        weights: [
          { weight: '100g', price: 85, strike: 105 },
          { weight: '250g', price: 195, strike: 240, active: true },
          { weight: '500g', price: 360, strike: 430 }
        ]
      },
      'red-chilli': {
        name: 'Red Chilli Powder',
        category: 'Pure Ground Powder',
        script: 'Deep Color & Rich Pungency',
        badge: 'Cold Ground',
        image: 'assets/chilli.png',
        desc: 'Handpicked stemless sun-dried Guntur and Byadgi chillies, cold-pulverized below 40°C. Delivers rich, vibrant vermilion red color and warm, layered piquancy without harsh synthetic additives.',
        weights: [
          { weight: '100g', price: 75, strike: 95 },
          { weight: '250g', price: 185, strike: 220, active: true },
          { weight: '500g', price: 340, strike: 400 }
        ]
      },
      'garam-masala': {
        name: 'Royal Garam Masala',
        category: 'Signature Blend',
        script: 'Slow-Roasted Royal Formula',
        badge: 'Rich Aroma',
        image: 'assets/garammasala.png',
        desc: 'Royal court formulation featuring high-grade Idukki green cardamom, bold Tellicherry peppercorns, cloves, mace, and royal cinnamon. Roasted in cast iron and coarse-ground for deep fragrance.',
        weights: [
          { weight: '100g', price: 95, strike: 120, active: true },
          { weight: '250g', price: 210, strike: 260 },
          { weight: '500g', price: 395, strike: 480 }
        ]
      },
      'cumin-seeds': {
        name: 'India Cumin Seeds',
        category: 'India Whole Spice',
        script: 'Bold Grain & Crisp Crackle',
        badge: 'India Origin',
        image: 'assets/step_01_sourced.png',
        desc: 'Hand-selected from India APMC mandi lots. Bold, elongated seeds with high 3.8% thymol essential oil concentration. Crackles with crisp earthy sweetness in hot oil tadka.',
        weights: [
          { weight: '100g', price: 70, strike: 85 },
          { weight: '250g', price: 160, strike: 190, active: true },
          { weight: '500g', price: 295, strike: 350 }
        ]
      },
      'fennel-seeds': {
        name: 'Royal Fennel Seeds',
        category: 'India Whole Spice',
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
        category: 'Pure Ground Powder',
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
        category: 'Pure Ground Powder',
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
        category: 'Gift Set & Bundle',
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
    const prod = productsData[prodId] || productsData['magic-blend'];

    const breadName = document.getElementById('pdp-bread-name');
    const badgeEl = document.getElementById('pdp-badge');
    const imgEl = document.getElementById('pdp-img');
    const catEl = document.getElementById('pdp-category');
    const scriptEl = document.getElementById('pdp-script');
    const descEl = document.getElementById('pdp-desc');
    const priceEl = document.getElementById('pdp-price');
    const strikeEl = document.getElementById('pdp-price-strike');
    const savingsEl = document.getElementById('pdp-savings');
    const packContainer = document.getElementById('pdp-pack-options');
    const activeWeightLabel = document.getElementById('pdp-active-weight-label');

    if (breadName) breadName.textContent = prod.name;
    if (badgeEl) badgeEl.textContent = prod.badge;
    if (imgEl) {
      imgEl.src = prod.image;
      imgEl.alt = prod.name;
    }
    if (catEl) catEl.textContent = prod.category;
    if (pdpTitle) pdpTitle.textContent = prod.name;
    if (scriptEl) scriptEl.textContent = prod.script;
    if (descEl) descEl.textContent = prod.desc;

    let selectedWeight = prod.weights.find(w => w.active) || prod.weights[0];

    function renderPackOptions() {
      if (!packContainer) return;
      packContainer.innerHTML = prod.weights.map(w => `
        <button type="button" class="pdp-pack-btn ${w.weight === selectedWeight.weight ? 'active' : ''}" data-weight="${w.weight}" data-price="${w.price}" data-strike="${w.strike}">
          <span class="pdp-pack-weight">${w.weight}</span>
          <span class="pdp-pack-price">₹${w.price}</span>
        </button>
      `).join('');

      packContainer.querySelectorAll('.pdp-pack-btn').forEach(btn => {
        btn.addEventListener('click', () => {
          const wStr = btn.getAttribute('data-weight');
          const found = prod.weights.find(w => w.weight === wStr);
          if (found) {
            selectedWeight = found;
            renderPackOptions();
            updatePriceDisplay();
          }
        });
      });
    }

    function updatePriceDisplay() {
      if (priceEl) priceEl.textContent = `₹${selectedWeight.price}`;
      if (strikeEl) strikeEl.textContent = `₹${selectedWeight.strike}`;
      if (savingsEl) {
        const discount = Math.round(((selectedWeight.strike - selectedWeight.price) / selectedWeight.strike) * 100);
        savingsEl.textContent = `Save ${discount}%`;
      }
      if (activeWeightLabel) {
        activeWeightLabel.textContent = `Selected: ${selectedWeight.weight}`;
      }
    }

    renderPackOptions();
    updatePriceDisplay();

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

