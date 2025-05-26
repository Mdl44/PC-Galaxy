window.addEventListener("DOMContentLoaded", function() {
    const themeOptions = document.querySelectorAll('.theme-option');
    
    themeOptions.forEach(option => {
        option.addEventListener('click', function(e) {
            e.preventDefault();
            const selectedTheme = this.getAttribute('data-theme');
            
            document.body.classList.remove('default', 'light', 'dark');
            
            if (selectedTheme !== 'default') {
                document.body.classList.add(selectedTheme);
            }
            
            // Salvăm în localStorage
            if (selectedTheme === 'default') {
                localStorage.removeItem('tema');
            } else {
                localStorage.setItem('tema', selectedTheme);
            }
        });
    });
});