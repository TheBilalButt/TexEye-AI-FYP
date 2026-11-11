// TexEye AI Portal JavaScript
document.addEventListener('DOMContentLoaded', () => {
  const tabs = document.querySelectorAll('.tab-btn');
  const panes = document.querySelectorAll('.tab-pane');

  tabs.forEach(tab => {
    tab.addEventListener('click', () => {
      // Remove active from all tabs & panes
      tabs.forEach(t => t.classList.remove('active'));
      panes.forEach(p => p.classList.remove('active'));

      // Activate current tab & pane
      tab.classList.add('active');
      const targetId = tab.getAttribute('data-tab');
      const targetPane = document.getElementById(targetId);
      if (targetPane) {
        targetPane.classList.add('active');
        // Scroll smoothly to main content
        const main = document.querySelector('.main-content');
        if (main && window.scrollY > 300) {
          main.scrollIntoView({ behavior: 'smooth' });
        }
      }
    });
  });

  // Log portal initialization
  console.log('TexEye AI Documentation & UML Portal Initialized.');
});

