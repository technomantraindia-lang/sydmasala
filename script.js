/**
 * SYD SPICES - CINEMATIC BACKGROUND SLIDER & DRAWER ENGINE
 */

document.addEventListener('DOMContentLoaded', () => {
  // --------------------------------------------------------------------------
  // 1. Sliding Hero Slider Logic
  // --------------------------------------------------------------------------
  const slides = document.querySelectorAll('.hero-slide');
  const progressBars = document.querySelectorAll('.progress-bar-item');
  const currentNumEl = document.getElementById('current-slide-num');
  const prevBtn = document.getElementById('prev-slide-btn');
  const nextBtn = document.getElementById('next-slide-btn');
  const sliderSection = document.getElementById('hero-slider');

  let currentSlide = 0;
  const totalSlides = slides.length;
  const slideDuration = 6000; // 6 seconds per slide
  let slideInterval = null;
  let progressAnimation = null;

  function goToSlide(index) {
    // Wrap around
    if (index >= totalSlides) index = 0;
    if (index < 0) index = totalSlides - 1;

    currentSlide = index;

    // Update slides
    slides.forEach((slide, i) => {
      slide.classList.toggle('active', i === currentSlide);
    });

    // Update progress bars
    progressBars.forEach((bar, i) => {
      bar.classList.toggle('active', i === currentSlide);
      const fill = bar.querySelector('.progress-bar-fill');
      if (fill) {
        fill.style.transition = 'none';
        fill.style.width = i === currentSlide ? '0%' : (i < currentSlide ? '100%' : '0%');
      }
    });

    // Update numeric counter
    if (currentNumEl) {
      currentNumEl.textContent = String(currentSlide + 1).padStart(2, '0');
    }

    // Start progress fill animation
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

  // Navigation events
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

  // Indicator click
  progressBars.forEach((bar, i) => {
    bar.addEventListener('click', () => {
      goToSlide(i);
      startSliderTimer();
    });
  });

  // Pause on hover
  if (sliderSection) {
    sliderSection.addEventListener('mouseenter', pauseSlider);
    sliderSection.addEventListener('mouseleave', startSliderTimer);
  }

  // Keyboard navigation
  document.addEventListener('keydown', (e) => {
    if (e.key === 'ArrowRight') {
      goToSlide(currentSlide + 1);
      startSliderTimer();
    } else if (e.key === 'ArrowLeft') {
      goToSlide(currentSlide - 1);
      startSliderTimer();
    }
  });

  // Start initial slider
  goToSlide(0);
  startSliderTimer();

  // --------------------------------------------------------------------------
  // 2. Header & Cart Drawer Logic
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
      header.classList.add('scrolled');
    } else {
      header.classList.remove('scrolled');
    }
  });

  // Shopping Bag Drawer Toggle
  function openBag() {
    cartDrawer.classList.add('active');
    drawerBackdrop.classList.add('active');
    document.body.style.overflow = 'hidden';
  }

  function closeBag() {
    cartDrawer.classList.remove('active');
    drawerBackdrop.classList.remove('active');
    document.body.style.overflow = '';
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
});
